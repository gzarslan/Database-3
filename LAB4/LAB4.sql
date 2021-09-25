 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 12/02/2021
 --Purpose: Lab 4 DBS311
  --***********************
 
 --Q1 Display cities that no warehouse is located in them. (use set operators to answer this question).--
--Q1 Solution--
  SELECT
   city 
FROM
   locations MINUS
   SELECT
      l.city 
   FROM
      locations l,
      warehouses w 
   WHERE
      l.location_id = w.location_id;
--Q2 Display the category ID, category name,and the number of products in category1, 2, and 5. In your result, display first the number of products in category 5, then category 1 and then 2.--
--Q2 Answer-- 
    
--Q3 Display product ID for products whose quantity in the inventory is less thanto 5.(You are not allowed to use JOIN for this question.--
--Q3 Answer-- 
 SELECT
   product_id 
FROM
   inventories 
WHERE
   quantity < 5 
UNION
SELECT
   product_id 
FROM
   inventories 
WHERE
   quantity < 5; 
--Q4 We need a single report to display all warehouses and the state that they are located in and all states regardless of whether they have warehouses in them or not.(Use set operators in you answer.) -- 
--Q4 Answer--
 SELECT
   warehouse_name,
   state 
FROM
   warehouses w 
   FULL JOIN
      locations l 
      ON w.location_id = l.location_id 
WHERE
   w.location_id IS NULL 
UNION
SELECT
   warehouse_name,
   state 
FROM
   warehouses w 
   FULL JOIN
      locations l 
      ON w.location_id = l.location_id 
WHERE
   w.location_id IS NOT NULL 
ORDER BY
   warehouse_name,
   state;
 