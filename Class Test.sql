create database February_Class_Test_Sql_Server;
use February_Class_Test_Sql_Server;


create database Employee_Management;
use Employee_Management;



create table Department (
	Dep_Id int primary key identity,
	Dept_Name varchar(50)
);

insert into Department (Dept_Name) values ('Sales'),('Purchase'),('Finance'),('HR'),('IT');

create table Employees (
	Employee_Id int primary key identity,
	First_Name varchar(50),
	Last_Name varchar(50),
	Department_Id int,
	Salary decimal(10,2),

	FOREIGN KEY (Department_Id) REFERENCES Department(Dep_Id)
);

insert into Employees (First_Name,Last_Name,Department_Id,Salary) values
('Jhon','Doe',1,25000),('Ven','Hellsing',5,75000),('Dr','Frankestien',3,35000),
('Edward','HUbbel',2,25300),('Isaac','Newton',4,56400),('Nikola','Tesla',1,25400),
('Leonardo','Davinci',3,25479),('Mona','Lisa',2,14900),('Dr','AluCard',1,35000),
('Son','Goku',3,45800),('King','Vegeta',2,36000),('Jane','Smith',1,25000),
('Lucifer','Morningstar',3,65000),('Dream','Chaser',1,35000),('Moon','Knight',4,25000);

-----------------b--------------------------

update Employees set salary = salary*1.10 where Department_Id = 1 ;

select * from Employees;


-------------------c------------------------------

Delete from Employees Where Salary = (select min(salary) from Employees);

select * from Employees;



--------------------SQL SERVER----------------------------

------------------------a----------------------------------
USE master;


CREATE LOGIN HR_Manager
WITH PASSWORD = 'password';




-------------------b--------------------
GO
CREATE USER HR_Manager
FOR LOGIN HR_Manager

GO


--------------------c------------------------------

GRANT SELECT ON dbo.Employees TO HR_Manager;


-------------------------------d----------------------

REVOKE INSERT ON dbo.Employees FROM HR_Manager;




--------------------Trigger-------------------------


CREATE TABLE Save_Backup (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name varchar(50),
	Department_Name varchar(50),
	Salary decimal(10,2),
    EventType NVARCHAR(50),
    EventDate DATETIME
);


CREATE TRIGGER employeeTrigger
ON Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @EventType NVARCHAR(50);
    DECLARE @Name VARCHAR(100); -- Increased the length to accommodate the concatenated name
    DECLARE @Dep_Id INT;
    DECLARE @Salary DECIMAL(10,2);

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
        BEGIN
            SET @EventType = 'UPDATE';
            SELECT @Name = CONCAT(First_Name, ' ', Last_Name) FROM DELETED;
            SELECT @Dep_Id = Department_Id FROM DELETED;
            SELECT @Salary = Salary FROM DELETED;
        END
        ELSE
        BEGIN
            SET @EventType = 'INSERT';
            SELECT @Name = CONCAT(First_Name, ' ', Last_Name) FROM INSERTED;
            SELECT @Dep_Id = Department_Id FROM INSERTED;
            SELECT @Salary = Salary FROM INSERTED;
        END
    END
    ELSE
    BEGIN
        SET @EventType = 'DELETE';
        SELECT @Name = CONCAT(First_Name, ' ', Last_Name) FROM DELETED;
        SELECT @Dep_Id = Department_Id FROM DELETED;
        SELECT @Salary = Salary FROM DELETED;
    END;

    INSERT INTO Save_Backup (Name, Department_Name, Salary, EventType, EventDate)
    VALUES (@Name, @Dep_Id, @Salary, @EventType, GETDATE());
END;

select * from Save_Backup;





--------------------a-------------------

select * from Employees where Last_Name like 's%%' ;

--------------------b-------------------

select * from Employees where First_Name like '%an%' ;

--------------------a-------------------

select * from Employees where Last_Name like '%%son' ;




-------------------Table Student-------------------------

create table Course (
	id int primary key identity,
	Course_Name varchar(50),
	Instructor varchar(50)
);

insert into Course (Course_Name,Instructor) values ('Computer Science','Noman Ejaz'),('Cyber Security','Furqan Aziz'),('Web Development','Gulam');

create table Students (
	Student_Id int primary key identity,
	First_Name varchar(50),
	Last_Name varchar(50),
	Age int,
	Percentage int,
	Course int,

	FOREIGN KEY (Course) REFERENCES Course(id)
);

insert into Students (First_Name,Last_Name,Age,Percentage,Course) values
('Eva','Long',18,78,1),('Daniel','Cliff',25,85,2),('Robert','Drown',19,65,3),
('Kate','Willson',23,98,1),('Kate','Willson',23,65,2);



-----------------------a--------------------------

select * from Students where Percentage = (select max(Percentage) from Students) ;


------------------------b----------------------------

select c.Course_Name , COUNT(s.First_Name) as Enrolled_Students from Students as s right join 
Course as c on s.Course = c.id Group By c.Course_Name , c.id order by c.id;


------------------------c------------------------------


select AVG(Percentage) as Average_Percentage from Students where Course = 1 ;