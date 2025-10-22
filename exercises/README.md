# SQL Training Exercises

Welcome to the ride-hailing database SQL exercises! This folder contains structured exercises to help you master SQL from basics to advanced techniques.

## 📁 Structure

```
exercises/
├── README.md (this file)
├── 01_basic_queries.md (⭐ Easy - Beginner friendly)
├── 02_intermediate_queries.md (⭐⭐ Medium - Window functions, CTEs)
├── 03_advanced_queries.md (⭐⭐⭐ Hard - Complex analytics)
└── solutions/ (add your solutions here as you complete them)
    ├── 01_basic_solutions.sql
    ├── 02_intermediate_solutions.sql
    └── 03_advanced_solutions.sql
```

## 🎯 Learning Path

### Level 1: Basic (Start Here!)
**Prerequisites:** Basic SQL knowledge (SELECT, WHERE, JOIN)

**You'll Learn:**
- SELECT statements with filtering
- JOIN operations (INNER, LEFT)
- GROUP BY and aggregations (COUNT, SUM, AVG)
- ORDER BY and LIMIT
- Date functions basics

**Time Estimate:** 2-4 hours

📄 **Start with:** `01_basic_queries.md`

---

### Level 2: Intermediate
**Prerequisites:** Comfortable with Level 1 concepts

**You'll Learn:**
- Window functions (ROW_NUMBER, RANK, LEAD, LAG)
- Common Table Expressions (CTEs)
- Subqueries (correlated and non-correlated)
- Advanced GROUP BY (ROLLUP, CUBE)
- Complex date calculations

**Time Estimate:** 5-8 hours

📄 **Continue with:** `02_intermediate_queries.md`

---

### Level 3: Advanced
**Prerequisites:** Strong grasp of Level 2 concepts

**You'll Learn:**
- Recursive CTEs
- Query optimization and EXPLAIN
- Statistical analysis in SQL
- Feature engineering for ML
- Complex business logic implementation
- Performance tuning

**Time Estimate:** 10-15 hours

📄 **Master with:** `03_advanced_queries.md`

---

## 📝 How to Use These Exercises

### 1. **Read the Exercise Carefully**
- Understand what's being asked
- Note the expected output columns
- Check the difficulty rating

### 2. **Review the Hints**
- Hints guide you without giving away the solution
- Try without hints first if you feel confident
- Don't be afraid to check hints if stuck!

### 3. **Write Your Query**
- Start simple, add complexity gradually
- Test each part before combining
- Use proper formatting (indentation, line breaks)

### 4. **Test Your Solution**
```sql
-- Example testing approach
-- First, check if query runs without errors
SELECT ...

-- Then verify the output
-- - Are the columns correct?
-- - Is the data logical?
-- - Does the count make sense?

-- Finally, test edge cases
-- - What if there's no data?
-- - What happens with NULL values?
```

### 5. **Save Your Solution**
Create a file in `solutions/` folder:
```sql
-- Exercise 1.3: Count Rides Per City
-- Date: 2025-01-15
-- My approach: Used JOIN + GROUP BY

SELECT 
    l.city_name,
    COUNT(*) AS total_rides
FROM fact_rides f
INNER JOIN dim_location l ON f.pickup_location_id = l.location_id
GROUP BY l.city_name
ORDER BY total_rides DESC;

-- Notes: Initially forgot to filter by pickup only,
-- realized dropoff would double-count rides
```

---

## 💡 Tips for Success

### General SQL Best Practices

```sql
-- ✅ GOOD: Readable, maintainable
SELECT 
    d.name AS driver_name,
    COUNT(*) AS total_rides,
    ROUND(AVG(f.price), 2) AS avg_price
FROM fact_rides f
INNER JOIN dim_driver d ON f.driver_id = d.driver_id
WHERE f.status = 'Completed'
    AND f.start_time >= '2025-01-01'
GROUP BY d.driver_id, d.name
HAVING COUNT(*) > 10
ORDER BY total_rides DESC;

-- ❌ BAD: Hard to read, hard to debug
SELECT d.name,COUNT(*),ROUND(AVG(f.price),2) FROM fact_rides f INNER JOIN dim_driver d ON f.driver_id=d.driver_id WHERE f.status='Completed' AND f.start_time>='2025-01-01' GROUP BY d.driver_id,d.name HAVING COUNT(*)>10 ORDER BY COUNT(*) DESC;
```

### Debugging Tips

