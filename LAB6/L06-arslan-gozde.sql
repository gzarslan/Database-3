 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 25/02/2021
 --Purpose: Lab 6 DBS311
 --***********************


-- Question 1 – 
-- Q2 SOLUTION –

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE calculate_salary
(empID employees.employee_id%type)
AS
p_employee employees%type;
newSalary employees.salary%type;
yearsWork INTEGER;

BEGIN
    SELECT * INTO p_employee
    FROM employees
    WHERE employee_id = empID;

    newSalary := p_employee.salary;
    yearsWork := TRUNC(MONTHS_BETWEEN(SYSDATE,p_employee.hire_date)/12);
    
    FOR YEAR IN 2..yearsWork LOOP
    newSalary:= newSalary * 1.05;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('First Name: ' || p_employee.first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name:  ' || p_employee.last_name);
    DBMS_OUTPUT.PUT_LINE('Salary:   ' || to_char(newSalary, '$999999.99')); 

EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || empID || ' does not exist.');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('No state');
END calculate_salary;
/
EXEC calculate_salary(5);

/
-- Question 2 – 
-- Q3 SOLUTION –

CREATE OR REPLACE PROCEDURE employee_works_here AS
    empId employees.employee_id%type;
    lname  employees.last_name%type;
    dpName departments.department_name%type;
    myId employees.employee_id%type := 01;
    maxId employees.employee_id%type := 105;
    counter NUMBER := 0;
BEGIN
    dbms_output.put_line(rpad('Employee #', 12)||rpad('Last Name', 20)||rpad('Department Name',20));
    FOR employee IN (
                SELECT employee_id, last_name, department_name
                FROM employees
                LEFT JOIN departments using(department_id)
                WHERE employee_id BETWEEN myId and maxId
                ORDER BY employee_id
                )
    LOOP 
        empId :=  employees.employee_id;
        lname := employees.last_name;
        dpName := employees.department_name;
        IF dpName = NULL THEN
            dpName := 'No department';
        END IF;
        DBMS_OUTPUT.PUT_LINE(rpad(empId, 12) || rpad(lname, 20) || rpad(dpName,20)); 
        counter := counter +1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE (counter || ' rows returned.');
EXCEPTION
WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('No data found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
END;
/
EXEC employee_works_here;