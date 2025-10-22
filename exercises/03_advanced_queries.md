# Advanced SQL Exercises

These exercises focus on recursive CTEs, complex analytics, optimization techniques, and real-world business scenarios.

---

## Exercise 1: Recursive CTE - Generate Date Series

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice recursive CTEs

**Task:**
Create a recursive CTE that generates all dates in Q1 2025 (January-March), then count how many rides occurred on each date. Include dates with zero rides.

**Expected columns:**
- date
- ride_count

**Hint:** 
- Start with base case: SELECT '2025-01-01'
- Recursive case: Add 1 day until reaching '2025-03-31'
- LEFT JOIN with fact_rides grouped by date
- Use COALESCE to show 0 for dates with no rides

**Expected result:** 90 rows (all dates in Q1, some may have 0 rides).

---

## Exercise 2: Complex Analytics - RFM Segmentation

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Real-world customer segmentation

**Task:**
Create an RFM (Recency, Frequency, Monetary) analysis for riders. For each rider:
- Recency: Days since last ride
- Frequency: Total number of rides
- Monetary: Total amount spent

Assign scores (1-5) for each dimension and create segments like "Champions", "At Risk", "Lost".

**Expected columns:**
- rider_name
- recency_days
- frequency
- monetary_value
- r_score (1-5)
- f_score (1-5)
- m_score (1-5)
- segment

