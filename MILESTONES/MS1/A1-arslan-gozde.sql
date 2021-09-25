 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 21/02/2021
 --Purpose: Assignment 1 DBS311
  --***********************


-- Q1. Display the employee number, full employee name, jobtitle,and hire date ofall employees hired in Septemberwith the most recently hired employees displayed first.
-- Solution Q1--

SELECT
   employee_id AS "Employee Number",
   rpad(first_name || ', ' || last_name, 25, ' ') AS "Full Name",
   job_title AS "JOB TITLE",
   to_char(last_day(hire_date), '[Month ddTH "of" yyyy]') AS "Hire Date" 
FROM
   employees 
WHERE
   EXTRACT(MONTH 
FROM
   hire_date) IN 
   (
      9
   )
ORDER BY
   hire_date DESC;
   


-- Q2. The company wants to see the total sale amount per sales person (salesman) for all
--     orders. Assume that online orders do not have any sales representative. For onlineorders (orders with no salesman ID),
--     consider the salesman ID as 0. Display thesalesman ID and the total sale amount for each employee.Sort the result 
--      according to employee number.
-- Solution Q2--
SELECT
  NVL( o.salesman_id,0) AS "Employee Number",
   SUM(i.unit_price*i.quantity) AS "Total Sale" 
FROM
   orders o,
   order_items i 
WHERE
   o.order_id = i.order_id 
GROUP BY
   o.salesman_id
  

ORDER BY NVL(o.salesman_id,0) ASC;



    
--Q3. Display customer Id, customer name and total number of orders for customers thatthe value of their 
--     customer ID is in values from 35 to 45. Include the customers with no orders in your report if 
--     their customer ID falls in the range 35 and 45.  Sort the result by the value of total orders.
-- Solution Q3--
SELECT
   c.customer_id,
   c.name AS " Name",
   COUNT(o.order_id) AS "Total Orders" 
FROM
   customers c 
   LEFT JOIN
      orders o 
      ON c.customer_id = o.customer_id 
WHERE
   c.customer_id BETWEEN 35 AND 45 
GROUP BY
   c.customer_id,
   c.name 
ORDER BY
   COUNT(o.order_id);   
  

-- Q4. Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
--     a. Show also the total quantity and the total amount of each customer?s order.
--     b. Sort the result from the highest to lowest total order amount.
-- Solution Q4--
SELECT
   c.customer_id,
   name,
   o.order_id,
   order_date,
   SUM(quantity) AS "Total_items",
   SUM(quantity * unit_price) AS "Total_amount"
FROM
   customers c 
   JOIN
      orders o 
      ON c.customer_id = o.customer_id 
   JOIN
      order_items oi 
      ON o.order_id = oi.order_id 
WHERE
   c.customer_id = 44 
GROUP BY
   c.customer_id,
   name,
   o.order_id,
   order_date 
ORDER BY
   SUM(quantity * unit_price) DESC;

--  Q5. Display customer Id, name, total number of orders, the total number of items ordered, 
--     and the total order amount for customers who have more than 30 orders.
--     Sort the result based on the total number of orders

-- Solution Q5--
SELECT
   c.customer_id,
   c.name,
   COUNT(o.order_id) AS "total number of orders",
   SUM(oi.quantity) AS "Total Items",
   SUM(oi.quantity * oi.unit_price) AS "Total Amount" 
FROM
   orders o,
   customers c,
   order_items oi 
WHERE
   c.customer_id = o.customer_id 
   AND o.order_id = oi.order_id 
GROUP BY
   c.customer_id,
   c.name 
HAVING
   COUNT(o.order_id) > 30 
ORDER BY
   COUNT(oi.order_id) ASC;


--  Q6. Display Warehouse Id, warehouse name, product category Id, product category  name, and the lowest
--      product standard cost for this combination.
--      In your result, include the rows that the lowest standard cost is less then $200.
--      Also, include the rows that the lowest cost is more than $500.
--      Sort the output according to Warehouse Id, warehouse name and then product category Id, and product category name
-- Solution Q6--
SELECT
   w.warehouse_id,
   warehouse_name,
   p.category_id,
   category_name,
   MIN(standard_cost) AS lowest_cost 
FROM
   inventories i 
   JOIN
      warehouses w 
      ON i.warehouse_id = w.warehouse_id 
   JOIN
      products p 
      ON i.product_id = p.product_id 
   JOIN
      product_categories pc 
      ON p.category_id = pc.category_id 
