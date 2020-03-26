--Grupa B5
/*1.(1p) Avand exemplele trimise, creati un pachet pentru 3 din functiile trimise. Apelati apoi una din aceste functii, in 
cadrul pachetului.*/
CREATE OR REPLACE PACKAGE pck_test IS
    PROCEDURE p_afiseaza_varsta;--daca se cere sa se afiseze random

    FUNCTION f_exista_student (
        in_id IN studenti.id%TYPE
    ) RETURN BOOLEAN;--functie ajutatoare

    FUNCTION f_are_note (
        in_id_student IN note.id_student%TYPE
    ) RETURN BOOLEAN;--functie ajutatoare

    FUNCTION f_exista_in_prieteni (
        in_id_student IN prieteni.id_student1%TYPE
    ) RETURN BOOLEAN;--functie ajutatoare

END pck_test;
/

CREATE OR REPLACE PACKAGE BODY pck_test IS

    PROCEDURE p_afiseaza_varsta IS
        p_numar_studenti  NUMBER(5);
        p_student_random  NUMBER(5);
        p_rezultat        VARCHAR(100);
    BEGIN
        SELECT
            COUNT(*)
        INTO p_numar_studenti
        FROM
            studenti;

        p_student_random := dbms_random.value(1, p_numar_studenti);
        SELECT
            id
            || ' '
            || nume
            || ' '
            || prenume
            || ' '
            || varsta
        INTO p_rezultat
        FROM
            (
                SELECT
                    id,
                    nume,
                    prenume,
                    trunc(months_between(sysdate, data_nastere) / 12)
                    || ' ani '
                    || floor(to_number(months_between(sysdate, data_nastere) -(trunc(months_between(sysdate, data_nastere) / 12)) *
                    12))
                    || ' luni '
                    || floor(to_number(sysdate - add_months(data_nastere, trunc(months_between(sysdate, data_nastere)))))
                    || ' zile. ' AS varsta,
                    ROWNUM AS rand
                FROM
                    studenti
            )
        WHERE
            rand = p_student_random;

        dbms_output.put_line(p_rezultat);
    END p_afiseaza_varsta;

    FUNCTION f_exista_student (
        in_id IN studenti.id%TYPE
    ) RETURN BOOLEAN IS
        e_std     BOOLEAN;
        p_number  NUMBER;--0 daca studentul nu exista, 1 daca exista
    BEGIN
        SELECT
            COUNT(*)
        INTO p_number
        FROM
            studenti
        WHERE
            id = in_id;

        IF p_number = 0 THEN
            dbms_output.put_line('Studentul cu id-ul '
                                 || in_id
                                 || ' nu exista in baza de date !');
            e_std := false;
      --return false;
        ELSE
            e_std := true;
      --return true;
        END IF;

        RETURN e_std;
    END f_exista_student;

    FUNCTION f_are_note (
        in_id_student IN note.id_student%TYPE
    ) RETURN BOOLEAN IS
        e_std     BOOLEAN;
        p_number  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO p_number
        FROM
            note
        WHERE
            id_student = in_id_student;

        IF p_number = 0 THEN
            dbms_output.put_line('Studentul cu id-ul '
                                 || in_id_student
                                 || ' nu are note!');
        END IF;

        e_std := false;
        RETURN e_std;
    END f_are_note;

    FUNCTION f_exista_in_prieteni (
        in_id_student IN prieteni.id_student1%TYPE
    ) RETURN BOOLEAN IS
        e_std     BOOLEAN;
        p_number  NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO p_number
        FROM
            prieteni
        WHERE
            id_student1 = in_id_student
            OR id_student2 = in_id_student;

        IF p_number = 0 THEN
            dbms_output.put_line('Studentul cu id-ul '
                                 || in_id_student
                                 || ' nu exista in tabela de prieteni !');
        END IF;

        e_std := false;
        RETURN e_std;
    END f_exista_in_prieteni;

END pck_test;
/

DECLARE
    p_medie1  NUMBER(4, 2);
    p_medie2  NUMBER(4, 2);
BEGIN
    pck_test.p_afiseaza_varsta;
END;
/



/*2.(1p) Creati o procedura sau functie care sa returneze raportul de promovabilitate pentru materiile incluse in baza de date.*/

-------------
--Ex2
-------------

CREATE OR REPLACE PROCEDURE rata_promovabilitate IS

    p_trecuti      NUMBER := 0;
    p_total        NUMBER := 0;
    id_materie     cursuri.id%TYPE;
    titlu_materie  cursuri.titlu_curs%TYPE;
    CURSOR materii IS
    SELECT
        id,
        titlu_curs AS nume
    FROM
        cursuri;

BEGIN
    FOR i IN materii LOOP
        SELECT
            COUNT(id)
        INTO p_trecuti
        FROM
            note
        WHERE
                valoare > 4
            AND id_curs = i.id;

        SELECT
            COUNT(id)
        INTO p_total
        FROM
            note
        WHERE
            id_curs = i.id;

        dbms_output.put_line('La materia '
                             || i.nume
                             || ' raportul este '
                             || trunc(p_trecuti / p_total, 2) * 100
                             || '%');

    END LOOP;
