use Company_SD 
--1-select all employees
select * from Employee

--2- 
select fname,lname,salary,dno FROM Employee

--3-
select pname,Plocation,Dnum from Project

--4-
select fname +' '+lname as [full Name], salary*12*.1 as [ANNUL COMM]
from Employee


--5-
select ssn ,fname +' ' +Lname as fullname
from employee 
where salary >1000
--6-
select ssn ,fname +' ' +Lname as fullname
from employee 
where salary*12 >10000

---7-
select fname +' ' +Lname as fullname, salary
from employee 
where sex = 'f'

--8-
select dnum,Dname from Departments
where mgrssn = 968574

--9-
select  Pnumber ,pname,Plocation from Project
where dnum = 10