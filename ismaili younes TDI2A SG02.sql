--1)
CREATE DATABASE reservations
USE reservations
create table  Client(
IdClient int identity(1,1),
NomClient varchar(50),
AdresseClient varchar(50), 
TelClient BIGINT
primary key(IdClient)
);
create table Réservation(
CodeReservation int not null identity(1,1),
DateRes date not null, 
PensionComplete bit,
TauxReduction int not null , 
IdClient int not null
primary key(CodeReservation)
foreign key(IdClient) references Client(IdClient)
);
create table Sejour(
NumSejour int not null identity(1,1), 
CodeReservation int , 
DateSejour Date , 
TypeSejour varchar(50), 
DureeSejour int 
foreign key(CodeReservation) references Réservation(CodeReservation)
);
create table ReservationAnnulee(
CodeReservation int , 
IdClient int ,
DateAnnulation datetime
foreign key(CodeReservation ) references Réservation(CodeReservation),
foreign key (IdClient) references Client(IdClient)
);
--2)
select *  from ReservationAnnulee
insert into Client(NomClient,AdresseClient,TelClient)values('ismaili','eljadida',+2126589875),('younes','sidibaneur',+2126359874);
insert into Réservation(DateRes,PensionComplete,TauxReduction,IdClient)values(12-3-2020,'NO',6,1),(02-4-2020,'YES',5,2);
insert into Sejour( DateSejour,TypeSejour,DureeSejour,CodeReservation)values(12-6-2021,'voyage ',15,1),(1-9-2021,'voyage ',15,2);
insert into ReservationAnnulee(CodeReservation,IdClient,DateAnnulation)values(1,1,12-3-2020-02-36-56),(2,2,02-03-2021-02-36-58);
--3)
alter table Réservation  add constraint CNK_TauxReduction check((TauxReduction between 0 and 75));
--4)
update Réservation set TauxReduction +=20
where MONTH(DateRes)= MONTH(GETDATE()) and YEAR(DateRes)= YEAR(GETDATE());
--5)
select * from Sejour where 
((MONTH(DateSejour)> MONTH(GETDATE())AND YEAR(DateSejour)= YEAR(GETDATE())) OR YEAR(DateSejour)> YEAR(GETDATE()))
order by TypeSejour;

--6)
create PROC list 

@id int, @count int output
as
set @count = (select count(*) from Réservation where IdClient = @id)
go
declare @nb int
exec list 10,@nb output
select @nb [nombre des reservation]
--7)
create function annule (@id int)
returns int
as
begin
declare @count int
select @count = count(*) from ReservationAnnulee where IdClient = @id
return @count
end
declare @res int
exec @res = annule 10
select @res
--8)
create trigger verifier
on ReservationAnnulee after insert,update
as
	if exists(select * from inserted I where 
	DateAnnulation <= (select DateRes from Réservation where 
	CodeReservation = I.CodeReservation))
	begin
	raiserror('la date de annulation est',16,10)
	rollback
	end
go
--9)
backup database gestion_Reservation

