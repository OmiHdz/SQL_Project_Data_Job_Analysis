/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/





SELECT 
    -- * 
    skills_dim.skills AS skill_name,
    COUNT(DISTINCT job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Scientist' --'Data Analyst'
GROUP BY skills_dim.skills 
ORDER BY demand_count DESC
LIMIT 5







-- SELECT 
--     -- * 
--     skills_dim.skills AS skill_name,
--     COUNT(DISTINCT job_postings_fact.job_id) AS job_count
-- FROM job_postings_fact
-- INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
-- INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
-- GROUP BY skills_dim.skills 
-- ORDER BY job_count DESC
-- LIMIT 10



-- SELECT * FROM skills_dim LIMIT 3  -- skill_id / skills / type
-- SELECT * FROM skills_job_dim LIMIT 3 -- job_id / skill_id