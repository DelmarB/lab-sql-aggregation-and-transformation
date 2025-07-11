-- Imagine you work at a movie rental company as an analyst. By using SQL in the challenges below, you are required to gain insights into different elements of its business operations.
USE sakila;
show tables;
-- ## Challenge 1

-- 1. You need to use SQL built-in functions to gain insights relating to the duration of movies:
-- 	- 1.1 Determine the **shortest and longest movie durations** and name the values as `max_duration` and `min_duration`.
SELECT MIN(length) AS "shortest movie", MAX(length) AS "longest movie" FROM sakila.film;

-- 	- 1.2. Express the **average movie duration in hours and minutes**. Don't use decimals.
--       - *Hint: Look for floor and round functions.*
SELECT SEC_TO_TIME(floor(round(AVG(length)))) as "average movie duration" From sakila.film;

-- 2. You need to gain insights related to rental dates:
-- 	- 2.1 Calculate the **number of days that the company has been operating**.
--       - *Hint: To do this, use the `rental` table, and the `DATEDIFF()` function to subtract the earliest date in the `rental_date` column from the latest date.*
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS "number of operating days" FROM sakila.rental;

-- 	- 2.2 Retrieve rental information and add two additional columns to show the **month and weekday of the rental**. Return 20 rows of results.
SELECT * FROM sakila.rental;
SELECT *, DATE_FORMAT(CONVERT(rental_date, DATE), '%M') AS "month of rental", 
	DATE_FORMAT(CONVERT(rental_date, DATE), '%d') AS "day of rental" FROM sakila.rental
	LIMIT 20;
-- 	- 2.3 *Bonus: Retrieve rental information and add an additional column called `DAY_TYPE` with values **'weekend' or 'workday'**, depending on the day of the week.*
--       - *Hint: use a conditional expression.*
-- 3. You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the **film titles and their rental duration**. 
-- If any rental duration value is **NULL, replace** it with the string **'Not Available'**. Sort the results of the film title in ascending order.
--     - *Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.*
--     - *Hint: Look for the `IFNULL()` function.*

-- SELECT title, rental_duration FROM sakila.film;
-- SELECT title, CAST(rental_duration AS CHAR) AS rental_info FROM sakila.film;

SELECT 
    title, 
    CASE 
        WHEN rental_duration IS NULL THEN 'Not Available'
        ELSE CAST(rental_duration AS CHAR)
    END AS rental_duration
FROM 
    sakila.film;
    




-- 4. *Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the **concatenated first and last names of customers**, along with the **first 3 characters of their email** address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.*

-- ## Challenge 2

-- 1. Next, you need to analyze the films in the collection to gain some more insights. Using the `film` table, determine:
-- 	- 1.1 The **total number of films** that have been released.
-- 	- 1.2 The **number of films for each rating**.
-- 	- 1.3 The **number of films for each rating, sorting** the results in descending order of the number of films.
-- 	This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
-- SELECT title, release_year, rating FROM sakila.film;

SELECT 
    COUNT(*) AS total_released_films
FROM sakila.film
WHERE release_year IS NOT NULL AND release_year != '';

SELECT 
    rating, 
    COUNT(*) AS num_films
FROM sakila.film
WHERE release_year IS NOT NULL AND release_year != ''
GROUP BY rating;

SELECT 
	rating,
    COUNT(*) AS number_of_films
FROM sakila.film
WHERE release_year IS NOT NULL AND release_year != ''
GROUP BY rating
ORDER BY number_of_films DESC;


-- 2. Using the `film` table, determine:
--    - 2.1 The **mean film duration for each rating**, and sort the results in descending order of the mean duration. 
--          Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
-- SELECT title, release_year, rating FROM sakila.film;

SELECT 
    rating,
    ROUND(AVG(length), 2) AS avg_duration
FROM sakila.film
WHERE release_year IS NOT NULL AND release_year != ''
GROUP BY rating
ORDER BY avg_duration DESC;

-- 	- 2.2 Identify **which ratings have a mean duration of over two hours** in order to help select films for customers who prefer longer movies.
SELECT 
    rating,
    ROUND(AVG(length), 2) AS avg_duration
FROM sakila.film
WHERE release_year IS NOT NULL AND release_year != ''
GROUP BY rating
HAVING AVG(length) > 120
ORDER BY avg_duration DESC;


-- 3. *Bonus: determine which last names are not repeated in the table `actor`.*