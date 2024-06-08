--1. What are the birth dates of all the employees in the HumanResources.Employee table?
Select BusinessEntityID, BirthDate
from HumanResources.Employee

--2. Can you list the employees who have a marital status of 'Married'?
Select BusinessEntityID, MaritalStatus
from [HumanResources].[Employee]
where MaritalStatus= 'M'

--3. How many employees have a job title that includes the word 'Engineer'?
Select COUNT(*)
from [HumanResources].[Employee]
where JobTitle like '%Engineer%'

--4. What are the sick leave hours taken by each employee?
Select BusinessEntityID, SickLeaveHours
from HumanResources.Employee

--5. How many employees have more than 5 years of tenure?
Select count(*)
from HumanResources.Employee
where DATEDIFF(Year, Hiredate, Getdate())>5

--6. What are the email addresses of each employee in the HumanResources.Employee table?
Select em.BusinessEntityID, pea.emailaddress
from HumanResources.Employee em
join [Person].[EmailAddress] pea on em.BusinessEntityID= pea.BusinessEntityID

--7. How many employees have received performance reviews in the last year?
Select em.BusinessEntityID, edh.Enddate
from HumanResources.Employee em
join [HumanResources].[EmployeeDepartmentHistory] edh on em.BusinessEntityID= edh.BusinessEntityID
Where enddate is null

--8. What is the total vacation hours taken by all employees?
Select SUM(VacationHours) as totalvacationhours
from HumanResources.Employee

--9. Can you find employees who work in the 'Marketing' department?
SELECT e.BusinessEntityID, e.JobTitle
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE d.Name = 'Marketing'

--10. How many employees were hired in the last month?
SELECT COUNT(*)
FROM HumanResources.Employee
WHERE HireDate BETWEEN DATEADD(MONTH, -1, GETDATE()) AND GETDATE();

--11. Which employees have taken the most sick leave hours?
SELECT TOP 1 BusinessEntityID, SickLeaveHours
FROM HumanResources.Employee
ORDER BY SickLeaveHours DESC;

--12. Can you list the employees who are eligible for promotion this year?
SELECT BusinessEntityID, HireDate
FROM HumanResources.Employee;

--13. What are the job start dates of each employee?
SELECT COUNT(*)
FROM HumanResources.Employee
WHERE JobTitle LIKE 'Senior%';

--14. How many employees have job titles that start with 'Senior'?
SELECT AVG(DATEDIFF(YEAR, HireDate, GETDATE())) AS AverageTenure
FROM HumanResources.Employee;

--15. How many employees have the most recent hire date?
SELECT COUNT(*)
FROM HumanResources.Employee
WHERE HireDate = (SELECT MAX(HireDate) FROM HumanResources.Employee);
  