/*
Question: what are the most in demand skills for data analysts and marketing analysts?
- Identify the top 5 in demand skills for a data analyst.
- focus on all job postings.
- why? retrieves the top 5 skills with the highest demand in the job market,
     providing insights into the most caluable skills for job seekers
     */

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
