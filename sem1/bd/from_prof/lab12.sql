--Variabile de substitutie
--exemple
--1.
SELECT *
FROM studenti
WHERE an=&an AND nume like '&nume';

--2.
SELECT nume, &camp_afisare--(an)*/
FROM studenti
WHERE &conditie2--(an>1)*/
ORDER BY &camp_sortare--(1)*/;

--3.
DEFINE camp=prenume
SELECT nume, &camp
FROM studenti
ORDER BY &camp;
undefine camp;

--Comenzi DML
--inserare date
INSERT INTO cursuri VALUES(30, 'Inv. automata', 3, 1, 5);
INSERT INTO cursuri (ID_curs, titlu_curs) VALUES(31, 'NoSQL');

--sau (se modifica 5 linii - la cursul cu id-ul 30 inseram note de 10, cu data de notare ziua curenta, pentru std din anul 3)
INSERT INTO note 
SELECT nr_matricol, 30, 10, SYSDATE
FROM studenti
WHERE an=3;
/
select * from note;

--Secvente
drop sequence s1;
/
CREATE SEQUENCE s1
  INCREMENT BY 2
  START WITH 10
  MAXVALUE 15;

SELECT s1.NEXTVAL FROM DUAL;
--Exercitii
--1.Cum poate fi utilizat�? o secvenț�? la inserare? R�?spundeți creând o secvenț�? care
--sa v�? ajute sa inserați noi cursuri cu id unic, cu intrari consecutive cresc�?toare cu pasul 1. 
--Inserati 3 cursuri noi cu id-ul generat de secventa.
drop sequence seq_idcurs;
/
create sequence seq_idcurs
increment by 1
start with 1
maxvalue 3;
/ 
insert into cursuri(id_curs,titlu_curs) values (seq_idcurs.nextval,'curs1'); 
insert into cursuri(id_curs,titlu_curs) values (seq_idcurs.nextval,'curs2'); 
insert into cursuri(id_curs,titlu_curs) values (seq_idcurs.nextval,'curs3'); 
insert into cursuri(id_curs,titlu_curs) values (seq_idcurs.nextval,'curs4'); --not ok
/
select * from cursuri;
--Actualizarea înregistr�?rilor
--Exemplu
UPDATE studenti
SET bursa=bursa*0.15 
WHERE bursa<300;

--Exercitii
--1.Actualizati valoarea bursei pentru studentii care au m�?car o not�? de 10. Acestia vor primi ca bursa 500RON.
--varianta cu operatorul exists
update studenti s1
set bursa = 500
where exists( 
	select 'X'
	from studenti s2 join note n on s2.nr_matricol=n.nr_matricol
	where n.valoare=10 and s1.nr_matricol=s2.nr_matricol);

--varianta cu operatorul in
update studenti s1
set bursa = 500
where nr_matricol in( 
	select s2.nr_matricol
	from studenti s2 join note n on s2.nr_matricol=n.nr_matricol
	where n.valoare=10 and s1.nr_matricol=s2.nr_matricol);
	
	
--2.Toti studentii primesc o bursa egala cu 100*media notelor lor. Efectuati modificarile necesare.
update studenti s
set bursa = (select 100*avg(valoare) from note n where s.nr_matricol = n.nr_matricol);


--�?tergerea înregistr�?rilor
--Exercitii
--1.Stergeti toti studentii care nu au nici o nota.
delete from studenti
where nr_matricol in
	(select s.nr_matricol from studenti s left join note n on n.nr_matricol=s.nr_matricol
	where valoare is null);
/
select * from studenti;

--alta varianta
delete from studenti
where nr_matricol not in
	(select s.nr_matricol from studenti s join note n on n.nr_matricol=s.nr_matricol);
/
select * from studenti;

--alta varianta (cea mai simpla)
delete from studenti
where nr_matricol not in
	(select nr_matricol from note);
/
select * from studenti;

--Comenzi DDL - creare/modificare structuri de date
--create table as
--1.Executati comanda ROLLBACK. Creati apoi o tabel�? care s�? stocheze numele, prenumele, bursa si mediile studentilor.
rollback;
/
drop table test_student;
/
create table test_student
as 
select nume,prenume,nvl(to_char(bursa),'nu are bursa') as bursa,nvl(to_char(round(avg(valoare),2)),'nu are note !') as medie
from studenti s left join note n on n.nr_matricol=s.nr_matricol 
group by s.nr_matricol,nume,prenume,nvl(to_char(bursa),'nu are bursa')
order by 4 desc;
/
select * from test_student;

