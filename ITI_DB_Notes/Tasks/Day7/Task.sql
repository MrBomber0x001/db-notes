-----------1--------------
CREATE VIEW studentCrsName(FullName,crs_name,grade)
AS
SELECT St_Fname+' '+St_Lname  , crs_name, Grade
FROM
    student s INNER JOIN Stud_Course SC
    ON s.St_Id = sc.St_Id
    INNER JOIN
    course C
    ON sc.Crs_Id =c.Crs_Id
WHERE Grade>50


SELECT *
FROM studentCrsName


-------------2------------
SELECT Top_Name , i.Ins_Name
FROM Topic t INNER JOIN Course C
    on t.Top_Id = c.Top_Id
    INNER JOIN Ins_Course ic
    ON ic.Crs_Id = c.Crs_Id



CREATE VIEW ManagerTopic(managerName,topic)
WITH encryption
AS
SELECT i.Ins_Name , Top_Name
FROM Instructor i INNER JOIN Department d
    ON i.Ins_Id = d.Dept_Manager
    INNER JOIN Ins_Course ic
    ON ic.Ins_Id = i.Ins_Id
    INNER JOIN Course c
    ON ic.Crs_Id = c.Crs_Id
    INNER join Topic t
    ON t.Top_Id = c.Top_Id

SELECT *
FROM ManagerTopic

sp_helptext'managerTopic'
-----------3-------------
CREATE VIEW instructordept(instructorName,Dept)
AS
SELECT Ins_Name , Dept_Name
FROM Instructor i INNER JOIN Department d
    ON i.Dept_Id = d.Dept_Id
WHERE d.Dept_Name IN ('SD','Java')

SELECT *
FROM instructordept
-----------------------4--------
CREATE VIEW studAlexOrCairo
AS
    SELECT *
    FROM Student
    WHERE St_Address IN ('alex','cairo')
WITH CHECK OPTION

SELECT *
FROM studAlexOrCairo

UPDATE studAlexOrCairo
    SET St_Address='tanta'
    WHERE St_Id = 1
-------------------------5------
CREATE VIEW noemployeeinpro(projName,EmployeeCount)
AS
SELECT Pname , COUNT(SSN) as EmployeeNums
FROM Employee e INNER JOIN Works_for wf
    ON e.SSN = wf.ESSn
    INNER JOIN Project p
    ON p.Pnumber = wf.Pno
GROUP BY Pname

SELECT *
FROM noemployeeinpro
------------6------------
CREATE SCHEMA company
ALTER SCHEMA company TRANSFER departments

CREATE SCHEMA HumanResource
ALTER SCHEMA HumanResource TRANSFER Employee

-----------7--------------
CREATE CLUSTERED INDEX i2 
ON Department(manager_hiredate)

--ERROR 

------------8---------
CREATE UNIQUE NONCLUSTERED INDEX i3 ON Student(st_age);

------error------------


------------9---------------
DECLARE c1 CURSOR
FOR SELECT Salary
FROM HumanResource.Employee
FOR
UPDATE

DECLARE @sal INT
OPEN c1
FETCH c1 INTO @sal
WHILE @@FETCH_STATUS=0
	BEGIN
    IF @sal <3000
	UPDATE HumanResource.Employee
		SET salary += salary*.1
	WHERE CURRENT OF c1
	ELSE IF @sal>=3000
		UPDATE HumanResource.Employee
			SET Salary +=salary*.2
	WHERE CURRENT OF c1
    FETCH c1 INTO @sal
END
CLOSE c1
DEALLOCATE c1

select *
FROM HumanResource.Employee

-----------------10----------
use ITI

DECLARE c2 CURSOR 
FOR SELECT Ins_Name , Dept_Name
FROM Department d INNER JOIN Instructor i
    on d.Dept_Manager = i.Ins_Id
FOR
READ
ONLY

DECLARE @name VARCHAR(20) ,@dept VARCHAR(20)

OPEN c2
FETCH c2 INTO @name,@dept
,
WHILE @@FETCH_STATUS = 0
    BEGIN
    SELECT @name +' '+@dept
    FETCH c2 INTO @name,@dept
END
CLOSE c2
DEALLOCATE c2

-----------------11-------
DECLARE c3 CURSOR

FOR SELECT (Ins_Name)
FROM Instructor
WHERE Ins_Name IS NOT NULL
FOR
READ
ONLY

DECLARE @name VARCHAR(20),@all_names VARCHAR(500) =''

OPEN c3
FETCH c3 INTO @name
WHILE @@FETCH_STATUS =0
	BEGIN
    SET @all_names=CONCAT(@all_names,',',@name)
    FETCH c3 INTO @name
END
SELECT @all_names
CLOSE c3
DEALLOCATE c3

