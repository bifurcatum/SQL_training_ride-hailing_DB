# Intermediate SQL Exercises

These exercises focus on window functions, subqueries, CTEs, and complex aggregations.

---

## Exercise 1: Rank Drivers by Total Revenue

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice window functions (RANK/DENSE_RANK)

**Task:**
Rank all drivers by their total revenue from completed rides. Show driver name, total revenue, and their rank. Handle ties appropriately (drivers with same revenue should have same rank).

**Expected columns:**
- driver_name
- total_revenue
- revenue_rank

**Hint:** 
- Use `SUM()` with `GROUP BY` first
- Then use `DENSE_RANK() OVER (ORDER BY ...)` in a CTE or subquery
- Filter for completed rides only

**Expected result:** 20 rows (one per driver), with ranks 1, 2, 3, etc.

---

## Exercise 2: Running Total of Daily Revenue

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice cumulative window functions

**Task:**
Calculate the running total of revenue for each day in January 2025. Show the date, daily revenue, and cumulative revenue up to that date. Order by date.

**Expected columns:**
- ride_date
- daily_revenue
- cumulative_revenue

**Hint:** 
- First aggregate revenue by date (using `DATE(start_time)`)
- Then use `SUM() OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`
- Filter for January 2025 and completed rides

**Expected result:** 31 rows (one per day in January).

---

## Exercise 3: Compare Each Ride Price to Driver's Average

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice window functions with partitioning

**Task:**
For each completed ride, show how much the price differs from that driver's average ride price. Display ride_id, driver_name, ride price, driver's average price, and the difference.

**Expected columns:**
- ride_id
- driver_name
- ride_price
- driver_avg_price
- price_difference

**Hint:** 
- Use `AVG() OVER (PARTITION BY driver_id)` to calculate each driver's average
- Subtract the average from the individual price
- Round to 2 decimal places

**Expected result:** Multiple rows (one per completed ride).

---

## Exercise 4: Find Riders Who Took More Than Average Rides

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice subqueries and aggregation

**Task:**
Find all riders who have taken more rides than the average number of rides per rider. Show rider name and their ride count. Order by ride count descending.

**Expected columns:**
- rider_name
- ride_count

**Hint:** 
- First calculate the average rides per rider using a subquery
- Compare each rider's count to that average
- Use `HAVING COUNT(*) > (subquery)`

**Expected result:** Variable number of rows (riders above average).

---

## Exercise 5: Month-over-Month Revenue Growth

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice LAG window function

**Task:**
Calculate the month-over-month revenue growth percentage. Show month name, current month revenue, previous month revenue, and percentage change. Order by month.

**Expected columns:**
- month_name
- current_month_revenue
- previous_month_revenue
- growth_percentage

**Hint:** 
- Use `LAG(revenue) OVER (ORDER BY month)` to get previous month
- Calculate percentage: `((current - previous) / previous) * 100`
- Handle NULL for first month (no previous month)
- Round to 2 decimal places

**Expected result:** 12 rows (one per month).

---

## Exercise 6: Top 3 Riders Per City

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice ROW_NUMBER with PARTITION

**Task:**
For each city (based on pickup location), find the top 3 riders by number of rides. Show city name, rider name, ride count, and rank within that city.

**Expected columns:**
- city_name
- rider_name
- ride_count
- city_rank

**Hint:** 
- Use `ROW_NUMBER() OVER (PARTITION BY city_id ORDER BY COUNT(*) DESC)`
- Wrap in a CTE or subquery and filter WHERE rank <= 3
- JOIN multiple tables (fact_rides, dim_location, dim_rider)

**Expected result:** Up to 15 rows (3 per city × 5 cities).

---

## Exercise 7: Rides During Rush Hours vs Non-Rush Hours

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice CASE statements and aggregation

**Task:**
Compare the total number of rides and average price during rush hours (7-9 AM and 5-7 PM) versus non-rush hours. Show two rows: one for rush hours and one for non-rush hours.

**Expected columns:**
- period (Rush Hours / Non-Rush Hours)
- total_rides
- avg_price

**Hint:** 
- Use `HOUR(start_time)` to extract hour
- Use CASE statement to categorize rides
- Group by the CASE result

**Expected result:** 2 rows.

---

## Exercise 8: Find Gaps in Driver Activity

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice LEAD/LAG for time series analysis

**Task:**
For driver_id = 1, find all gaps between consecutive rides that are longer than 24 hours. Show the end time of previous ride, start time of next ride, and the gap in hours.

**Expected columns:**
- previous_ride_end
- next_ride_start
- gap_hours

**Hint:** 
- Use `LEAD(start_time) OVER (ORDER BY start_time)` 
- Calculate difference using `TIMESTAMPDIFF(HOUR, end_time, next_start)`
- Filter WHERE gap > 24

