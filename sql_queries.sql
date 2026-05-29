-- =========================================================
-- HR Analytics SQL Project
-- Анализ вакансий аналитиков данных и системных аналитиков
--
-- База: PostgreSQL
-- Таблица: public.parcing_table
--
-- Примечания:
-- 1. Значения salary_from = 0 и salary_to = 0 считаются отсутствующими.
-- 2. Для поиска вакансий аналитиков используется ILIKE, чтобы учитывать разный регистр.
-- 3. Основные позиции в проекте: Data Analyst и System Analyst.
-- =========================================================


-- =========================================================
-- 1. Общая статистика по зарплатным вилкам во всём датасете
-- =========================================================
SELECT
    ROUND(AVG(NULLIF(salary_from, 0)), 2) AS avg_salary_from,
    MIN(NULLIF(salary_from, 0)) AS min_salary_from,
    MAX(NULLIF(salary_from, 0)) AS max_salary_from,
    ROUND(AVG(NULLIF(salary_to, 0)), 2) AS avg_salary_to,
    MIN(NULLIF(salary_to, 0)) AS min_salary_to,
    MAX(NULLIF(salary_to, 0)) AS max_salary_to
FROM public.parcing_table
WHERE salary_from > 0
   OR salary_to > 0;


-- =========================================================
-- 2. Топ-10 регионов по количеству вакансий во всём датасете
-- =========================================================
SELECT
    area,
    COUNT(*) AS vacancies_count
FROM public.parcing_table
GROUP BY area
ORDER BY vacancies_count DESC
LIMIT 10;


-- =========================================================
-- 3. Топ-20 работодателей по количеству вакансий во всём датасете
-- =========================================================
SELECT
    employer,
    COUNT(*) AS vacancies_count
FROM public.parcing_table
GROUP BY employer
ORDER BY vacancies_count DESC
LIMIT 20;


-- =========================================================
-- 4. Распределение вакансий по типу занятости и графику работы
-- =========================================================
SELECT
    employment,
    schedule,
    COUNT(*) AS vacancies_count
FROM public.parcing_table
GROUP BY employment, schedule
ORDER BY vacancies_count DESC;


-- =========================================================
-- 5. Распределение грейдов среди аналитиков данных и системных аналитиков
-- =========================================================
WITH analyst_vacancies AS (
    SELECT
        id,
        name,
        experience,
        CASE
            WHEN name ILIKE '%системн%аналитик%'
              OR name ILIKE '%system analyst%'
                THEN 'System Analyst'
            WHEN name ILIKE '%аналитик%данн%'
              OR name ILIKE '%data analyst%'
                THEN 'Data Analyst'
            ELSE 'Other Analyst'
        END AS analyst_type,
        CASE
            WHEN name ILIKE '%junior%'
              OR name ILIKE '%джун%'
              OR name ILIKE '%младш%'
              OR experience ILIKE '%junior%'
              OR experience ILIKE '%1-3%'
                THEN 'Junior'
            WHEN name ILIKE '%senior%'
              OR name ILIKE '%старш%'
              OR name ILIKE '%ведущ%'
              OR experience ILIKE '%senior%'
              OR experience ILIKE '%6+%'
              OR experience ILIKE '%более 6%'
              OR experience ILIKE '%more than 6%'
                THEN 'Senior'
            WHEN name ILIKE '%middle%'
              OR name ILIKE '%мидл%'
              OR experience ILIKE '%middle%'
              OR experience ILIKE '%3-6%'
                THEN 'Middle'
            ELSE 'Not specified'
        END AS grade
    FROM public.parcing_table
    WHERE name ILIKE '%системн%аналитик%'
       OR name ILIKE '%аналитик%данн%'
       OR name ILIKE '%data analyst%'
       OR name ILIKE '%system analyst%'
)
SELECT
    grade,
    COUNT(*) AS vacancies_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS vacancies_percent
FROM analyst_vacancies
GROUP BY grade
ORDER BY vacancies_count DESC;


