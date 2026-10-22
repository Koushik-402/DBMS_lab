-- EXPERIMENT 09: JOINS AND SUBQUERIES
-- Case Study: IT Company Project Management System
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- 1. Create Departments table
CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(40) NOT NULL UNIQUE
);

-- 2. Create Employees table
CREATE TABLE Employees (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(40) NOT NULL,
    Dept_ID INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

-- 3. Create Projects table
CREATE TABLE Projects (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(60) NOT NULL,
    Dept_ID INT NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

-- 4. Create Assignments table
CREATE TABLE Assignments (
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Hours INT NOT NULL,
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID),
    FOREIGN KEY (Project_ID) REFERENCES Projects(Project_ID)
);

-- 5. Insert departments
INSERT INTO Departments VALUES
(10, 'Development'),
(20, 'Testing'),
(30, 'HR'),
(40, 'Research');

-- 6. Insert employees
INSERT INTO Employees VALUES
(101, 'Arun', 10, 60000),
(102, 'Priya', 10, 75000),
(103, 'Ravi', 20, 50000),
(104, 'Sneha', 20, 55000),
(105, 'Kiran', 30, 45000),
(106, 'Divya', 40, 90000),
(107, 'Rahul', 10, 65000);

-- 7. Insert projects
INSERT INTO Projects VALUES
(201, 'Web Portal', 10, 300000),
(202, 'Mobile App', 10, 450000),
(203, 'QA Automation', 20, 200000),
(204, 'AI Prototype', 40, 600000),
(205, 'Recruitment Portal', 30, 120000);

-- 8. Insert assignments
INSERT INTO Assignments VALUES
(101, 201, 30),
(102, 201, 25),
(102, 202, 35),
(103, 203, 40),
(104, 203, 20),
(106, 204, 45),
(107, 202, 30);

-- =========================================
-- QUERY 1: INNER JOIN
-- Employees and department names
-- =========================================

SELECT e.Emp_Name, d.Dept_Name
FROM Employees e
INNER JOIN Departments d
    ON e.Dept_ID = d.Dept_ID
ORDER BY e.Emp_ID;

-- =========================================
-- QUERY 2: JOIN THREE TABLES
-- Employee project assignments
-- =========================================

SELECT e.Emp_Name, p.Project_Name, a.Hours
FROM Assignments a
JOIN Employees e
    ON a.Emp_ID = e.Emp_ID
JOIN Projects p
    ON a.Project_ID = p.Project_ID
ORDER BY a.Emp_ID, a.Project_ID;

-- =========================================
-- QUERY 3: LEFT JOIN
-- All employees, including unassigned
-- =========================================

SELECT e.Emp_Name, p.Project_Name
FROM Employees e
LEFT JOIN Assignments a
    ON e.Emp_ID = a.Emp_ID
LEFT JOIN Projects p
    ON a.Project_ID = p.Project_ID
ORDER BY e.Emp_ID, p.Project_ID;

-- =========================================
-- QUERY 4: RIGHT JOIN
-- All projects, including unassigned
-- =========================================

SELECT p.Project_Name, e.Emp_Name
FROM Assignments a
RIGHT JOIN Projects p
    ON a.Project_ID = p.Project_ID
LEFT JOIN Employees e
    ON a.Emp_ID = e.Emp_ID
ORDER BY p.Project_ID, e.Emp_ID;

-- =========================================
-- QUERY 5: CROSS JOIN
-- HR and all projects
-- =========================================

SELECT d.Dept_Name, p.Project_Name
FROM Departments d
CROSS JOIN Projects p
WHERE d.Dept_ID = 30
ORDER BY p.Project_ID;

-- =========================================
-- QUERY 6: SELF JOIN
-- Employees in the same department
-- =========================================

SELECT a.Emp_Name AS Employee1,
       b.Emp_Name AS Employee2
FROM Employees a
JOIN Employees b
    ON a.Dept_ID = b.Dept_ID
   AND a.Emp_ID < b.Emp_ID
ORDER BY a.Emp_ID, b.Emp_ID;

-- =========================================
-- QUERY 7: SCALAR SUBQUERY
-- Salary above company average
-- =========================================

SELECT Emp_Name, Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
)
ORDER BY Salary DESC;