1. **Build Incrementally**
```sql
-- Step 1: Basic SELECT
SELECT * FROM fact_rides LIMIT 10;

-- Step 2: Add filters
SELECT * FROM fact_rides WHERE status = 'Completed' LIMIT 10;

-- Step 3: Add JOIN
SELECT f.*, d.name
FROM fact_rides f
JOIN dim_driver d ON f.driver_id = d.driver_id
WHERE status = 'Completed'
LIMIT 10;

-- Step 4: Add aggregation
SELECT d.name, COUNT(*) as rides
FROM fact_rides f
JOIN dim_driver d ON f.driver_id = d.driver_id
WHERE status = 'Completed'
GROUP BY d.driver_id, d.name;
```

2. **Use LIMIT During Development**
```sql
-- While testing, use LIMIT to speed up queries
SELECT ... LIMIT 100;  -- Fast feedback

-- Remove LIMIT for final result
SELECT ...;  -- Full dataset
```

3. **Check Intermediate Results**
```sql
-- Wrap your query in a CTE to inspect
WITH ride_counts AS (
    SELECT driver_id, COUNT(*) as rides
    FROM fact_rides
    GROUP BY driver_id
)
SELECT * FROM ride_counts;  -- Check this first
```

4. **Common Mistakes to Avoid**

```sql
-- ❌ Forgot to GROUP BY all non-aggregated columns
SELECT driver_id, name, COUNT(*)
FROM fact_rides
GROUP BY driver_id;  -- Missing 'name'

-- ✅ Correct
SELECT driver_id, name, COUNT(*)
FROM fact_rides
GROUP BY driver_id, name;

-- ❌ Using WHERE with aggregates
SELECT driver_id, COUNT(*) as rides
FROM fact_rides
WHERE COUNT(*) > 10;  -- Won't work!

-- ✅ Use HAVING instead
SELECT driver_id, COUNT(*) as rides
FROM fact_rides
GROUP BY driver_id
HAVING COUNT(*) > 10;

-- ❌ Comparing NULL incorrectly
WHERE rating = NULL;  -- Always false!

-- ✅ Use IS NULL
WHERE rating IS NULL;
```

---

## 🔧 Useful SQL Patterns

### Pattern 1: Self-Join
```sql
-- Finding gaps between consecutive rides
SELECT 
    r1.ride_id as first_ride,
    r2.ride_id as next_ride,
    TIMESTAMPDIFF(HOUR, r1.end_time, r2.start_time) as gap_hours
FROM fact_rides r1
JOIN fact_rides r2 
    ON r1.driver_id = r2.driver_id
    AND r2.start_time = (
        SELECT MIN(start_time)
        FROM fact_rides
        WHERE driver_id = r1.driver_id
        AND start_time > r1.end_time
    );
```

### Pattern 2: Running Totals
```sql
-- Cumulative revenue by date
SELECT 
    DATE(start_time) as ride_date,
    SUM(price) as daily_revenue,
    SUM(SUM(price)) OVER (ORDER BY DATE(start_time)) as cumulative_revenue
FROM fact_rides
WHERE status = 'Completed'
GROUP BY DATE(start_time);
```

### Pattern 3: Ranking with Ties
```sql
-- Top 5 drivers, handling ties properly
WITH driver_revenue AS (
    SELECT 
        driver_id,
        SUM(price) as total_revenue,
        DENSE_RANK() OVER (ORDER BY SUM(price) DESC) as rank
    FROM fact_rides
    WHERE status = 'Completed'
    GROUP BY driver_id
)
SELECT * FROM driver_revenue WHERE rank <= 5;
```

### Pattern 4: Pivot Tables
```sql
-- Revenue by payment method (columns) and month (rows)
SELECT 
    MONTHNAME(start_time) as month,
    SUM(CASE WHEN p.payment_method = 'Cash' THEN price ELSE 0 END) as Cash,
    SUM(CASE WHEN p.payment_method = 'Card' THEN price ELSE 0 END) as Card,
    SUM(CASE WHEN p.payment_method = 'In-App' THEN price ELSE 0 END) as InApp,
    SUM(price) as Total
FROM fact_rides f
JOIN dim_payment_type p ON f.payment_type_id = p.payment_type_id
WHERE status = 'Completed'
GROUP BY MONTH(start_time), MONTHNAME(start_time)
ORDER BY MONTH(start_time);
```

---

## 📊 Checking Your Answers

Since solutions aren't provided, here's how to verify your work:

### 1. **Logic Check**
- Does the result make sense?
- Are the numbers realistic?
- Do totals add up correctly?

