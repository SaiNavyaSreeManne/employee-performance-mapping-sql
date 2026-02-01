1.	Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.
Query -

CREATE database employee;

Use employee;

2.	Create an ER diagram for the given employee database.


3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
QUERY -

Select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT from emp_record_table;

4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
•	less than two
•	greater than four 
•	between two and four
QUERY -

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING < 2
        OR EMP_RATING BETWEEN 2 AND 4
        OR EMP_RATING > 4;

5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.

QUERY –

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    DEPT,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS 'NAME'
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';

6.	Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

QUERY -

SELECT 
    m.EMP_ID AS ManagerID,
    CONCAT(m.FIRST_NAME, ' ', m.LAST_NAME) AS ManagerName,
    COUNT(e.EMP_ID) AS NumberOfReporters
FROM
    emp_record_table m
        JOIN
    emp_record_table e ON m.EMP_ID = e.MANAGER_ID
GROUP BY m.EMP_ID , m.FIRST_NAME , m.LAST_NAME;

7.	Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

QUERY -

SELECT 
    *
FROM
    emp_record_table
WHERE
    DEPT = 'HEALTHCARE' 
UNION SELECT 
    *
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';

8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
Query -

SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    DEPT,
    EMP_RATING,
    MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS Max_Dept_Rating
FROM emp_record_table
GROUP BY
    EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
    ORDER BY DEPT, EMP_RATING DESC;

9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
Query -

SELECT 
    EMP_ID,
    ROLE,
    SALARY,
    MIN(SALARY) OVER (PARTITION BY role) AS Min_Salary,
    MAX(SALARY) OVER (PARTITION BY role) AS Max_Salary
FROM 
    emp_record_table;

10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
Query -

SELECT
    EMP_ID,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS 'Full_Name' ,
    EXP,
    RANK() OVER (ORDER BY EXP DESC) AS Experience_Rank
FROM
    emp_record_table;

11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
Query -

CREATE VIEW Employees_View AS
    SELECT 
        emp_id, first_name, last_name, country, salary
    FROM
        emp_record_table
    WHERE
        salary > 6000
    ORDER BY country;

To View - 
select * from employees_view;

12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
Query -

SELECT 
    *
FROM
    emp_record_table
WHERE
    EXP > (SELECT 10);

13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
Query -
1.
DELIMITER //
CREATE PROCEDURE Experienced_Employees()
BEGIN
    SELECT *
    FROM emp_record_table
    WHERE EXP > 3;
END //
DELIMITER ;

2.
call Experienced_Employees();



14.	Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.

Query –
1.
DELIMITER $$

CREATE FUNCTION Job_Profile(EXP INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE ROLE VARCHAR(50);

    IF EXP <= 2 THEN
        SET ROLE = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP > 2 AND EXP <= 5 THEN
        SET ROLE = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP > 5 AND EXP <= 10 THEN
        SET ROLE = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP > 10 AND EXP <= 12 THEN
        SET ROLE = 'LEAD DATA SCIENTIST';
    ELSEIF EXP > 12 AND EXP <= 16 THEN
        SET ROLE = 'MANAGER';
    END IF;

    RETURN ROLE;
END $$

DELIMITER ;

2.
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    ROLE AS Assigned_Role,
    JOB_PROFILE(EXP) AS Expected_role,
    CASE
        WHEN ROLE = JOB_PROFILE(EXP) THEN 'MATCHED'
        ELSE 'NOT MATCHED'
    END AS Role_Status
FROM
    data_science_team;

15.	Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
Query –

Check Execution Plan (Before Index)

SELECT *
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';



Create Index

CREATE INDEX idx_first_name
ON emp_record_table (FIRST_NAME(20));

Check Execution Plan Again (After Index)

SELECT *
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

16.	Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
Query - 

SELECT 
    EMP_ID,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS 'EMP_NAME',
    SALARY,
    EMP_RATING,
    (SALARY * 0.05 * EMP_RATING) AS Bonus
FROM
    emp_record_table;


17.	Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

Query - 

SELECT 
    CONTINENT, COUNTRY, AVG(SALARY) AS AVG_SALARY
FROM
    emp_record_table
GROUP BY CONTINENT , COUNTRY;

