/* -- Objective: determine the number of retiring employees per title, 
        and identify employees who are eligible to participate in a mentorship program. 
        Then, you’ll write a report that summarizes your analysis and helps prepare Bobby’s 
        manager for the “silver tsunami” as many current employees reach retirement age.*/

/* Deliverables
        Deliverable 1: The Number of Retiring Employees by Title (21 prts)
        Deliverable 2: The Employees Eligible for the Mentorship Program (11 prts)
        Deliverable 3: A written report on the employee database analysis (README.md) */

-- ________________________________________PRE-WORK______________________________________________

-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR (40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	-- FOREIGN KEY (from_date) REFERENCES titles (from_date),
	-- FOREIGN KEY (to_date) REFERENCES dept_manager (to_date),
	PRIMARY KEY (emp_no, dept_no)
);

-- Import tables

-- ______________________________________________________________________________________

-- Deliverable #1: The Number of Retiring Employees by Title
    /* Create a Retirement Titles table that holds all the titles of current employees who were born between 
    January 1, 1952 and December 31, 1955. Because some employees may have multiple titles in the database—for 
    example, due to promotions—you’ll need to use the DISTINCT ON statement to create a table that contains the 
    most recent title of each employee. Then, use the COUNT() function to create a final table that has the number 
    of retirement-age employees by most recent job title. */

-- 1. Retrieve the emp_no, first_name, and last_name columns from the Employees table.
SELECT emp_no, first_name, last_name FROM employees;


-- 2. Retrieve the title, from_date, and to_date columns from the Titles table.
SELECT title, from_date, to_date FROM titles;


-- 3. & 4. Create a new table using the INTO clause and join employees and titles.
-- 		Link for How To reference: https://www.w3schools.com/sql/sql_select_into.asp
-- 		Decision: Added birth_date for filtering in later steps
SELECT employees.emp_no, employees.first_name, employees.last_name, employees.birth_date,
		titles.title, titles.from_date, titles.to_date
INTO retirement_titles
FROM employees
RIGHT JOIN titles ON employees.emp_no = titles.emp_no;


-- 5. Filter the data on the birth_date column to retrieve the employees who were born between 1952 and 1955. Then, order by the employee number.
-- How to Guide for FILTER WHERE link: https://kb.objectrocket.com/postgresql/how-to-use-the-filter-clause-in-postgresql-881

SELECT *
FROM retirement_titles
FILTER WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- 6. Export the Retirement Titles table from the previous step as retirement_titles.csv and save it to your Data folder in the Pewlett-Hackard-Analysis folder.
-- Response: Right click on table and export from there into desired folder location. Done.

-- 7. Before you export your table, confirm that it looks like the image
-- Response: Done.

-- 8. Copy the query from the Employee_Challenge_starter_code.sql and add it to your Employee_Database_challenge.sql file.
-- Use Dictinct with Orderby to remove duplicate rows
/*SELECT DISTINCT ON (______) _____,
______,
______,
______

INTO nameyourtable
FROM _______
ORDER BY _____, _____ DESC;
*/

--9. Retrieve the employee number, first and last name, and title columns from the Retirement Titles table.
SELECT emp_no, first_name, last_name, title
FROM retirement_titles
FILTER WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');

-- 10. Use the DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of 
-- rows defined by the ON () clause.
SELECT DISTINCT ON (emp_no) 
emp_no,
first_name,
last_name,
title,
from_date,
to_date
FROM retirement_titles
FILTER WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC, to_date DESC;

-- 11. Create a Unique Titles table using the INTO clause.
-- Link to How To Guide on DISTINCT ON(): https://www.postgresql.org/docs/9.5/sql-select.html
SELECT DISTINCT ON (emp_no) 
emp_no,
first_name,
last_name,
title,
to_date
INTO unique_titles
FROM retirement_titles
FILTER WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC, to_date DESC;

-- SELECT * FROM unique_titles;
-- DROP TABLE unique_titles;

/* 12. Sort the Unique Titles table in ascending order by the employee number and descending order by the last date 
(i.e. to_date) of the most recent title. */

DROP TABLE unique_titles;

SELECT DISTINCT ON (emp_no) 
emp_no,
first_name,
last_name,
title
--to_date
INTO unique_titles
FROM retirement_titles
FILTER WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC, to_date DESC;

SELECT * FROM unique_titles;
-- DROP TABLE unique_titles;

/* 13. Export the Unique Titles table as unique_titles.csv and save it to your Data folder in the 
Pewlett-Hackard-Analysis folder.*/

-- Export table

/* 14. Before you export your table, double check the output.*/
-- Response: Done. 

/* 15. Write another query in the Employee_Database_challenge.sql file to retrieve the number of employees by 
their most recent job title who are about to retire.*/

/* 16. Retrieve the number of employees by their most recent job title 
citing: https://www.w3resource.com/sql/aggregate-functions/count-with-group-by.php */
SELECT title, COUNT (*)
FROM unique_titles
GROUP BY title
ORDER BY COUNT (*) DESC;

/* 17. Then, create a Retiring Titles table to hold the required information. */
SELECT title, COUNT (*)
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT (*) DESC;

-- SELECT * FROM retiring_titles;

/* 18.Group the table by title, then sort the count column in descending order. */
SELECT title, COUNT (*)
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT (*) DESC;


/* 19. Export the Retiring Titles table as retiring_titles.csv and save it to your Data folder in the Pewlett-Hackard-Analysis folder. */
/* 20. Double check table. */
 
 -- Done.
 
 /* 21. Save your Employee_Database_challenge.sql file in your Queries folder in the Pewlett-Hackard folder. */
 
 -- Done.


-- ______________________________________________________________________________________
/* Deliverable 2
The Employees Eligible for the Mentorship Program 




-- ______________________________________________________________________________________
/* Deliverable 3
The analysis should contain the following:

Overview of the analysis: 
    Explain the purpose of this analysis.


Results: 
    Provide a bulleted list with four major points from the two analysis deliverables. Use images as support where needed.


Summary: 
    Provide high-level responses to the following questions, then provide two additional 
    queries or tables that may provide more insight into the upcoming "silver tsunami."
        1. How many roles will need to be filled as the "silver tsunami" begins to make 
            an impact?
        2. Are there enough qualified, retirement-ready employees in the departments to 
        mentor the next generation of Pewlett Hackard employees?
 */