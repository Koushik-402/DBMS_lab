-- EXPERIMENT 08: NORMALIZATION USING DEPENDENCIES
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS NormalizationLabDB;
USE NormalizationLabDB;

-- =========================================
-- STEP 1: UNNORMALIZED FORM (UNF)
-- =========================================

CREATE TABLE EnrollmentRaw (
    StudentID INT,
    StudentName VARCHAR(40),
    CourseList VARCHAR(100)
);

INSERT INTO EnrollmentRaw VALUES
(1, 'Anu', 'C101,C102'),
(2, 'Bala', 'C101'),
(3, 'Chitra', 'C102');

SELECT * FROM EnrollmentRaw ORDER BY StudentID;

-- =========================================
-- STEP 2: FIRST NORMAL FORM (1NF)
-- =========================================

CREATE TABLE Enrollment1NF (
    StudentID INT,
    StudentName VARCHAR(40),
    CourseID VARCHAR(8),
    CourseName VARCHAR(40),
    InstructorID VARCHAR(8),
    InstructorName VARCHAR(40),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID)
);

INSERT INTO Enrollment1NF VALUES
(1, 'Anu', 'C101', 'DBMS', 'I10', 'Rao', 'A'),
(1, 'Anu', 'C102', 'Networks', 'I20', 'Sen', 'B'),
(2, 'Bala', 'C101', 'DBMS', 'I10', 'Rao', 'B'),
(3, 'Chitra', 'C102', 'Networks', 'I20', 'Sen', 'A');

SELECT StudentID, CourseID, Grade
FROM Enrollment1NF
ORDER BY StudentID, CourseID;

-- =========================================
-- STEP 3: SECOND NORMAL FORM (2NF)
-- =========================================

CREATE TABLE Students2NF (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(40) NOT NULL
);

CREATE TABLE Courses2NF (
    CourseID VARCHAR(8) PRIMARY KEY,
    CourseName VARCHAR(40),
    InstructorID VARCHAR(8),
    InstructorName VARCHAR(40)
);

