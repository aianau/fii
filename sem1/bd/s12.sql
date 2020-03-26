drop sequence seq_idcurs;

create sequence seq_idcurs
start with 50 
increment by 1
maxvalue 52;

insert into cursuri (id_curs, titlu_curs) values
                    (seq_idcurs.NEXTVAL, 'curs 1');

select * from cursuri;

-- DML data manipulation language
-- select
-- update
-- delete 
-- ^^^ sunt actualizari.

-- DDL = create, alter, 

-- 
update studenti s1
set bursa = 500
where exists (select * 
                from studenti s2 join note n on s2.nr_matricol=n.nr_matricol
                where valoare =10 and s1.nr_matricol=s2.nr_matricol);
/
select * from studenti order by bursa desc;


-- 2
update studenti s set bursa=100*(select avg(valoare)
                                from note n
                                where s.nr_matricol=n.nr_matricol);

delete from studenti s
where not exists (select * from studenti s1 join note n on s1.nr_matricol=n.nr_matricol
                    where s.nr_matricol=s1.nr_matricol);
                    

alter table studenti add constraint pk_stud primary key (nr_matricol);
alter table cursuri add constraint pk_cursuri primary key (id_curs);
alter table profesori add constraint pk_profesori primary key (id_prof);

select * from profesori;

update profesori 
set id_prof = 'p23'
where nume='Nastasa';
update profesori 
set id_prof = 'p24'
where nume='PASAT';

alter table note 
add constraint fk_nr_mat 
foreign key (nr_matricol) references studenti(nr_matricol);

alter table note 
add constraint fk_id_curs 
foreign key (id_curs) references cursuri(id_curs);

alter table note add constraint pk_note primary key (nr_matricol, id_curs);

alter table didactic 
add constraint fk_id_curs1
foreign key (id_curs) references cursuri(id_curs);

alter table didactic 
add constraint fk_id_prof
foreign key (id_prof) references profesori(id_prof);

alter table didactic add constraint pk_didactic primary key (id_prof, id_curs);

delete from profesori where id_prof='p1';

delete from cursuri where id_curs=25;

-- ce inseamna conceptul A.C.I.D. -- definitia si un exemplu practic din curs.
-- 1) 
drop table T;
create table T(c integer);
insert into T
values (1); -- DML
select * from T;

alter table T 
add (d integer); -- DDL
insert into T 
values (2, null); -- DML

rollback; -- ma duce inainte de un DDL


delete from didactic ;
delete from profesori;
insert into profesori 
values ('p1', 'nume1', 'pren1', 'prof');
save point s1
update profesori 
set nume='nume2
where nume = 'nume1';
select * from profesori;
rollback to s1;
select * from profesori;
rollback;


























