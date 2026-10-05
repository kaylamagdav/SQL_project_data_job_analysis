/*
Answer - What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
-Focuses on roles with specified salaries, regardless of location
- why? it reveals how different skills impact salary levels for Data Analysts and 
helps identify the most financially reqaring skills to acquire or improve
*/  

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

/* 
Here's a breakdown of the results for top paying skills
-- **Infrastructure beats application tools.** Big data and cloud skills (`hadoop`, `nosql`, `snowflake`, `airflow`, `azure`, `aws`) 
     dominate the top of the list, while classic analyst tools (`python`, `vba`, `spreadsheet`, `cognos`) cluster near the bottom — 
     proximity to data engineering pays a premium over everyday analytical tools.

-- **BI tools are solid but not standout.** `microstrategy`, `looker`, and `cognos` 
     all land mid-pack in the six figures — expected baseline skills for an analyst, not differentiators.

-- **Watch for small-sample outliers.** Entries like `notion`, `twilio`, `zoom`, `confluence`, and `phoenix` 
     are unusual for a "data analyst skills" list — these likely reflect just 1–2 high-paying postings 
     rather than genuine market demand, so they're worth verifying against sample size before drawing conclusions.