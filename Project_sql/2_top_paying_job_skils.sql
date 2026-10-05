/*
Question: What skills are required for the top_paying data/ marketing analyst jobs?
- Use the top 10 highest-paying Data Anaylst jobs from first query
- add the specific skills required for these roles
- why? It provides a detailed look at which high paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
*/


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

/*
Key insights:
- SQL and Tableau are the clear baseline — each appears in 7 of the 9 postings (78%). If you're targeting these roles, 
these two are non-negotiable.
- Python shows up in over half (5 of 9), reinforcing SQL + Python + Tableau as the core stack for marketing-focused data analyst roles.
- Excel still matters (4 of 9) even at senior/lead salary levels — it hasn't been fully displaced by BI tools.
- "Phoenix" is odd — it appears in 3 postings, all at USAA (two of them at the same salary, $167,755). 
    This is likely an internal tool or system name at USAA rather than a general industry skill — worth treating as an outlier rather than a market signal.
- The two highest-paying roles ($167,755, both USAA) require the widest skill sets (5–7 skills each), including SQL, Python, and either R or SAS 
    suggesting the top pay tier rewards statistical/programming breadth, not just BI tool fluency.
*/
