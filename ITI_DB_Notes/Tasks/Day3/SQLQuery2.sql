create database courses
use Courses
Create Table Instructor (
 ID int primary key identity,
salary int,
fname varchar(20),
lname varchar(20),
hiredate date default getdate(),
address varchar(50),
overtime int unique,
BD date,
Netsal  AS (isnull(salary, 0) + isnull(overtime, 0)),
age  AS (year(getdate()) - isnull(year(BD), 0)),

constraint c1 check(salary between 1000 and 3000),
constraint c2 check(address IN ('alex','cairo'))
)


create table course (
Cid int primary key identity,
Cname varchar(30),
Duration int unique
)

create table instructor_course(
instID int ,
Cid int

constraint c3 primary key (instID, Cid),
constraint C4 foreign key(instID) references Instructor(ID)
	on delete Cascade on update cascade ,
constraint C5 foreign key(Cid) references course(Cid)
	on delete Cascade on update cascade
)

create table Lab (
Lid int identity,
Location Varchar(50),
capacity int  ,
CID int,
constraint c6 check(capacity<20),
constraint c7 foreign key (CID) references course(CID)
on delete Cascade on update cascade,
constraint c8 primary key (Lid, CID),
)
