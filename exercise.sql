--EXERCISE
-- 1	CREATE DATABASE SYNTAX
CREATE DATABASE database_name
WITH
   OWNER =  role_name
   TEMPLATE = template
   ENCODING = encoding
   LC_COLLATE = collate]
   LC_CTYPE = ctype
   TABLESPACE = tablespace_name
   ALLOW_CONNECTIONS = true
   CONNECTION LIMIT = -1
   IS_TEMPLATE = false 


-- 2	CREATE SCHEMA SYNTAX
CREATE SCHEMA IF NOT EXISTS schema1
AUTHORIZATION postgres;


-- 3	"create table name test and 
-- 		test1(with column id,  first_name, last_name, school, percentage, status (pass or fail),pin, created_date, updated_date)
-- 		define constraints in it such as Primary Key, Foreign Key, Not Null...
-- 		apart from this take default value for some column such as cretaed_date"

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
	id INTEGER NOT NULL,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	school VARCHAR(40),
	percentage NUMERIC(5,2),
	status VARCHAR(4),
	pin BIGINT NOT NULL,
	create_date DATE DEFAULT CURRENT_DATE,
	update_date DATE DEFAULT CURRENT_DATE,
	PRIMARY KEY(id),
	CHECK (percentage BETWEEN 0 AND 100),
	CHECK (status IN ('pass','fail'))
);

INSERT INTO 
	test(id,first_name,last_name,school,percentage,status,pin,create_date,update_date)
VALUES (1,'first1','last1','ABC',90.00,'pass',380015,CURRENT_DATE,CURRENT_DATE);

INSERT INTO 
	test(id,first_name,last_name,school,percentage,status,pin,create_date,update_date)
VALUES  (2,'first2','last2','ABC',91.00,'pass',380016,CURRENT_DATE,CURRENT_DATE),
 		(3,'first3','last3','XYZ',92.00,'pass',380017,CURRENT_DATE,CURRENT_DATE),
 		(4,'first4','last4','ABC',93.00,'pass',380018,CURRENT_DATE,CURRENT_DATE),
 		(5,'first5','last5','PQR',94.00,'pass',380019,CURRENT_DATE,CURRENT_DATE),
 		(6,'first6','last6','XYZ',95.00,'pass',380010,CURRENT_DATE,CURRENT_DATE);

SELECT * FROM test; 	

DROP TABLE IF EXISTS test1;

CREATE TABLE test1
AS
SELECT * FROM test;

-- 4	Create film_cast table with film_id,title,first_name and last_name of the actor.. (create table from other table)
DROP TABLE IF EXISTS film_cast;

CREATE TABLE film_cast
AS
(SELECT f.film_id,
		f.title,
		a.first_name,
		a.last_name
FROM
	actor a
	JOIN film_actor fa
	USING(actor_id)
	JOIN film f
	USING(film_id));
SELECT * FROM film_cast;

-- 5	drop table test1
DROP TABLE IS EXISTS test1;

-- 6	what is temproray table ? what is the purpose of temp table ? create one temp table 
-- Temporary table is a kind of table that is created for a perticular single session.
CREATE TEMPORARY TABLE temp_table
AS
SELECT * 
FROM film_cast LIMIT 10;

SELECT * FROM temp_table;

-- 7	difference between delete and truncate ? 
-- DELETE will delete the whole table
-- whereas truncate delete all the rows of the table only, table will still exist in database

-- 8	rename test table to student table
ALTER TABLE test
RENAME TO student;

-- 9	add column in test table named city 
ALTER TABLE student
ADD city VARCHAR(20);
SELECT * FROM student;

-- 10	change data type of one of the column of test table
ALTER TABLE student
ALTER COLUMN pin TYPE BIGINT;

-- 11	drop column pin from test table 
ALTER TABLE student
DROP COLUMN pin;
SELECT * FROM student;

-- 12	rename column city to location in test table
ALTER TABLE student
RENAME COLUMN city TO location;

-- 13	Create a Role with read only rights on the database.
CREATE ROLE read_role;
GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC 
TO read_role;

