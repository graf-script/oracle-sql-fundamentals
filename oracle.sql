-- select statement
CREATE TABLE customer1 
(
    cust_id NUMBER(8),
    cust_name VARCHAR2(100),
    mobile NUMBER(10),
    dob DATE,
    city VARCHAR2(100),
    email_id VARCHAR2(100)
);

SELECT * FROM customer1;

INSERT INTO customer1
(cust_id, cust_name, mobile, dob, city, email_id)
VALUES(10000, 'Arun', 90909090, to_date('08/04/2000', 'mm/dd/yyyy'), 'Yuzhne', 'arun@gmail.com');

rollback;

INSERT INTO customer1
(cust_id, cust_name, mobile, dob, city, email_id)
VALUES(10000, 'John', 90909090, to_date('08/04/2000', 'mm/dd/yyyy'), 'Odessa', 'arun@gmail.com');


commit;

INSERT INTO customer1
(cust_id, cust_name, mobile, dob, city, email_id)
VALUES(10000, 'Omaha', 90909090, to_date('08/04/2000', 'mm/dd/yyyy'), 'Kyiv', 'arun@gmail.com');

commit;

UPDATE customer1
SET mobile = 12121212;

UPDATE customer1
SET mobile = 54545454 WHERE city = 'Kyiv';

UPDATE customer1
SET country = 'Ukraine';

-- add column
ALTER TABLE customer1 
ADD country VARCHAR2(50);

-- drop column
alter table customer1
drop column country;

-- error, must be empty column
alter table customer1
MODIFY country NUMBER(31);

CREATE TABLE customer1_bkp AS SELECT * FROM customer1;

SELECT * FROM customer1_bkp;

TRUNCATE TABLE customer1;

SELECT * FROM customer1;

ALTER TABLE customer1
MODIFY country NUMBER(31);

ALTER TABLE customer1 
MODIFY country VARCHAR2(31);

DESC customer1;

INSERT INTO customer1 (SELECT * FROM customer1_bkp);

DROP TABLE customer1_bkp;

SELECT * FROM employees;

-- alias column
select id AS employee_id, full_name, job_title AS job, business_unit AS department
FROM employees;

-- concat column
SELECT id as employee_id, job_title ||' '|| business_unit AS full_job
FROM employees;

-- calculate column
SELECT id, full_name, annual_salary + 1000 AS premium_salary
FROM employees;

-- count
SELECT COUNT(distinct business_unit) FROM employees;
SELECT COUNT(*) FROM employees WHERE id IS NULL;

-- where clause
SELECT * FROM employees WHERE annual_salary > 10000;
SELECT * FROM employees WHERE annual_salary > 50000 AND annual_salary < 60000;
SELECT * FROM employees WHERE annual_salary > 50000 OR annual_salary < 60000;
SELECT * FROM employees WHERE annual_salary BETWEEN 40000 AND 80000;
SELECT * FROM employees WHERE annual_salary NOT BETWEEN 40000 AND 80000;
SELECT * FROM employees WHERE age IN (51, 43, 31);
SELECT * FROM employees WHERE age NOT IN (51, 43, 31);
SELECT * FROM employees WHERE id = 80 OR (id = 70 AND annual_salary > 40000);
SELECT * FROM employees WHERE ROWNUM <= 5;
SELECT ROWNUM, ROWID, e.* FROM employees e;


-- filter data
SELECT * FROM employees ORDER BY full_name;
SELECT * FROM employees ORDER BY full_name DESC;
SELECT * FROM employees ORDER BY 8 desc 6;
SELECT id, full_name, annual_salary 
FROM employees ORDER BY 3;

-- unique values

SELECT DISTINCT business_unit 
FROM employees;

-- SELECT DATE

SELECT id, full_name, hire_date, to_char(hire_date, 'yyyy') AS hire_year FROM employees
SELECT id, full_name, hire_date, to_number(to_char(hire_date, 'yyyy')) AS hire_year FROM employees
SELECT id, full_name, hire_date, to_char(hire_date, 'mon') AS hire_year FROM employees
SELECT id, full_name, hire_date, to_char(hire_date, 'Month') AS hire_year FROM employees
SELECT id, full_name, hire_date, to_char(hire_date, 'dd') AS hire_year FROM employees
SELECT id, full_name, hire_date, to_char(hire_date, 'dd-mm-yyyy') AS hire_year FROM employees
SELECT id, full_name, hire_date, to_char(hire_date, 'dd-mm-yyyy hh24:mi:ss') AS hire_year FROM employees
SELECT * FROM employees WHERE to_char(hire_date, 'yyyy') = '2005';