**Hint:** 
- Use NTILE(5) to create quintile scores
- Use CASE statements to define segments based on scores
- Champions: R=5, F=5, M=5 or similar high scores
- At Risk: High F and M but low R (haven't ridden recently)
- Lost: Low R, low F, low M

**Expected result:** 50 rows (one per rider with their segment).

---

## Exercise 3: Time Series Forecasting Data Prep

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Prepare data for forecasting

**Task:**
Create a dataset suitable for time series forecasting. For each day, calculate:
- Total rides
- Average price
- Day of week (as number)
- Is weekend
- Is holiday
- 7-day lagged rides (rides from 7 days ago)
- 14-day lagged rides

**Expected columns:**
- date
- rides
- avg_price
- day_of_week_num
- is_weekend
- is_holiday
- rides_lag_7
- rides_lag_14

**Hint:** 
- Use window functions with specific frame offsets
- `LAG(rides, 7) OVER (ORDER BY date)`
- First 7-14 days will have NULL lag values

**Expected result:** One row per date with rides.

---

## Exercise 4: Identifying Anomalies - Statistical Outliers

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Statistical analysis with SQL

**Task:**
Find rides that are statistical outliers in terms of price. Calculate mean and standard deviation of prices for each distance bucket (0-5km, 5-10km, 10-20km, 20+km), then identify rides where price is more than 2 standard deviations from the mean for their distance bucket.

**Expected columns:**
- ride_id
- distance
- price
- distance_bucket
- bucket_avg_price
- bucket_stddev
- std_devs_from_mean

**Hint:** 
- Use CASE to create distance buckets
- Use `STDDEV()` and `AVG()` as window functions partitioned by bucket
- Calculate z-score: `(price - avg) / stddev`
- Filter WHERE ABS(z-score) > 2

**Expected result:** Variable rows (outlier rides).

---

## Exercise 5: Complex Join - Driver-Rider Affinity Matrix

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Many-to-many relationship analysis

**Task:**
Create a matrix showing which drivers have driven which riders most frequently. Show only driver-rider pairs with at least 3 completed rides together. Include their average rating and total revenue from those rides.

**Expected columns:**
- driver_name
- rider_name
- rides_together
- avg_rating
- total_revenue

**Hint:** 
- Simple GROUP BY driver_id and rider_id
- Join to get names
- Filter HAVING COUNT(*) >= 3
- Order by rides_together DESC

**Expected result:** Variable rows (frequent driver-rider pairs).

---

## Exercise 6: Optimization Challenge - Index Impact

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Understand query optimization

**Task:**
Write a query to find all rides for a specific rider (rider_id = 10) in a specific month (January 2025), ordered by start_time. Then:
1. Run EXPLAIN on your query
2. Document which indexes are being used
3. Suggest one additional index that would improve performance

**Your query:**
```sql
-- Write your query here
```

**Analysis questions:**
1. What indexes are currently being used?
2. What is the query execution plan?
3. What index would you add and why?

**Hint:** 
- Use `EXPLAIN SELECT ...` to see execution plan
- Look for "Using index" vs "Using where"
- Composite indexes can cover multiple columns

**Expected result:** Query + performance analysis.

---

## Exercise 7: Hierarchical Query - City-to-City Route Analysis

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Advanced grouping with ROLLUP

**Task:**
Create a hierarchical report showing ride counts and revenue:
- By pickup city and dropoff city (detail level)
- By pickup city (subtotal)
- Grand total

Use ROLLUP to create the hierarchy in a single query.

**Expected columns:**
- pickup_city
- dropoff_city
- ride_count
- total_revenue

**Hint:** 
- Use `GROUP BY pickup_city, dropoff_city WITH ROLLUP`
- Use `GROUPING()` function to identify summary rows
- Use `IF(GROUPING(column), 'TOTAL', column)` for labels

**Expected result:** Multiple rows with detail and summary levels.

---

## Exercise 8: Dynamic Pivot - Payment Methods by Month

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Create pivot table in SQL

**Task:**
Create a pivot table showing revenue by payment method (columns) and month (rows). Each cell should contain the total revenue for that payment method in that month.

**Expected columns:**
- month_name
- Cash
- Card
- In-App
- Promo
- Total

**Hint:** 
- Use CASE statements with SUM for each payment method
- `SUM(CASE WHEN payment_method = 'Cash' THEN price ELSE 0 END) AS Cash`
- Group by month
- Add row total as extra column

**Expected result:** 12 rows (one per month) with payment methods as columns.

---

## Exercise 9: Complex Window Function - Cumulative Share

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Calculate running percentages

**Task:**
For each driver ordered by total revenue (highest first), calculate:
- Individual revenue
- Cumulative revenue
- Individual percentage of total
- Cumulative percentage (how much % of total revenue is captured by top N drivers)

This shows how concentrated revenue is among top drivers (Pareto principle).

**Expected columns:**
- driver_rank
- driver_name
- driver_revenue
- cumulative_revenue
- revenue_pct
- cumulative_pct

**Hint:** 
- Use window function for cumulative sum
- Calculate total revenue in subquery or with another window function
- Divide individual and cumulative by total, multiply by 100

**Expected result:** 20 rows showing concentration of revenue.

---

## Exercise 10: JSON Aggregation - Rider Journey

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Use JSON functions (MySQL 8+)

**Task:**
For each rider, create a JSON array of all their rides with ride_id, date, and price. Only include riders with more than 3 rides.

**Expected columns:**
- rider_name
- total_rides
- rides_json

**Hint:** 
- Use `JSON_ARRAYAGG()` or `JSON_OBJECT()`
- Group by rider
- Filter with HAVING COUNT(*) > 3

**Expected result:** JSON output for each qualifying rider.

---

## Exercise 11: Performance Tuning - Slow Query Optimization

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Real-world optimization scenario

**Scenario:** The following query is running slow in production:
```sql
SELECT 
    d.name,
    COUNT(*) as rides,
    AVG(f.price) as avg_price
FROM fact_rides f
JOIN dim_driver d ON f.driver_id = d.driver_id
WHERE f.start_time >= '2025-01-01'
    AND f.start_time < '2025-02-01'
    AND f.status = 'Completed'
GROUP BY d.name
ORDER BY rides DESC;
```

**Tasks:**
1. Run EXPLAIN on this query and document the output
2. Identify performance bottlenecks
3. Suggest 2-3 specific optimizations (indexes, query rewrite, etc.)
4. Implement your optimizations
5. Measure improvement

**Deliverable:** Document with analysis and optimized query.

---

## Exercise 12: Complex Business Logic - Surge Pricing Analysis

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Implement business rules in SQL

**Task:**
Identify time periods (hour blocks) where surge pricing should have been applied based on these rules:
- More than 20 rides per hour in a city
- Average wait time > 10 minutes (you'll need to calculate this)
- Or: it's a holiday or weekend evening (6-10 PM)

For each qualifying hour, show suggested surge multiplier (1.5x if one condition met, 2.0x if two met, 2.5x if all three met).

**Expected columns:**
- city_name
- hour_block (datetime rounded to hour)
- rides_in_hour
- meets_volume_criteria
- meets_time_criteria
- meets_holiday_criteria
- suggested_multiplier

**Hint:** 
- Use `DATE_FORMAT()` to round to hour
- Count rides per city per hour
- Use CASE statements for criteria
- Calculate multiplier based on met criteria count

**Expected result:** Variable rows (hours needing surge pricing).

---

## Exercise 13: Data Quality Check - Referential Integrity

**Difficulty:** ⭐⭐ Medium

**Objective:** Write validation queries

**Task:**
Write a comprehensive data quality report that checks for:
1. Orphaned records (rides with non-existent driver_id, rider_id, etc.)
2. Invalid data ranges (negative prices, durations, distances)
3. Logical inconsistencies (end_time before start_time, completed rides with null rating)
4. Duplicate records (if any)

Create one query that returns all issues found with issue type and count.

**Expected columns:**
- check_name
- issue_description
- record_count
- severity (Critical/Warning)

**Hint:** 
- Use UNION ALL to combine multiple validation checks
- LEFT JOIN to find orphans
- WHERE clauses for range checks

**Expected result:** Multiple rows, one per check (hopefully all counts are 0!).

---

## Exercise 14: Advanced Analytics - Churn Prediction Features

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Feature engineering for ML

**Task:**
Create a dataset with features that could predict rider churn. For each rider, calculate:
- Days since last ride
- Average days between rides
- Trend: are rides becoming less frequent? (compare last 30 days vs previous 30 days)
- Average ride rating
- Total spent
- Number of cancelled rides
- Preferred payment method
- Preferred city

**Expected columns:**
- rider_id
- days_since_last_ride
- avg_days_between_rides
- frequency_trend (increasing/decreasing/stable)
- avg_rating_received
- total_spent
- cancellation_rate
- main_payment_method
- main_city
- risk_score (calculated)

**Hint:** 
- This requires multiple CTEs
- Use LAG to calculate days between rides
- Compare recent behavior to historical
- Create a simple risk score (e.g., days since last ride > 60 = high risk)

**Expected result:** 50 rows with churn risk indicators.

---

## Exercise 15: Real-World Report - Executive Dashboard Data

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Create executive summary

**Task:**
Create a single query that produces an executive summary report with:
- Total rides, revenue, unique riders, unique drivers
- Month-over-month growth (rides and revenue)
- Top 3 cities by revenue
- Average rating trend (this month vs last month)
- Completion rate (% of rides completed vs cancelled)
- Customer segments (new: first ride this month, returning: 2+ rides, at-risk: no rides in 30 days)

All metrics should be for the last complete month with comparisons.

**Expected format:** Single result set or multiple related result sets.

**Hint:** 
- Use multiple CTEs for different metrics
- May need UNION for different metric types
- Consider creating this as a VIEW for reusability

**Expected result:** Comprehensive dashboard data.

---

## Bonus Challenge: Stored Procedure

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Encapsulate complex logic

**Task:**
Create a stored procedure `GetDriverPerformanceReport(driver_id, start_date, end_date)` that returns:
- Driver details
- Performance metrics (rides, revenue, ratings)
- Comparison to other drivers
- Week-by-week trend
- Recommended actions (e.g., "Schedule more weekend shifts")

**Deliverable:** Stored procedure code + sample execution.

---

## Tips for Advanced Exercises

1. **Plan First:** Sketch out your approach before coding
2. **Use CTEs Liberally:** Break complex queries into manageable parts
3. **Test with Small Data:** Verify logic on subset before full dataset
4. **Comment Your Code:** Explain complex logic
5. **Consider Performance:** Use EXPLAIN to understand query plans
6. **Handle Edge Cases:** NULL values, empty results, division by zero

## Beyond These Exercises

Consider:
- Building a complete BI dashboard
- Implementing data warehouse patterns
- Creating automated reporting procedures
- Optimizing for scale (millions of rows)
- Integrating with application code

You're now at professional-level SQL! 🚀