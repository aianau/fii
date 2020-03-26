-- Exercitii (5pt)
-- Dupa cum puteti observa din scriptul de creare, toti studentii au note la materia logica. Asta inseamna ca o noua
-- nota nu ar trebui sa fie posibil sa fie inserata pentru un student si pentru aceasta materie (nu poti avea doua note
-- la aceeasi materie). Construiti o constrangere care sa arunce o exceptie cand regula de mai sus este incalcata (poate
-- fi unicitate pe campurile id_student+id_curs, index unique peste aceleasi doua campuri sau cheie primara peste cele
-- doua).
--
-- Prin intermediul unui script PLSQL incercati de 1 milion de ori sa inserati o nota la materia logica. Pentru aceasta
-- aveti doua metode:
--
-- - sa vedeti daca exista nota (cu count, cum deja ati mai facut) pentru studentul X la logica si sa inserati doar daca
-- nu exista.
-- - sa incercati sa inserati si sa prindeti exceptia in caz ca aceasta este aruncata.
-- Implementati ambele metode si observati timpii de executie pentru fiecare dintre ele. (3pct)
--
--
-- Construiti o functie PLSQL care sa primeasca ca parametri numele si prenumele unui student si care sa returneze media
-- si, in caz ca nu exista acel student (dat prin nume si prenume) sa arunce o exceptie definita de voi. Dintr-un bloc
-- anonim care contine intr-o structura de tip colectie mai multe nume si prenume (trei studenti existenti si trei care
-- nu sunt in baza de date), apelati functia cu diverse valori. Prindeti exceptia si afisati un mesaj corespunzator
-- atunci cand studentul nu exista sau afisati valoarea returnata de functie daca studentul exista. (2pct)


-- Tema (2pt)
-- Demonstrati prinderea unei exceptii aruncate de catre aplicatia PLSQL intr-un limbaj de programare la algere (aruncati din PLSQL si prindeti in JAVA / PHP / ce vreti voi).

ALTER TABLE note
    ADD CONSTRAINT nota_unica UNIQUE (id_student, id_curs);

CREATE OR REPLACE PACKAGE lab5 IS
    tuplu_inexistent exception;
    pragma exception_init ( tuplu_inexistent, -20001 );
    student_inexistent exception;
    PRAGMA EXCEPTION_INIT (student_inexistent, -20002);
    student_fara_note EXCEPTION;
    PRAGMA EXCEPTION_INIT (student_fara_note, -20003);
    PROCEDURE verificare_numarare_validare(id_student_in in studenti.id%type, id_curs_in in cursuri.id%type);
    PROCEDURE verificare_numarare_exceptie(id_student_in in studenti.id%type, id_curs_in in cursuri.id%type);
    PROCEDURE aruncare_exceptie_direct(id_student_in in studenti.id%type, id_curs_in in cursuri.id%type);
    FUNCTION calcul_medie(v_nume_in IN VARCHAR2, v_prenume_in IN VARCHAR2) RETURN NUMERIC;
END lab5;

CREATE OR REPLACE PACKAGE BODY lab5 IS
    PROCEDURE verificare_numarare_validare(id_student_in in studenti.id%type, id_curs_in in cursuri.id%type) AS
        numar_studenti NUMERIC;
    BEGIN
        select count(id) into numar_studenti from note where id_student = id_student_in AND id_curs = id_curs_in;
        IF numar_studenti = 0 THEN
            insert into note (id, id_student, id_curs)
            values ((select max(id) + 1 from note), id_student_in, id_student_in);
        END IF;
    END verificare_numarare_validare;

    PROCEDURE verificare_numarare_exceptie(id_student_in in studenti.id%type, id_curs_in in cursuri.id%type) AS
        exista_tuplu NUMERIC;
    BEGIN
        select count(id) into exista_tuplu from note where id_student = id_student_in AND id_curs = id_curs_in;
        IF exista_tuplu != 0 THEN
            raise tuplu_inexistent;
        else
            insert into note (id, id_student, id_curs)
            values ((select max(id) + 1 from note), id_student_in, id_curs_in);
        END IF;
    exception
        when tuplu_inexistent then
            DBMS_OUTPUT.PUT_LINE('studentul cu id ' || id_student_in || ' si cursul ' || id_curs_in ||
                                 ' este ca tuplu duplicat in baza de date');

    END verificare_numarare_exceptie;

    PROCEDURE aruncare_exceptie_direct(id_student_in in studenti.id%type, id_curs_in in cursuri.id%type) AS
    BEGIN
        insert into note (id, id_student, id_curs) values ((select max(id) + 1 from note), id_student_in, id_curs_in);
    exception
        when dup_val_on_index then
            DBMS_OUTPUT.PUT_LINE('studentul cu id ' || id_student_in || ' si cursul ' || id_curs_in ||
                                 ' este ca tuplu duplicat in baza de date');
    END aruncare_exceptie_direct;

    FUNCTION calcul_medie(v_nume_in IN VARCHAR2, v_prenume_in IN VARCHAR2) RETURN NUMERIC IS
        medie       NUMERIC(4, 2);
        numar_tuple numeric;
    BEGIN
        SELECT COUNT(*) INTO numar_tuple FROM studenti WHERE nume = v_nume_in AND prenume = v_prenume_in;
        IF numar_tuple = 0 THEN
            raise student_inexistent;
        END IF;

        SELECT COUNT(*)
        INTO numar_tuple
        FROM STUDENTI s
                 JOIN note n ON s.id = n.id_student
        WHERE s.nume = v_nume_in
          AND s.prenume = v_prenume_in;
        IF numar_tuple = 0 THEN
            raise student_fara_note;
        END IF;

        SELECT AVG(valoare)
        INTO medie
        FROM note n
                 JOIN studenti s ON s.id = n.id_student
        WHERE s.nume = v_nume_in
          AND s.prenume = v_prenume_in;
        return medie;
    END calcul_medie;
END lab5;


select *
from STUDENTI;

begin
    DBMS_OUTPUT.PUT_LINE(lab5.CALCUL_MEDIE('Condurache', 'Paula'));
end;

----------------------------------------------------------------------------------------------------------------exercitiul 2;

create or replace type nume_prenume_object as object
(
    nume    varchar2(15),
    prenume varchar2(15)
);
/

DECLARE
    TYPE lista_studenti_type IS TABLE OF nume_prenume_object;
    lista_studenti lista_studenti_type;
    medie      NUMERIC(5, 2);
BEGIN
    lista_studenti := lista_studenti_type();

    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('andrei', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('123', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('321421', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('ewqewq', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('ewqewq', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('ewq', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('eqw', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('anrrewqdrei', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('anewqewqdrei', 'ianau'));
    lista_studenti := lista_studenti MULTISET union lista_studenti_type(nume_prenume_object('aewqewqndrei', 'ianau'));

    for i in 1..lista_studenti.COUNT
        LOOP
            BEGIN
                medie := lab5.calcul_medie(lista_studenti(i).NUME, lista_studenti(i).PRENUME);
                dbms_output.put_line(
                            'Studentul ' || lista_studenti(i).NUME || ' ' || lista_studenti(i).PRENUME || ' are media: ' || medie);
            EXCEPTION
                WHEN lab5.student_inexistent THEN
                    dbms_output.put_line('Studentul ' || lista_studenti(i).NUME || ' ' || lista_studenti(i).PRENUME ||
                                         ' nu exista in baza de date');
                WHEN lab5.student_fara_note THEN
                    dbms_output.put_line('Studentul ' || lista_studenti(i).NUME || ' ' || lista_studenti(i).PRENUME || ' nu are note');
            END;
        END LOOP;
END;

