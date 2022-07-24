-- Exercitiu (5pt)
-- Sa se construiasca un view ca fiind joinul dintre tabelul studenti, note si cursuri, cu rolul de catalog: va contine
-- numele si prenumele studentului, materia si nota pe care studentul a luat-o la acea materie.

create or replace view catalog as
select S.nume, S.prenume, C.TITLU_CURS, N.VALOARE
from STUDENTI S
         join NOTE N on S.ID = N.ID_STUDENT
         join CURSURI C on N.ID_CURS = C.ID;

select *
from catalog;

-- Dupa cum va puteti da seama, operatii de genul INSERT nu sunt permise pe acest view din cauza ca ar trebui sa
-- inserati datele in toate tabelele. Totusi, cu ajutorul unui trigger, puteti sa verificati existenta studentului
-- (si sa il creati daca nu exista), existenta materiei (si sa o creati daca nu exista) sau a notei.

-- Construiti triggere pentru realizarea de operatii de tipul INSERT, UPDATE si DELETE pe viewul creat, care sa
-- genereze date random atunci cand sunt adaugate informatii inexistente (de exemplu daca faceti insert cu un student
-- inexistent, va genera un nr matricol, o bursa, grupa, an etc pentru acel student sau un numar de credite si un an,
-- semestru pentru un curs, etc.)
--
-- Cazuri posibile:
--
-- Stergerea unui student si totodata a notelor sale (fara a folosi cascade constraints);
-- Inserarea unei note la un curs pentru un student inexistent cu adaugarea studentului;
-- Inserarea unei note la un curs pentru un curs inexistent - cu adaugarea cursului;
-- Inserarea unei note cand nu exista nici studentul si nici cursul.
-- Update la valoarea notei pentru un student - se va modifica valoarea campului updated_at. De asemenea, valoarea
-- nu poate fi modificata cu una mai mica (la mariri se considera nota mai mare).
-- ex: INSERT INTO CATALOG VALUES ('Popescu', 'Mircea', 10, 'Yoga');

-- Stergerea unui student si totodata a notelor sale (fara a folosi cascade constraints);
CREATE OR REPLACE TRIGGER detele_student_note
    INSTEAD OF delete
    ON catalog
declare
    v_id_student STUDENTI.id%type := -1;
BEGIN
    dbms_output.put_line('Stergem pe:' || :OLD.nume);
    select ID
    into v_id_student
    from STUDENTI
    where :OLD.nume = nume
      and :OLD.prenume = prenume;

    if F_EXISTA_STUDENT(v_id_student) then
        delete from note n where n.ID_STUDENT = v_id_student;
        delete from prieteni where id_student1 = v_id_student;
        delete from prieteni where id_student2 = v_id_student;
        delete from studenti where id = v_id_student;
    end if;
END;

-- Inserarea unei note la un curs pentru un student inexistent cu adaugarea studentului;
-- Inserarea unei note la un curs pentru un curs inexistent - cu adaugarea cursului;
-- Inserarea unei note cand nu exista nici studentul si nici cursul.
-- ex: INSERT INTO CATALOG VALUES ('Popescu', 'Mircea', 10, 'Yoga');
CREATE OR REPLACE TRIGGER insert_nota_catalog
    INSTEAD OF insert
    ON catalog
declare
    v_id_student   STUDENTI.id%type := -1;
    v_date_random  STUDENTI.data_nastere%type;
    v_email_random STUDENTI.email%type;
    v_id_curs      CURSURI.id%type;
BEGIN
    select ID
    into v_id_student
    from STUDENTI
    where :NEW.nume = nume
      and :NEW.prenume = prenume;

    select ID
    into v_id_curs
    from CURSURI
    where :NEW.titlu_curs = TITLU_CURS;

    dbms_output.put_line('Inseram nota:' || :NEW.VALOARE);
    if not F_EXISTA_STUDENT(v_id_student) then
        SELECT TO_DATE(
                       TRUNC(
                               DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01', 'J')
                                   , TO_CHAR(DATE '2012-12-31', 'J')
                                   )
                           ), 'J'
                   )
        into v_date_random
        FROM DUAL;

        select DBMS_RANDOM.string('U', 7) || '@' || DBMS_RANDOM.string('U', 7) || '.com'
        into v_email_random
        from dual;

        select max(ID) + 1
        into v_id_student
        from STUDENTI;

        insert into STUDENTI
        values ( v_id_student, DBMS_RANDOM.string('x', 6), :NEW.nume, :new.prenume
               , TRUNC(DBMS_RANDOM.value(1, 4)), DBMS_RANDOM.string('U', 1) || TRUNC(DBMS_RANDOM.value(1, 2))
               , TRUNC(DBMS_RANDOM.value(1, 600)), v_date_random, v_email_random, sysdate, sysdate);
    end if;

    if not F_EXISTA_CURS(v_id_curs) then
        select max(ID) + 1
        into v_id_curs
        from CURSURI;

        insert into CURSURI
        values ( v_id_curs, :NEW.titlu_curs
               , TRUNC(DBMS_RANDOM.value(2000, 2021)), TRUNC(DBMS_RANDOM.value(1, 3))
               , TRUNC(DBMS_RANDOM.value(1, 7)), sysdate, sysdate);
    end if;

    SELECT TO_DATE(
                   TRUNC(
                           DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01', 'J')
                               , TO_CHAR(DATE '2012-12-31', 'J')
                               )
                       ), 'J'
               )
    into v_date_random
    FROM DUAL;

    insert into NOTE
    values ((select max(id) from note) + 1,
            v_id_student,
            v_id_curs,
            :NEW.valoare,
            v_date_random,
            sysdate,
            sysdate);
END;

-- Update la valoarea notei pentru un student - se va modifica valoarea campului updated_at. De asemenea, valoarea
-- nu poate fi modificata cu una mai mica (la mariri se considera nota mai mare).
CREATE
    OR
    REPLACE TRIGGER marire_nota_catalog
    instead of update
    ON catalog
    FOR EACH ROW
declare
    v_id_student   STUDENTI.id%type := -1;
    v_id_curs      CURSURI.id%type;
BEGIN
    select ID
    into v_id_student
    from STUDENTI
    where :NEW.nume = nume
      and :NEW.prenume = prenume;

    select ID
    into v_id_curs
    from CURSURI
    where :NEW.titlu_curs = TITLU_CURS;

    IF :OLD.valoare < :NEW.valoare THEN
        update note n set n.VALOARE=:NEW.valoare, n.UPDATED_AT=sysdate
        where n.ID_STUDENT=v_id_student and n.ID_CURS=v_id_curs;
    end if;
END;