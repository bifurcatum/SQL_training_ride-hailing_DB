# Basic SQL Exercises

These exercises focus on fundamental SQL operations: SELECT, WHERE, ORDER BY, and basic aggregations.

---

## Exercise 1: Find All Completed Rides

**Difficulty:** ⭐ Easy

**Objective:** Practice basic SELECT with WHERE clause

**Task:**
Write a query to find all completed rides. Display the ride_id, start_time, and price.

**Expected columns:**
- ride_id
- start_time
- price

**Hint:** Check the `status` column in the `fact_rides` table.

**Expected result:** Multiple rows with only completed rides.

---

## Exercise 2: Top 10 Most Expensive Rides

**Difficulty:** ⭐ Easy

**Objective:** Practice ORDER BY and LIMIT

**Task:**
Find the 10 most expensive rides. Show the ride_id, price, distance, and start_time. Order from most expensive to least expensive.

**Expected columns:**
- ride_id
- price
- distance
- start_time

**Hint:** Use `ORDER BY` with `DESC` and `LIMIT`.

**Expected result:** 10 rows, ordered by price (highest first).

---

## Exercise 3: Count Rides Per City

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice JOINs and GROUP BY

**Task:**
Count how many rides started in each city. Show the city name and the count of rides. Order by number of rides (highest first).

**Expected columns:**
- city_name
- total_rides

**Hint:** You'll need to JOIN `fact_rides` with `dim_location` using `pickup_location_id`.

**Expected result:** 5 rows (one per city), ordered by ride count.

---

## Exercise 4: Average Price by Payment Method

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice JOINs and aggregation functions

**Task:**
Calculate the average ride price for each payment method. Only include completed rides. Round the average to 2 decimal places.

**Expected columns:**
- payment_method
- avg_price
- total_rides

**Hint:** 
- JOIN with `dim_payment_type`
- Use `AVG()` and `ROUND()` functions
- Filter for completed rides only
- Use `GROUP BY`

**Expected result:** 4 rows (one per payment method).

---

## Exercise 5: Rides on Weekends

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice joining with time dimension

**Task:**
Find all rides that occurred on weekends. Show ride_id, start_time, full_date, and day_of_week. Order by start_time.

**Expected columns:**
- ride_id
- start_time
- full_date
- day_of_week

**Hint:** 
- JOIN `fact_rides` with `dim_time` using `date_id`
- Use the `is_weekend` column
- Remember that `is_weekend` is a BOOLEAN

**Expected result:** Multiple rows, only Saturday and Sunday rides.

---

## Exercise 6: Drivers Who Have Never Had a Cancelled Ride

**Difficulty:** ⭐⭐⭐ Hard

**Objective:** Practice NOT IN or NOT EXISTS

**Task:**
Find all drivers who have never had a cancelled ride. Display driver name and their total number of completed rides.

**Expected columns:**
- driver_name
- completed_rides

**Hint:** 
- You can use a subquery with `NOT IN`
- Or use `NOT EXISTS`
- Filter for drivers who don't appear in cancelled rides

**Expected result:** Variable number of rows depending on data.

---

## Exercise 7: Total Revenue Per Month

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice date functions and aggregation

**Task:**
Calculate total revenue (sum of prices) for each month. Only include completed rides. Show month number, month name, and total revenue. Order by month.

**Expected columns:**
- month_num
- month_name
- total_revenue

**Hint:** 
- JOIN with `dim_time`
- Use `SUM()` and `GROUP BY`
- Filter for status = 'Completed'

**Expected result:** 12 rows (one per month), ordered by month.

---

## Exercise 8: Busiest Day of Week

**Difficulty:** ⭐⭐ Medium

**Objective:** Practice grouping by day of week

**Task:**
Find which day of the week has the most rides. Show day_of_week and ride count. Order from busiest to least busy.

**Expected columns:**
- day_of_week
- total_rides

**Hint:** 
- JOIN with `dim_time`
- Use `COUNT()` and `GROUP BY day_of_week`

**Expected result:** 7 rows (one per day), ordered by count.

---

## Exercise 9: Riders with Gold Status

**Difficulty:** ⭐ Easy

**Objective:** Practice simple JOIN and filtering

**Task:**
List all riders with Gold loyalty status along with how many rides they've taken. Order by number of rides (highest first).

**Expected columns:**
- rider_name
- loyalty_status
- total_rides

**Hint:** 
- JOIN `fact_rides` with `dim_rider`
- Filter WHERE loyalty_status = 'Gold'
- Use `COUNT()` and `GROUP BY`

**Expected result:** Multiple rows, only Gold status riders.

---

## Exercise 10: Longest Ride by Distance

**Difficulty:** ⭐ Easy

**Objective:** Practice using MAX or ORDER BY with LIMIT

**Task:**
Find the single longest ride by distance. Show ride_id, distance, duration, price, pickup city, and dropoff city.

**Expected columns:**
- ride_id
- distance
- duration
- price
- pickup_city
- dropoff_city

**Hint:** 
- You'll need to JOIN `dim_location` twice (once for pickup, once for dropoff)
- Use table aliases like `pickup.city_name` and `dropoff.city_name`
- Order by distance DESC and LIMIT 1

**Expected result:** 1 row with the longest ride.

---

## Tips for Success

1. **Start Simple:** Write the basic SELECT first, then add JOINs and filters
2. **Use Aliases:** Table aliases make queries more readable (`fact_rides AS fr`)
3. **Test Incrementally:** Run your query after each addition to catch errors early
4. **Check Data Types:** Remember that `is_weekend` is BOOLEAN (TRUE/FALSE)
5. **Format Your Code:** Use indentation and line breaks for readability

## Next Steps

Once you've completed these exercises, move on to:
- **Intermediate Exercises:** Window functions, subqueries, CTEs
- **Advanced Exercises:** Complex analytics, optimization techniques

Good luck! 🚀