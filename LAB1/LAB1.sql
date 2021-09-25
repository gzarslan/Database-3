 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 20/01/2021
 --Purpose: Lab 1 DBS311
 --***********************
   
--Q1 Write a query to display the tomorrow’s date in the following format:January 10th of year 2019the result will depend on the day when you RUN/EXECUTE this query.  Label the column “Tomorrow”.--
--Q1 Solution--
   SELECT to_char(sysdate+1,'Month DD"th of year" YYYY') AS tomorrow FROM DUAL;
--Q2 Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date anduse it in an SQL statement. Here the question is asking you to use a Substitution variable. Instead of using the constant values in your queries, you can use variables to store and reuse the values.--
--Q2 Answer--
  define tomorrow datetime = sysdate;
  define tomorrow = sysdate + 1;
  SELECT &tomorrow FROM dual;
--Q3 For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. Display a new list price as a whole number.In your result, add a calculated column to show the difference of old and new list prices--
--Q3 Answer-- 
  SELECT product_id,product_name,list_price,round(list_price+list_price*0.02) AS "NEW_PRICE", round(list_price+(list_price*0.02)-(list_price),2) AS price_diffrence FROM products WHERE category_id=2 OR category_id=3 OR category_id=5 ORDER BY category_id, product_id;
--Q4 For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format -- 
--Q4 Answer--
  SELECT (last_name||','||first_name||' is '||job_title) AS  "Employee Info" FROM employees WHERE manager_id=2 ORDER BY employee_id;
--Q5 For each employee hired before October 2016, display the employee’s last name, hire date and calculate the number of YEARS between TODAY and the date the employee was hired.--
--Q5 Answer--
  SELECT last_name as "Last Name", to_char(hire_date,'DD "-" Mon"-" YY') as "Hired Date",  EXTRACT(YEAR FROM (SYSDATE - HIRE_DATE) YEAR TO MONTH) as "year Worked" FROM employees Where hire_date>'01-JAN-16' ORDER BY hire_date;
--Q6 Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired afterJanuary 1,2016.-- 
--Q6 Answer--
  SELECT last_name as"Last Name", to_char(hire_date,'DD "-" Mon"-" YY') as "Hired Date", to_char(next_day(hire_date+366,'tuesday'),'"TUESDAY," MONTH" the "ddspth" of year "YYYY') as "Review Date" FROM employees Where hire_date>'01-JAN-16' ORDER BY next_day(hire_date+365,'Tuesday');
--Q7 For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column, display “unknown”.Sort the result based on the warehouse ID.--
--Q7 Answer--
 SELECT warehouse_id as "Warehouse ID" ,warehouse_name as "Warehouse Name",city as "City",Coalesce(state,'unkown') as "State" FROM warehouses w LEFT JOIN locations l ON w.location_id=l.location_id  ORDER BY warehouse_id;

