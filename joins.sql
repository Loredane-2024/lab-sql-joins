-- Challenge - Joining on multiple tables
-- Write SQL queries to perform the following tasks using the Sakila database:
-- 1. List the number of films per category.
SELECT c.name,
	COUNT( DISTINCT(film_id)) as count_film
FROM film_category AS fc
JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY fc.category_id;


-- 2. Retrieve the store ID, city, and country for each store.
SELECT s.store_id, c.city, cy.country
FROM store AS s
JOIN address AS a ON s.address_id = a.address_id
JOIN city AS c ON a.city_id = c.city_id
JOIN country AS cy ON c.country_id = cy.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.
SELECT  s.store_id,
	SUM(amount) AS total_revenue
FROM payment AS p
JOIN staff AS st ON st.staff_id = p.staff_id
JOIN store AS s ON s.store_id = st.store_id
GROUP BY s.store_id;

-- 4. Determine the average running time of films for each category.
SELECT  c.name AS category,
	AVG(length) AS avg_running_time
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.category_id;

-- Bonus:
-- 5. Identify the film categories with the longest average running time.
SELECT  c.name AS category,
	AVG(length) AS avg_running_time
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.category_id
ORDER BY avg_running_time DESC;

-- 6. Display the top 10 most frequently rented movies in descending order.
SELECT  f.title,
	COUNT(DISTINCT(r.rental_id)) AS rental_count
FROM rental AS r
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT f.title, s.store_id
FROM store AS s
JOIN inventory AS i ON i.store_id = s.store_id
JOIN film AS f ON i.film_id = f.film_id
WHERE title = 'Academy Dinosaur' AND i.store_id = 1;

-- 8. Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."
SELECT f.title,
    CASE 
        WHEN COUNT(i.inventory_id) = 0 THEN 'NOT available'
        WHEN COUNT(i.inventory_id) > 0 
             AND COUNT(IF(r.rental_id IS NULL, 1, NULL)) = 0 THEN 'NOT available'
        ELSE 'Available'
    END AS availability
FROM film  AS f
LEFT JOIN inventory AS  i ON f.film_id = i.film_id
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
GROUP BY f.title
ORDER BY f.title;