END;
/

EXEC rata_promovabilitate;
/
/*3.(3p) Creati o procedura prin care un profesor pune note la disciplinele sale. Tratati toate exceptiile corespunzatoare (5).
Creati mai intai o tabela std_profi cu campurile id,id_student,id_prof,id_curs,valoare*/
-- nu exista student
-- nu exista profesor
-- nu exista curs
-- profesoru nu preda la cursu rspectiv
-- studentu a mai fost notat la acea disciplina

DROP TABLE std_profi;
/

CREATE TABLE std_profi (
    id          NUMBER,
    id_student  NUMBER,
    id_prof     NUMBER,
    id_curs     NUMBER,
    valoare     NUMBER
);
/

CREATE OR REPLACE FUNCTION f_exista_student (
    in_id IN studenti.id%TYPE
) RETURN BOOLEAN IS
    e_std     BOOLEAN;
    p_number  NUMBER;--0 daca studentul nu exista, 1 daca exista
BEGIN
    SELECT
        COUNT(*)
    INTO p_number
    FROM
        studenti
    WHERE
        id = in_id;

    IF p_number = 0 THEN
        dbms_output.put_line('Studentul cu id-ul '
                             || in_id
                             || ' nu exista in baza de date !');
        e_std := false;--return false;
    ELSE
        e_std := true;--return true;
    END IF;

    RETURN e_std;
END f_exista_student;
/

CREATE OR REPLACE FUNCTION f_exista_profesor (
    in_id IN profesori.id%TYPE
) RETURN BOOLEAN IS
    e_std     BOOLEAN;
    p_number  NUMBER;--0 daca studentul nu exista, 1 daca exista
BEGIN
    SELECT
        COUNT(*)
    INTO p_number
    FROM
        profesori
    WHERE
        id = in_id;

    IF p_number = 0 THEN
        dbms_output.put_line('Proful cu id-ul '
                             || in_id
                             || ' nu exista in baza de date !');
        e_std := false;--return false;
    ELSE
        e_std := true;--return true;
    END IF;

    RETURN e_std;
END f_exista_profesor;
/

CREATE OR REPLACE FUNCTION f_exista_curs (
    in_id IN cursuri.id%TYPE
) RETURN BOOLEAN IS
    e_std     BOOLEAN;
    p_number  NUMBER;--0 daca studentul nu exista, 1 daca exista
BEGIN
    SELECT
        COUNT(*)
    INTO p_number
    FROM
        cursuri
    WHERE
        id = in_id;

    IF p_number = 0 THEN
        dbms_output.put_line('Cursru cu id-ul '
                             || in_id
                             || ' nu exista in baza de date !');
        e_std := false;--return false;
    ELSE
        e_std := true;--return true;
    END IF;

    RETURN e_std;
END f_exista_curs;
/

CREATE OR REPLACE PROCEDURE p_add_nota (
    in_id_profesor     IN  profesori.id%TYPE,
    in_id_student  IN  studenti.id%TYPE,
    in_id_curs     IN  cursuri.id%TYPE,
    in_valoare     IN  note.valoare%TYPE
) AS
    num_prof_curs  NUMBER;
    num_nota_stud  NUMBER;
begin
    IF f_exista_student(in_id_student) = false THEN
        dbms_output.put_line('studentu cu id-ul '
                             || in_id_student
                             || ' nu exista in baza de date !');
    
    END IF;

    IF f_exista_profesor(in_id_profesor) = false THEN
        dbms_output.put_line('profesoru cu id-ul '
                             || in_id_profesor
                             || ' nu exista in baza de date !');
        
    END IF;

    IF f_exista_curs(in_id_curs) = false THEN
        dbms_output.put_line('cursru cu id-ul '
                             || in_id_curs
                             || ' nu exista in baza de date !');
       
    END IF;

    SELECT
        COUNT(*)
    INTO num_prof_curs
    FROM
             profesori p
        JOIN didactic  d ON p.id = d.id_profesor
        JOIN cursuri   c ON d.id_curs = c.id
    WHERE
            p.id = in_id_profesor
        AND c.id = in_id_curs;

    IF num_prof_curs = 0 THEN
        dbms_output.put_line('profu si cursu nu se pupa!');
        return;
    END IF;
    SELECT
        COUNT(*)
    INTO num_nota_stud
    FROM
             studenti s
        JOIN note     n ON s.id = n.id_student
        JOIN cursuri  c ON n.id_curs = c.id
    WHERE
            s.id = in_id_student
        AND c.id = in_id_curs;

    IF num_nota_stud > 0 THEN
        dbms_output.put_line('stud are deja nota la curs!');
        return;
    END IF;
    INSERT INTO std_profi VALUES (
        in_id_student,
        in_id_profesor,
        in_id_curs,
        valoare
    );

END;
/


BEGIN
    p_add_nota(10, 10, 10, 8);
end;   
/

