drop user STUDENT;
CREATE USER STUDENT IDENTIFIED BY STUDENT DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;--se creeaza un user cu numele student
ALTER USER STUDENT QUOTA 100M ON USERS; -- v-ati alocat maxim 100mb spatiu pe baza de date
GRANT CONNECT TO STUDENT; -- userul a primit dreptul sa se conecteze la baza de date
GRANT CREATE TABLE TO STUDENT; -- userul a primit dreptul sa creeze tabele, constrainturi si indecsi
GRANT CREATE VIEW TO STUDENT; -- userul a primit dreptul sa creeze viewuri
GRANT CREATE SEQUENCE TO STUDENT; -- userul a primit dreptul sa creeze secvente
GRANT CREATE TRIGGER TO STUDENT; -- userul a primit dreptul sa creeze triggere
GRANT CREATE SYNONYM TO STUDENT; -- userul a primit dreptul sa creeze sinonime
GRANT CREATE PROCEDURE TO STUDENT; -- userul a primit dreptul sa creeze proceduri, functii si pachete
GRANT SELECT_CATALOG_ROLE TO STUDENT; -- userul a primit un rol si prin acesta un set de permisiuni prin care va putea accesa anumite viewuri sistem.
GRANT EXECUTE_CATALOG_ROLE TO STUDENT; -- userul a primit un alt rol si prin acesta un set de permisiuni prin care va putea executa functii si proceduri din pachete sistem. 
CONN STUDENT/STUDENT@localhost/XE -- conexiune cu userul proaspat creat.

edit --se deschide deschide editorul implicit pentru a edita continutul bufferului.
--Acest editor trebuie inchis pentru a putea rula din nou continutul bufferului (cu RUN sau /);

--2. Inseraţi în baza de date nou creat�? un student Popescu Ionut, 
proaspat înmatriculat în anul 2 care a luat nota 10 la materia Logica pentru informatica predata de Cristian Masalagiu în primul semestru din anul 1*/
insert into studenti values ('124','Popescu','Ionut',2,null,null,to_date('10/05/1997', 'dd/mm/yyyy'));
insert into note values('124',21,10,to_date('10/02/2016','dd/mm/yyyy'));
/
delete from studenti where nr_matricol=124;
/
--alta varianta de a insera date intr-un tabel
insert into studenti(nr_matricol,nume,prenume,an,data_nastere) values ('124','Popescu','Ionut',2,to_date('10/05/1997', 'dd/mm/yyyy'));
insert into note values('124',21,10,to_date('10/02/2016','dd/mm/yyyy'));
/
--Inserare multipla intr-un tabel
--dorim sa inseram mai mult de un student in tabela studenti
insert all 
	into studenti(nr_matricol,nume,prenume) values('1','nume1','prenume1')
	into studenti(nr_matricol,nume,prenume) values('2','nume2','prenume2')
	into studenti(nr_matricol,nume,prenume) values('3','nume3','prenume3')
select * from dual;	
/
select * from studenti;

--Inserare in mai mult de o tabela
--dorim sa inseram atat doi studenti cat si un curs
insert all
	into studenti(nr_matricol,nume,prenume) values('4','nume4','prenume4')
	into studenti(nr_matricol,nume,prenume) values('5','nume5','prenume5')
	into cursuri (id_curs,titlu_curs) values ('30','P.A')
select * from dual;	
/
select * from studenti;
select * from cursuri;

--Creati tabelul studenti_nerestantieri (in care vom insera doar studentii ce au note mai mari sau egale cu 5)
create table studenti_nerestantieri(
	nr_matricol char(4) not null,
	titlu_curs varchar2(15) not null,
	valoare number(2)
		constraint ck_valoare check (valoare between 5 and 10),
		primary key(nr_matricol,titlu_curs));
--inseram studentii impreuna doar cu cursurile la care au luat nota de trecere
insert into studenti_nerestantieri
select n.nr_matricol,titlu_curs,valoare
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
where valoare>=5;
/
select * from studenti_nerestantieri
order by 1,3 desc;
/
--daca dorim sa setam o alta schema
connect hr
alter session set current_schema=student;
select * from studenti;




