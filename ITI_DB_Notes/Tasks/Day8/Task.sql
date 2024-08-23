---------1--------------
CREATE PROC numberOfStudents
AS
SELECT Dept_Name , count(St_Id) as numberOfStudents
FROM student  s INNER JOIN Department d
    ON s.Dept_Id = d.Dept_Id
GROUP BY Dept_Name

EXECUTE numberOfStudents
---------------2--------
use Company_SD

alter proc employeeinp1
AS

 if (SELECT count(ssn)
from employee e inner JOIN Works_for wf
    ON wf.ESSn = e.ssn
    INNER JOIN project p
    on p.pnumber = wf.Pno
WHERE p.pnumber=100
GROUP BY pname) > 3
SELECT 'The number of employees in the project p1 is 3 or more'
ELSE
    BEGIN
    DECLARE @name VARCHAR(100)=''
    SELECT e.Fname , e.lname
    from employee e
        inner JOIN Works_for wf
        ON wf.ESSn = e.ssn
        INNER JOIN project p
        on p.pnumber = wf.Pno
    WHERE p.pnumber = 100
    SELECT 'The Following Employees work for project p1' + @name
end


EXEC employeeinp1
--------------3------------

ALTER proc updateemp
    @old int,
    @new int,
    @pno int
as 
begin try 
UPDATE Works_for
set ESSn = @new
WHERE pno =@pno and ESSn = @old
end try
begin catch 
select 'error happened while updating' 
end catch

exec updateemp 1,1,500

-----------------4-----------------
use Company_SD

CREATE table audit
(
    projectNo int,
    userName varchar(50),
    ModifiedDate datetime,
    budget_old int ,
    budget_new int
)


CREATE TRIGGER t5 
on project 
after UPDATE
AS
    if  UPDATE(budget) 
    begin
    declare @old int ,@new int ,@pno int
    select @old = budget , @pno=pnumber
    from deleted
    SELECT @new = budget
    from inserted
    INSERT into audit
    VALUES(@pno, SUSER_NAME(), GETDATE(), @old, @new)
end

UPDATE project 
set budget = 20000 
where pnumber = 200

SELECT *
from audit

------------5-----------------
create TRIGGER t1 
on Department 
INSTEAD of INSERT
as 
    SELECT 'You cant Enter values to department'

select *
from Department

INSERT into Department
values(200, 'sd', 'java', 'alex', 1, GETDATE())
---------------6----------

CREATE TRIGGER t2 
ON employee 
instead of INSERT
as
 IF MONTH(GETDATE()) ='March'
    SELECT 'Cant insert values in march'
ELSE
BEGIN
    INSERT into employee
    SELECT *
    FROM inserted
END



---------------------7--------------
use ITI

create TABLE audit
(
    serverUsername VARCHAR(50),
    date DATETIME ,
    Note VARCHAR(100)
)

create TRIGGER t3
on student
after INSERT
as
    DECLARE @key int=100
    SELECT @key =st_id
FROM inserted
    
    INSERT into audit
values(suser_name() , GETDATE(), CONCAT(SUSER_NAME(),'insert a new row with key',cast(@key as varchar(20))))


INSERT into student
    (st_id,St_Fname)
VALUES(1500, 'ahmed')
SELECT *
from audit
select *
from Student


---------------8------------

create TRIGGER t4
on student
instead of DELETE
as
    DECLARE @key int
    SELECT @key =st_id
FROM deleted
    
    INSERT into audit
values(suser_name() , GETDATE(), CONCAT(SUSER_NAME(),'try to delete row with key',cast(@key as varchar(20))))


DELETE from Student
WHERE St_Id = 1

SELECT *
from audit
select *
from Student