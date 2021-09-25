 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 05/02/2021
 --Purpose: Lab 3 DBS311
  --***********************
 
 --Q1 Write a SQL query to displaythe last nameand hire dateof all employees who were hired before the employee with ID 107 got hiredbut after March2016. Sort the result by the hire date and then employee ID .--
--Q1 Solution--
  SELECT 
    last_name,
    to_char(hire_date,'DD "-" MON"-" YY') as "HIRED_DATE",   
    employee_id
  FROM 
    employees
  WHERE
      employee_id <107 AND hire_date> to_date('2016-March-31')
  ORDER BY
  hire_date,
  employee_id;
--Q2 Write a SQL query to display customer nameand creditlimit for customers with lowest credit limit.Sort the result by customer ID..--
--Q2 Answer-- 
SELECT
   name,
   credit_limit 
FROM
   customers 
WHERE
   credit_limit IN
   (
      SELECT
         MIN (credit_limit) 
      FROM
         customers 
   )
ORDER BY
   customer_id;
--Q3 Write a SQL query to displaythe product ID, product name, and list priceof the highest paid product(s) in each category.  Sort by category IDand the product ID--
--Q3 Answer-- 
 SELECT
   category_id,
   product_id,
   product_name,
   list_price 
FROM
   products 
WHERE
   list_price IN
   (
      SELECT
         MAX(list_price) 
      FROM
         products 
      GROUP BY
         category_id 
   )
ORDER BY
   category_id,
   product_id;   
--Q4 Write a SQL query to displaythe category ID and the category nameof the most expensive (highest list price)product(s) -- 
--Q4 Answer--
 SELECT
   category_id,
   category_name 
FROM
   product_categories 
WHERE
   category_id IN
   (
      SELECT
         category_id 
      FROM
         products 
      WHERE
         list_price IN
         (
            SELECT
               MAX(list_price) 
            FROM
               products 
         )
   )
;
--Q5 Write a SQL query to displayproduct name and list price for productsin category 1which have the list price less than the lowest list price in ANY category. Sort the output by top list prices first and then by the productID.--
--Q5 Answer--
  
 SELECT
   product_name,
   list_price 
FROM
   products 
WHERE
   category_id = 1 
   AND list_price < ANY( 
   SELECT
      MIN(list_price) 
   FROM
      products 
   GROUP BY
      category_id) 
   ORDER BY
      list_price DESC,
      product_name;
      
 --Q6 Display the maximum price (list price)of the category(s) that has the lowest price product.-- 
--Q6 Answer--
  SELECT
   MAX(list_price) 
FROM
   products 
WHERE
   category_id IN
   (
      SELECT
         category_id 
      FROM
         products 
      WHERE
         list_price IN 
         (
            SELECT
               MIN(list_price) 
            FROM
               products
         )
   )
;

  