--Create a role with all the write permission on the database.
CREATE ROLE write_role;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public 
TO write_role;

-- 15. Create a database user who can only read the data from the database.
REASSIGN OWNED BY ps TO postgres;
DROP OWNED BY ps;
DROP ROLE ps;
CREATE USER temp_role login PASSWORD 'ps1';
GRANT read_role TO temp_role;

-- 16. Create a database user who can read as well as write data into database.
CREATE ROLE temp_user login password 'temp_user';
GRANT write_role to temp_user;

-- 17. Create an admin role who is not superuser but can create database and  manage roles.
CREATE ROLE admin_role
WITH CREATEDB CREATEROLE;

-- 18. Create user whoes login credentials can last until 1st June 2023
CREATE ROLE new_user
LOGIN 
PASSWORD 'new_user'
VALID UNTIL '2023-06-01';

-- 19. List all unique film’s name. 
SELECT DISTINCT(title) FROM film;

-- 20. List top 100 customers details.
SELECT * FROM customer LIMIT 100;

-- 21. List top 10 inventory details starting from the 5th one.
SELECT * FROM 
inventory LIMIT 10 OFFSET 5;

SELECT * FROM inventory

-- 22. find the customer's name who paid an amount between 1.99 and 5.99.
SELECT DISTINCT first_name || ' ' || last_name as customer_name 
FROM customer
JOIN payment 
USING(customer_id)
WHERE amount BETWEEN 1.99 AND 5.99;

select * from payment;
-- 23. List film's name which is staring from the A.
SELECT title 
FROM film
WHERE title like 'A%';

-- 24. List film's name which is end with "a"
SELECT title 
FROM film
WHERE title like '%a';

-- 25. List film's name which is start with "M" and ends with "a"
SELECT title 
FROM film
WHERE title like 'M%a';

-- 26. List all customer details which payment amount is greater than 40. (USING EXISTs)


-- 27. List Staff details order by first_name.
SELECT * FROM staff
ORDER BY first_name;

-- 28. List customer's payment details (customer_id,payment_id,first_name,last_name,payment_date)
SELECT c.customer_id, payment_id, first_name, last_name, payment_date
FROM customer c
JOIN payment p
    USING(customer_id);
	
-- 29. Display title and it's actor name.
SELECT * FROM actor;
SELECT f.title, a.first_name||' '|| a.last_name 
FROM film f
JOIN film_actor fa 
    ON fa.film_id = f.film_id
JOIN actor a 
    ON a.actor_id = fa.actor_id
ORDER BY title;

-- 30. List all actor name and find corresponding film id
SELECT first_name,last_name,f.film_id
FROM actor a
LEFT JOIN film_actor fa 
    ON fa.actor_id = a.actor_id
LEFT JOIN film f
    ON fa.film_id = f.film_id;

-- 31. List all addresses and find corresponding customer's name and phone.
SELECT first_name,last_name,phone,address,address2,district
FROM address
LEFT JOIN customer
    USING(address_id);

-- 32. Find Customer's payment (include null values if not matched from both tables)(customer_id,payment_id,first_name,last_name,payment_date)
SELECT c.customer_id,payment_id,first_name,last_name,payment_date
FROM customer c
FULL JOIN payment p 
	USING(customer_id);
	
-- 33 List customer's address_id. (Not include duplicate id )
SELECT DISTINCT address_id
FROM customer;

-- 34 List customer's address_id. (Include duplicate id ) 
SELECT address_id
FROM customer;

-- 35 List Individual Customers' Payment total. 
SELECT customer_id,
		SUM(amount) as payment_total
FROM payment
GROUP BY customer_id;

-- 36 List Customer whose payment is greater than 80. 
SELECT customer_id,amount
FROM payment
WHERE amount > 8.0;

-- 37 Shop owners decided to give 5 extra days to keep their dvds to all the rentees who rent the movie before June 15th 2005 make according changes in db 

UPDATE rental
SET return_date = return_date + interval '5 days'
WHERE
rental_date <='15-06-2005';

SELECT * 
FROM rental
WHERE rental_date<='15-06-2005'
ORDER BY rental_date DESC;