-- =========================================================
-- 6. Распределение грейдов отдельно по Data Analyst и System Analyst
-- =========================================================
WITH analyst_vacancies AS (
    SELECT
        id,
        name,
        experience,
        CASE
            WHEN name ILIKE '%системн%аналитик%'
              OR name ILIKE '%system analyst%'
                THEN 'System Analyst'
            WHEN name ILIKE '%аналитик%данн%'
              OR name ILIKE '%data analyst%'
                THEN 'Data Analyst'
            ELSE 'Other Analyst'
        END AS analyst_type,
        CASE
            WHEN name ILIKE '%junior%'
              OR name ILIKE '%джун%'
              OR name ILIKE '%младш%'
              OR experience ILIKE '%junior%'
              OR experience ILIKE '%1-3%'
                THEN 'Junior'
            WHEN name ILIKE '%senior%'
              OR name ILIKE '%старш%'
              OR name ILIKE '%ведущ%'
              OR experience ILIKE '%senior%'
              OR experience ILIKE '%6+%'
              OR experience ILIKE '%более 6%'
              OR experience ILIKE '%more than 6%'
                THEN 'Senior'
            WHEN name ILIKE '%middle%'
              OR name ILIKE '%мидл%'
              OR experience ILIKE '%middle%'
              OR experience ILIKE '%3-6%'
                THEN 'Middle'
            ELSE 'Not specified'
        END AS grade
    FROM public.parcing_table
    WHERE name ILIKE '%системн%аналитик%'
       OR name ILIKE '%аналитик%данн%'
       OR name ILIKE '%data analyst%'
       OR name ILIKE '%system analyst%'
)
SELECT
    analyst_type,
    grade,
    COUNT(*) AS vacancies_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY analyst_type), 2) AS vacancies_percent
FROM analyst_vacancies
GROUP BY analyst_type, grade
ORDER BY analyst_type, vacancies_count DESC;


-- =========================================================
-- 7. Основные регионы для аналитиков данных и системных аналитиков
-- =========================================================
SELECT
    area,
    COUNT(*) AS vacancies_count
FROM public.parcing_table
WHERE name ILIKE '%системн%аналитик%'
   OR name ILIKE '%аналитик%данн%'
   OR name ILIKE '%data analyst%'
   OR name ILIKE '%system analyst%'
GROUP BY area
ORDER BY vacancies_count DESC
LIMIT 10;


-- =========================================================
-- 8. Основные работодатели, зарплаты и условия труда для аналитиков
-- =========================================================
WITH analyst_vacancies AS (
    SELECT
        id,
        name,
        employer,
        employment,
        schedule,
        experience,
        salary_from,
        salary_to,
        CASE
            WHEN name ILIKE '%системн%аналитик%'
              OR name ILIKE '%system analyst%'
                THEN 'System Analyst'
            WHEN name ILIKE '%аналитик%данн%'
              OR name ILIKE '%data analyst%'
                THEN 'Data Analyst'
            ELSE 'Other Analyst'
        END AS analyst_type
    FROM public.parcing_table
    WHERE name ILIKE '%системн%аналитик%'
       OR name ILIKE '%аналитик%данн%'
       OR name ILIKE '%data analyst%'
       OR name ILIKE '%system analyst%'
)
SELECT
    employer,
    COUNT(*) AS vacancies_count,
    COUNT(*) FILTER (WHERE salary_from > 0 OR salary_to > 0) AS vacancies_with_salary,
    ROUND(AVG(NULLIF(salary_from, 0)), 2) AS avg_salary_from,
    ROUND(AVG(NULLIF(salary_to, 0)), 2) AS avg_salary_to,
    MIN(NULLIF(salary_from, 0)) AS min_salary_from,
    MAX(NULLIF(salary_to, 0)) AS max_salary_to,
    STRING_AGG(DISTINCT analyst_type, ', ') AS analyst_types,
    STRING_AGG(DISTINCT employment, ', ') AS employment_types,
    STRING_AGG(DISTINCT schedule, ', ') AS schedules,
    STRING_AGG(DISTINCT experience, ', ') AS experience_levels
FROM analyst_vacancies
GROUP BY employer
ORDER BY vacancies_count DESC
LIMIT 20;


