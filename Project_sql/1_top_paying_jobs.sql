/*
question: what are the top_paying data analyst jobs?
- focuses on job postings with specified salaries (remove nulls).
- why? highligh the top_paying opportunities for data analysts, offering insights into empoyment
*/

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
    (job_title ILIKE '%marketing%' OR job_title ILIKE '%analyst%')
    AND (job_location ILIKE '%Austin%' OR job_location ILIKE '%San Antonio%' OR job_location ILIKE '%Dallas%') 
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 100;

