use Company_SD
select * from employee
select * from Dependent

--1-
select Dependent_name ,d.sex
from Dependent d inner join Employee e
on ESSN =SSN
where d.Sex='f' and e.sex = 'f'
union
select Dependent_name ,d.sex
from Dependent d inner join Employee e
on ESSN =SSN
where d.Sex='m' and e.sex = 'm'

--2-
select Pname,sum(hours)
from Works_for  inner join Employee 
on ESSn = SSN
inner join Project 
on pnumber = Pno
group by pname


--3-
select d.* 
from  Employee inner join Departments d
on dno = Dnum
where ssn =(select min(ssn) From Employee) 


--4-
select dname,Dnum, max(salary),min(salary),avg(salary)
from  Employee inner join Departments d
on dno = Dnum
group by Dnum,dname

--5-
select fname +' '+Lname  as fullname 
from employee
where ssn = (
select MGRSSN from Departments
where MGRSSN not in (select ESSN from Dependent))

--6-

select dnum,Dname, count(SSN)
from employee inner join Departments
on Dnum = Dno
group by dname,dnum
Having avg(salary)< (select AVG(salary) from Employee)


--7-
select fname,lname,Pname ,Dnum from 
Employee inner join Works_for
on essn =SSN
inner join project
on pno = Pnumber
order by dnum, Lname,Fname

--8-
select max(Salary) as secmax,(select max(salary) from Employee) as maxsal
from employee
where salary not in (select max(salary) from Employee)

--9-

select  Dependent_name from Dependent
intersect
select fname+' '+lname
from employee

--10-
select fname+' '+lname
from Employee as e
where  exists  (select Essn from Dependent where essn =e.ssn)


--11-

Insert into Departments
Values('DEPT IT', 100,112233,1-11-2006)

--12
select * from Departments
update Departments
set MGRSSN =968574
where Dnum = 100

update Departments
set MGRSSN =102672
where Dnum = 20

update Employee
set Superssn =102672
where ssn =102660

--13-
delete from Dependent 
where essn=223344
select * from Employee

update employee
set Superssn =NULL
where Superssn = 223344

delete from Works_for
where ESSn = 223344
update Departments 

set MGRSSN =NULL
where MGRSSN = 223344

delete from Employee
where ssn =223344

--14-
update Employee 
set Salary += Salary*.3
where ssn IN(
	select SSN
	from employee inner join Works_for
	on SSN = ESSn
	inner join Project 
	on pnumber = pno
	where pname = 'Al Rabwah')