GROUP BY
   w.warehouse_id,
   warehouse_name,
   p.category_id,
   category_name 
HAVING
   MIN(standard_cost) < 200 
   OR MIN(standard_cost) > 500 
ORDER BY
   w.warehouse_id,
   warehouse_name,
   p.category_id,
   category_name;


-- Q7. Display the total number of orders per month. Sort the result from January to December
-- Solution Q7--
SELECT
   to_char(to_date(the_month, 'MM'), 'Month') AS "MONTH",
   counts AS "number of orders" 
FROM
   (
      SELECT
         EXTRACT(MONTH 
      FROM
         order_date) AS the_month,
         COUNT(*) AS counts 
      FROM
         orders 
      GROUP BY
         EXTRACT(MONTH 
      FROM
         order_date) 
   )
   sales 
ORDER BY
   the_month;


--Q8. Display product Id, product name for products that their list price is more than any highest product
--      standard cost per warehouse outside Americas regions. (You need to find the highest standard cost for each 
--      warehouse that is located outside the Americas regions. Then you need to return all products that their list
--      price is higher than any highest standard cost of those warehouses.)
--      Sort the result according to list price from highest value to the lowest.
-- Solution Q8--
SELECT
   product_id AS "product id",
   product_name AS "product name",
   to_char(list_price, '$999,999.99') AS "price" 
FROM
   products 
WHERE
   list_price > ANY ( 
   SELECT
      MAX(standard_cost) 
   FROM
      locations l 
      JOIN
         countries c 
         ON l.country_id = c.country_id 
      JOIN
         regions r 
         ON r.region_id = c.region_id 
      JOIN
         warehouses w 
         ON w.location_id = l.location_id 
      JOIN
         inventories i 
         ON i.warehouse_id = w.warehouse_id 
      JOIN
         products p 
         ON p.product_id = i.product_id 
   WHERE
      region_name NOT LIKE 'Americas' 
   GROUP BY
      w.warehouse_id) 
   ORDER BY
      list_price DESC;

--   Q9. Write a SQL statement to display the most expensive and the cheapest product (list
--        price). Display product ID, product name, and the list price.
-- Solution Q9--
SELECT
   product_id,
   product_name,
   list_price AS "PRICE"
FROM
   products 
WHERE
   list_price = 
   (
      SELECT
         MAX(list_price) 
      FROM
         products
   )
   OR list_price = 
   (
      SELECT
         MIN(list_price) 
      FROM
         products
   )
;

-- Q10. Write a SQL query to display the number of customers with total order amount over the average amount
--     of all orders, the number of customers with total order amount under the average amount of all orders, 
--     number of customers with no orders, and the total number of customers. See the format of the following result.
-- Solution 10--
SELECT
   'Number of customers with total purchase amount over average: ' || COUNT(*) AS "customer report" 
FROM
   (
      SELECT
         c.customer_id,
         SUM(i.quantity*i.unit_price) AS total_amount 
      FROM
         customers c 
         INNER JOIN
            orders o 
            ON c.customer_id = o.customer_id 
         INNER JOIN
            order_items i 
            ON i.order_id = o.order_id 
      GROUP BY
         c.customer_id 
   )
WHERE
   total_amount > (
   SELECT
      AVG(quantity*unit_price) 
   FROM
      order_items) 
   UNION ALL
   SELECT
      'Number of customers with total purchase amount below average: ' || COUNT(*) 
   FROM
      (
         SELECT
            c.customer_id,
            SUM(i.quantity*i.unit_price) AS total_amount 
         FROM
            customers c 
            INNER JOIN
               orders o 
               ON c.customer_id = o.customer_id 
            INNER JOIN
               order_items i 
               ON i.order_id = o.order_id 
         GROUP BY
            c.customer_id 
      )
   WHERE
      total_amount < (
      SELECT
         AVG(quantity*unit_price) 
      FROM
         order_items) 
      UNION ALL
      SELECT
         'Number of customers with no orders: ' || COUNT(*) 
      FROM
         (
            SELECT
               customer_id 
            FROM
               customers minus 
               SELECT
                  customer_id 
               FROM
                  orders
         )
      UNION ALL
      SELECT
         'Total number of customers: ' || COUNT(*) 
      FROM
         (
            SELECT
               customer_id 
            FROM
               customers 
            UNION
            SELECT
               customer_id 
            FROM
               orders
         )
;   






