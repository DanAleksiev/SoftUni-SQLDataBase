--1
USE SoftUni

SELECT TOP (5) e.EmployeeID,e.JobTitle,e.AddressID, a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = E.AddressID
ORDER BY e.AddressID

--2

SELECT TOP (50) e.FirstName, e.LastName, t.Name, A.AddressText
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
ORDER BY e.FirstName,e.LastName

--3

SELECT e.EmployeeID, e.FirstName, e.LastName ,d.Name
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE D.NAME = 'Sales'
ORDER BY e.EmployeeID

--4

SELECT TOP (5) e.EmployeeID, e.FirstName, e.Salary, d.Name
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID

--5

SELECT TOP (3) E.EmployeeID, E.FirstName
FROM Employees AS e 
LEFT JOIN EmployeesProjects AS ep ON EP.EmployeeID = E.EmployeeID
WHERE ProjectID IS NULL
ORDER BY e.EmployeeID


SELECT TOP (3) E.EmployeeID, E.FirstName
FROM Employees AS e 
WHERE e.EmployeeID NOT IN 
	(SELECT EmployeeID FROM EmployeesProjects)
ORDER BY e.EmployeeID

--6

SELECT e.FirstName, e.LastName, e.HireDate, d.Name
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE E.HireDate > '1999-1-1' AND D.NAME = 'Sales' OR D.NAME ='Finance' 
ORDER BY e.HireDate

--7

SELECT TOP(5) E.EmployeeID, E.FirstName,p.Name AS ProjectName
FROM Employees AS e 
LEFT JOIN EmployeesProjects AS ep ON EP.EmployeeID = E.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID


--8

SELECT e.EmployeeID, E.FirstName, 
	CASE WHEN  p.StartDate < '2005-01-01'  THEN P.[Name]
	ELSE NULL
	END AS ProjectName 
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

--9

SELECT e.EmployeeID, e.FirstName, e.ManagerID, M.FirstName AS ManagerName 
FROM Employees AS e
JOIN Employees AS m ON E.ManagerID = m.EmployeeID 
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

--10

SELECT TOP (50)  e.EmployeeID, e.FirstName +  ' ' + e.LastName AS EmployeeName, m.FirstName +' '+ m.LastName AS ManagerName, d.Name AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID

--11

SELECT TOP(1)
MIN(a.AvarageSalary) AS MinAverageSalary
FROM 
	(SELECT e.DepartmentID,
	AVG(e.Salary) AS AvarageSalary
	FROM Employees AS e
	GROUP BY e.DepartmentID
	) as a
--12

USE Geography

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Peaks AS p
JOIN Mountains AS m ON m.Id =  p.MountainId
JOIN MountainsCountries AS mc ON mc.MountainId = p.MountainId
WHERE MC.CountryCode = 'BG' AND p.Elevation >= 2835
ORDER BY p.Elevation DESC

--13

SELECT mc.CountryCode, COUNT (m.MountainRange) AS MountainRange
FROM Mountains AS m 
JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
WHERE mc.CountryCode = 'BG' OR mc.CountryCode = 'RU' OR mc.CountryCode = 'US'
GROUP BY mc.CountryCode

--14

SELECT TOP (5)c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode =  c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--15*

SELECT COUNT(CurrencyCode) AS CurrencyUsage
FROM Countries 
GROUP BY ContinentCode
ORDER BY ContinentCode

--16

SELECT COUNT(C.Capital) AS [Count]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
WHERE mc.MountainId IS NULL
GROUP BY MC.MountainId

--17

SELECT TOP(5) c.CountryName,MAX (p.Elevation)AS HighestPeakElevation, MAX (r.Length) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = C.CountryCode
LEFT JOIN Mountains AS m ON m.Id = MC.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = M.Id
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY C.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName


--18*




SELECT *
FROM Rivers