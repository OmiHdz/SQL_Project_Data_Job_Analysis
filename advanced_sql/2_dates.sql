SELECT * FROM job_postings_fact 
ORDER BY job_posted_date ASC
LIMIT 10





/*
WITH q1_jobs AS(
    -- Get the jobs and companyes from January
    SELECT 
        job_title_short,
        job_id,
        salary_year_avg as salary
    FROM january_jobs

    UNION ALL-- Combines table WITH DUPLICATES
    -- Get the jobs and companyes from February
    SELECT 
        job_title_short,
        job_id,
        salary_year_avg as salary
    FROM february_jobs

    UNION ALL
    -- Get the jobs and companyes from March
    SELECT 
        job_title_short,
        job_id,
        salary_year_avg as salary
    FROM march_jobs
    )
SELECT 
    q1_jobs.job_id,
    skills_job_dim.skill_id,
    q1_jobs.salary,
    skills_dim.skills as skill_name,
    skills_dim.type as type

FROM q1_jobs
LEFT JOIN skills_job_dim ON skills_job_dim.job_id = q1_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE q1_jobs.salary > 70000 AND q1_jobs.job_title_short = 'Data Analyst'
ORDER BY q1_jobs.salary DESC

ORDER BY q1_jobs.job_id, skills_dim.skills







*Get the corresponding skill and skill_tye for each job_posting in q1
*include those without any skills
*look for the skills and type for each job in q1 with salary > 70k

*/





-- Get the jobs and companyes from January
SELECT 
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION ALL-- Combines table WITH DUPLICATES
-- Get the jobs and companyes from February
SELECT 
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION ALL
-- Get the jobs and companyes from March
SELECT 
    job_title_short,
    company_id,
    job_location
FROM march_jobs






-- Get the jobs and companyes from January
SELECT 
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION -- Combines table without duplicates
-- Get the jobs and companyes from February
SELECT 
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION
-- Get the jobs and companyes from March
SELECT 
    job_title_short,
    company_id,
    job_location
FROM march_jobs


/*
WITH remote_job_skills AS(
        SELECT 
            skill_id, 
            COUNT(*) AS skill_count

            FROM 
            job_postings_fact 
            LEFT JOIN skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id 
            WHERE job_postings_fact.job_work_from_home = TRUE AND
            job_postings_fact.job_title_short = 'Data Analyst'
            GROUP BY skill_id 
            )
SELECT 
    skills_dim.skill_id,
    skills_dim.skills as skill_name,
    remote_job_skills.skill_count as job_count
FROM remote_job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id 
ORDER BY remote_job_skills.skill_count DESC
LIMIT 5 

ambas correctas pero la de arriba es más slim, versión profesor


WITH 
    remote_jobs AS( 
            SELECT 
            job_postings_fact.job_id, 
            skills_job_dim.skill_id 
            FROM 
            job_postings_fact 
            LEFT JOIN skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id 
            WHERE job_work_from_home = TRUE ) ,
    skill_count AS( 
    SELECT 
        remote_jobs.skill_id, 
        COUNT( DISTINCT job_id) AS job_count 
        FROM remote_jobs 
        GROUP BY skill_id 
    ) 
    SELECT 
    skill_count.skill_id, 
    skill_count.job_count, 
    skills_dim.skills AS skill_name 
    FROM skill_count 
    INNER JOIN skills_dim ON skills_dim.skill_id = skill_count.skill_id 
    ORDER BY skill_count.job_count DESC 
    LIMIT 5

Necesitamos primero encontrar los job_ids con remote
después contar los skills asociados a esos job_ids y ordenarlos al top 5
después hacer Join con la tabla skills_dim para encontrar el nombre de la skill
*/


/*
Find the count of the number of remote job postings per skill
    - Display top 5 skills by demand in remote jobs
    -Include skill_idm name, and count of postings requiring the skill
*/


/*
WITH job_size AS(
    SELECT
        company_id, 
        COUNT(job_id) as job_count
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT 
    job_size.company_id,
    job_size.job_count,
    CASE 
        WHEN job_size.job_count < 10 THEN 'Small'
        WHEN job_size.job_count BETWEEN 10  AND 50 THEN 'Medium'
        WHEN job_size.job_count > 50 THEN 'Large'
    END AS size_category
FROM job_size
ORDER BY job_count DESC


Determine size category (Small, med, large) for each company by identifying the number of
job postings they have.

subquery to calculate the total job postings per company.
small is less than 10 posts ,Med if between 10 -50 , large > 50
subquery to aggregate job counts per company before classifying themb based on size

*/