CREATE TABLE Registrations2NF (
    StudentID INT,
    CourseID VARCHAR(8),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students2NF(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses2NF(CourseID)
);

INSERT INTO Students2NF VALUES
(1, 'Anu'),
(2, 'Bala'),
(3, 'Chitra');

INSERT INTO Courses2NF VALUES
('C101', 'DBMS', 'I10', 'Rao'),
('C102', 'Networks', 'I20', 'Sen');

INSERT INTO Registrations2NF VALUES
(1, 'C101', 'A'),
(1, 'C102', 'B'),
(2, 'C101', 'B'),
(3, 'C102', 'A');

SELECT * FROM Students2NF;
SELECT * FROM Courses2NF;
SELECT * FROM Registrations2NF;

-- =========================================
-- STEP 4: THIRD NORMAL FORM (3NF)
-- =========================================

CREATE TABLE Instructors3NF (
    InstructorID VARCHAR(8) PRIMARY KEY,
    InstructorName VARCHAR(40) NOT NULL
);

CREATE TABLE Courses3NF (
    CourseID VARCHAR(8) PRIMARY KEY,
    CourseName VARCHAR(40) NOT NULL,
    InstructorID VARCHAR(8) NOT NULL,
    FOREIGN KEY (InstructorID)
        REFERENCES Instructors3NF(InstructorID)
);

INSERT INTO Instructors3NF VALUES
('I10', 'Rao'),
('I20', 'Sen');

INSERT INTO Courses3NF VALUES
('C101', 'DBMS', 'I10'),
('C102', 'Networks', 'I20');

-- Display normalized student registration details
SELECT r.StudentID,
       s.StudentName,
       c.CourseName,
       i.InstructorName,
       r.Grade
FROM Registrations2NF r
JOIN Students2NF s
    ON s.StudentID = r.StudentID
JOIN Courses3NF c
    ON c.CourseID = r.CourseID
JOIN Instructors3NF i
    ON i.InstructorID = c.InstructorID
ORDER BY r.StudentID, c.CourseID;

-- =========================================
-- STEP 5: FOURTH NORMAL FORM (4NF)
-- =========================================

CREATE TABLE StudentInterestRaw (
    StudentID INT,
    Hobby VARCHAR(30),
    Language VARCHAR(30),
    PRIMARY KEY (StudentID, Hobby, Language)
);

INSERT INTO StudentInterestRaw VALUES
(1, 'Chess', 'English'),
(1, 'Chess', 'Tamil'),
(1, 'Music', 'English'),
(1, 'Music', 'Tamil');

SELECT *
FROM StudentInterestRaw
ORDER BY Hobby, Language;

-- Decompose into independent hobby and language relations
CREATE TABLE StudentHobby4NF (
    StudentID INT,
    Hobby VARCHAR(30),
    PRIMARY KEY (StudentID, Hobby)
);

CREATE TABLE StudentLanguage4NF (
    StudentID INT,
    Language VARCHAR(30),
    PRIMARY KEY (StudentID, Language)
);

INSERT INTO StudentHobby4NF VALUES
(1, 'Chess'),
(1, 'Music');

INSERT INTO StudentLanguage4NF VALUES
(1, 'English'),
(1, 'Tamil');

-- Reconstruct original combinations
SELECT h.StudentID, h.Hobby, l.Language
FROM StudentHobby4NF h
JOIN StudentLanguage4NF l
    ON h.StudentID = l.StudentID
ORDER BY h.Hobby, l.Language;

-- =========================================
-- STEP 6: FIFTH NORMAL FORM (5NF)
-- =========================================

CREATE TABLE SupplyRaw (
    SupplierID VARCHAR(8),
    PartID VARCHAR(8),
    ProjectID VARCHAR(8),
    PRIMARY KEY (SupplierID, PartID, ProjectID)
);

INSERT INTO SupplyRaw VALUES
('S1', 'P1', 'J1'),
('S1', 'P2', 'J1'),
('S2', 'P1', 'J1');

-- Create three binary projections
CREATE TABLE SupplierPart5NF AS
SELECT DISTINCT SupplierID, PartID
FROM SupplyRaw;

CREATE TABLE SupplierProject5NF AS
SELECT DISTINCT SupplierID, ProjectID
FROM SupplyRaw;

CREATE TABLE PartProject5NF AS
SELECT DISTINCT PartID, ProjectID
FROM SupplyRaw;

ALTER TABLE SupplierPart5NF
ADD PRIMARY KEY (SupplierID, PartID);

ALTER TABLE SupplierProject5NF
ADD PRIMARY KEY (SupplierID, ProjectID);

ALTER TABLE PartProject5NF
ADD PRIMARY KEY (PartID, ProjectID);

-- Reconstruct ternary relation
SELECT sp.SupplierID, sp.PartID, sj.ProjectID
FROM SupplierPart5NF sp
JOIN SupplierProject5NF sj
    ON sj.SupplierID = sp.SupplierID
JOIN PartProject5NF pj
    ON pj.PartID = sp.PartID
   AND pj.ProjectID = sj.ProjectID
ORDER BY sp.SupplierID, sp.PartID, sj.ProjectID;

-- =========================================
-- STEP 7: VERIFY LOSSLESS RECONSTRUCTION
-- =========================================

SELECT COUNT(*) AS OriginalRows
FROM SupplyRaw;

SELECT COUNT(*) AS ReconstructedRows
FROM (
    SELECT sp.SupplierID, sp.PartID, sj.ProjectID
    FROM SupplierPart5NF sp
    JOIN SupplierProject5NF sj
        ON sj.SupplierID = sp.SupplierID
    JOIN PartProject5NF pj
        ON pj.PartID = sp.PartID
       AND pj.ProjectID = sj.ProjectID
) AS Reconstructed;

-- Compare original and reconstructed relations in both directions
WITH Reconstructed AS (
    SELECT sp.SupplierID, sp.PartID, sj.ProjectID
    FROM SupplierPart5NF sp
    JOIN SupplierProject5NF sj
        ON sj.SupplierID = sp.SupplierID
    JOIN PartProject5NF pj
        ON pj.PartID = sp.PartID
       AND pj.ProjectID = sj.ProjectID
)
SELECT 'Original only' AS DifferenceType,
       o.SupplierID, o.PartID, o.ProjectID
FROM SupplyRaw o
LEFT JOIN Reconstructed r
    ON r.SupplierID = o.SupplierID
   AND r.PartID = o.PartID
   AND r.ProjectID = o.ProjectID
WHERE r.SupplierID IS NULL

UNION ALL

SELECT 'Reconstructed only' AS DifferenceType,
       r.SupplierID, r.PartID, r.ProjectID
FROM Reconstructed r
LEFT JOIN SupplyRaw o
    ON r.SupplierID = o.SupplierID
   AND r.PartID = o.PartID
   AND r.ProjectID = o.ProjectID
WHERE o.SupplierID IS NULL;

-- =========================================
-- FINAL VERIFICATION
-- =========================================

SELECT COUNT(*) AS Enrollment1NF_Rows
FROM Enrollment1NF;

SELECT COUNT(*) AS StudentCount
FROM Students2NF;

SELECT COUNT(*) AS CourseCount
FROM Courses2NF;

SELECT COUNT(*) AS RegistrationCount
FROM Registrations2NF;

SELECT COUNT(*) AS InstructorCount
FROM Instructors3NF;

SELECT COUNT(*) AS CourseCount3NF
FROM Courses3NF;

SELECT COUNT(*) AS InterestRawRows
FROM StudentInterestRaw;

SELECT COUNT(*) AS HobbyCount
FROM StudentHobby4NF;

SELECT COUNT(*) AS LanguageCount
FROM StudentLanguage4NF;

SELECT COUNT(*) AS SupplyRows
FROM SupplyRaw;


-- EXPERIMENT 08: NORMALIZATION USING DEPENDENCIES
-- Oracle Database
-- Connect to your Oracle schema before running.

-- =========================================
-- STEP 1: UNNORMALIZED FORM (UNF)
-- =========================================

CREATE TABLE EnrollmentRaw (
    StudentID NUMBER,
    StudentName VARCHAR2(40),
    CourseList VARCHAR2(100)
);

INSERT ALL
    INTO EnrollmentRaw VALUES (1, 'Anu', 'C101,C102')
    INTO EnrollmentRaw VALUES (2, 'Bala', 'C101')
    INTO EnrollmentRaw VALUES (3, 'Chitra', 'C102')
SELECT 1 FROM DUAL;

-- =========================================
-- STEP 2: FIRST NORMAL FORM (1NF)
-- =========================================

CREATE TABLE Enrollment1NF (
    StudentID NUMBER,
    StudentName VARCHAR2(40),
    CourseID VARCHAR2(8),
    CourseName VARCHAR2(40),
    InstructorID VARCHAR2(8),
    InstructorName VARCHAR2(40),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID)
);

