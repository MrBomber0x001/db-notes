------------1-------
CREATE FUNCTION dbo.monthname(@date DATETIME)
RETURNS VARCHAR(20)
    BEGIN
    DECLARE @name VARCHAR(20)
    SELECT @name =FORMAT(@date,'MMMM')
    RETURN @name
END


SELECT dbo.monthname(getdate())

--------2-----------
ALTER FUNCTION valuesbetween (@x INT ,@y INT)
RETURNS @t TABLE (
    val int
		) 
AS
	BEGIN
    Declare @tem int=@x
    WHILE @tem < @y
        BEGIN
        SET  @tem +=1
        INSERT INTO @t
        SELECT @tem
    END
    RETURN
END


SELECT *
FROM valuesbetween(5,10)

------3--------
CREATE FUNCTION studentdept(@stid int)
RETURNS TABLE
AS 
	RETURN(
		SELECT CONCAT(s.St_Fname,' ',s.St_Lname) as FullName , d.Dept_Name
FROM Student s LEFT JOIN Department d
    ON s.Dept_Id = d.Dept_Id
WHERE s.St_Id=@stid
	)


SELECT *
FROM studentdept(10)
----------4------------


CREATE FUNCTION nullnames(@id int)
RETURNS VARCHAR(30)
	BEGIN
    DECLARE @res varchar(30)
    SELECT @res =CASE WHEN COALESCE(St_Fname,St_Lname) is null THEN 'First Name and Last Name are Null' 
             WHEN St_Fname is null THEN 'First Name is Null'
             WHEN St_Lname is null THEN 'Last Name is Null'
             ELSE 'First Name And Last Name are not null'
        END
    from Student
    WHERE St_Id=@id
    RETURN @res
END


SELECT dbo.nullnames(14)

--------------5------------
CREATE FUNCTION deptmangr(@id int)
RETURNS TABLE
AS 
	RETURN(
        SELECT Dept_Name, Ins_Name, Manager_hiredate
FROM Department d LEFT JOIN Instructor i
    on d.Dept_Manager = i.Ins_Id
WHERE Ins_Id =@id
	)


SELECT *
FROM deptmangr(1)


-------------6------------------
CREATE FUNCTION studentname (@name varchar(20))
RETURNS @t TABLE (
    studname VARCHAR(20)
		) 
AS
	BEGIN
    IF @name ='first name'
		INSERT INTO @t
    SELECT ISNULL(St_Fname,'No First Name')
    FROM student

	ELSE IF @name ='last name'
		INSERT INTO @t
    SELECT ISNULL(St_Lname,'No Last Name')
    FROM student
	ELSE IF @name ='full name'
		INSERT INTO @t
    SELECT ISNULL(concat(st_fname,' ',st_lname),'full name is null')
    FROM student
    RETURN
END


SELECT *
FROM studentname('full name')
SELECT *
FROM studentname('first name')
SELECT *
FROM studentname('last name')


--------------7------------------

SELECT St_Id, SUBSTRING(St_Fname,0,LEN(St_Fname))
FROM Student


---------8------------------

Update Stud_Course
    SET Grade = 0
WHERE St_Id IN  (SELECT St_Id
FROM Student s LEFT JOIN Department d
    on s.Dept_Id = d.Dept_Id
WHERE Dept_Name = 'SD'
)

SELECT *
FROM Stud_Course
---------------9----------------
MERGE INTO  LastTransaction T
USING DailyTransaction S
On T.Tid =S.Sid
WHEN MATCHED THEN
    UPDATE 
    SET T.value = S.Value
WHEN NOT MATCHED THEN 
    INSERT 
    VALUES(S.Sid,S.Value)

 -----10 -----------

