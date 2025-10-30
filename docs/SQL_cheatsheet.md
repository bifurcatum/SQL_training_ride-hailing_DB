# SQL Quick Reference Cheatsheet

## 📋 Table of Contents
- [Basic SELECT](#basic-select)
- [Filtering & Sorting](#filtering--sorting)
- [Aggregations](#aggregations)
- [JOINs](#joins)
- [Window Functions](#window-functions)
- [Date Functions](#date-functions)
- [String Functions](#string-functions)
- [Subqueries & CTEs](#subqueries--ctes)
- [CASE Statements](#case-statements)
- [NULL Handling](#null-handling)
- [Set Operations](#set-operations)
- [Common Patterns](#common-patterns)
- [Performance Tips](#performance-tips)

---

## Basic SELECT

```sql
-- Select specific columns
SELECT column1, column2 FROM table_name;

-- Select all columns
SELECT * FROM table_name;

-- Select with alias
SELECT column1 AS alias_name FROM table_name;

-- Distinct values
SELECT DISTINCT column1 FROM table_name;

-- Limit results
SELECT * FROM table_name LIMIT 10;
```

---

## Filtering & Sorting

```sql
-- WHERE clause
SELECT * FROM table_name WHERE condition;

-- Multiple conditions
SELECT * FROM table_name 
WHERE condition1 AND condition2;

SELECT * FROM table_name 
WHERE condition1 OR condition2;

-- IN operator
SELECT * FROM table_name 
WHERE column1 IN (value1, value2, value3);

-- BETWEEN
SELECT * FROM table_name 
WHERE column1 BETWEEN value1 AND value2;

-- LIKE pattern matching
SELECT * FROM table_name 
WHERE column1 LIKE 'pattern%';  -- Starts with
WHERE column1 LIKE '%pattern';  -- Ends with
WHERE column1 LIKE '%pattern%'; -- Contains

-- IS NULL / IS NOT NULL
SELECT * FROM table_name WHERE column1 IS NULL;
SELECT * FROM table_name WHERE column1 IS NOT NULL;

-- ORDER BY
SELECT * FROM table_name ORDER BY column1 ASC;  -- Ascending
SELECT * FROM table_name ORDER BY column1 DESC; -- Descending

-- Multiple sort columns
SELECT * FROM table_name 
ORDER BY column1 DESC, column2 ASC;
```

---

## Aggregations

```sql
-- Basic aggregates
SELECT COUNT(*) FROM table_name;
SELECT COUNT(DISTINCT column1) FROM table_name;
SELECT SUM(column1) FROM table_name;
SELECT AVG(column1) FROM table_name;
SELECT MIN(column1) FROM table_name;
SELECT MAX(column1) FROM table_name;

-- GROUP BY
SELECT column1, COUNT(*) 
FROM table_name 
GROUP BY column1;

-- GROUP BY with multiple columns
SELECT column1, column2, COUNT(*) 
FROM table_name 
GROUP BY column1, column2;

-- HAVING (filter after grouping)
SELECT column1, COUNT(*) as cnt
FROM table_name 
GROUP BY column1
HAVING COUNT(*) > 10;

-- ROUND numbers
SELECT ROUND(AVG(column1), 2) FROM table_name;
```

---

## JOINs

```sql
-- INNER JOIN (only matching rows)
SELECT t1.*, t2.column
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.foreign_id;

-- LEFT JOIN (all from left table)
SELECT t1.*, t2.column
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.foreign_id;

-- RIGHT JOIN (all from right table)
SELECT t1.*, t2.column
FROM table1 t1
RIGHT JOIN table2 t2 ON t1.id = t2.foreign_id;

-- Multiple JOINs
SELECT t1.*, t2.column, t3.column
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.foreign_id
INNER JOIN table3 t3 ON t1.id = t3.foreign_id;

-- Self JOIN
SELECT t1.column, t2.column
FROM table1 t1
JOIN table1 t2 ON t1.parent_id = t2.id;

-- Join same table twice (with different aliases)
SELECT 
    r.*,
    pickup.city_name as pickup_city,
    dropoff.city_name as dropoff_city
FROM rides r
JOIN locations pickup ON r.pickup_location_id = pickup.id
JOIN locations dropoff ON r.dropoff_location_id = dropoff.id;
```

---

## Window Functions

```sql
-- ROW_NUMBER (unique sequential number)
SELECT 
    column1,
    ROW_NUMBER() OVER (ORDER BY column2) as row_num
FROM table_name;

-- RANK (same values get same rank, gaps in sequence)
SELECT 
    column1,
    RANK() OVER (ORDER BY column2 DESC) as rank
FROM table_name;

-- DENSE_RANK (same values get same rank, no gaps)
SELECT 
    column1,
    DENSE_RANK() OVER (ORDER BY column2 DESC) as rank
FROM table_name;

-- PARTITION BY (restart numbering for each group)
SELECT 
    category,
    column1,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY column2) as row_num
FROM table_name;

-- LAG (previous row value)
SELECT 
    column1,
    column2,
    LAG(column2, 1) OVER (ORDER BY column1) as previous_value
FROM table_name;

-- LEAD (next row value)
SELECT 
    column1,
    column2,
    LEAD(column2, 1) OVER (ORDER BY column1) as next_value
FROM table_name;

-- Running total (cumulative sum)
SELECT 
    date,
    amount,
    SUM(amount) OVER (ORDER BY date) as running_total
FROM table_name;

-- Moving average
SELECT 
    date,
    value,
    AVG(value) OVER (
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7days
FROM table_name;

-- NTILE (divide into N groups)
SELECT 
    column1,
    NTILE(4) OVER (ORDER BY column2) as quartile
FROM table_name;

-- FIRST_VALUE and LAST_VALUE
SELECT 
    column1,
    FIRST_VALUE(column2) OVER (PARTITION BY group_col ORDER BY date) as first_val,
    LAST_VALUE(column2) OVER (
        PARTITION BY group_col 
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_val
FROM table_name;
```

---

## Date Functions

```sql
-- Current date/time
SELECT NOW();           -- Current datetime
SELECT CURDATE();       -- Current date
SELECT CURTIME();       -- Current time

-- Extract parts of date
SELECT DATE(datetime_column);           -- Date only
SELECT YEAR(date_column);               -- Year
SELECT MONTH(date_column);              -- Month (1-12)
SELECT DAY(date_column);                -- Day of month
SELECT HOUR(datetime_column);           -- Hour
SELECT DAYOFWEEK(date_column);          -- Day of week (1=Sunday, 7=Saturday)
SELECT DAYNAME(date_column);            -- Day name (Monday, Tuesday, etc.)
SELECT MONTHNAME(date_column);          -- Month name (January, February, etc.)
SELECT QUARTER(date_column);            -- Quarter (1-4)
SELECT WEEK(date_column);               -- Week of year

-- Date arithmetic
SELECT DATE_ADD(date_column, INTERVAL 1 DAY);
SELECT DATE_SUB(date_column, INTERVAL 7 DAY);
SELECT DATE_ADD(date_column, INTERVAL 1 MONTH);
SELECT DATE_ADD(date_column, INTERVAL 1 YEAR);

-- Difference between dates
SELECT DATEDIFF(date1, date2);                       -- Difference in days
SELECT TIMESTAMPDIFF(HOUR, datetime1, datetime2);    -- Difference in hours
SELECT TIMESTAMPDIFF(MINUTE, datetime1, datetime2);  -- Difference in minutes

-- Format dates
SELECT DATE_FORMAT(date_column, '%Y-%m-%d');        -- 2025-01-15
SELECT DATE_FORMAT(date_column, '%M %d, %Y');       -- January 15, 2025
SELECT DATE_FORMAT(date_column, '%W, %M %d, %Y');   -- Wednesday, January 15, 2025

-- Create date from parts
SELECT CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0'));

-- Truncate to beginning of period
SELECT DATE_FORMAT(date_column, '%Y-%m-01');        -- First day of month
```

---

## String Functions

```sql
-- Concatenation
SELECT CONCAT(first_name, ' ', last_name) as full_name;
SELECT CONCAT_WS('-', year, month, day);  -- With separator

-- Case conversion
SELECT UPPER(column1);      -- UPPERCASE
SELECT LOWER(column1);      -- lowercase

-- Substring
SELECT SUBSTRING(column1, 1, 10);       -- First 10 characters
SELECT LEFT(column1, 5);                -- Left 5 characters
SELECT RIGHT(column1, 5);               -- Right 5 characters

-- Length
SELECT LENGTH(column1);                 -- String length
SELECT CHAR_LENGTH(column1);            -- Character length

-- Trim whitespace
SELECT TRIM(column1);                   -- Both sides
SELECT LTRIM(column1);                  -- Left side
SELECT RTRIM(column1);                  -- Right side

-- Replace
SELECT REPLACE(column1, 'old', 'new');

-- Padding
SELECT LPAD(column1, 5, '0');          -- Left pad: 00123
SELECT RPAD(column1, 10, ' ');         -- Right pad

-- Pattern matching
SELECT column1 LIKE '%pattern%';        -- Contains
SELECT column1 REGEXP '^[A-Z]';         -- Regular expression

-- Position
SELECT LOCATE('substring', column1);    -- Find position
SELECT INSTR(column1, 'substring');     -- Find position (alternative)
```

---

## Subqueries & CTEs

```sql
-- Subquery in WHERE
SELECT * FROM table1
WHERE column1 IN (
    SELECT column1 FROM table2 WHERE condition
);

-- Subquery in SELECT
SELECT 
    column1,
    (SELECT AVG(column2) FROM table2) as avg_value
FROM table1;

-- Subquery in FROM (derived table)
SELECT * FROM (
    SELECT column1, COUNT(*) as cnt
    FROM table1
    GROUP BY column1
) subquery
WHERE cnt > 10;

-- Correlated subquery
SELECT t1.*
FROM table1 t1
WHERE column1 > (
    SELECT AVG(column1)
    FROM table1 t2
    WHERE t2.category = t1.category
);

-- EXISTS
SELECT * FROM table1 t1
WHERE EXISTS (
    SELECT 1 FROM table2 t2
    WHERE t2.foreign_id = t1.id
);

-- NOT EXISTS
SELECT * FROM table1 t1
WHERE NOT EXISTS (
    SELECT 1 FROM table2 t2
    WHERE t2.foreign_id = t1.id
);

-- Common Table Expression (CTE)
WITH cte_name AS (
    SELECT column1, COUNT(*) as cnt
    FROM table1
    GROUP BY column1
)
SELECT * FROM cte_name WHERE cnt > 10;

-- Multiple CTEs
WITH 
cte1 AS (
    SELECT * FROM table1 WHERE condition
),
cte2 AS (
    SELECT * FROM table2 WHERE condition
)
SELECT * FROM cte1 JOIN cte2 ON cte1.id = cte2.id;

-- Recursive CTE (generate series)
WITH RECURSIVE date_series AS (
    SELECT '2025-01-01' as date
    UNION ALL
    SELECT DATE_ADD(date, INTERVAL 1 DAY)
    FROM date_series
    WHERE date < '2025-12-31'
)
SELECT * FROM date_series;
```

---

## CASE Statements

```sql
-- Simple CASE
SELECT 
    column1,
    CASE column1
        WHEN value1 THEN 'Result 1'
        WHEN value2 THEN 'Result 2'
        ELSE 'Other'
    END as result
FROM table_name;

-- Searched CASE (with conditions)
SELECT 
    column1,
    CASE 
        WHEN column1 > 100 THEN 'High'
        WHEN column1 > 50 THEN 'Medium'
        ELSE 'Low'
    END as category
FROM table_name;

-- CASE in aggregation
SELECT 
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as completed_total,
    SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) as pending_total
FROM table_name;

-- CASE in ORDER BY
SELECT * FROM table_name
ORDER BY 
    CASE 
        WHEN priority = 'high' THEN 1
        WHEN priority = 'medium' THEN 2
        ELSE 3
    END;
```

---

## NULL Handling

```sql
-- Check for NULL
WHERE column1 IS NULL
WHERE column1 IS NOT NULL

-- COALESCE (return first non-NULL value)
SELECT COALESCE(column1, column2, 'default') as value;

-- IFNULL (MySQL specific)
SELECT IFNULL(column1, 0) as value;

-- NULLIF (return NULL if equal)
SELECT NULLIF(column1, column2);  -- Returns NULL if equal

-- NULL in calculations
SELECT column1 + COALESCE(column2, 0);  -- Treat NULL as 0

-- NULL in aggregations (NULLs are ignored)
SELECT AVG(column1);  -- Ignores NULL values
SELECT COUNT(column1);  -- Counts non-NULL values
SELECT COUNT(*);  -- Counts all rows including NULLs
```

---

## Set Operations

```sql
-- UNION (combine results, remove duplicates)
SELECT column1 FROM table1
UNION
SELECT column1 FROM table2;

-- UNION ALL (combine results, keep duplicates)
SELECT column1 FROM table1
UNION ALL
SELECT column1 FROM table2;

-- INTERSECT (MySQL 8+)
SELECT column1 FROM table1
INTERSECT
SELECT column1 FROM table2;

-- EXCEPT (in table1 but not in table2) - MySQL 8+
SELECT column1 FROM table1
EXCEPT
SELECT column1 FROM table2;
```

---

## Common Patterns

### Pattern 1: Find Duplicates
```sql
SELECT column1, COUNT(*)
FROM table_name
GROUP BY column1
HAVING COUNT(*) > 1;
```

### Pattern 2: Top N per Group
```sql
WITH ranked AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY group_column ORDER BY value_column DESC) as rn
    FROM table_name
)
SELECT * FROM ranked WHERE rn <= 3;
```

### Pattern 3: Running Total
```sql
SELECT 
    date,
    amount,
    SUM(amount) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING) as running_total
FROM table_name;
```

### Pattern 4: Percent of Total
```sql
SELECT 
    category,
    amount,
    ROUND(100.0 * amount / SUM(amount) OVER (), 2) as pct_of_total
FROM table_name;
```

### Pattern 5: Year-over-Year Growth
```sql
WITH yearly_data AS (
    SELECT 
        YEAR(date) as year,
        SUM(amount) as total
    FROM table_name
    GROUP BY YEAR(date)
)
SELECT 
    year,
    total,
    LAG(total) OVER (ORDER BY year) as previous_year,
    ROUND(100.0 * (total - LAG(total) OVER (ORDER BY year)) / 
          LAG(total) OVER (ORDER BY year), 2) as growth_pct
FROM yearly_data;
```

### Pattern 6: Pivot Table
```sql
SELECT 
    row_category,
    SUM(CASE WHEN col_category = 'A' THEN value ELSE 0 END) as A,
    SUM(CASE WHEN col_category = 'B' THEN value ELSE 0 END) as B,
    SUM(CASE WHEN col_category = 'C' THEN value ELSE 0 END) as C,
    SUM(value) as Total
FROM table_name
GROUP BY row_category;
```

### Pattern 7: Gap and Islands (Find Consecutive Sequences)
```sql
WITH gaps AS (
    SELECT 
        *,
        id - ROW_NUMBER() OVER (ORDER BY id) as grp
    FROM table_name
)
SELECT 
    MIN(id) as start_id,
    MAX(id) as end_id,
    COUNT(*) as sequence_length
FROM gaps
GROUP BY grp;
```

### Pattern 8: Moving Average
```sql
SELECT 
    date,
    value,
    AVG(value) OVER (
        ORDER BY date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as ma_3
FROM table_name;
```

### Pattern 9: First/Last Value in Group
```sql
SELECT DISTINCT
    group_column,
    FIRST_VALUE(value_column) OVER (
        PARTITION BY group_column 
        ORDER BY date
    ) as first_value,
    LAST_VALUE(value_column) OVER (
        PARTITION BY group_column 
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_value
FROM table_name;
```

### Pattern 10: Cohort Analysis
```sql
WITH cohorts AS (
    SELECT 
        user_id,
        DATE_FORMAT(MIN(signup_date), '%Y-%m-01') as cohort_month
    FROM users
    GROUP BY user_id
)
SELECT 
    c.cohort_month,
    TIMESTAMPDIFF(MONTH, c.cohort_month, 
                  DATE_FORMAT(a.activity_date, '%Y-%m-01')) as months_since_signup,
    COUNT(DISTINCT a.user_id) as active_users
FROM cohorts c
LEFT JOIN activity a ON c.user_id = a.user_id
GROUP BY c.cohort_month, months_since_signup
ORDER BY c.cohort_month, months_since_signup;
```

### Pattern 11: Remove Duplicates (Keep First)
```sql
DELETE t1 FROM table_name t1
INNER JOIN table_name t2 
WHERE t1.id > t2.id 
AND t1.duplicate_key = t2.duplicate_key;
```

### Pattern 12: Median Calculation
```sql
WITH numbered AS (
    SELECT 
        value,
        ROW_NUMBER() OVER (ORDER BY value) as rn,
        COUNT(*) OVER () as cnt
    FROM table_name
)
SELECT AVG(value) as median
FROM numbered
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2));
```

---

## Performance Tips

```sql
-- Use EXPLAIN to see query plan
EXPLAIN SELECT * FROM table_name WHERE condition;

-- Use indexes for WHERE clauses
CREATE INDEX idx_column1 ON table_name(column1);

-- Composite indexes for multiple columns
CREATE INDEX idx_multi ON table_name(column1, column2);

-- Cover queries with indexes (include all needed columns)
CREATE INDEX idx_cover ON table_name(column1, column2, column3);

-- Avoid SELECT *
SELECT column1, column2  -- Better than SELECT *
FROM table_name;

-- Use LIMIT when testing
SELECT * FROM table_name LIMIT 100;

-- Filter early with WHERE
SELECT * FROM table_name 
WHERE condition  -- Filter before JOIN when possible
JOIN other_table ON ...;

-- Use EXISTS instead of IN for large subqueries
WHERE EXISTS (subquery)  -- Often faster than IN

-- Avoid functions on indexed columns in WHERE
WHERE YEAR(date_column) = 2025;  -- ❌ Can't use index
WHERE date_column >= '2025-01-01' 
  AND date_column < '2026-01-01';  -- ✅ Uses index

-- Use UNION ALL instead of UNION when duplicates are okay
SELECT ... UNION ALL SELECT ...;  -- Faster (no deduplication)
```

---

## Common Mistakes to Avoid

```sql
-- ❌ Using = NULL
WHERE column1 = NULL;  -- Always returns false!

-- ✅ Use IS NULL
WHERE column1 IS NULL;

-- ❌ Forgetting GROUP BY columns
SELECT column1, column2, COUNT(*)
GROUP BY column1;  -- Error! Missing column2

-- ✅ Include all non-aggregate columns
SELECT column1, column2, COUNT(*)
GROUP BY column1, column2;

-- ❌ Using WHERE with aggregates
WHERE COUNT(*) > 10;  -- Error!

-- ✅ Use HAVING
HAVING COUNT(*) > 10;

-- ❌ Comparing different data types
WHERE int_column = '123';  -- Implicit conversion, slow

-- ✅ Use correct type
WHERE int_column = 123;

-- ❌ Not handling NULL in calculations
SELECT column1 + column2;  -- NULL if either is NULL

-- ✅ Use COALESCE
SELECT COALESCE(column1, 0) + COALESCE(column2, 0);

-- ❌ Using OR in WHERE (can prevent index usage)
WHERE column1 = 'A' OR column1 = 'B';  -- May not use index

-- ✅ Use IN
WHERE column1 IN ('A', 'B');  -- Better for index

-- ❌ Cartesian product (forgot JOIN condition)
SELECT * FROM table1, table2;  -- Returns every combination!

-- ✅ Always specify JOIN condition
SELECT * FROM table1 JOIN table2 ON table1.id = table2.id;
```

---

## Quick Reference for ride_hailing Database

```sql
-- Tables in ride_hailing database
fact_rides          -- Central fact table (1000 rides)
dim_driver          -- 20 drivers
dim_rider           -- 50 riders
dim_location        -- 5 cities (Tallinn, Tartu, Narva, Pärnu, Viljandi)
dim_payment_type    -- 4 payment methods
dim_time            -- 365 days in 2025

-- Common JOINs pattern
FROM fact_rides f
JOIN dim_driver d ON f.driver_id = d.driver_id
JOIN dim_rider r ON f.rider_id = r.rider_id
JOIN dim_location pickup ON f.pickup_location_id = pickup.location_id
JOIN dim_location dropoff ON f.dropoff_location_id = dropoff.location_id
JOIN dim_payment_type p ON f.payment_type_id = p.payment_type_id
JOIN dim_time t ON f.date_id = t.date_id

-- Valid status values
'Completed', 'Cancelled', 'Refunded'

-- Valid payment methods
'Cash', 'Card', 'In-App', 'Promo'

-- Valid vehicle types
'Sedan', 'SUV', 'Economy'

-- Valid loyalty status
'Bronze', 'Silver', 'Gold'

-- Useful filters
WHERE f.status = 'Completed'              -- Only completed rides
WHERE t.is_weekend = TRUE                 -- Weekend rides only
WHERE t.is_holiday = TRUE                 -- Holiday rides only
WHERE HOUR(f.start_time) IN (7,8,17,18)  -- Rush hour rides
WHERE f.pickup_location_id = f.dropoff_location_id  -- Same city rides
```

---

## Useful MySQL 8 Features

```sql
-- JSON functions
SELECT JSON_EXTRACT(json_column, '$.key');
SELECT JSON_ARRAYAGG(column1) FROM table_name;
SELECT JSON_OBJECTAGG(key_col, value_col) FROM table_name;

-- Window function frames
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- All previous + current
ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING          -- ±3 rows
RANGE BETWEEN INTERVAL 7 DAY PRECEDING AND CURRENT ROW  -- Last 7 days

-- GROUP BY with ROLLUP (subtotals)
SELECT category, subcategory, SUM(amount)
FROM table_name
GROUP BY category, subcategory WITH ROLLUP;

-- CTE with UNION
WITH combined AS (
    SELECT * FROM table1
    UNION ALL
    SELECT * FROM table2
)
SELECT * FROM combined;
```

---

**Pro Tip:** Bookmark this page and refer to it while solving exercises!

🔗 **More Resources:**
- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [SQL Window Functions Tutorial](https://dev.mysql.com/doc/refman/8.0/en/window-functions.html)
- Project exercises: `exercises/README.md`