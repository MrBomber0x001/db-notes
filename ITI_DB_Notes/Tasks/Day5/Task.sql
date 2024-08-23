--- Query 1
SELECT COUNT(*)
FROM Student
WHERE St_Age is NOT NULL;

-----Query 2
SELECT distinct Ins_Name
from Instructor;

----Query3 
select St_Id as StudentID , ISNULL( St_Fname,' ')+' '+IsNull(St_Lname,' ') as FullName, Dept_Id as 'Department name'
from Student

---Query4
SELECT Ins_Name as InstructorName , Dept_Name as Departmentname
FROM Instructor i LEFT OUTER JOIN Department d
    ON i.dept_id = d.Dept_Id

---Query 5
SELECT s.St_Fname +' ' +s.St_Lname as FullName, Grade, c.Crs_Name
FROM Student s left outer join Stud_Course sc
    ON s.St_Id = sc.st_id
    join Course c
    On sc.Crs_Id = c.Crs_Id
Where Grade is NOT NULL

----query6
SELECT Top_Name , COUNT(Crs_Id)  as count
from course c left JOIN Topic t
    ON c.Top_Id = t.Top_Id
GROUP BY Top_Name

---query7
SELECT MAX(Salary), MIN(Salary)
FROM Instructor

---query 8
SELECT Ins_Id, Salary , Ins_Name
from Instructor
WHERE Salary < ( select AVG(Salary)
FROM Instructor)

---- query9
SELECT top(1)
    Dept_name
from Instructor LEFT JOIN Department
    ON Instructor.Dept_Id = Department.Dept_Id
ORDER by Salary

---query 10
select salary
from (
SELECT *, DENSE_RANK() OVER(ORDER by salary desc) as dn
    FROM Instructor )as newtable
where dn <=2

---query 11
SELECT Ins_Name , coalesce(Convert(varchar,salary) ,Ins_name)
FROM Instructor

---query 12
SELECT AVG(ISNULL(salary,0))
from Instructor

---query 13
select s.St_Fname+ ' '+s.St_Lname as FullName , su.*
from student s LEFT OUTER JOIN Student su
    on s.St_super = su.St_Id

---query 14
select ISNULL(Salary ,0) , Dept_Id
from (
SELECT *, DENSE_RANK() OVER(partition by dept_id ORDER by salary desc) as dn
    FROM Instructor )as newtable
where dn <=2

----query 15
SELECT *
from (
SELECT * , Row_number() OVER(partition by dept_id ORDER by NEWID()) as Rn
    from Student) as students
WHERE rn =1


----part 2
---query1
SELECT SalesOrderID, ShipDate
FROM sales.salesorderheader
WHERE OrderDate BETWEEN '7/28/2002' and '7/29/2014'
---query2

SELECT ProductID, Name
FROM Production.Product
WHERE StandardCost < 110

---query3
SELECT ProductID, Name
FROM Production.Product
WHERE Weight is NULL

---query4
SELECT *
FROM Production.Product
WHERE Color IN('red','black','silver')


---query5
SELECT *
FROM Production.Product
WHERE Name LIKE 'a%'

---query6
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

SELECT *
FROM Production.ProductDescription
WHERE Description like '%[_]%'

---query7
SELECT OrderDate , SUM(TotalDue)
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '7/1/2002' and '7/31/2014'
GROUP BY OrderDate

---QUERY8 
SELECT distinct HireDate
FROM HumanResources.Employee

---query 9
SELECT AVG(distinct ListPrice)
FROM Production.Product

--query 10
SELECT 'The '+Name + ' is Only !' + cast(ISNULL(ListPrice,0) as varchar(10) )
from Production.Product
WHERE ListPrice BETWEEN 100 and 120
ORDER BY ListPrice

---query 11

SELECT rowguid, Name, SalesPersonID, Demographics
into  store_Archive
FROM Sales.Store

SELECT *
FROM store_Archive

SELECT rowguid, Name, SalesPersonID, Demographics
into  store_Archive2
FROM Sales.Store
where 1 = 2

select *
FROM store_Archive2


----query 12
SELECT CONVERT(varchar, getdate(), 121)
UNION
 SELECT CONVERT(varchar, getdate(), 23)
UNION
SELECT FORMAT(getdate(), 'MMM dd yyyy')
UNION
SELECT CONVERT(varchar, getdate(), 103)
UNION
SELECT CONVERT(varchar, getdate(), 110)