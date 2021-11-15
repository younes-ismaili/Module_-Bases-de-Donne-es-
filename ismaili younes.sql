--create database
CREATE DATABASE univesity;
--create table
CREATE TABLE students(
	 studentID int NOT NULL PRIMARY KEY,
	 first_name varchar(30) NOT NULL,
	 last_name varchar(30) NOT NULL,
	 city_name varchar(30) NOT NULL,
	 email varchar(30) DEFAULT 'el jadida',
	 age int,
	 CONSTRAINT chk_student CHECK (age>=20 AND city_name='el jadida')
);
 --insert new records in a table
INSERT INTO students (studentID, first_name,last_name, city_name,email)
VALUES (1525, 'younes', 'ismaili', 'el jadida', 'yo.ismailii@gmail.com',21);
-- update records in a table
UPDATE students
SET first_name='younes'
WHERE city_name='casablanca';
--select data from a database
SELECT TOP 8 PERCENT * FROM students WHERE  age <=20;
SELECT * FROM students
WHERE first_name LIKE 'y%';
--delete  records in a table
DELETE FROM students WHERE studentID=1525;
--modify columns in a table
ALTER TABLE students
ADD country_name varchar(30);
--delete a table
DROP TABLE students;
--delete a databese
DROP DATABASE univesity;