-- 38	Remove the records of all the inactive customers from the Database
-- ALTER TABLE customer
--     DROP CONSTRAINT payment_customer_id_fkey,   
--     ADD CONSTRAINT payment_customer_id_fkey FOREIGN KEY (customer_id)
--           REFERENCES payment (customer_id) ON DELETE CASCADE;

DELETE FROM customer
WHERE active=0;

SELECT * FROM customer
WHERE active=0;

-- 39	count the number of special_features category wise.... total no.of deleted scenes, Trailers etc....
SELECT * FROM film;

SELECT category_id,UNNEST(special_features),COUNT(special_features)
FROM film
JOIN film_category
USING(film_id)
GROUP BY category_id,UNNEST(special_features),special_features
ORDER BY category_id;

-- 40	count the numbers of records in film table
SELECT COUNT(*) as total_record FROM film;

-- 41	count the no.of special fetures which have Trailers alone, Trailers and Deleted Scened both etc....
SELECT COUNT(DISTINCT special_features) FROM film;

-- 42	use CASE expression with the SUM function to calculate the number of films in each rating:
SELECT distinct rating FROM film;

SELECT 
	SUM(CASE WHEN rating='PG-13' THEN 1 END) AS "PG-13",
	SUM(CASE WHEN rating='R' THEN 1 END) AS "R",
	SUM(CASE WHEN rating='G' THEN 1 END) AS "G",
	SUM(CASE WHEN rating='NC-17' THEN 1 END) AS "NC-17",
	SUM(CASE WHEN rating='PG' THEN 1 END) AS "PG"
FROM film;

-- 43	Display the discount on each product, if there is no discount on product Return 0
SELECT product,
CASE WHEN discount IS NULL THEN 0 
ELSE discount END AS discount
FROM items;

-- 44	Return title and it's excerpt, if excerpt is empty or null display last 6 letters of respective body from posts table
SELECT title, 
CASE WHEN excerpt IS NULL OR excerpt='' THEN RIGHT(body,6)
	 ELSE excerpt
END AS excerpt
FROM posts;

-- 45	Can we know how many distinct users have rented each genre? if yes, name a category with highest and lowest rented number  ..
WITH cte AS
(
	SELECT name,COUNT(DISTINCT customer_id) count
	FROM rental r
	JOIN inventory i
	USING(inventory_id)
	JOIN film_category
	USING(film_id)
	JOIN category
	USING(category_id)
	GROUP BY name),
cte2 AS (
	SELECT * FROM cte 
	ORDER BY count LIMIT 1),
cte3 AS (
	SELECT * FROM cte 
	ORDER BY count DESC LIMIT 1 )
SELECT * FROM cte2
UNION
SELECT * FROM cte3;

-- 46	"Return film_id,title,rental_date and rental_duration
	-- according to rental_rate need to define rental_duration 
	-- such as 
	-- rental rate  = 0.99 --> rental_duration = 3
	-- rental rate  = 2.99 --> rental_duration = 4
	-- rental rate  = 4.99 --> rental_duration = 5
	-- otherwise  6"
SELECT film_id,
	   title,
	   rental_date,
	   CASE
	   		WHEN rental_rate = 0.99 THEN 3
			WHEN rental_rate = 2.99 THEN 4
			WHEN rental_rate = 4.99 THEN 5
			ELSE 6
	   END AS rental_duration
FROM rental r
JOIN inventory
USING(inventory_id)
JOIN film
USING(film_id);

-- 47	Find customers and their email that have rented movies at priced $9.99.
SELECT first_name||' '||last_name AS "full_name",
		email
FROM customer
JOIN rental
USING(customer_id)
JOIN payment
USING(rental_id)
WHERE amount=9.99;

-- 48	Find customers in store #1 that spent less than $2.99 on individual rentals, but have spent a total higher than $5.
SELECT customer_id,
		SUM(amount)
FROM payment
JOIN staff
USING(staff_id)
WHERE customer_id IN (SELECT DISTINCT customer_id
					  FROM payment
					  WHERE amount<2.99)
GROUP BY customer_id
ORDER BY customer_id;