INSERT ALL
    INTO Enrollment1NF VALUES (1, 'Anu', 'C101', 'DBMS', 'I10', 'Rao', 'A')
    INTO Enrollment1NF VALUES (1, 'Anu', 'C102', 'Networks', 'I20', 'Sen', 'B')
    INTO Enrollment1NF VALUES (2, 'Bala', 'C101', 'DBMS', 'I10', 'Rao', 'B')
    INTO Enrollment1NF VALUES (3, 'Chitra', 'C102', 'Networks', 'I20', 'Sen', 'A')
SELECT 1 FROM DUAL;

-- =========================================
-- STEP 3: SECOND NORMAL FORM (2NF)
-- =========================================

CREATE TABLE Students2NF (
    StudentID NUMBER PRIMARY KEY,
    StudentName VARCHAR2(40) NOT NULL
);

CREATE TABLE Courses2NF (
    CourseID VARCHAR2(8) PRIMARY KEY,
    CourseName VARCHAR2(40),
    InstructorID VARCHAR2(8),
    InstructorName VARCHAR2(40)
);

CREATE TABLE Registrations2NF (
    StudentID NUMBER,
    CourseID VARCHAR2(8),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students2NF(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses2NF(CourseID)
);

INSERT ALL
    INTO Students2NF VALUES (1, 'Anu')
    INTO Students2NF VALUES (2, 'Bala')
    INTO Students2NF VALUES (3, 'Chitra')
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Courses2NF VALUES ('C101', 'DBMS', 'I10', 'Rao')
    INTO Courses2NF VALUES ('C102', 'Networks', 'I20', 'Sen')
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Registrations2NF VALUES (1, 'C101', 'A')
    INTO Registrations2NF VALUES (1, 'C102', 'B')
    INTO Registrations2NF VALUES (2, 'C101', 'B')
    INTO Registrations2NF VALUES (3, 'C102', 'A')
SELECT 1 FROM DUAL;

-- =========================================
-- STEP 4: THIRD NORMAL FORM (3NF)
-- =========================================

CREATE TABLE Instructors3NF (
    InstructorID VARCHAR2(8) PRIMARY KEY,
    InstructorName VARCHAR2(40) NOT NULL
);

CREATE TABLE Courses3NF (
    CourseID VARCHAR2(8) PRIMARY KEY,
    CourseName VARCHAR2(40) NOT NULL,
    InstructorID VARCHAR2(8) NOT NULL,
    FOREIGN KEY (InstructorID)
        REFERENCES Instructors3NF(InstructorID)
);

INSERT ALL
    INTO Instructors3NF VALUES ('I10', 'Rao')
    INTO Instructors3NF VALUES ('I20', 'Sen')
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Courses3NF VALUES ('C101', 'DBMS', 'I10')
    INTO Courses3NF VALUES ('C102', 'Networks', 'I20')
SELECT 1 FROM DUAL;

SELECT r.StudentID,
       s.StudentName,
       c.CourseName,
       i.InstructorName,
       r.Grade
FROM Registrations2NF r
JOIN Students2NF s
    ON s.StudentID = r.StudentID
JOIN Courses3NF c
    ON c.CourseID = r.CourseID
JOIN Instructors3NF i
    ON i.InstructorID = c.InstructorID
ORDER BY r.StudentID, c.CourseID;

-- =========================================
-- STEP 5: FOURTH NORMAL FORM (4NF)
-- =========================================

CREATE TABLE StudentInterestRaw (
    StudentID NUMBER,
    Hobby VARCHAR2(30),
    Language VARCHAR2(30),
    PRIMARY KEY (StudentID, Hobby, Language)
);

INSERT ALL
    INTO StudentInterestRaw VALUES (1, 'Chess', 'English')
    INTO StudentInterestRaw VALUES (1, 'Chess', 'Tamil')
    INTO StudentInterestRaw VALUES (1, 'Music', 'English')
    INTO StudentInterestRaw VALUES (1, 'Music', 'Tamil')
SELECT 1 FROM DUAL;

CREATE TABLE StudentHobby4NF (
    StudentID NUMBER,
    Hobby VARCHAR2(30),
    PRIMARY KEY (StudentID, Hobby)
);

CREATE TABLE StudentLanguage4NF (
    StudentID NUMBER,
    Language VARCHAR2(30),
    PRIMARY KEY (StudentID, Language)
);

INSERT ALL
    INTO StudentHobby4NF VALUES (1, 'Chess')
    INTO StudentHobby4NF VALUES (1, 'Music')
SELECT 1 FROM DUAL;

INSERT ALL
    INTO StudentLanguage4NF VALUES (1, 'English')
    INTO StudentLanguage4NF VALUES (1, 'Tamil')
SELECT 1 FROM DUAL;

SELECT h.StudentID, h.Hobby, l.Language
FROM StudentHobby4NF h
JOIN StudentLanguage4NF l
    ON h.StudentID = l.StudentID
ORDER BY h.Hobby, l.Language;

-- =========================================
-- STEP 6: FIFTH NORMAL FORM (5NF)
-- =========================================

CREATE TABLE SupplyRaw (
    SupplierID VARCHAR2(8),
    PartID VARCHAR2(8),
    ProjectID VARCHAR2(8),
    PRIMARY KEY (SupplierID, PartID, ProjectID)
);

INSERT ALL
    INTO SupplyRaw VALUES ('S1', 'P1', 'J1')
    INTO SupplyRaw VALUES ('S1', 'P2', 'J1')
    INTO SupplyRaw VALUES ('S2', 'P1', 'J1')
SELECT 1 FROM DUAL;

CREATE TABLE SupplierPart5NF AS
SELECT DISTINCT SupplierID, PartID
FROM SupplyRaw;

CREATE TABLE SupplierProject5NF AS
SELECT DISTINCT SupplierID, ProjectID
FROM SupplyRaw;

CREATE TABLE PartProject5NF AS
SELECT DISTINCT PartID, ProjectID
FROM SupplyRaw;

ALTER TABLE SupplierPart5NF
ADD PRIMARY KEY (SupplierID, PartID);

ALTER TABLE SupplierProject5NF
ADD PRIMARY KEY (SupplierID, ProjectID);

ALTER TABLE PartProject5NF
ADD PRIMARY KEY (PartID, ProjectID);

SELECT sp.SupplierID, sp.PartID, sj.ProjectID
FROM SupplierPart5NF sp
JOIN SupplierProject5NF sj
    ON sj.SupplierID = sp.SupplierID
JOIN PartProject5NF pj
    ON pj.PartID = sp.PartID
   AND pj.ProjectID = sj.ProjectID
ORDER BY sp.SupplierID, sp.PartID, sj.ProjectID;

-- =========================================
-- STEP 7: VERIFY LOSSLESS RECONSTRUCTION
-- =========================================

SELECT COUNT(*) AS OriginalRows
FROM SupplyRaw;

SELECT COUNT(*) AS ReconstructedRows
FROM (
    SELECT sp.SupplierID, sp.PartID, sj.ProjectID
    FROM SupplierPart5NF sp
    JOIN SupplierProject5NF sj
        ON sj.SupplierID = sp.SupplierID
    JOIN PartProject5NF pj
        ON pj.PartID = sp.PartID
       AND pj.ProjectID = sj.ProjectID
);

WITH Reconstructed AS (
    SELECT sp.SupplierID, sp.PartID, sj.ProjectID
    FROM SupplierPart5NF sp
    JOIN SupplierProject5NF sj
        ON sj.SupplierID = sp.SupplierID
    JOIN PartProject5NF pj
        ON pj.PartID = sp.PartID
       AND pj.ProjectID = sj.ProjectID
)
SELECT 'Original only' AS DifferenceType,
       o.SupplierID, o.PartID, o.ProjectID
FROM SupplyRaw o
LEFT JOIN Reconstructed r
    ON r.SupplierID = o.SupplierID
   AND r.PartID = o.PartID
   AND r.ProjectID = o.ProjectID
WHERE r.SupplierID IS NULL
UNION ALL
SELECT 'Reconstructed only' AS DifferenceType,
       r.SupplierID, r.PartID, r.ProjectID
FROM Reconstructed r
LEFT JOIN SupplyRaw o
    ON r.SupplierID = o.SupplierID
   AND r.PartID = o.PartID
   AND r.ProjectID = o.ProjectID
WHERE o.SupplierID IS NULL;

COMMIT;