-- =========================================
-- QUERY 8: IN SUBQUERY
-- Employees in departments with projects
-- budgeted at 400000 or more
-- =========================================

SELECT Emp_Name, Dept_ID
FROM Employees
WHERE Dept_ID IN (
    SELECT Dept_ID
    FROM Projects
    WHERE Budget >= 400000
)
ORDER BY Emp_ID;

-- =========================================
-- QUERY 9: EXISTS
-- Employees assigned to projects
-- =========================================

SELECT e.Emp_Name
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- =========================================
-- QUERY 10: NOT EXISTS
-- Employees without assignments
-- =========================================

SELECT e.Emp_Name
FROM Employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Emp_ID = e.Emp_ID
);

-- =========================================
-- QUERY 11: CORRELATED SUBQUERY
-- Employees earning above department average
-- =========================================

SELECT e.Emp_Name, e.Dept_ID, e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(x.Salary)
    FROM Employees x
    WHERE x.Dept_ID = e.Dept_ID
)
ORDER BY e.Emp_ID;

-- =========================================
-- QUERY 12: MAX SUBQUERY
-- Highest-paid employee
-- =========================================

SELECT Emp_Name, Salary
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
);

-- =========================================
-- QUERY 13: JOIN AND GROUP BY
-- Number of employees assigned per project
-- =========================================

SELECT p.Project_Name,
       COUNT(a.Emp_ID) AS Staff
FROM Projects p
LEFT JOIN Assignments a
    ON p.Project_ID = a.Project_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY p.Project_ID;

-- =========================================
-- QUERY 14: Projects without staff
-- =========================================

SELECT p.Project_Name
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Project_ID = p.Project_ID
);

-- =========================================
-- VERIFICATION
-- =========================================

SELECT
    (SELECT COUNT(*) FROM Departments) AS Departments,
    (SELECT COUNT(*) FROM Employees) AS Employees,
    (SELECT COUNT(*) FROM Projects) AS Projects,
    (SELECT COUNT(*) FROM Assignments) AS Assignments;

-- =========================================
-- STUDENT PRACTICE EXERCISES
-- =========================================

-- 1. Employees with department and salary
SELECT e.Emp_Name, d.Dept_Name, e.Salary
FROM Employees e
JOIN Departments d ON e.Dept_ID = d.Dept_ID;

-- 2. All projects with department names
SELECT p.Project_Name, d.Dept_Name
FROM Projects p
JOIN Departments d ON p.Dept_ID = d.Dept_ID;

-- 3. Employees assigned to Mobile App
SELECT e.Emp_Name
FROM Employees e
JOIN Assignments a ON e.Emp_ID = a.Emp_ID
JOIN Projects p ON a.Project_ID = p.Project_ID
WHERE p.Project_Name = 'Mobile App';

-- 4. Employees without assignments using LEFT JOIN
SELECT e.Emp_Name
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
WHERE a.Emp_ID IS NULL;

-- 5. Projects without employees using NOT EXISTS
SELECT p.Project_Name
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Project_ID = p.Project_ID
);

-- 6. Employees earning less than company average
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary < (SELECT AVG(Salary) FROM Employees);

-- 7. Employees earning more than Arun
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary > (
    SELECT Salary
    FROM Employees
    WHERE Emp_Name = 'Arun'
);

-- 8. Projects with budget above average
SELECT Project_Name, Budget
FROM Projects
WHERE Budget > (SELECT AVG(Budget) FROM Projects);

-- 9. Project count per employee, including zero
SELECT e.Emp_Name,
       COUNT(a.Project_ID) AS Project_Count
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
GROUP BY e.Emp_ID, e.Emp_Name
ORDER BY e.Emp_ID;

-- 10. Employees assigned to more than one project
SELECT e.Emp_Name,
       COUNT(a.Project_ID) AS Project_Count
FROM Employees e
JOIN Assignments a ON e.Emp_ID = a.Emp_ID
GROUP BY e.Emp_ID, e.Emp_Name
HAVING COUNT(a.Project_ID) > 1;


-- EXPERIMENT 09: JOINS AND SUBQUERIES
-- Case Study: IT Company Project Management System
-- Oracle Database

