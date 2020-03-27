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