-- Join statement

SELECT * FROM employees;

SELECT * FROM departments;

SELECT
e.employee_id,
e.first_name,
e.email,
e.department_id,
d.department_name,
d.location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id

SELECT
e.employee_id,
e.email_id,
e.salary,
e.department_id,
d.department_name,
d.location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id(+)

UNION

SELECT
e.employee_id,
e.email_id,
e.salary,
e.department_id,
d.department_name,
d.location_id
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id

-- inner join
SELECT
e.employee_id,
e.email_id,
e.salary,
e.department_id,
d.department_name,
d.location_id
FROM employees e INNER JOIN department d
ON e.department_id = d.department_id;

-- left join
SELECT
e.employee_id,
e.email_id,
e.salary,
e.department_id,
d.department_name,
d.location_id
FROM employees e LEFT JOIN department d
ON e.department_id = d.department_id;

-- right join
SELECT
e.employee_id,
e.email_id,
e.salary,
e.department_id,
d.department_name,
d.location_id
FROM employees e RIGHT JOIN department d
ON e.department_id = d.department_id;

-- full join
SELECT
e.employee_id,
e.email_id,
e.salary,
e.department_id,
d.department_name,
d.location_id
FROM employees e FULL JOIN department d
ON e.department_id = d.department_id;

------------------ AGGREGATE FUNCTIONS ------------------

/*
    min()
    max()
    sum()
    avg()
    count()
*/

SELECT MAX(annual_salary) FROM employees;
SELECT MIN(annual_salary) FROM employees;
SELECT SUM(annual_salary) FROM employees;
SELECT COUNT(annual_salary) FROM employees;
SELECT AVG(annual_salary) FROM employees;

-- We can not select non-aggregate column with aggregate column
select full_name,max(annual_salary) from employees;
-- ORA-00937: not a single-group group function

-- use GROUP BY
select full_name,max(annual_salary) from employees GROUP BY full_name;

-- Having clause is always come with group by group by + having
SELECT business_unit, SUM(annual_salary) FROM employees GROUP BY business_unit HAVING SUM(annual_salary) > 50000;

-- wrong logic
SELECT full_name,max(annual_salary) FROM employees GROUP BY full_name;

SELECT business_unit, SUM(annual_salary)
FROM employees
WHERE business_unit IS NOT NULL
GROUP BY business_unit
HAVING SUM(annual_salary) > 4000000
ORDER BY 1;

/*
    The order of keywords in any oracle SQL statement.

    1.from
    2.where
    3.group by
    4.having
    5.order by
*/

