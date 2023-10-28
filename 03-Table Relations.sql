--1
CREATE DATABASE [Table Relations]

USE [Table Relations]

CREATE TABLE [Passports](
[PassportID] INT PRIMARY KEY,
[PassportNumber] VARCHAR(8)
)

INSERT Passports ([PassportID],[PassportNumber])
VALUES
(101,'N34FG21B'),
(102,'K65LO4R7'),
(103,'ZE657QP2')

CREATE TABLE [Persons] (
PersonID INT IDENTITY PRIMARY KEY,
FirstName NVARCHAR(15) NOT NULL,
Salary DECIMAL (8,2) NOT NULL,
PassportID INT FOREIGN KEY REFERENCES [Passports]([PassportID])
)

--DROP TABLE Persons

--SELECT * FROM Passports

INSERT Persons (FirstName,Salary,PassportID)
VALUES
('Roberto', 43300.00 ,102),
('Tom', 56100.00 ,103),
('Yana', 60200.00 ,101)

--2

CREATE TABLE Manufacturers(
ManufacturerID INT IDENTITY PRIMARY KEY,
Name VARCHAR(20),
EstablishedOn DATE
)

INSERT Manufacturers(Name, EstablishedOn)
VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

--SELECT * FROM Manufacturers
--DROP TABLE Manufacturers

CREATE TABLE Models(
ModelID INT PRIMARY KEY,
Name VARCHAR(20),
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers
)

INSERT Models (ModelID, Name, ManufacturerID)
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)

--3
CREATE DATABASE [Many-To-Many Relationship]
USE [Many-To-Many Relationship]

CREATE TABLE Students (
StudentID INT IDENTITY PRIMARY KEY,
Name VARCHAR (30)
)

INSERT Students (Name)
VALUES
('Mila'),
('Toni'),
('Ron')

CREATE TABLE Exams (
ExamID INT IDENTITY (101,1)PRIMARY KEY,
Name VARCHAR (30)
)

INSERT Exams (Name)
VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

CREATE TABLE StudentsExams (
StudentID INT,
ExamID INT ,
PRIMARY KEY (StudentID, ExamID),
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
)

INSERT StudentsExams (StudentID,ExamID)
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103)


DROP TABLE StudentsExams

SELECT * FROM StudentsExams

--4

CREATE TABLE Teachers (
TeacherID INT PRIMARY KEY,
Name VARCHAR (30),
ManagerID INT FOREIGN KEY REFERENCES Teachers,
)

INSERT INTO Teachers (TeacherID, Name, ManagerID)
VALUES
(101,'John', NULL),
(102,'Maya', 106),
(103,'Silvia', 106),
(104,'Ted', 105),
(105,'Mark', 101),
(106,'Greta', 101)


SELECT * FROM Teachers

--5
CREATE DATABASE [Online Store]
GO
USE [Online Store]


CREATE TABLE ItemTypes (
ItemTypeID INT IDENTITY PRIMARY KEY,
Name VARCHAR(20)
)

CREATE TABLE Items (
ItemID INT IDENTITY PRIMARY KEY,
Name VARCHAR(20),
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes
)

CREATE TABLE Cities (
CityID INT IDENTITY PRIMARY KEY,
Name VARCHAR(20)
)

CREATE TABLE Customers (
CustomerID INT IDENTITY PRIMARY KEY,
Name VARCHAR(20),
Birthday DATE,
CityID INT FOREIGN KEY REFERENCES Cities
)

CREATE TABLE Orders (
OrderID INT IDENTITY PRIMARY KEY,
CustomerID INT FOREIGN KEY REFERENCES Customers
)

CREATE TABLE OrderItems (
OrderID INT ,
ItemID INT,
PRIMARY KEY (OrderID,ItemID),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
)

--6
CREATE DATABASE University
GO
USE University

CREATE TABLE Majors(
MajorID INT IDENTITY PRIMARY KEY,
Name VARCHAR (30),
)

CREATE TABLE Students(
StudentID INT IDENTITY PRIMARY KEY,
StudentNumber INT,
StudentName VARCHAR(30),
MajorID INT FOREIGN KEY REFERENCES Majors  
)

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY,
SubjectName VARCHAR (30),
)

CREATE TABLE Agenda (
StudentID INT,
SubjectID INT,
PRIMARY KEY (StudentID,SubjectID),
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
)

CREATE TABLE Payments(
PaymentID INT IDENTITY PRIMARY KEY,
PaymentDate	DATE,
PaymentAmount DECIMAL (6,2),
StudentID INT FOREIGN KEY REFERENCES Students
)

--9
USE Geography

SELECT MountainRange,PeakName,Elevation 
FROM Peaks AS P,Mountains AS M
WHERE P.MountainId = 17 AND  M.Id = 17
ORDER BY Elevation DESC

