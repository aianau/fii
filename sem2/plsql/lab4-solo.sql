-- noinspection SqlWithoutWhereForFile

create or replace type medii is table of number(2,0);
/
alter table studenti add medii_student medii
nested table medii_student store as medii_student;
/
update studenti
set
    medii_student = medii();
/
select * from studenti;
/

declare 
    n_sids num_arr;
    n_values num_arr;
    s_ids num_arr;
    medie number;
begin 
    select sids, nvalues
    bulk collect into n_sids, n_values
    from (select id_student as sids, valoare as nvalues
        from note);
    select sids
    bulk collect into s_ids
    from (select id as sids
        from studenti);
    
    for i in 1..s_ids.count loop
        for an in 1..3 loop
            for semestru in 1..2 loop
                select avg(n.valoare)
                into medie 
                from note n join cursuri c on n.id_curs=c.id
                where n.id_student=s_ids(i) and c.an=an and c.semestru=semestru;
                
                update studenti
                set medii_student = medii_student multiset union medii(medie)
                where id=s_ids(i);
            end loop;
        end loop;
    end loop;
    
end;
/

CREATE OR REPLACE FUNCTION NUMAR_MEDII(id_stud_in in studenti.id%type)
return number
as 
    student studenti%ROWTYPE;
begin
    select * 
    into student
    from studenti
    where id_stud_in=id;
    
    return student.medii_student.count;
end;
/

begin
    dbms_output.put_line(numar_medii(100));
end;
/

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- sau mai interesant (ce mi-a venit dupa ceva timp de gandire)
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

select * from STUDENTI;

alter table studenti add medii_student medii
nested table medii_student store as medii_student;
/
create or replace type medie as object
(
    valoare numeric,
    an number(1),
    semestru number(1)
);

create or replace type medii is table of medie;

alter table STUDENTI add medii_student medii
nested table medii_student store as medii_student;

create or replace package pck_medii
as
    cursor medii_studenti is
        select s.id as sid, avg(n.valoare) as nvaloare, c.an as can, c.semestru as csemestru
        from studenti s join note n on s.ID = n.ID_STUDENT join CURSURI c on n.ID_CURS = c.ID
        group by c.an, c.semestru, s.id;

    procedure initializare;
    procedure update_medii_studenti;
    function numar_medii(id_stud_in in numeric) return numeric;
end pck_medii;

create or replace package body pck_medii
as
    procedure initializare
        as
        begin
            update STUDENTI set STUDENTI.medii_student = medii();
            end;

    procedure update_medii_studenti
        as
        begin
            for record in medii_studenti loop
                insert into table (select MEDII_STUDENT from studenti where id=record.sid) values(medie(record.nvaloare, record.can, record.csemestru));
                end loop;
            end;
    function numar_medii(id_stud_in in numeric) return numeric
    as
        medie_student MEDII;
        begin
            select MEDII_STUDENT
            into medie_student
                from STUDENTI
                    where id=id_stud_in;

            return medie_student.count;
            end;
end pck_medii;


begin
    pck_medii.initializare();
    pck_medii.update_medii_studenti();
    DBMS_OUTPUT.PUT_LINE(pck_medii.numar_medii(100));
end;

select * from STUDENTI;