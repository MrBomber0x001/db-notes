use Company_SD

--1-
select Dnum , Dname ,ssn , Fname
from Employee Inner join Departments
on SSN = MGRSSN

--2-

select Dname ,Pname 
from Departments d inner join Project p
on d.Dnum = p.Dnum
--3-

select e.Fname ,d.*
from Employee e inner join Dependent d
on d.ESSN = e.SSN

--4-
select Pnumber , Pname, Plocation
from Project
where City  = 'Cairo' or City = 'Alex'

--5-
select * 
from project 
where Pname Like 'a%'

--6-
select * 
from Employee 
where Dno = 30 AND 
Salary between 1000 And 2000 


--7-
select Employee.Fname
from Employee inner join Works_for
on ESSn = SSN
inner join Project 
on pnumber  =pno
where hours >=10 AND pname ='Al Rabwah' and Dno =10

--8-

select emp.Fname + ' '+emp.Lname as fullName
from Employee emp ,Employee mgr
where emp.Superssn = mgr.SSN
and mgr.Fname ='kamel' and mgr.Lname ='Mohamed'

--9-
select Fname +' '+Lname ,Pname
from Employee emp inner join Works_for
on emp.SSN = ESSn
inner join project 
on Pnumber =Pno
order by Pname

--10-
select p.* ,mgr.Lname as manager ,mgr.Address ,mgr.Bdate
from project p inner join Departments d
on p.Dnum = d.Dnum
inner join Employee mgr
on mgr.SSN = MGRSSN
where city ='cairo'

--11-
select Employee.*
from Departments left outer join Employee
on MGRSSN = SSN

--12-
select * 
from Employee Left outer join Dependent
on SSN =ESSN

--13-
Insert into Employee
Values('Ahmed','Elmaadawy',102672,2000-3-22,'12Abu alam str menouf menoufia','M',3000,112233,30)

--14-
Insert into Employee(Fname,Lname,SSN,Bdate,Address,Sex,Dno)
Values('Ahmed','Elkisky',102660,1998-12-4,'12Abu alam str Tala menoufia','M',30)

--15
Update Employee
	set Salary +=Salary *.2
From Employee
where SSN = 102672