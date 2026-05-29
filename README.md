# HR Analytics SQL Project

## Описание проекта

Проект посвящён анализу рынка вакансий аналитиков данных и системных аналитиков на основе данных из таблицы `public.parcing_table`.

Цель проекта — изучить рынок аналитических вакансий: определить зарплатные диапазоны, основные регионы и компании, востребованные грейды, условия труда и ключевые навыки.

## Инструменты

- PostgreSQL
- DBeaver
- SQL
- GitHub

## Данные

В проекте использовалась таблица `public.parcing_table`, содержащая информацию о вакансиях:

- название вакансии;
- работодатель;
- регион;
- дата публикации;
- зарплатные вилки;
- опыт работы;
- тип занятости;
- график работы;
- hard skills;
- soft skills.

## Основные задачи анализа

В рамках проекта были выполнены следующие задачи:

1. Рассчитана общая статистика по зарплатным вилкам.
2. Определены регионы с наибольшим количеством вакансий.
3. Выявлены компании с наибольшим числом открытых вакансий.
4. Проанализированы типы занятости и графики работы.
5. Изучено распределение грейдов Junior, Middle и Senior.
6. Проанализировано распределение грейдов отдельно для Data Analyst и System Analyst.
7. Определены основные регионы для аналитических вакансий.
8. Выявлены основные работодатели, зарплаты и условия труда для аналитиков.
9. Проанализированы зарплаты по типу аналитика и грейду.
10. Определены наиболее востребованные hard skills и soft skills.

## Использованные SQL-подходы

В проекте использовались:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `COUNT`
- `AVG`
- `MIN`
- `MAX`
- `CASE WHEN`
- `ILIKE`
- `NULLIF`
- `ROUND`
- `UNION ALL`
- оконные функции
- обработка пропущенных и нулевых значений

## Структура проекта

```text
HR_Analytics_SQL_Project/
│
├── README.md
├── sql_queries.sql
│
├── results/
│   ├── 01_salary_overview.csv
│   ├── 02_top_regions.csv
│   ├── 03_top_employers.csv
│   ├── 04_employment_schedule.csv
│   ├── 05_grades_distribution.csv
│   ├── 06_grades_by_position.csv
│   ├── 07_analyst_top_regions.csv
│   ├── 08_analyst_employers_conditions.csv
│   ├── 09_salary_by_position_grade.csv
│   └── 10_skills_by_position_grade.csv
│
└── screenshots/
    ├── 01_salary_overview.png
    ├── 02_top_regions.png
    ├── 03_top_employers.png
    ├── 04_employment_schedule.png
    ├── 05_grades_distribution.png
    ├── 06_grades_by_position.png
    ├── 07_analyst_top_regions.png
    ├── 08_analyst_employers_conditions.png
    ├── 09_salary_by_position_grade.png
    └── 10_skills_by_position_grade.png


## Примеры SQL-запросов

Полный набор SQL-запросов находится в файле [`sql_queries.sql`](sql_queries.sql).  
Ниже представлены несколько ключевых примеров.

### 1. Общая статистика по зарплатам

```sql
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
```

### 2. Топ регионов по количеству вакансий

```sql
SELECT 
    area,
    COUNT(*) AS vacancies_count
FROM public.parcing_table
GROUP BY area
ORDER BY vacancies_count DESC
LIMIT 10;
```

### 3. Распределение грейдов среди аналитиков

```sql
SELECT 
    CASE
        WHEN experience ILIKE '%junior%' THEN 'Junior'
        WHEN experience ILIKE '%middle%' THEN 'Middle'
        WHEN experience ILIKE '%senior%' THEN 'Senior'
        ELSE 'Not specified'
    END AS grade,
    COUNT(*) AS vacancies_count
FROM public.parcing_table
WHERE name ILIKE '%системн%аналитик%'
   OR name ILIKE '%аналитик%данн%'
   OR name ILIKE '%data analyst%'
   OR name ILIKE '%system analyst%'
GROUP BY grade
ORDER BY vacancies_count DESC;
```

---

## Результаты

Результаты SQL-запросов сохранены в папке [`results`] в формате CSV.  
Скриншоты выполненных запросов и таблиц с результатами находятся в папке [`screenshots`].

| № | Раздел анализа | CSV | Скриншот |
|---|---|---|---|
| 1 | Общая статистика по зарплатам | `01_salary_overview.csv` | `01_salary_overview.png` |
| 2 | Топ регионов | `02_top_regions.csv` | `02_top_regions.png` |
| 3 | Топ работодателей | `03_top_employers.csv` | `03_top_employers.png` |
| 4 | Тип занятости и график | `04_employment_schedule.csv` | `04_employment_schedule.png` |
| 5 | Распределение грейдов | `05_grades_distribution.csv` | `05_grades_distribution.png` |
| 6 | Грейды по позициям | `06_grades_by_position.csv` | `06_grades_by_position.png` |
| 7 | Топ регионов для аналитиков | `07_analyst_top_regions.csv` | `07_analyst_top_regions.png` |
| 8 | Работодатели и условия | `08_analyst_employers_conditions.csv` | `08_analyst_employers_conditions.png` |
| 9 | Зарплаты по позиции и грейду | `09_salary_by_position_grade.csv` | `09_salary_by_position_grade.png` |
| 10 | Навыки по позициям и грейдам | `10_skills_by_position_grade.csv` | `10_skills_by_position_grade.png` |

---

## Основные выводы

- Наибольшее количество вакансий сосредоточено в крупнейших регионах и городах.
- Среди работодателей выделяются компании с большим количеством открытых аналитических позиций.
- Наиболее распространённые условия труда — полная занятость и стандартный график.
- В вакансиях аналитиков часто встречаются грейды Junior / Middle, а также позиции без явного указания грейда.
- Для аналитиков данных и системных аналитиков востребованы разные наборы навыков.
- Среди hard skills чаще встречаются SQL, Excel, Python, BI-инструменты и навыки работы с данными.
- Среди soft skills чаще встречаются коммуникация, аналитическое мышление и умение работать в команде.

---

## Что показывает проект

Проект демонстрирует навыки:

- написания SQL-запросов;
- агрегации и группировки данных;
- фильтрации текстовых данных через `ILIKE`;
- обработки пропущенных и нулевых значений;
- категоризации данных через `CASE WHEN`;
- анализа зарплат, вакансий, работодателей и навыков;
- подготовки результатов для портфолио и дальнейшей визуализации.