-- 1. Create Departments table
CREATE TABLE Departments (
    Dept_ID NUMBER PRIMARY KEY,
    Dept_Name VARCHAR2(40) NOT NULL UNIQUE
);

-- 2. Create Employees table
CREATE TABLE Employees (
    Emp_ID NUMBER PRIMARY KEY,
    Emp_Name VARCHAR2(40) NOT NULL,
    Dept_ID NUMBER NOT NULL,
    Salary NUMBER(10,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

-- 3. Create Projects table
CREATE TABLE Projects (
    Project_ID NUMBER PRIMARY KEY,
    Project_Name VARCHAR2(60) NOT NULL,
    Dept_ID NUMBER NOT NULL,
    Budget NUMBER(12,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

-- 4. Create Assignments table
CREATE TABLE Assignments (
    Emp_ID NUMBER NOT NULL,
    Project_ID NUMBER NOT NULL,
    Hours NUMBER NOT NULL,
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID),
    FOREIGN KEY (Project_ID) REFERENCES Projects(Project_ID)
);

-- 5. Insert departments
INSERT ALL
    INTO Departments VALUES (10, 'Development')
    INTO Departments VALUES (20, 'Testing')
    INTO Departments VALUES (30, 'HR')
    INTO Departments VALUES (40, 'Research')
SELECT 1 FROM DUAL;

-- 6. Insert employees
INSERT ALL
    INTO Employees VALUES (101, 'Arun', 10, 60000)
    INTO Employees VALUES (102, 'Priya', 10, 75000)
    INTO Employees VALUES (103, 'Ravi', 20, 50000)
    INTO Employees VALUES (104, 'Sneha', 20, 55000)
    INTO Employees VALUES (105, 'Kiran', 30, 45000)
    INTO Employees VALUES (106, 'Divya', 40, 90000)
    INTO Employees VALUES (107, 'Rahul', 10, 65000)
SELECT 1 FROM DUAL;

-- 7. Insert projects
INSERT ALL
    INTO Projects VALUES (201, 'Web Portal', 10, 300000)
    INTO Projects VALUES (202, 'Mobile App', 10, 450000)
    INTO Projects VALUES (203, 'QA Automation', 20, 200000)
    INTO Projects VALUES (204, 'AI Prototype', 40, 600000)
    INTO Projects VALUES (205, 'Recruitment Portal', 30, 120000)
SELECT 1 FROM DUAL;

-- 8. Insert assignments
INSERT ALL
    INTO Assignments VALUES (101, 201, 30)
    INTO Assignments VALUES (102, 201, 25)
    INTO Assignments VALUES (102, 202, 35)
    INTO Assignments VALUES (103, 203, 40)
    INTO Assignments VALUES (104, 203, 20)
    INTO Assignments VALUES (106, 204, 45)
    INTO Assignments VALUES (107, 202, 30)
SELECT 1 FROM DUAL;

COMMIT;

-- QUERY 1: INNER JOIN
SELECT e.Emp_Name, d.Dept_Name
FROM Employees e
INNER JOIN Departments d
    ON e.Dept_ID = d.Dept_ID
ORDER BY e.Emp_ID;

-- QUERY 2: JOIN THREE TABLES
SELECT e.Emp_Name, p.Project_Name, a.Hours
FROM Assignments a
JOIN Employees e ON a.Emp_ID = e.Emp_ID
JOIN Projects p ON a.Project_ID = p.Project_ID
ORDER BY a.Emp_ID, a.Project_ID;

-- QUERY 3: LEFT JOIN
SELECT e.Emp_Name, p.Project_Name
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
LEFT JOIN Projects p ON a.Project_ID = p.Project_ID
ORDER BY e.Emp_ID, p.Project_ID;

-- QUERY 4: RIGHT JOIN
SELECT p.Project_Name, e.Emp_Name
FROM Assignments a
RIGHT JOIN Projects p ON a.Project_ID = p.Project_ID
LEFT JOIN Employees e ON a.Emp_ID = e.Emp_ID
ORDER BY p.Project_ID, e.Emp_ID;

-- QUERY 5: CROSS JOIN
SELECT d.Dept_Name, p.Project_Name
FROM Departments d
CROSS JOIN Projects p
WHERE d.Dept_ID = 30
ORDER BY p.Project_ID;

-- QUERY 6: SELF JOIN
SELECT a.Emp_Name AS Employee1,
       b.Emp_Name AS Employee2
FROM Employees a
JOIN Employees b
    ON a.Dept_ID = b.Dept_ID
   AND a.Emp_ID < b.Emp_ID
ORDER BY a.Emp_ID, b.Emp_ID;

-- QUERY 7: SALARY ABOVE COMPANY AVERAGE
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY Salary DESC;

-- QUERY 8: IN SUBQUERY
SELECT Emp_Name, Dept_ID
FROM Employees
WHERE Dept_ID IN (
    SELECT Dept_ID FROM Projects WHERE Budget >= 400000
)
ORDER BY Emp_ID;

-- QUERY 9: EXISTS
SELECT e.Emp_Name
FROM Employees e
WHERE EXISTS (
    SELECT 1 FROM Assignments a WHERE a.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- QUERY 10: NOT EXISTS
SELECT e.Emp_Name
FROM Employees e
WHERE NOT EXISTS (
    SELECT 1 FROM Assignments a WHERE a.Emp_ID = e.Emp_ID
);

-- QUERY 11: CORRELATED SUBQUERY
SELECT e.Emp_Name, e.Dept_ID, e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(x.Salary)
    FROM Employees x
    WHERE x.Dept_ID = e.Dept_ID
)
ORDER BY e.Emp_ID;

-- QUERY 12: HIGHEST-PAID EMPLOYEE
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);

-- QUERY 13: PROJECT STAFFING
SELECT p.Project_Name,
       COUNT(a.Emp_ID) AS Staff
FROM Projects p
LEFT JOIN Assignments a ON p.Project_ID = a.Project_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY p.Project_ID;

-- QUERY 14: PROJECTS WITHOUT STAFF
SELECT p.Project_Name
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1 FROM Assignments a WHERE a.Project_ID = p.Project_ID
);

-- VERIFICATION
SELECT
    (SELECT COUNT(*) FROM Departments) AS Departments,
    (SELECT COUNT(*) FROM Employees) AS Employees,
    (SELECT COUNT(*) FROM Projects) AS Projects,
    (SELECT COUNT(*) FROM Assignments) AS Assignments;

-- PRACTICE EXERCISES

-- 1. Employees with department and salary
SELECT e.Emp_Name, d.Dept_Name, e.Salary
FROM Employees e
JOIN Departments d ON e.Dept_ID = d.Dept_ID;

-- 2. Projects with department names
SELECT p.Project_Name, d.Dept_Name
FROM Projects p
JOIN Departments d ON p.Dept_ID = d.Dept_ID;

-- 3. Employees assigned to Mobile App
SELECT e.Emp_Name
FROM Employees e
JOIN Assignments a ON e.Emp_ID = a.Emp_ID
JOIN Projects p ON a.Project_ID = p.Project_ID
WHERE p.Project_Name = 'Mobile App';

-- 4. Employees without assignments using LEFT JOIN
SELECT e.Emp_Name
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
WHERE a.Emp_ID IS NULL;

-- 5. Projects without employees
SELECT p.Project_Name
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1 FROM Assignments a WHERE a.Project_ID = p.Project_ID
);

-- 6. Employees earning below company average
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary < (SELECT AVG(Salary) FROM Employees);

-- 7. Employees earning more than Arun
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary > (
    SELECT Salary FROM Employees WHERE Emp_Name = 'Arun'
);

-- 8. Projects with budget above average
SELECT Project_Name, Budget
FROM Projects
WHERE Budget > (SELECT AVG(Budget) FROM Projects);

-- 9. Project count per employee, including zero
SELECT e.Emp_Name,
       COUNT(a.Project_ID) AS Project_Count
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
GROUP BY e.Emp_ID, e.Emp_Name
ORDER BY e.Emp_ID;

-- 10. Employees assigned to more than one project
SELECT e.Emp_Name,
       COUNT(a.Project_ID) AS Project_Count
FROM Employees e
JOIN Assignments a ON e.Emp_ID = a.Emp_ID
GROUP BY e.Emp_ID, e.Emp_Name
HAVING COUNT(a.Project_ID) > 1;

COMMIT;