**Expected result:** Variable rows (depends on that driver's schedule).

---

## Exercise 9: Riders Who Never Used Promo Code

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice NOT EXISTS or NOT IN with subqueries

**Task:**
Find all riders who have never used a promo code payment method. Show rider name, loyalty status, and total number of rides they've taken.

**Expected columns:**
- rider_name
- loyalty_status
- total_rides

**Hint:** 
- Use NOT EXISTS or NOT IN with subquery
- The subquery should find riders who used payment_method = 'Promo'
- Join with dim_payment_type to check payment method

**Expected result:** Variable rows (riders who never used promo).

---

## Exercise 10: Moving Average of Daily Rides

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice window functions with ROWS frame

**Task:**
Calculate a 7-day moving average of the number of rides per day. Show the date, daily ride count, and the 7-day moving average (current day + 6 previous days). Order by date.

**Expected columns:**
- ride_date
- daily_rides
- moving_avg_7days

**Hint:** 
- First aggregate rides by DATE(start_time)
- Use `AVG() OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`
- Round to 2 decimal places

**Expected result:** Multiple rows (one per date with rides).

---

## Exercise 11: Identify Loyal Drivers (High Ride Frequency)

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice date functions and aggregation

**Task:**
Find drivers who have completed at least 20 rides within any 30-day period. Show driver name, start date of the period, end date of the period, and number of rides in that period.

**Expected columns:**
- driver_name
- period_start
- period_end
- rides_in_period

**Hint:** 
- This is challenging! Consider using self-join on fact_rides
- For each ride, count how many rides the same driver had in the next 30 days
- Filter where count >= 20

**Alternative approach:** Use window functions with RANGE frame

**Expected result:** Variable rows (drivers with busy 30-day periods).

---

## Exercise 12: Percentage of Revenue by Vehicle Type

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice subqueries and percentage calculations

**Task:**
Calculate what percentage of total revenue comes from each vehicle type. Show vehicle type, revenue, and percentage of total. Order by percentage descending.

**Expected columns:**
- vehicle_type
- total_revenue
- revenue_percentage

**Hint:** 
- Join fact_rides with dim_driver to get vehicle_type
- Calculate sum per vehicle type
- Divide by total revenue (use subquery or window function)
- Multiply by 100 for percentage

**Expected result:** 3 rows (Sedan, SUV, Economy).

---

## Exercise 13: First and Last Ride of Each Rider

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice FIRST_VALUE and LAST_VALUE window functions

**Task:**
For each rider, show their first ride date and last ride date, along with the number of days between them. Only include riders with more than 5 rides.

**Expected columns:**
- rider_name
- first_ride_date
- last_ride_date
- days_active
- total_rides

**Hint:** 
- Use `MIN()` and `MAX()` on start_time grouped by rider
- Calculate `DATEDIFF(max_date, min_date)`
- Filter with HAVING COUNT(*) > 5

**Expected result:** Variable rows (active riders).

---

## Exercise 14: Rides with Above-Average Distance for Each City Pair

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice complex window functions and grouping

**Task:**
Find rides where the distance was above average for that specific city pair (pickup city → dropoff city). Show ride_id, pickup city, dropoff city, ride distance, and average distance for that route.

**Expected columns:**
- ride_id
- pickup_city
- dropoff_city
- ride_distance
- route_avg_distance

**Hint:** 
- Use `AVG(distance) OVER (PARTITION BY pickup_location_id, dropoff_location_id)`
- Filter WHERE ride_distance > route_avg_distance
- Need multiple joins to dim_location

**Expected result:** Variable rows (rides above route average).

---

## Exercise 15: Cohort Analysis - Rider Retention

**Difficulty:** ⭐⭐⭐⭐ Very Hard

**Objective:** Practice advanced date functions and cohort analysis

**Task:**
Create a cohort analysis showing how many riders from each registration month took rides in subsequent months. Show registration month, month offset (0, 1, 2, 3...), and count of active riders.

**Expected columns:**
- registration_month
- month_offset
- active_riders

**Hint:** 
- Join dim_rider with fact_rides
- Calculate month difference between registration_date and ride date
- Group by registration month and month offset
- This is advanced - consider using CTEs

**Expected result:** Multiple rows showing retention patterns.

---

## Tips for These Exercises

1. **Use CTEs:** Common Table Expressions make complex queries more readable
2. **Break It Down:** Solve step by step, testing each part
3. **Understand Window Functions:** PARTITION BY vs ORDER BY vs frame clauses
4. **Handle NULLs:** Use COALESCE or IS NULL checks appropriately
5. **Performance:** Consider adding indexes if queries are slow

## Next Steps

Once you master these, try:
- **Advanced Exercises:** Recursive CTEs, complex analytics, query optimization
- **Real-world scenarios:** Building dashboards, reporting queries

Keep practicing! 💪