-- 49	Select the titles of the movies that have the highest replacement cost.
SELECT title FROM film
WHERE 
	replacement_cost = (SELECT MAX(replacement_cost)
						FROM film); 

-- 50	list the cutomer who have rented maximum time movie and also display the count of that... 
--(we can add limit here too---> list top 5 customer who rented maximum time)
SELECT customer_id,film_id, 
		count(*) AS cnt 
FROM rental
JOIN inventory
USING(inventory_id)
GROUP BY customer_id,film_id
ORDER BY cnt DESC LIMIT 5;


-- 51	Display the max salary for each department
SELECT dept_name,MAX(salary)
FROM employee
GROUP BY dept_name;

-- 52	"Display all the details of employee and add one extra column name max_salary (which shows max_salary dept wise) 
	-- /*
	-- emp_id	 emp_name   dept_name	salary   max_salary
	-- 120	     ""Monica""	""Admin""		5000	 5000
	-- 101		 ""Mohan""	""Admin""		4000	 5000
	-- 116		 ""Satya""	""Finance""		6500	 6500
	-- 118		 ""Tejaswi""	""Finance""	5500	 6500

	-- --> like this way if emp is from admin dept then , max salary of admin dept is 5000, 
	--then in the max salary column 5000 will be shown for dept admin
	-- */"
SELECT * FROM
(SELECT * FROM employee) t2
JOIN
(SELECT dept_name,MAX(salary)
FROM employee
GROUP BY dept_name) t1
USING(dept_name)
ORDER BY dept_name;


-- 53	"Assign a number to the all the employee department wise  
	-- such as if admin dept have 8 emp then no. goes from 1 to 8, then if finance have 3 then it goes to 1 to 3

	-- emp_id   emp_name       dept_name   salary  no_of_emp_dept_wsie
	-- 120		""Monica""		""Admin""		5000	1
	-- 101		""Mohan""		""Admin""		4000	2
	-- 113		""Gautham""		""Admin""		2000	3
	-- 108		""Maryam""		""Admin""		4000	4
	-- 113		""Gautham""		""Admin""		2000	5
	-- 120		""Monica""		""Admin""		5000	6
	-- 101		""Mohan""		""Admin""		4000	7
	-- 108		""Maryam""	    ""Admin""		4000	8
	-- 116		""Satya""	    ""Finance""		6500	1
	-- 118		""Tejaswi""		""Finance""		5500	2
	-- 104		""Dorvin""		""Finance""		6500	3
	-- 106		""Rajesh""		""Finance""		5000	4
	-- 104		""Dorvin""		""Finance""		6500	5
	-- 118		""Tejaswi""		""Finance""		5500	6"

SELECT *,
	ROW_NUMBER() 
	OVER(PARTITION BY dept_name
		ORDER BY salary DESC)
FROM employee;