--ALTER TABLE
--Exemple
--1.adaugare de noi coloane
ALTER TABLE cursuri ADD (abreviere CHAR(2) NULL,descriere VARCHAR(40) DEFAULT 'curs obligatoriu');
desc cursuri;
--2.stergerea unei coloane
ALTER TABLE cursuri DROP COLUMN descriere;
desc cursuri;
--3.cresterea dimensiunii unor campuri existente
ALTER TABLE profesori MODIFY (nume VARCHAR(20),prenume VARCHAR(20));
desc profesori;
--4.schimbarea denumirii unei coloane
ALTER TABLE note RENAME COLUMN valoare TO nota;
desc note;
--5.schimbarea denumirii unei tabele
ALTER TABLE profesori RENAME TO cadre_didactice;
--6.adaugarea cheii primare la o tabela
ALTER TABLE studenti ADD CONSTRAINT pk_studs PRIMARY KEY (nr_matricol);
desc studenti;
--7.adaugarea cheii straine la o tabela (dependenta referentiala)
ALTER TABLE note ADD CONSTRAINT fk_studs FOREIGN KEY (nr_matricol) REFERENCES studenti(nr_matricol) ON DELETE CASCADE;
desc note;
--8.stergerea unei constrangeri
ALTER TABLE note DROP CONSTRAINT fk_studs;

--Exercitii
1--1.Ad�?ugați constrângerile de tip cheie primar�? pentru tabelele Studenti, Profesori, Cursuri.
ALTER TABLE studenti ADD CONSTRAINT pk_studs PRIMARY KEY (nr_matricol);--ok
--pentru profesori nu va merge deoarece in tabela profesori avem chei duplicat !
ALTER TABLE profesori ADD CONSTRAINT pk_profs PRIMARY KEY (id_prof);
--corectam 
update profesori set id_prof='p23' where nume='Nastasa';
update profesori set id_prof='p24' where nume='PASAT';
--acum va merge !
ALTER TABLE profesori ADD CONSTRAINT pk_profs PRIMARY KEY (id_prof);
--pentru cursuri e ok
ALTER TABLE cursuri ADD CONSTRAINT pk_curs PRIMARY KEY (id_curs);

--2.Ad�?ugați constrângerile referențiale pentru tabelele Note si Didactic
ALTER TABLE note ADD CONSTRAINT fk_studs FOREIGN KEY (nr_matricol) REFERENCES studenti(nr_matricol);-- ON DELETE CASCADE;
ALTER TABLE note ADD CONSTRAINT fk_curs_note FOREIGN KEY (id_curs) REFERENCES cursuri(id_curs);-- ON DELETE CASCADE;
ALTER TABLE didactic ADD CONSTRAINT fk_curs FOREIGN KEY (id_curs) REFERENCES cursuri(id_curs);-- ON DELETE CASCADE;
ALTER TABLE didactic ADD CONSTRAINT fk_profs FOREIGN KEY (id_prof) REFERENCES profesori(id_prof);-- ON DELETE CASCADE;
alter table didactic add constraint pk_did primary key(id_prof,id_curs);
-------------------
delete from didactic 
where id_prof='p1';
/
select * from didactic;
--sa incercam sa stergem un curs din tabela de baza, cursuri...va merge? daca nu, de ce?
--pentru ca id_curs din tabela cursuri este referentiat si in tabela note !
--mai intai se sterg inregistrarile copil (adica liniile din tabela de legatura, note in cazurl de fata), iar apoi inregistrarea parinte (din tabela de baza, cursuri)
delete from cursuri
where id_curs=25;
/
select * from didactic;

--3.Impuneți constrângerea ca un student s�? nu aib�? mai mult de o not�? la un curs.
alter table note add constraint un_valoare_curs unique(nr_matricol,id_curs);

--4.Impuneți constrângerea ca valoarea notei s�? fie cuprins�? între 1 și 10.
alter table note drop constraint ck_valoare1;
alter table note add constraint ck_valoare1 check(valoare between 1 and 10);

--Tranzactii
--exemplu clasic de tranzactie
drop table T;
create table T(c integer);
insert into T values(1);
select * from T;
alter table T add (d integer);
insert into T values (2,null);
select * from T;
rollback;
select * from T;--daca dupa insert into T values (2,null) se da commit, atunci rollback nu mai influenteaza, se afiseaza 1 si 2 !

--1.Asigurati-va c�? începeți o nou�? tranzacție.
--2.�?tergeți toate înregistr�?rile din tabela Profesori.
delete from profesori;
--3.Inserați un profesor.
insert into profesori values ('p1','nume1','prenume1','prof');
--4.Marcați starea curent�? ca 's1'.
savepoint s1;
--5.Schimbați numele profesorului inserat.
update profesori
set nume = 'nume_1'
where nume='nume1';
--6.Vizualizați datele.
select * from profesori;
--7.Reveniți la starea s1.
rollback to s1;
--8.Vizualizați datele.
select * from profesori;
--9.Reveniți la starea de dinaintea ștergerii.
rollback;
/
select * from profesori;

