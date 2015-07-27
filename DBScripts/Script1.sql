CREATE TABLE [dbo].[Table1]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NCHAR(30) NULL, 
    [Exams] INT NULL,
	[Marks] INT NULL
)

insert into Table1 values ('a', 10, 100);
insert into Table1 values ('a', 20, 200);
insert into Table1 values ('a', 30, 400);
insert into Table1 values ('a', 40, 300);

insert into Table1 values ('b', 10, 200);
insert into Table1 values ('b', 20, 300);
insert into Table1 values ('b', 30, 300);


select * from Table1

select Name, marks from Table1 where Exams = Max(exams) group by name 

select Name, Id from Table1 where Id in 

 

;With tempTable (Name, MaxExams)
AS 
(Select Name, Max(Exams) MaxExams from Table1 group by Name
)
select * from tempTable
,
tblFinal AS (
Select * from Table1 Where Name = tempTable.Name and Exams = tempTable.Exams )


select * from MLModelTable