/*
WITH job_skill_count AS(
    SELECT 
        skill_id,
        COUNT(skill_id) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY COUNT(skill_id) DESC
    LIMIT 5
)
SELECT 
    skills_dim.skills,
    job_skill_count.skill_id,
    job_skill_count.skill_count
FROM skills_dim
INNER JOIN job_skill_count ON job_skill_count.skill_id = skills_dim.skill_id


Top 5 skills more frequently mentioned in job postings
find skill_ids with highest count in skills_job_dim 
join with skills_dim to get names

*/



/*
WITH company_job_count AS(
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM    job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name  AS company_name,
    company_job_count.total_jobs

FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC




CTE's
Find the companies that have the most job openings
- Get the total number of job postings per company (job_posting_fact)
- Return the total number of jobs with the company name (company_dim)

*/




/*SELECT 
    company_id,
    name AS company_name    

FROM company_dim
WHERE company_id IN(
    SELECT 
        company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE
    ORDER BY company_id
)*/



-- ORDER BY job_postings_fact.job_posted_date 






/*
SELECT 
    job_id,
    job_title,
    job_location,
    salary_year_avg,
    CASE 
        WHEN salary_year_avg BETWEEN 30000 AND 69999  THEN 'Low'
        WHEN salary_year_avg BETWEEN 70000 AND 129999 THEN 'Standard'
        WHEN salary_year_avg >= 130000 THEN 'High'

    END AS salary_category

FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC



categorize salaries from each job_posting
* salaries into different buckets
* define what's high, standard, low salary
* only data analyst roles
* order from highest to lowest

*/




/*
SELECT 
    COUNT(job_id) AS number_of_jobs,
    
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY location_category
*/






/*
CREATE TABLE january_23 AS
SELECT * 
FROM job_postings_fact
WHERE job_postings_fact.job_posted_date >= '2023-01-01'
    AND job_postings_fact.job_posted_date < '2023-02-01'
ORDER BY job_postings_fact.job_posted_date 


CREATE TABLE february_jobs AS
SELECT * 
FROM job_postings_fact
WHERE job_postings_fact.job_posted_date >= '2023-02-01'
    AND job_postings_fact.job_posted_date < '2023-03-01'
ORDER BY job_postings_fact.job_posted_date 


CREATE TABLE march_jobs AS
SELECT * 
FROM job_postings_fact
WHERE job_postings_fact.job_posted_date >= '2023-03-01'
    AND job_postings_fact.job_posted_date < '2023-04-01'
ORDER BY job_postings_fact.job_posted_date 




Create 3 tables :
Jan 2023 jobs
Feb 2023
Mar 2023
*/

-- Practice 6



/*
SELECT
    DISTINCT
    company.name,
    EXTRACT(
        QUARTER FROM job_postings_fact.job_posted_date 
    ) AS quarter

FROM job_postings_fact
LEFT JOIN company_dim as company ON company.company_id = job_postings_fact.company_id
WHERE 
    job_postings_fact.job_posted_date >= '2023-01-01'
    AND job_postings_fact.job_posted_date < '2024-01-01'
    AND job_postings_fact.job_health_insurance = TRUE
    AND
    EXTRACT(
        QUARTER FROM job_postings_fact.job_posted_date 
    ) = 2

company_name that posted jobs offering health insurance
only postings made during the q2 of 2023
exctract to filter by quarter

*/

/* 
SELECT
    -- *
    COUNT(job_id),
    EXTRACT(
        MONTH FROM
        job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York' 
    ) AS job_month

FROM job_postings_fact
WHERE 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York' >= '2023-01-01'
AND job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York' <  '2024-01-01'
GROUP BY job_month
ORDER BY job_month


number of job posts
FOR EACH MONTH
in 2023
adjusting job_post_date to be in AMERICA/NY time zone
group and order by month
*/

/*
SELECT
    -- *
    job_schedule_type,
    AVG(salary_year_avg) AS salary_year_avg,
    AVG(salary_hour_avg) AS salary_hour_avg
FROM job_postings_fact
WHERE job_posted_date >'2023-06-01'
GROUP BY job_schedule_type




Average salary both yearly and hourly
for jobs posted after June 1 2023
Group by job schedule type
*/













/*
WHERE job_title_short='Data Scientist' AND job_location='Mexico'
GROUP BY month
ORDER BY job_count DESC
*/

    /*job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date_time,
    EXTRACT(MONTH FROM job_posted_date) as month,
    EXTRACT(YEAR FROM job_posted_date) as month*/