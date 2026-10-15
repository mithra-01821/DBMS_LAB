SET SERVEROUTPUT ON;
SET LINESIZE 120;
SET PAGESIZE 50;
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Employment CASCADE CONSTRAINTS';
EXCEPTION
WHEN OTHERS THEN NULL;
END;
/
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Education CASCADE CONSTRAINTS';
EXCEPTION
WHEN OTHERS THEN NULL;
END;
/
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Addresses CASCADE CONSTRAINTS';
EXCEPTION
WHEN OTHERS THEN NULL;
END;
/
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Persons CASCADE CONSTRAINTS';
EXCEPTION
WHEN OTHERS THEN NULL;
END;
/
BEGIN
EXECUTE IMMEDIATE 'DROP VIEW PersonDetails';
EXCEPTION
WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE Persons (
PersonID NUMBER PRIMARY KEY,
FirstName VARCHAR2(50),
LastName VARCHAR2(50),
Gender VARCHAR2(10),
DOB DATE,
Phone VARCHAR2(15),
Email VARCHAR2(100)
);
CREATE TABLE Addresses (
AddressID NUMBER PRIMARY KEY,
PersonID NUMBER,
Street VARCHAR2(100),
City VARCHAR2(50),
State VARCHAR2(50),
Pincode VARCHAR2(10),
CONSTRAINT fk_person
FOREIGN KEY(PersonID)
REFERENCES Persons(PersonID)
);
CREATE TABLE Education (
EducationID NUMBER PRIMARY KEY,
PersonID NUMBER,
Qualification VARCHAR2(100),
Institution VARCHAR2(100),
YearOfPassing NUMBER,
CONSTRAINT fk_edu_person
FOREIGN KEY(PersonID)
REFERENCES Persons(PersonID)
);
CREATE TABLE Employment (
EmployeeID NUMBER PRIMARY KEY,
PersonID NUMBER,
CompanyName VARCHAR2(100),
Designation VARCHAR2(100),
Salary NUMBER(10,2),
CONSTRAINT fk_emp_person
FOREIGN KEY(PersonID)
REFERENCES Persons(PersonID)
);
INSERT INTO Persons VALUES
(1,'Arun','Kumar','Male',
TO_DATE('15-05-2000','DD-MM-YYYY'),
'9876543210',
'arun@gmail.com');
INSERT INTO Persons VALUES
(2,'Divya','Rani','Female',
TO_DATE('20-08-1999','DD-MM-YYYY'),
'9876543211',
'divya@gmail.com');
INSERT INTO Persons VALUES
(3,'Rahul','Sharma','Male',
TO_DATE('10-01-1998','DD-MM-YYYY'),
'9876543212',
'rahul@gmail.com');
INSERT INTO Addresses VALUES
(1,1,'Anna Nagar','Chennai','Tamil Nadu','600040');
INSERT INTO Addresses VALUES
(2,2,'RS Puram','Coimbatore','Tamil Nadu','641002');
INSERT INTO Addresses VALUES
(3,3,'KK Nagar','Madurai','Tamil Nadu','625020');
INSERT INTO Education VALUES
(1,1,'B.E CSE','Anna University',2021);
INSERT INTO Education VALUES
(2,2,'B.Sc IT','Bharathiar University',2020);
INSERT INTO Education VALUES
(3,3,'MCA','Madurai Kamaraj University',2022);
INSERT INTO Employment VALUES
(1,1,'TCS','Software Engineer',45000);
INSERT INTO Employment VALUES
(2,2,'Infosys','System Engineer',40000);
INSERT INTO Employment VALUES
(3,3,'Wipro','Developer',42000);
COMMIT;
CREATE OR REPLACE VIEW PersonDetails AS
SELECT
p.PersonID,
p.FirstName,
p.LastName,
a.City,
e.Qualification,
em.CompanyName
FROM Persons p
JOIN Addresses a
ON p.PersonID = a.PersonID
JOIN Education e
ON p.PersonID = e.PersonID
JOIN Employment em
ON p.PersonID = em.PersonID;
CREATE OR REPLACE PROCEDURE GetPersonInfo
(
p_id IN NUMBER
)
AS
BEGIN
FOR rec IN
(
SELECT *
FROM Persons
WHERE PersonID = p_id
)
LOOP
DBMS_OUTPUT.PUT_LINE(
rec.FirstName || ' ' ||
rec.LastName
);
END LOOP;
END;
/
CREATE OR REPLACE FUNCTION GetSalary
(
p_id NUMBER
)
RETURN NUMBER
IS
sal NUMBER;
BEGIN
SELECT Salary
INTO sal
FROM Employment
WHERE PersonID = p_id;
RETURN sal;
END;
/
CREATE OR REPLACE TRIGGER Salary_Check
BEFORE INSERT OR UPDATE
ON Employment
FOR EACH ROW
BEGIN
IF :NEW.Salary <= 0 THEN
RAISE_APPLICATION_ERROR(-20001,
'Salary must be greater than zero');
END IF;
END;
/
SELECT * FROM Persons;
/*
OUTP
