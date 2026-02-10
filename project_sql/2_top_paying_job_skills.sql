/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Scientist jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
  helping job seekers understand which skills to develop that align with top salaries
*/




WITH top_paying_jobs AS(
    SELECT 
        job_postings_fact.job_id,
        job_title,
        salary_year_avg,
        name AS company_name
        

    FROM job_postings_fact 
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    WHERE 
        job_title_short = 'Data Scientist'
        AND job_location = 'Anywhere' --United States
        AND job_work_from_home = TRUE 
        AND salary_year_avg IS NOT NULL
    ORDER BY  salary_year_avg DESC
    LIMIT 10

)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills AS skill_name

FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC

-- SELECT * FROM skills_dim LIMIT 3  -- skill_id / skills / type
-- SELECT * FROM skills_job_dim LIMIT 3 -- job_id / skill_id


--     company_dim.name AS company_name,
--     skills_dim.skills AS skill_name

--     INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
-- INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id