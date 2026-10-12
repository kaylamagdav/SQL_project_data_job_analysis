# Introduction
Here is a look into the data job market! With a focus on marketing and data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics. 

SQL queries? Take a look here: [project_sql folder](/Project_sql/) 

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining other work to find optimal jobs. 

Data from this project is derived from a public [SQL course](https://lukebarousse.com/sql) by Luke Barousse. The data from this course includes insights on job titles, salaries, locations, and skills from the job market. 

### The questions I wanted to answer through my SQL quereies were:
1. What are the top-paying data analyst jobs?
2. What skills are required for tese top-paying jobs?
3. What skills are most in dfemand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn? 

# Tools I used
To complete this project I utilized 4 key tools:

- **SQL:** The foundation of my analysis, SQL allowed me to query the database and yield critical insights and answers to my questions. 
- **PostgresSQL:** The chosen database management system. Optimal for handling the dataset.
- **Visual Studio Code:** My preferred code editor for database managemnt and executing SQL queries. 
- **Git & GitHub:** Essential for version control and sharing SQL scripts and analysis, ensuring collaboration and project tracking. 

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question: 
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions to include job titles with marketing in the title, by average yearly salary, location, and focusing on jobs in the San Antonio and Austin area. This query highlights the high paying opportunities in the field, while tailoring to my preferences. 

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    (job_title ILIKE '%marketing%' OR job_title ILIKE '%analyst%') AND 
    (job_location ILIKE '%Austin%' OR job_location ILIKE '%San Antonio%' OR 
    job_location ILIKE '%Dallas%') AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 100;
```
Here is a breakdown of the top data and marketing analyst jobs from 2023:
- **San Antonio pays the most on average, but it's really a USAA effect.** San Antonio postings average ~$133,700 vs. Austin's ~$120,900 and Dallas's ~$115,900. That's not broad market strength — USAA alone accounts for 17 of the 100 postings (14 under "USAA," 3 more under its full legal name "United Services Automobile Association"), most of them senior "Lead" or "Decision Science" roles clustered in the $125K–$168K range. Strip USAA out and San Antonio's advantage mostly disappears.

- **The market centers tightly around $100K–$125K.** 60 of the 100 postings (60%) fall in that band, and the median across all three cities is close to $111K–$126K depending on city. The $150K+ postings are real but are the exception (15 of 100), not the norm — useful context if you're benchmarking an offer or expectation against "top-paying" headlines.

- **A handful of postings are duplicates or near-duplicates, which can quietly skew any average.** For example, Frontier Communications posted the identical "Data Analyst / Data Scientist, Wholesale" role twice at $118,965, and USAA posted near-identical "Information Management Analyst I" and "Decision Science Analyst - Mid Level" roles 2–3 times each at the same salary. If you're computing company-level or city-level averages, it's worth deduplicating by title+company+salary first, since repeated postings of the same role inflate both the count and the perceived demand.

![Top Paying Roles](assets\1_top_paying_marketing_analyst_jobs.png)
 *Bar graph visualizing the salary for the top 10 salaries for data analysts; Claude generated this graph from my SQL query results*

 ### 2. Skills for Top Paying Jobs

 ``` SQL
 WITH top_paying_jobs AS (
SELECT
    jp.job_id,
    jp.job_title,
    salary_year_avg,
    cd.name AS company_name
FROM
    job_postings_fact AS jp
LEFT JOIN
    company_dim AS cd 
        ON jp.company_id = cd.company_id
WHERE 
    (jp.job_title ILIKE '%marketing%' AND jp.job_title ILIKE '%analyst%')
    AND (jp.job_location ILIKE '%Austin%' OR jp.job_location ILIKE '%San Antonio%' OR jp.job_location ILIKE '%Dallas%') 
    AND jp.salary_year_avg IS NOT NULL
ORDER BY
    jp.salary_year_avg DESC
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
 - Here is a breakdown of the top paying jobs based on skillset.
 - **SQL and Tableau are the clear backbone skills.** SQL appears for 7 of the 9 unique jobs, and Tableau for 7 as well — basically every posting except the two USAA "Decision Science" roles. If you're prepping for one of these roles, these two are the safest bet to have down cold.

- **"Phoenix" and "SAS" cluster almost entirely inside USAA postings.** Of the 3 jobs listing `phoenix` (`1035043`, `730616`, `438867`) and the 1 job listing `sas` (`730616`), every single one is a USAA or USAA-affiliated posting. That's a strong signal these aren't general-market skills at all, but tools/systems specific to USAA's internal stack — worth excluding them if you're trying to identify what the broader marketing-analyst job market actually wants, since they'd otherwise look like meaningful "high-salary skills" purely because USAA happens to pay the most in this slice.

- **Skill count doesn't track with salary.** The two $167,755 USAA postings have 5–7 skills listed, but so does the $60,000 iTalent Digital posting (5 skills: sql, python, express, excel, tableau) — same toolkit, roughly a third of the pay. Meanwhile `785984` ($90,000, Xometry) lists only 2 skills (sql, looker). This reinforces something from earlier in our analysis: company and role context explain pay differences here more than the breadth of the skill list does.

![Top Paying skills](assets\2_top_paying_data_marketing_analyst_skills(1).png)
 *Bar graph visualizing the top skills required for top paying data analyst jobs; ChatGPT generated this graph from my SQL query results*

 ### 3. In-Demand Skills for Data Analysts

 ``` SQL
SELECT 
     skills_dim.skills,
     COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title ILIKE '%marketing%' AND job_title ILIKE '%analyst%')
GROUP BY
     skills
ORDER BY
     demand_count DESC
limit 5;
```
 -Here is a breakdown of the top in-demand skills for data and marketing analysts.

 - **Infrastructure-heavy skills only show up at the top three salary tiers.** `snowflake`, `hadoop`, and `nosql` appear exclusively in the two $167,755 USAA jobs and the $138,640 USAA-affiliated job — none of the postings at $120,000 or below list any of these. This lines up with the broader pattern we saw in the standalone skills-salary data: big data/cloud-adjacent skills cluster with the highest pay, while the sub-$120K postings stick to SQL, Python, Excel, and Tableau.

- **The two iTalent Digital rows are identical duplicate postings, not two separate data points.** `516960` and `773993` have the same title, company, salary ($60,000), and exact skill set (sql, python, express, excel, tableau). If you're counting skill frequency or averaging salaries from this data, these should be deduplicated first — otherwise "express" and the $60K salary both get double-counted and look more common/representative than they really are.

- **USAA (and its full-name variant) controls 3 of the 8 distinct jobs in this dataset, all in the top 4 salaries.** Since USAA-linked postings dominate the high end, any "top skill" that looks salary-correlated here (phoenix, sas, snowflake, r) may really just be "skills USAA happens to ask for" rather than a broader market signal — worth keeping in mind before generalizing this to the marketing-analyst job market as a whole.

![Top Demanded Skills](assets\3_top_demanded_skills_data_analyst.png)
 *Bar graph visualizing the top demanded skills for data analysts; Claude generated this graph from my SQL query results*

 ### 4. Skills Based on Salaries

```SQL
 SELECT 
     skills_dim.skills,
     ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
      (job_title ILIKE '%marketing%' AND job_title ILIKE '%analyst%') 
      AND salary_year_avg IS NOT NULL
GROUP BY
     skills
ORDER BY
     avg_salary DESC
limit 25;
```
 - Here is a breakdown of the top skills based on salary. 

- **Big data and cloud infrastructure skills top the list.** `hadoop` ($162,086), `nosql` ($138,640), `snowflake` ($112,121), `aws` ($112,058), and `airflow` ($111,175) all rank in the upper half — these are traditionally data engineering tools, not classic analyst tools, suggesting the highest-paying "data analyst" roles blend into data engineering work.

- **Everyday analyst tools sit at the bottom, despite being the most widely used.** `python` ($105,027), `javascript` ($104,808), `html` ($104,328), `cognos` ($103,567), `vba` ($102,500), and `spreadsheet` ($102,500) are all in the bottom third. This isn't a knock on these skills — it reflects that widespread, table-stakes skills tend to command lower pay premiums than scarce, specialized ones.

- **A few entries look like small-sample outliers, not real trends.** `notion` ($158,750), `twilio` ($138,500), `zoom` ($111,250), and `confluence` ($107,000) are collaboration/productivity tools, not analytical skills — unusual for a "top-paying skills for data analysts" list. These are very likely averages pulled from just 1–2 high-paying postings that happened to mention the tool, rather than genuine market demand. Worth checking the number of postings behind each of these before treating them as actionable signals.

![Top Skills Based On Salary](assets\4_top_skills_based_on_salary_full25.png)
 *Bar graph visualizing the top paying skills for data analysts; Claude generated this graph from my SQL query results*

 ### 5. Most Optimal Skills to Learn

 ``` sql
 SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title ILIKE '%marketing%' AND job_title ILIKE '%analyst%') 
    AND salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    demand_count DESC,
    avg_salary DESC
lIMIT 25;
```
 - Here is a breakdown of the most optimal skills to learn and the salary averages for each.

 - **SQL dominates demand by a wide margin.** It appears in 100 postings — nearly 1.5x Tableau (70) and over double Excel (65), and more than double Python (40). For marketing-analyst roles, SQL isn't just common, it's close to universal.

- **High demand and high pay don't line up.** The three most in-demand skills (sql, tableau, excel: 100, 70, 65 postings) all pay *below* the average of several lower-demand skills — python (40 postings, $105,027), looker (25, $109,601), r (23, $111,006), and snowflake (17, $112,121) all pay more despite being required far less often. This fits the pattern we've seen throughout: widespread "table-stakes" skills get diluted pay, while scarcer, more specialized skills command a premium.

- **Snowflake stands out as the best "demand-to-pay" tradeoff in this list.** It has the fewest postings (17) but the highest average salary ($112,121) of the whole set — a small but reliable signal that cloud data warehousing is a differentiator worth having, now backed by a double-digit sample size rather than the 1-2 posting flukes we saw with `notion` or `twilio` in the earlier (unfiltered) data.

![Optimal Skils](assets\5_optimal_skills.png)
*Chart visualizing the most optimal skills for data analysts to learn based on demand and salary; ChatGPT generated this graph from my SQL query results*

# What I learned
Throughout this project I've strengthened my efficency working in SQL in a few different ways:
- **complex query crafting:** From merging tables, to using WITH clauses, I became comfortable enough with advanced SQL to answer complex queries of different magnitudes.
- **Data aggregation:** Used GROUP BY and aggregate function like COUNT() and AVG () to summarize large data.
- **Analytics:** Solved real-world problems using problem-solving skills that turned questions into actionable, insightful SQL queries. 

# Conclusion

### Insights
1. **Top paying Data Analyst Jobs:**
2. **Skills for top-paying Jobs:** 
3.  **Most In-Demand Skills:** 
4. **Skills with Higher Salaries:**
5. **Optimal Skills for Job Markert Value** 


### Closing thoughts 
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better postion themselves in a competititve job market by focusing on high demand, high salary skills. This exploration higlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics. 