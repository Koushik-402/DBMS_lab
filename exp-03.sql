-- EXPERIMENT 3: DCL AND TCL COMMANDS
-- MYSQL DATABASE

CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

CREATE TABLE BankAccount (
    Account_ID INT PRIMARY KEY,
    Holder_Name VARCHAR(50) NOT NULL,
    Branch VARCHAR(30) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL CHECK (Balance >= 0),
    Account_Type VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- Insert records
INSERT INTO BankAccount VALUES
(201, 'Anand', 'Chennai', 50000, 'Savings'),
(202, 'Bhavya', 'Hyderabad', 35000, 'Savings'),
(203, 'Charan', 'Vijayawada', 20000, 'Current'),
(204, 'Deepa', 'Chennai', 45000, 'Savings'),
(205, 'Eshan', 'Bengaluru', 60000, 'Current');

SELECT * FROM BankAccount ORDER BY Account_ID;

-- DCL: Create user (administrator required)
CREATE USER 'lab_teller3'@'localhost'
IDENTIFIED BY 'LabDemo_ChangeMe_2026!';

GRANT SELECT ON BankDB.BankAccount
TO 'lab_teller3'@'localhost';

SHOW GRANTS FOR 'lab_teller3'@'localhost';

REVOKE SELECT ON BankDB.BankAccount
FROM 'lab_teller3'@'localhost';

SHOW GRANTS FOR 'lab_teller3'@'localhost';

-- TCL: COMMIT deposit
START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance + 5000
WHERE Account_ID = 201;

COMMIT;

-- TCL: ROLLBACK withdrawal
START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance - 3000
WHERE Account_ID = 202;

ROLLBACK;

-- SAVEPOINT and partial rollback
START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance + 1000
WHERE Account_ID = 203;

SAVEPOINT sp1;

UPDATE BankAccount
SET Balance = Balance + 2000
WHERE Account_ID = 204;

ROLLBACK TO SAVEPOINT sp1;
COMMIT;

-- Transfer 4000 between accounts
START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance - 4000
WHERE Account_ID = 201 AND Balance >= 4000;

UPDATE BankAccount
SET Balance = Balance + 4000
WHERE Account_ID = 202;

COMMIT;

-- Final results
SELECT * FROM BankAccount ORDER BY Account_ID;

SELECT SUM(Balance) AS Total_Balance
FROM BankAccount;

-- Run after permission testing is complete
DROP USER 'lab_teller3'@'localhost';



-- EXPERIMENT 3: DCL AND TCL COMMANDS
-- ORACLE DATABASE

-- Connect to your Oracle schema first.

-- Create table
CREATE TABLE BankAccount (
    Account_ID NUMBER(10) PRIMARY KEY,
    Holder_Name VARCHAR2(50) NOT NULL,
    Branch VARCHAR2(30) NOT NULL,
    Balance NUMBER(12,2) NOT NULL CHECK (Balance >= 0),
    Account_Type VARCHAR2(20) NOT NULL
);

-- Insert records
INSERT INTO BankAccount VALUES
(201, 'Anand', 'Chennai', 50000, 'Savings');

INSERT INTO BankAccount VALUES
(202, 'Bhavya', 'Hyderabad', 35000, 'Savings');

INSERT INTO BankAccount VALUES
(203, 'Charan', 'Vijayawada', 20000, 'Current');

INSERT INTO BankAccount VALUES
(204, 'Deepa', 'Chennai', 45000, 'Savings');

INSERT INTO BankAccount VALUES
(205, 'Eshan', 'Bengaluru', 60000, 'Current');

COMMIT;

SELECT * FROM BankAccount ORDER BY Account_ID;
-- TCL: COMMIT deposit
UPDATE BankAccount
SET Balance = Balance + 5000
WHERE Account_ID = 201;

COMMIT;

-- TCL: ROLLBACK withdrawal
UPDATE BankAccount
SET Balance = Balance - 3000
WHERE Account_ID = 202;

ROLLBACK;

-- SAVEPOINT and partial rollback
UPDATE BankAccount
SET Balance = Balance + 1000
WHERE Account_ID = 203;

SAVEPOINT sp1;

UPDATE BankAccount
SET Balance = Balance + 2000
WHERE Account_ID = 204;

ROLLBACK TO sp1;
COMMIT;

-- Transfer 4000 between accounts
SAVEPOINT before_transfer;

UPDATE BankAccount
SET Balance = Balance - 4000
WHERE Account_ID = 201
AND Balance >= 4000;

UPDATE BankAccount
SET Balance = Balance + 4000
WHERE Account_ID = 202;

COMMIT;

-- Final results
SELECT * FROM BankAccount ORDER BY Account_ID;

SELECT SUM(Balance) AS Total_Balance
FROM BankAccount;

-- Run separately as an authorized administrator
-- after disconnecting the test user.
-- DROP USER lab_teller3;