-- =========================================================
-- 9. Зарплатные вилки по типу аналитика и грейду
-- =========================================================
WITH analyst_vacancies AS (
    SELECT
        id,
        name,
        experience,
        salary_from,
        salary_to,
        CASE
            WHEN name ILIKE '%системн%аналитик%'
              OR name ILIKE '%system analyst%'
                THEN 'System Analyst'
            WHEN name ILIKE '%аналитик%данн%'
              OR name ILIKE '%data analyst%'
                THEN 'Data Analyst'
            ELSE 'Other Analyst'
        END AS analyst_type,
        CASE
            WHEN name ILIKE '%junior%'
              OR name ILIKE '%джун%'
              OR name ILIKE '%младш%'
              OR experience ILIKE '%junior%'
              OR experience ILIKE '%1-3%'
                THEN 'Junior'
            WHEN name ILIKE '%senior%'
              OR name ILIKE '%старш%'
              OR name ILIKE '%ведущ%'
              OR experience ILIKE '%senior%'
              OR experience ILIKE '%6+%'
              OR experience ILIKE '%более 6%'
              OR experience ILIKE '%more than 6%'
                THEN 'Senior'
            WHEN name ILIKE '%middle%'
              OR name ILIKE '%мидл%'
              OR experience ILIKE '%middle%'
              OR experience ILIKE '%3-6%'
                THEN 'Middle'
            ELSE 'Not specified'
        END AS grade
    FROM public.parcing_table
    WHERE name ILIKE '%системн%аналитик%'
       OR name ILIKE '%аналитик%данн%'
       OR name ILIKE '%data analyst%'
       OR name ILIKE '%system analyst%'
)
SELECT
    analyst_type,
    grade,
    COUNT(*) AS vacancies_count,
    COUNT(*) FILTER (WHERE salary_from > 0 OR salary_to > 0) AS vacancies_with_salary,
    ROUND(AVG(NULLIF(salary_from, 0)), 2) AS avg_salary_from,
    ROUND(AVG(NULLIF(salary_to, 0)), 2) AS avg_salary_to,
    MIN(NULLIF(salary_from, 0)) AS min_salary_from,
    MAX(NULLIF(salary_to, 0)) AS max_salary_to
FROM analyst_vacancies
GROUP BY analyst_type, grade
ORDER BY analyst_type, grade;


-- =========================================================
-- 10. Топ навыков: hard и soft skills по позициям и грейдам
-- =========================================================
WITH analyst_vacancies AS (
    SELECT
        id,
        name,
        experience,
        CASE
            WHEN name ILIKE '%системн%аналитик%'
              OR name ILIKE '%system analyst%'
                THEN 'System Analyst'
            WHEN name ILIKE '%аналитик%данн%'
              OR name ILIKE '%data analyst%'
                THEN 'Data Analyst'
            ELSE 'Other Analyst'
        END AS analyst_type,
        CASE
            WHEN name ILIKE '%junior%'
              OR name ILIKE '%джун%'
              OR name ILIKE '%младш%'
              OR experience ILIKE '%junior%'
              OR experience ILIKE '%1-3%'
                THEN 'Junior'
            WHEN name ILIKE '%senior%'
              OR name ILIKE '%старш%'
              OR name ILIKE '%ведущ%'
              OR experience ILIKE '%senior%'
              OR experience ILIKE '%6+%'
              OR experience ILIKE '%более 6%'
              OR experience ILIKE '%more than 6%'
                THEN 'Senior'
            WHEN name ILIKE '%middle%'
              OR name ILIKE '%мидл%'
              OR experience ILIKE '%middle%'
              OR experience ILIKE '%3-6%'
                THEN 'Middle'
            ELSE 'Not specified'
        END AS grade,
        key_skills_1,
        key_skills_2,
        key_skills_3,
        key_skills_4,
        soft_skills_1,
        soft_skills_2,
        soft_skills_3,
        soft_skills_4
    FROM public.parcing_table
    WHERE name ILIKE '%системн%аналитик%'
       OR name ILIKE '%аналитик%данн%'
       OR name ILIKE '%data analyst%'
       OR name ILIKE '%system analyst%'
),
all_skills AS (
    SELECT analyst_type, grade, 'Hard Skill' AS skill_type, key_skills_1 AS skill FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Hard Skill', key_skills_2 FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Hard Skill', key_skills_3 FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Hard Skill', key_skills_4 FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Soft Skill', soft_skills_1 FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Soft Skill', soft_skills_2 FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Soft Skill', soft_skills_3 FROM analyst_vacancies
    UNION ALL
    SELECT analyst_type, grade, 'Soft Skill', soft_skills_4 FROM analyst_vacancies
),
skill_counts AS (
    SELECT
        analyst_type,
        grade,
        skill_type,
        LOWER(TRIM(skill)) AS skill,
        COUNT(*) AS vacancies_count
    FROM all_skills
    WHERE skill IS NOT NULL
      AND TRIM(skill) <> ''
    GROUP BY analyst_type, grade, skill_type, LOWER(TRIM(skill))
),
ranked_skills AS (
    SELECT
        analyst_type,
        grade,
        skill_type,
        skill,
        vacancies_count,
        ROW_NUMBER() OVER (
            PARTITION BY analyst_type, grade, skill_type
            ORDER BY vacancies_count DESC
        ) AS skill_rank
    FROM skill_counts
)
SELECT
    analyst_type,
    grade,
    skill_type,
    skill,
    vacancies_count,
    skill_rank
FROM ranked_skills
WHERE skill_rank <= 10
ORDER BY analyst_type, grade, skill_type, skill_rank;