-- 54	Fetch the first 2 employees from each department to join the company. (assume that emp_id assign in the order of joining
WITH cte AS
(
	SELECT *,
		ROW_NUMBER()
		OVER(PARTITION BY dept_name
			ORDER BY emp_id) AS row_num
	FROM employee
)
SELECT emp_id,
	   emp_name,
	   dept_name,
	   salary
FROM cte
WHERE row_num<=2;


-- 55	Fetch the top 3 employees in each department earning the max salary.
WITH cte AS
(
	SELECT *,
		DENSE_RANK()
		OVER(PARTITION BY dept_name
			ORDER BY salary DESC) AS rnk
	FROM employee
)
SELECT emp_id,
	   emp_name,
	   dept_name,
	   salary,rnk
FROM cte
WHERE rnk<=3;

-- 56	write a query to display if the salary of an employee is higher, lower or equal to the previous employee.
WITH cte AS
(
	SELECT *,
	LAG(salary) OVER() AS pre_sal
	FROM employee
)
SELECT *,
	CASE
		WHEN pre_sal < salary THEN 'Higher'
		WHEN pre_sal = salary THEN 'Equal'
		WHEN pre_sal > salary THEN 'lower'
		ELSE NULL
	END
FROM cte;

-- 57	Get all title names those are released on may DATE
SELECT * FROM film;
SELECT * FROM rental;
SELECT title,rental_date 
FROM rental
JOIN inventory
USING(inventory_id)
JOIN film
USING(film_id)
WHERE EXTRACT(MONTH FROM rental_date)=5;

-- 58	get all Payments Related Details from Previous week
SELECT * FROM payment
WHERE EXTRACT(WEEK FROM payment_date) = 
	(SELECT EXTRACT(WEEK FROM MAX(payment_date))-1
	 FROM payment);
	 
-- 59	Get all customer related Information from Previous Year
SELECT * FROM customer
WHERE EXTRACT(YEAR FROM create_date) =
		(SELECT EXTRACT(YEAR FROM MAX(create_date))-1 
		 FROM customer);
-- 60	What is the number of rentals per month for each store?
SELECT * FROM rental;
SELECT staff_id,EXTRACT(MONTH FROM rental_date),COUNT(rental_id) 
FROM rental
GROUP BY EXTRACT(MONTH FROM rental_date),staff_id
ORDER BY staff_id;

-- 61	Replace Title 'Date speed' to 'Data speed' whose Language 'English'
UPDATE film
SET title='Data Speed'
WHERE title='Date Speed' 
	AND language_id=1;
	
-- 62	Remove Starting Character "A" from Description Of film
UPDATE film
SET description = RIGHT(description,LENGTH(description)-2)
WHERE description LIKE 'A%';
SELECT * FROM film
WHERE description LIKE 'A%';

-- 63 if end of string is 'Italian'then Remove word from Description of Title
UPDATE film
SET description = REPLACE(description,' Italian','')
WHERE description LIKE '%Italian';

-- 64    Who are the top 5 customers with email details per total sales
SELECT c.customer_id,c.email,SUM(amount) AS sales
FROM payment p
JOIN customer c
USING(customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 65    Display the movie titles of those movies offered in both stores at the same time.
SELECT 
	film_id,title,rental_date
FROM film
JOIN inventory
	USING(film_id)
JOIN rental
	USING(inventory_id)
WHERE store_id=1
INTERSECT
SELECT 
	film_id,title,rental_date
FROM film
JOIN inventory
	USING(film_id)
JOIN rental
	USING(inventory_id)
WHERE store_id=2;

-- 66    Display the movies offered for rent in store_id 1 and not offered in store_id 2.
SELECT 
	DISTINCT ON(film_id) film_id,
	title,
	rental_date
FROM film
JOIN inventory
	USING(film_id)
JOIN rental
	USING(inventory_id)
WHERE store_id=1
EXCEPT
SELECT film_id,title,rental_date
FROM film
JOIN inventory
	USING(film_id)
JOIN rental
	USING(inventory_id)
WHERE store_id=2;

-- 67    Show the number of movies each actor acted in
SELECT actor_id,
		first_name||' '||last_name AS "full name",
		COUNT(film_id)
FROM actor
JOIN film_actor
	USING(actor_id)
GROUP BY actor_id,first_name,last_name
ORDER BY actor_id;

-- 68    Find all customers with at least three payments whose amount is greater than 9 dollars
WITH cte AS
(		SELECT customer_id,
 				first_name,
 				last_name,
 				row_number()
 				OVER(PARTITION BY customer_id
					 ORDER BY amount DESC) AS row_num
 		FROM payment
 		JOIN customer c
 		USING(customer_id)
 		WHERE amount>=9)
SELECT customer_id,
		first_name||' '||last_name AS "full_name"
FROM cte
WHERE row_num>=3;

-- 69    find out the lastest payment date of each customer
SELECT customer_id,
	   MAX(payment_date)
FROM payment
GROUP BY customer_id
ORDER BY customer_id;

-- 70	Create a trigger that will delete a customer’s reservation record once the customer’s rents the DVD
CREATE OR REPLACE FUNCTION del_reservation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
	DELETE FROM resrvation res
	WHERE res.inventory_id = NEW.inventory_id
		AND res.customer_id = NEW.inventory_id;
	RETURN NULL;
END
$$;

CREATE TRIGGER del_res_on_insert
AFTER INSERT
ON rental
FOR EACH ROW
EXECUTE PROCEDURE del_reservation();


SELECT * FROM reservation;
-- 71	Create a trigger that will help me keep track of all operations performed on the reservation table. 
-- I want to record whether an insert, delete or update occurred on the reservation table and store that log in reservation_audit table.
CREATE OR REPLACE FUNCTION add_log()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
	IF TG_OP='INSERT' THEN
		--insert operation
		INSERT INTO reservation_audit
		VALUES('I',CURRENT_TIMESTAMP,NEW.customer_id,NEW.inventory_id,NEW.reserve_date);
		RETURN NULL;
	ELSEIF TG_OP='UPDATE' THEN
		--update operation
		INSERT INTO reservation_audit
		VALUES('U',CURRENT_TIMESTAMP,NEW.customer_id,NEW.inventory_id,NEW.reserve_date);
		RETURN NULL;
	ELSEIF TG_OP='DELETE' THEN
		--delete operation
		INSERT INTO reservation_audit
		VALUES('D',CURRENT_TIMESTAMP,customer_id,inventory_id,reserve_date);
		RETURN NULL;
	END IF;
END
$$;

CREATE TRIGGER track_op_res
AFTER INSERT OR UPDATE OR DELETE
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE add_log();


INSERT INTO reservation
VALUES(5,11,CURRENT_DATE);
SELECT * FROM reservation;
SELECT * FROM reservation_audit;

-- 72	Create trigger to prevent a customer for reserving more than 3 DVD’s.

CREATE OR REPLACE FUNCTION max_dvd_reserve()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
	IF (SELECT COUNT(*) FROM reservation r WHERE r.customer_id=NEW.customer_id) >3 THEN
		RAISE NOTICE 'You cant reserve more than 3 DVDs.';
	ELSE
		RETURN NEW;
	END IF;
END
$$;

CREATE TRIGGER max_dvd_check
BEFORE INSERT
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE max_dvd_reserve();

SELECT * FROM reservation 
ORDER BY customer_id;

INSERT INTO reservation
VALUES(1,18,CURRENT_DATE);

-- 73	create a function which takes year as a argument and return the concatenated result of title which contain 'ful' in it 
-- and release year like this (title:release_year) 

CREATE OR REPLACE FUNCTION get_film_titles(p_year INT)
RETURNS TEXT
LANGUAGE plpgsql
AS 
$$
DECLARE    
	titles TEXT DEFAULT '';
	rec record;
	cur_films CURSOR(p_year INT) 
	FOR SELECT title, release_year FROM film
                WHERE release_year = p_year;
BEGIN
	OPEN cur_films(p_year);
	LOOP
        FETCH cur_films into rec;
		EXIT WHEN NOT FOUND;
		IF rec.title ILIKE '%ful%' THEN 
            IF titles != '' THEN
                titles = titles || ', ' || rec.title || ' - ' || rec.release_year;
			ELSE
                titles = rec.title || ' - ' || rec.release_year;
			END IF;
		END IF;    
	END LOOP;    
	CLOSE cur_films;
	RETURN titles;
END 
$$;
SELECT get_film_titles(2006) AS films;

-- 74	Find top 10 shortest movies using for loop
DO
$$
DECLARE    
	rec record;
BEGIN
	FOR rec IN SELECT title,length 
           	 FROM film 
			 ORDER BY length
			 LIMIT 10
	LOOP
    	RAISE NOTICE '% - % mins', rec.title, rec.length;
	END LOOP;
END
$$;

-- 75	Write a function using for loop to derive value of 6th field in fibonacci series (fibonacci starts like this --> 1,1,.....)
CREATE OR REPLACE FUNCTION fibonaci(n INTEGER)
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE    
	a INT = 0;
	b INT = 1;
	temp INT;
	n INT = n;
	i INT;
BEGIN
	FOR i IN 2..n
    LOOP
        temp:= a + b;
		a := b;
		b := temp;
	END LOOP;   
	RETURN b;
END 
$$;

SELECT fibonaci(6);