### 2. **Edge Case Testing**
```sql
-- Test with known data
SELECT * FROM fact_rides WHERE ride_id = 1;

-- Then run your query with that specific data
-- Manually verify the result
```

### 3. **Cross-Verification**
```sql
-- Method 1: Your complex query
SELECT COUNT(*) FROM (your complex query);

-- Method 2: Simple count to verify
SELECT COUNT(*) FROM fact_rides WHERE (conditions);

-- Results should match!
```

### 4. **Ask Questions**
- Why did I get this result?
- What happens if I remove this WHERE clause?
- What if I change JOIN to LEFT JOIN?

---

## 🎓 Learning Resources

### MySQL Documentation
- [Window Functions](https://dev.mysql.com/doc/refman/8.0/en/window-functions.html)
- [Date and Time Functions](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html)
- [Aggregate Functions](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html)

---

## 🤝 Contributing Your Solutions

Once you've solved exercises and verified them:

1. **Document Your Approach**
```sql
-- Exercise: Average Price by Payment Method
-- Author: Your Name
-- Date: 2025-10-22
-- Approach: Used JOIN to combine fact and dimension tables,
--           then GROUP BY payment method with AVG aggregate

-- My solution:
SELECT 
    p.payment_method,
    ROUND(AVG(f.price), 2) as avg_price,
    COUNT(*) as total_rides
FROM fact_rides f
INNER JOIN dim_payment_type p 
    ON f.payment_type_id = p.payment_type_id
WHERE f.status = 'Completed'
GROUP BY p.payment_type_id, p.payment_method
ORDER BY avg_price DESC;

-- Alternative approach I considered:
-- Could use window functions, but GROUP BY is more efficient here

-- Lessons learned:
-- - Remember to filter for 'Completed' status only
-- - GROUP BY needs both ID and name for consistency
```

2. **Share Interesting Findings**
Did you discover something cool in the data? Document it!

3. **Suggest New Exercises**
Think of a challenging scenario? Add it as an issue or pull request!

---

## 🐛 Troubleshooting

### "Column not found" error
```sql
-- Check your table aliases
SELECT name FROM fact_rides;  -- ❌ 'name' is in dim_driver

-- Correct:
SELECT d.name FROM fact_rides f
JOIN dim_driver d ON f.driver_id = d.driver_id;
```

### "Subquery returns more than 1 row"
```sql
-- When using = with subquery
WHERE price = (SELECT price FROM fact_rides);  -- ❌

-- Use IN or add LIMIT 1
WHERE price IN (SELECT price FROM fact_rides);  -- ✅
```

### Slow query performance
```sql
-- Add EXPLAIN to see execution plan
EXPLAIN SELECT ...

-- Check if indexes are being used
-- Add WHERE clauses to filter early
-- Use LIMIT during testing
```

---

## 🎯 Goal Setting

Set personal goals:
- ⭐ **Beginner:** Complete all Basic exercises in 1 week
- ⭐⭐ **Intermediate:** Complete Intermediate exercises in 2 weeks  
- ⭐⭐⭐ **Advanced:** Complete Advanced exercises in 1 month
- 🏆 **Expert:** Create your own complex analytical queries

---

## 💪 Challenge Yourself

After completing the exercises:

1. **Time Yourself:** How fast can you solve Exercise 1.3 now vs first time?
2. **Optimize:** Rewrite your solutions to be more efficient
3. **Teach Others:** Explain your solutions to someone else
4. **Create New Exercises:** Think of business questions and solve them
5. **Real Project:** Build a complete dashboard using these queries

---

## 📞 Getting Help

If you're stuck:

1. **Re-read the hint** - it often contains the key insight
2. **Break down the problem** - solve one piece at a time
3. **Check the schema** - review table relationships in `01_create_schema.sql`
4. **Sample the data** - use `LIMIT 10` to see what data looks like
5. **Search documentation** - MySQL docs are excellent
6. **Ask the community** - open an issue on GitHub

---

## 🌟 Remember

> "The only way to learn SQL is to write SQL."

- Don't just read exercises - actually write and run the queries
- It's okay to struggle - that's how you learn
- Mistakes are learning opportunities
- Compare your first attempt to your final solution - see your growth!
- There's often more than one correct approach

---

## 🚀 Ready to Start?

1. Make sure your database is set up (run `utils/reset_db.sql`)
2. Open `01_basic_queries.md`
3. Start with Exercise 1
4. Have fun and learn!

**Good luck on your SQL journey!** 💻✨