SELECT 
e.department_id, d.department_name, SUM(salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id AND e.department_id IS NOT NULL
GROUP BY e.department_id, d.department_name
HAVING SUM(salary) > 50000 ORDER BY 1;

-- select the department where more than 30 employees are working

SELECT
FROM employees e INNER JOIN department d
ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name
HAVING COUNT(*) > 30;

-- country wise employees count

SELECT
FROM employees e, department d, locations l, countries c
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id
GROUP BY l.country_id, c.country_name;

-- find total number of employees
SELECT COUNT(*) FROM employees;

-- find city wise total number of employees
SELECT city, COUNT(*) FROM employees GROUP BY country;

-- find the total number of employees in each country
SELECT country, COUNT(*) FROM employees GROUP BY country;

-- find total number of employees in India
SELECT COUNT(*) FROM employees WHERE country = 'India';

-- find the cities where more than 3 employees are working in India
SELECT city, COUNT(*) FROM employees WHERE country = 'India' GROUP BY city HAVING COUNT(*) > 3;

-- who is the youngest person
SELECT MAX(dob) FROM employees;
SELECT * FROM employees WHERE dob = (
    SELECT MAX(dob) FROM employees
);

-- who is the oldest person
SELECT MAX(dob) FROM employees;
SELECT * FROM employees WHERE dob = (
    SELECT MIN(dob) FROM employees
);

-- in which skillset, the highest number of employees are working
SELECT skillset, COUNT(*) FROM employees GROUP BY skillset ORDER BY 2 DESC;

-- is there any employee with the same name
SELECT full_name, COUNT(*) FROM employees GROUP BY full_name;
SELECT full_name, COUNT(*) FROM employees GROUP BY full_name HAVING COUNT(*) > 1;

-- is there any employee with the same id
SELECT id, COUNT(*) FROM employees GROUP BY id HAVING COUNT(*) > 1;

----------------- SUB QUERIES ----------------------

-- whose employee job is same name as the job of 'Ellen' and who are earning salary more then 'Ellen'

SELECT * FROM employees 
WHERE job_id = 
    (
        SELECT job_id FROM employees WHERE first_name = 'Ellen'
    )
AND salary > 
    (
        SELECT salary FROM employees WHERE first_name = 'Ellen'
    );

-- display senior employee among all the employees;
SELECT MIN(hire_date) FROM employees;
SELECT * FROM employees
WHERE hire_date = (
    SELECT MIN(hire_date) FROM employees
);

-- second highest salary
SELECT MAX(annual_salary) FROM employees;
SELECT MAX(annual_salary) FROM employees
WHERE annual_salary < (
    SELECT MAX(annual_salary) FROM employees
);

-- second highest salaries employee

SELECT * FROM employees WHERE annual_salary = (
    SELECT MAX(annual_salary) FROM employees WHERE annual_salary < (
        SELECT MAX(annual_salary) FROM employees
    )
);

SELECT SUM(salary) FROM employees WHERE job_id LIKE '%CLERK%';

SELECT job_id, SUM(salary)
FROM employees GROUP BY job_id HAVING SUM(salary) > (
    SELECT SUM(salary) FROM employees WHERE job_id LIKE '%CLERK%'
);

-- multy row subquery

SELECT * FROM employees WHERE annual_salary = (
    SELECT MAX(annual_salary) FROM employees GROUP BY department_id
)

--ORA-01427: single-row subquery returns more than one row

/*
    IN
    NOT IN
    >ANY
    <ANY
    >ALL
    <ALL
*/ 

SELECT * FROM employees WHERE job_id = (
    SELECT job_id FROM employees WHERE first_name = 'James'
);
--ORA-01427: single-row subquery returns more than one row
SELECT * FROM employees WHERE job_id IN (
    SELECT job_id FROM employees WHERE first_name = 'James'
);

SELECT * FROM employees WHERE annual_salary IN (
    SELECT MAX(annual_salary) FROM employees GROUP BY business_unit
) ORDER BY business_unit;

SELECT * FROM employees WHERE department_id > ANY (
    SELECT department_id FROM departments WHERE department_name IN (
        'PURCHASING', 'IT', 'Executive'
    )
) ORDER BY department_id;

SELECT * FROM employees WHERE department_id < ANY (30,60,90) ORDER BY department_id;
SELECT * FROM employees WHERE department_id > ANY (30,60,90) ORDER BY department_id;

-- select the department where no employees are working

SELECT * FROM departments WHERE department_id NOT IN (
    SELECT DISTINCT department_id FROM employees WHERE department_id IS NOT NULL
);

-- CO - RELEATED SUB QUERY
/*
    For every one record it execute the inner query
    
    Find employees having atleast one person reporting under him
    
    non co-related sub query:
*/

SELECT * FROM employees WHERE employee_id IN (
    SELECT manager_id FROM employees GROUP BY manager_id
);

SELECT * FROM employees a WHERE 1 <= (
    SELECT COUNT(*) FROM employees b
    WHERE b.manager_id = a.manager_id
)

/*
    The Oracle EXISTS operator is a Boolean operator that returns either true or false. The EXISTS operator is
    often used with a subquery to test for the existence of rows:
    
    An EXISTS condition tests for existence of rows in a subquery. If at least one row returns, it will evaluate
    as TRUE.
    
    The EXISTS operator returns true if the subquery returns any rows, otherwise, it returns false. In
    addition, the EXISTS operator terminates the processing of the subquery once the subquery returns the
    first row.
    
    The EXISTS subquery is used when we want to display all rows where we have a matching column in both
    tables
    
    The IN clause is faster than EXISTS when the subquery results is very small.
    
    The IN clause can't compare anything with NULL values, but the EXISTS clause can compare everything
    with NULLs
    
    This returns the employees (in the EMP table) that are managers. It checks for their employee number as
    a manager (mgr column) and returns them if they are found at least once.
*/

-- SELECT * FROM table_name WHERE EXISTS(subquery);

SELECT * FROM employees e1
    WHERE EXISTS (
        SELECT NULL FROM employees e2
        WHERE e2.manager_id = e1.employee_id
);

-------------- SET OPERATORS -----------------
CREATE TABLE customer2 (
    cust_id NUMBER(10) NOT NULL,
    cust_name VARCHAR2(50) NOT NULL,
    mobile NUMBER(10) NOT NULL,
    city VARCHAR(50) NOT NULL
);

INSERT INTO customer2 VALUES(100001, 'Arun', 09090909, 'Chennai');
INSERT INTO customer2 VALUES(100002, 'Bala', 82828282, 'Hyd');
INSERT INTO customer2 VALUES(100003, 'Rakesh', 5757575, 'Chennai');
INSERT INTO customer2 VALUES(100001, 'Arun', 41414141, 'Chennai');

commit;

SELECT * FROM customer2;

CREATE TABLE customer3 (
    cust_id NUMBER(10) NOT NULL,
    cust_name VARCHAR2(50) NOT NULL,
    phone NUMBER(10) NOT NULL,
    city VARCHAR(50) NOT NULL
);

INSERT INTO customer3 VALUES(100001, 'Arun', 09090909, 'Chennai');
INSERT INTO customer3 VALUES(100004, 'John', 82828282, 'Hyd');
INSERT INTO customer3 VALUES(100003, 'Rakesh', 5757575, 'Chennai');
INSERT INTO customer3 VALUES(100005, 'Sanjay', 41414141, 'Pune');

commit;

SELECT * FROM customer2;

CREATE TABLE emp_union_1 AS SELECT employee_id, first_name, last_name,email,phone_number,
salary, department_id FROM employees WHERE salary > 12000;

CREATE TABLE emp_union_2 AS SELECT employee_id, first_name, email, phone_number,
salary, department_id FROM employees WHERE salary > 15000;

SELECT * FROM emp_union_1

UNION 

SELECT * FROM emp_union_2;

--ORA-01789: в блоке запроса неверное число столбцов результата
--01789. 00000 -  "query block has incorrect number of result columns"

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_1

UNION

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_2;


SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_1

UNION ALL

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_2;

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_1

INTERSECT

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_2;

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_1

MINUS

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_2;

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_2

MINUS

SELECT employee_id, first_name, email, phone_number, salary, department_id
FROM emp_union_1;

--------- Analytical Functions or Window Functions in Oracle: -------

/*
    1. RANK() -- RANK() over(order by ranking_cloumn asc|desc)
    
    2. DENSE_RANK() -- Dense_RANK() over(order by ranking_cloumn asc|desc)
    
    3. Row_number()
    
    4. Lead()
    
    5. Lag()

*/

SELECT id, first_name, salary, department_id, SUM(salary) OVER(PARTITION BY department_id), SUM(salary) OVER() FROM employees;

-- RANK() OVER(ORDER BY salary DESC)

SELECT id, full_name, annual_salary, business_unit, RANK() OVER(ORDER BY annual_salary DESC) RANK FROM employees;

-- DENSE_RANK()
SELECT id, full_name, annual_salary, business_unit, DENSE_RANK() OVER(ORDER BY annual_salary DESC) RANK FROM employees;

-- ROW_NUMBER()
SELECT id, full_name, annual_salary, business_unit, ROW_NUMBER() OVER(ORDER BY annual_salary DESC) no_ties FROM employees;
SELECT ROWNUM, e.* FROM employees e WHERE ROWNUM <= (SELECT ROUND(COUNT(*)/2) FROM employees)
MINUS
SELECT ROWNUM, e.* FROM employees e WHERE ROWNUM < (SELECT ROUND(COUNT(*)/2) FROM employees);

-- GROUP BY => PARTITION BY
SELECT id, full_name, annual_salary, business_unit, 
RANK() OVER(PARTITION BY business_unit ORDER BY annual_salary DESC) RANK FROM employees;
SELECT id, full_name, annual_salary, business_unit, RANK() OVER(PARTITION BY business_unit ORDER BY annual_salary) RANK FROM employees;

SELECT id, full_name, annual_salary, business_unit, 
DENSE_RANK() OVER(PARTITION BY business_unit ORDER BY annual_salary DESC) RANK FROM employees;
SELECT id, full_name, annual_salary, business_unit, 
DENSE_RANK() OVER(PARTITION BY business_unit ORDER BY annual_salary) RANK FROM employees;

-- least 5 earners
SELECT full_name, annual_salary, business_unit,
RANK FROM (
    SELECT full_name, annual_salary, business_unit, RANK() OVER(ORDER BY annual_salary) RANK FROM employees
) WHERE RANK <= 5;

-- top 5 earners
SELECT full_name, annual_salary, business_unit,
RANK FROM (
    SELECT full_name, annual_salary, business_unit, RANK() OVER(ORDER BY annual_salary DESC) RANK FROM employees
) WHERE RANK <= 5;

-- least 5 employees
SELECT full_name, annual_salary, business_unit,
RANK FROM (
    SELECT full_name, annual_salary, business_unit, DENSE_RANK() OVER(ORDER BY annual_salary DESC) RANK FROM employees
) WHERE RANK <= 5;

-- top 5 employees
SELECT full_name, annual_salary, business_unit,
RANK FROM (
    SELECT full_name, annual_salary, business_unit, DENSE_RANK() OVER(ORDER BY annual_salary) RANK FROM employees
) WHERE RANK <= 5;

-- top 5 earners with department_name
SELECT 
a.first_name,
a.email,
a.phone_number,
a.salary,
a.department_id,
d.department_name,
a.rank
FROM (
    SELECT full_name, annual_salary, department_id, RANK() OVER(ORDER BY annual_salary DESC) "RANK" FROM employees a
    INNER JOIN departments d
    ON a.department_id = d.department_id WHERE a.rank <= 5 ORDER BY a.rank;
)


-- LEAD()
SELECT full_name, annual_salary, hire_date, 
LEAD(hire_date) OVER(ORDER BY hire_date) AS after_hire,
LEAD(full_name) OVER(ORDER BY hire_date) AS after_hire_name FROM employees;

-- LAG()
SELECT full_name, annual_salary, hire_date, 
LAG(hire_date) OVER(ORDER BY hire_date) AS before_hire,
LAG(full_name) OVER(ORDER BY hire_date) AS before_hire_name FROM employees;

------------- VIEW -----------------

CREATE OR REPLACE VIEW emp_salary
AS SELECT id, full_name, annual_salary 
FROM employees 
WHERE annual_salary > 50000 GROUP BY id, full_name, annual_salary
HAVING annual_salary < 100000;

SELECT * FROM emp_salary;

CREATE OR REPLACE VIEW emp_department_name
AS SELECT
e.first_name,
e.salary,
e.email,
e.department_id,
d.department_name
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id;

SELECT * FROM emp_department_name;

CREATE OR REPLACE VIEW top_emp_salary
AS SELECT id, full_name, annual_salary, RANK() OVER(ORDER BY annual_salary DESC) AS rank_sal FROM employees;

SELECT * FROM top_emp_salary;

CREATE OR REPLACE VIEW top_5_salary
AS SELECT id, full_name, annual_salary,
RANK FROM(SELECT id, full_name, annual_salary,
RANK() OVER(ORDER BY annual_salary) rank FROM employees) 
WHERE rank <= 5;

SELECT * FROM top_5_salary;

CREATE OR REPLACE VIEW high_department_salary
AS SELECT e.department_id AS dep_id, d.department_name dep_name, SUM(salary) sum_salary
FROM employees e, departments d
WHERE e.department_id = d.department_id AND e.department_id  IS NOT NULL 
GROUP BY e.department_id, d.department_name
HAVING SUM(salary) > 50000 ORDER BY 1;

SELECT * FROM high_department_salary;

CREATE OR REPLACE VIEW emp_in_department AS 
SELECT 
e.department_id dep_id, d.department_name dep_name, COUNT(*)sum_emp
FROM employees e, departments d
WHERE e.department_id = d.department_id AND e.department_id IS NOT NULL
GROUP BY e.department_id, d.department_name ORDER BY 3 DESC;

---------------- INDEXES --------------------

-- SELECT UNIQUE | NON UNIQUE INDEX <index_name> ON <table_name> (<col_name>, <col_name> ...) TABLESPACE <tablespace_name>;

CREATE INDEX empno_idx ON employees (empno);

-- B-TREE INDEX
SELECT * FROM all_indexes;

SELECT * FROM all_indexes WHERE table_name = 'EMPLOYEES';

CREATE INDEX emp_salary_idx ON employees(annual_salary);

SELECT * FROM ALL_IND_COLUMN;

CREATE BITMAP INDEX <index_name> ON <table_name> (col_name, col_name, ...) PCTFREE <integer> TABLESPACE <tablespace_name>

CREATE BITMAP INDEX emp_gender ON employees(gender);

SELECT * FROM emp_gender WHERE gender='Male';

-------------- REGULAR EXPRESSION ------------------

/*
This function searches a character column for a pattern. Use this function in the WHERE clause of a
query to return rows matching the regular expression you specify.

1) source_string
is a string for which to be searched. Typically, it is a character column of any data type CHAR,
VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.

2) search_pattern
is a literal string that represents the regular expression pattern to be matched.
3) match_parameter
is a literal string that changes the default matching behavior of the REGEXP_LIKE() function.
*/

-- Retrieve all of the names that contain the letter 'm'
SELECT * FROM employees
    WHERE 
        REGEXP_LIKE(full_name, 'm');

-- Match on more than one alternative

SELECT last_name FROM employees 
    WHERE 
        REGEXP_LIKE(last_name, 'Atkins(o|e|a)n');

-- Match on beginning - Return all employees whise last_name starts with 'A'

SELECT last_name FROM employees 
    WHERE 
        REGEXP_LIKE (last_name, '^A(*)');

-- Match on end - return all employees whosee last_name ends with 'on'

SELECT last_name FROM employees 
    WHERE 
        REGEXP_LIKE(last_name, '(*)on$');

----------------- MERGE STATEMENT -------------
CREATE TABLE s_customer
(
cust_id number,
cust_name varchar2(50),
mobile varchar2(50),
address varchar2(50),
email varchar2(50),
dob date
);

INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1000',
'Neena', '515.123.4568', 'Venice', 'NKOCHHAR', TO_DATE('2005-09-21 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1001',
'Lex', '515.123.4569', 'Texas', 'LDEHAAN', TO_DATE('2001-01-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1002',
'Alexander', '590.423.4567', 'New York', 'AHUNOLD', TO_DATE('2006-01-03 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1003',
'Bruce', '590.423.4568', 'Southlake', 'BERNST', TO_DATE('2007-05-21 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1004',
'David', '590.423.4569', 'South San Francisco', 'DAUSTIN', TO_DATE('2005-06-25 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1005',
'Valli', '590.423.4560', 'South Brunswick', 'VPATABAL', TO_DATE('2006-02-05 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1006',
'Diana', '590.423.5567', 'Seattle', 'DLORENTZ', TO_DATE('2007-02-07 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1007',
'Nancy', '515.124.4569', 'Toronto', 'NGREENBE', TO_DATE('2002-08-17 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));

create table t_customer
(
cust_id number primary key,
cust_name varchar2(50),
mobile varchar2(50),
address varchar2(50),
email varchar2(50),
dob date
);

/*
    merge into target
    using source
    on (condition)
    when not matched then
    insert
    when matched then
    update/delete;
*/

MERGE INTO t_customer t USING s_customer s
ON (s.cust_id = t.cust_id)
WHEN NOT MATCHED THEN
INSERT VALUES(s.cust_id, s.cust_name, s.mobile, s.address, s.email, s.dob)
WHEN MATCHED THEN
UPDATE SET t.cust_name = s.cust_name, t.mobile = s.mobile, t.address = s.address, t.email = s.email, t.dob = s.dob; 

SELECT * FROM t_customer;

-- merge with minus query

MERGE INTO t_customer t
USING (
    SELECT * FROM s_customer
    MINUS
    SELECT * FROM t_customer
) s
ON (s.cust_id = t.cust_id)
WHEN NOT MATCHED THEN
INSERT VALUES(s.cust_id,s.cust_name,s.mobile,s.address,s.email,s.dob)
WHEN MATCHED THEN
UPDATE SET t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email,
t.dob=s.dob;

SELECT * FROM s_customer
MINUS
SELECT * FROM t_customer;

-- merge with update and delete
MERGE INTO t_customer t
USING (
    SELECT nvl(s.cust_id, t.cust_id) AS cust_id,
    s.cust_name, s.mobile, s.address, s.email, s.dob FROM t_customer t FULL JOIN
    s_customer s ON s.cust_id = t.cust_id
) s
ON (t.cust_id = s.cust_id)
WHEN MATCHED THEN 
UPDATE SET t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email,
t.dob=s.dob 
DELETE WHERE s.cust_name IS NULL;

MERGE INTO t_customer t
USING (
    SELECT nvl(s.cust_id, t.cust_id) AS cust_id,
    s.cust_name, s.mobile, s.address, s.email, s.dob FROM t_customer t FULL JOIN
    s_customer s ON s.cust_id = t.cust_id
) s
ON (t.cust_id = s.cust_id)
WHEN NOT MATCHED THEN
INSERT VALUES(s.cust_id,s.cust_name,s.mobile,s.address,s.email,s.dob)
WHEN MATCHED THEN 
UPDATE SET t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email,
t.dob=s.dob 
DELETE WHERE s.cust_name IS NULL;

-- Explain plan, cost cpu, optimisation oracle performance
-- LIMIT 
