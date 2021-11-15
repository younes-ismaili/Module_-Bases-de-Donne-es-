
--A 1)
create database Devior_2
use Devior_2
create table client(
Num_d int not null identity(1,1),
Nom varchar(50) not null,
dat_n date not null,
tel varchar(50) not null
primary key(Num_d)
);
create table compte(
Num_cpt int not null identity(1,1),
typ varchar(50) not null,
Num_d int 
primary key(Num_cpt)
Foreign key(Num_d) References client(Num_d)
);
create table operation(
Num_opn int not null identity(1,1),
Nom_opn varchar(50) not null,
typ varchar(50) not null,
date_opration datetime not null,
date_valour datetime not null,
montent decimal(10,2) not null,
Num_cpt int 
primary key(Num_opn)
foreign key(Num_cpt) references compte(Num_cpt)
);
alter table client add constraint CK_client_dateNaissance check( Datediff(YEAR,DateNaissance,getdate() )>18)
alter table client add constraint Ck_Client_tel check(Tel like '+212[56][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
alter table client add constraint  CK_Operation_type  check ( typ in ('+','-'));
insert into client values('cl1','6/6/1999','+212629471247'),('cl2','22/8/2000','+212622246079'),
('cl3','9/8/1999','+212658975246'),('cl4','30/9/1998','+212625892245')
insert into Compte values('TDER','9/12/2020',8),('ZAGF','30/12/2020',2)
insert into operation values('OP1','+','14/12/2020',309,8),('OP2','-','12/3/2020',400,12),('OP3','+','16/1/2021',900,21)
insert into operation (Nom_opn,date_opration,montent,Num_cpt) values('OP4','9/8/2021',900,9)
--B
--1)
select Num_d,Nom,FLOOR(DATEDIFF(DAY,dat_n,GETDATE())/365.25) as "Age",Tel from Client where Tel like'_5%045' order by Age
--2)
select * from Compte where Num_cpt not in (select distinct Num_cpt from Operation where MONTH(date_opration)=MONTH(GETDATE()))
--3)
select c.Num_d,ISNULL(Somme_Créditeurs,0) - ISNULL(Somme_Créditeurs,0) as "solde"
from(select c.Num_d,SUM(o.montent) as "Somme_Créditeurs" from Operation o inner join Compte c on o.Num_cpt=c.Num_cpt
where o.typ='+' group by c.Num_d) c left outer join (select c.Num_d,SUM(o.montent) as "Somme_Débiteurs" from Operation
o inner join Compte c on o.Num_cpt=c.Num_cpt where o.typ='-'group by c.Num_d) d on c.Num_d=d.Num_d

--4)
select c.*from (select c.Num_d,ISNULL(Somme_Créditeurs,0) - ISNULL(Somme_debiteurs,0) as "Solde"
from(select c.Num_d,SUM(o.montent) as "Somme_Créditeurs" from Operation o inner join Compte c on o.Num_cpt=c.Num_cpt
where o.typ='+'group by c.Num_d) c left outer join(select c.Num_d,SUM(o.montent) as "Somme_debiteurs"
from Operation o inner join Compte c on o.Num_cpt=c.Num_cpt where o.typ='-'group by c.Num_d) d
on c.Num_d=d.Num_d ) cs inner join Client c on cs.Num_d=c.Num_d where cs.Solde>10000

--5)

select *from Compte where Num_cpt in ( select distinct Num_cpt from Operation where typ='+'and DATEDIFF(DAY,date_opration,GETDATE())<=3)and 
Num_cpt in( select distinct Num_cpt from Operation where typ='-'and DATEDIFF(DAY,date_opration,GETDATE())<=3)
--C
--1)
delete from Compte where Num_cpt not in (select distinct Num_cpt from Operation)
--2)
update Operation set montent=case when typ='+' then montent*1.1when typ='-' then montent*0.9
else montent end where CAST(date_opration as DATE)=cast(GETDATE() as DATE) and Num_cpt=100  
--D
--1)
create login cli1 with password='98745',default_database=Devior_2
create login cli2 with password='63595',default_database=Devior_2
--2)
create user cli1 for login cli1
create user cli2 for login cli2
--3)

--4)
grant update,select on Object::Operation to cli1,cli2
select *from client
select *from  operation
select * from compte
