 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 19/02/2021
 --Purpose: Lab 5 DBS311
  --***********************

SET SERVEROUTPUT ON
-- Q1.	Write a store procedure that get an integer number and prints The number is even.
--         If a number is divisible by 2. Otherwise, it prints The number is odd.
CREATE 
OR replace PROCEDURE findevenodd(x IN number) IS 
BEGIN
   IF MOD(x, 2) = 0 
THEN
   dbms_output.put_line( ' The number is even ');
ELSE
   dbms_output.put_line('The number is odd ');
END
IF;
END
;
/ 
BEGIN
   findevenodd(8) ;
END
;
/

-- Q2.	Create a stored procedure named find_employee. This procedure gets an employee number and prints the following 
--   employee information: First name Last name Email Phone Hire date Job title



CREATE 
OR replace PROCEDURE find_employee(p_employee_id IN number) AS v_count number;
v_first_name employees.first_name % type;
v_last_name employees.last_name % type;
v_email employees.email % type;
v_phone employees.phone % type;
v_hire_date employees.hire_date % type;
v_job_title employees.job_title % type;
BEGIN
   SELECT
      COUNT(employee_id) INTO v_count 
   FROM
      employees 
   WHERE
      employee_id = p_employee_id;
IF v_count = 0 
THEN
   dbms_output.put_line( ' The EMPLOYEE_ID is not present in EMPLOYEES ');
ELSE
   SELECT
      first_name,
      last_name,
      email,
      phone,
      hire_date,
      job_title INTO v_first_name,
      v_last_name,
      v_email,
      v_phone,
      v_hire_date,
      v_job_title 
   FROM
      employees 
   WHERE
      employee_id = p_employee_id;
dbms_output.put_line('FIRST_NAME : ' || v_first_name);
dbms_output.put_line('LAST_NAMENAME: ' || v_last_name);
dbms_output.put_line('EMAIL: ' || v_email);
dbms_output.put_line('PHONE: ' || v_phone);
dbms_output.put_line('HIRE_DATE: ' || v_hire_date);
dbms_output.put_line('JOB_TITLE: ' || v_job_title);
END
IF;
exception 
WHEN
   no_data_found 
THEN
   dbms_output.put_line('Employee not found.');
WHEN
   others 
THEN
   dbms_output.put_line('Stored PROCEDURE has errors.');
END
;
---------------------
/ 
BEGIN
   find_employee(107);
END
;
/


-- Q3.Every year, the company increasesthe price of all products in one category. For example,
--the company wants to increase the price(list_price)of products in category 1 by $5. 
--Write a procedure named update_price_by_catto update the price of all products ina given category and the given amount to be added to the current priceif the price is greater than 0.
--The procedure shows the number of updated rows if the update is successful--

CREATE 
OR replace PROCEDURE update_price_by_cat(p_category_id IN products.category_id % type, p_amount IN products.list_price % type) AS v_count number;
BEGIN
   SELECT
      COUNT(category_id) INTO v_count 
   FROM
      products 
   WHERE
      category_id = p_category_id;
IF (p_amount > 0 
AND v_count > 0) 
THEN
   UPDATE
      products 
   SET
      list_price = list_price + p_amount 
   WHERE
      category_id = p_category_id;
dbms_output.put_line('Rows Updated =' || SQL % rowcount);
ELSE
   dbms_output.put_line('Either there are no CATEGORY matching or the input price is less than zero');
END
IF;
exception 
WHEN
   no_data_found 
THEN
   dbms_output.put_line('PRODUCTS not found.');
WHEN
   others 
THEN
   dbms_output.put_line(' PROCEDURE has errors.');
END
;


/
BEGIN
   update_price_by_cat(1 , 11.11 );
END
;
/
-- Q4. Every year, the company increase the price of products whose price is less than the average price of all products by 1%. 
--(list_price * 1.01). Write a stored procedure named update_price_under_avg. This procedure do not have any parameters. 
--You need to find the average price of all products and store it into a variable of the same type. 
--If the average price is less than or equal to $1000, update products’ priceby 2% if the price of the product is less than the calculated average. 
--If the average price is greater than $1000, update products’ price by 1% if the price of the product is less than the calculatedaverage. 
--The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.--


CREATE 
or replace PROCEDURE update_price_under_avg AS
v_avg products.list_price%TYPE;
v_rate number;
BEGIN

select avg(LIST_PRICE) into v_avg from products ;

   if v_avg >= 1000 THEN
       v_rate := 1.02;         
   ELSE
v_rate :=1.01;
   end if;
  
  
   update products set LIST_PRICE = LIST_PRICE * v_rate where LIST_PRICE <= v_avg;
   DBMS_OUTPUT.PUT_LINE('Rows Updated =' || SQL%ROWCOUNT);  


EXCEPTION
  
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('PRODUCTS not found.');   
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. ');     
end;
--------------
/
BEGIN
   update_price_under_avg;
END;
/

-- Q5. The company needs a report that shows three category of products basedtheir prices. The company needsto know if the product price is cheap, fair, or expensive. 


CREATE 
OR replace PROCEDURE product_price_report AS avg_price number;
min_price number;
max_price number;
cheap_count number;
fair_count number;
exp_count number;
BEGIN
   SELECT
      AVG(list_price),
      MAX(list_price),
      MIN(list_price) INTO avg_price,
      max_price,
      min_price 
   FROM
      products;
SELECT
   COUNT(list_price) INTO cheap_count 
FROM
   products 
WHERE
   list_price < (avg_price - min_price) / 2;
SELECT
   COUNT(list_price) INTO exp_count 
FROM
   products 
WHERE
   list_price > (max_price - avg_price) / 2;
SELECT
   COUNT(list_price) INTO fair_count 
FROM
   products 
WHERE
   list_price >= 
   (
      avg_price - min_price
   )
   / 2 
   AND list_price <= 
   (
      max_price - avg_price
   )
   / 2;
dbms_output.put_line('Cheap: ' || cheap_count);
dbms_output.put_line('Fair: ' || fair_count);
dbms_output.put_line('Expensive: ' || exp_count);
END
;
/ 
BEGIN
   product_price_report();
END
;
/

