--A   1)
create database gestion_projet 
use gestion_projet 
create table Servicee(
Num_serv int  identity(1,1),
Nom_serv varchar not null,
Date_creation date not null
primary key(Num_serv)

);
create table Employe(
Matricule int  not null identity(1,1),
Nom varchar(30) not null,
Prenom varchar(30) not null,
DateNaissance date not null,
Adresse varchar(50),
Salaire int not null,
Grade varchar(30),
Num_serv int 
primary key(Matricule)
FOREIGN KEY (Num_serv) REFERENCES Servicee(Num_serv)
);
create table Projet(
Num_prj int not null identity(1,1) ,
Nom_prj varchar(30) not null,
Lieu varchar(30) not null,
nbr_limite_taches int not null,
Num_serv int 
primary key(Num_prj)
foreign key (Num_serv) references Servicee(Num_serv)
);
create table Tache(
Num_tach int not null,
Nom_tache varchar(30) not null,
date_debut date not null,
date_fin date not null,
cout int not null,
Num_prj int 
primary key(Num_tach)
foreign key(Num_prj) references Projet(Num_prj)
);
create table Travaille (
Matricule int identity(1,1) ,
Num_tach int,
Nombre_heure int not null
primary key(Matricule,Num_tach)
foreign key (Matricule) references Employe(Matricule),
foreign key (Num_tach) references Tache(Num_tach)
);
alter table Employe add constraint CK_Employe_dateNaissance check( Datediff(YEAR,DateNaissance,getdate() )>=18)
alter table Employe add constraint CK_Tache_duree check(Datediff(DAY,date_debut,date_fin) >= 3)
alter table Employe add constraint CK_Tache_cout check(( Datediff(DAY,date_debut,date_fin)*1000 <=cout AND cout>=1000 )
--A 2
alter table Employe add age as (Datediff(DAY,[DateNaissance],getdate() )/365.25)
-- B 1
select Nom,DateNaissance from Employe where Nom like 'El%[^a-f]'order by DateNaissance
--B 2
select UPPER(Nom_tache) , date_fin from Tache where MONTH(date_fin)=MONTH(getdate())
--B 3
select COUNT(distinct Grade) as "nombre de grade" from Employe
--B 4
select * from Employe
--B 5
select *from Projet
where Num_prj in (select distinct Num_prj from Tache where DATEDIFF(DAY,date_debut,date_fin)<30)
and Num_prj in (select distinct Num_prj from Tache where DATEDIFF(DAY,date_debut,date_fin)>60)
--B 6
 --select Num_prj,SUM(Nombre_heure) as "Horaire"
 --B 8
 select *,DATEADD(year,Datediff(YEAR,DateNaissance,getdate()),DateNaissance) as "Dateanniversaire"from Employe
 --B 9
 select *from Projet where Num_prj in(select Num_prj from Tache
group by Num_prj having count(distinct Num_tach)=(select MAX(PT.nombre_tache)   
from (select Num_prj,count(distinct Num_tach)as "nombre_tache" from Tache group by Num_prj) as "PT"))
--B 10
select Num_prj,DATEDIFF(DAY,MIN(date_debut),max(date_fin)) as "duree realisation"from Tache group by Num_prj
--C 1
update Employe
set Salaire=case
when age >60 then Salaire+Salaire*5/100
when age between 58 and 60 then  Salaire+Salaire*0.5/100
else Salaire
end

--C 2
delete from Tache
where Num_tach in (select Num_tach from Tache where GETDATE()>date_fin) and Num_tach not in (select distinct Num_tach from Travaille)

--D 1
create login CnxGestionnaire with password='963852g'create login [ChefProjet-PC\ChefProjet] from windows

--D 2
create user Gestionnaire from login CnxGestionnaire 
create user ChefProjet from login [ChefProjet-PC\ChefProjet]

--D 3
grant insert,update,delete on Service to Gestionnaire
grant insert,update,delete on Projet to Gestionnaire
grant insert,update,delete on Tache to Gestionnaire
grant insert,update,delete on Travaille to Gestionnaire

--D 4


