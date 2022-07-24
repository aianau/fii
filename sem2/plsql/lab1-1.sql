/*1. Avand doua IDuri de studenti (hardcodate), afisati care dintre ei are media mai mare, cu conditia ca numarul de note al fiecaruia sa fie de minim 15.
Daca media este egala, afisati care are nota mai mare la BD, asta in cazul in care amandoi au nota la BD.
Daca macar unul nu are nota la BD, afisati un mesaj corespuzator. Daca amandoi au aceeasi nota la BD, atunci amandoi sunt declarati castigatori.*/

--select de verificare (luati mai intai 2 studenti care au minim 15 note si vedeti cum merge, apoi luati macar un id de student ce are mai putin de 15 note)
--select id_student, count(*) from studenti s join note n on n.id_student = s.id group by id_student order by 2 desc;
DECLARE
    p_id1                studenti.id%TYPE := 2;
    p_id2                studenti.id%TYPE := 44;
    p_castigator         VARCHAR2(100);
    p_count_id1          studenti.id%TYPE;
    p_count_id2          studenti.id%TYPE;
    p_medie_id1          NUMBER;
    p_medie_id2          NUMBER;
    p_nr_note_id1        note.valoare%TYPE;
    p_nr_note_id2        note.valoare%TYPE;
    p_valoare_id1        note.valoare%TYPE;
    p_valoare_id2        note.valoare%TYPE;
    p_count_valoare_id1  note.valoare%TYPE;
    p_count_valoare_id2  note.valoare%TYPE;
BEGIN
    SELECT
        COUNT(id)
    INTO p_count_id1
    FROM
        studenti
    WHERE
        id = p_id1;

    SELECT
        COUNT(id)
    INTO p_count_id2
    FROM
        studenti
    WHERE
        id = p_id2;

    SELECT
        COUNT(valoare),
        AVG(valoare)
    INTO
        p_nr_note_id1,
        p_medie_id1
    FROM
             studenti s
        JOIN note n ON s.id = n.id_student
    WHERE
        s.id = p_id1;

    SELECT
        COUNT(valoare),
        AVG(valoare)
    INTO
        p_nr_note_id2,
        p_medie_id2
    FROM
             studenti s
        JOIN note n ON s.id = n.id_student
    WHERE
        s.id = p_id2;

    IF (
        p_count_id1 = 1 AND p_count_id2 = 0
    ) THEN
        dbms_output.put_line('Studentul '
                             || p_id2
                             || ' nu exista in baza de date !');
    ELSIF (
        p_count_id1 = 0 AND p_count_id2 = 1
    ) THEN
        dbms_output.put_line('Studentul '
                             || p_id1
                             || ' nu exista in baza de date !');
    ELSIF (
        p_count_id1 = 0 AND p_count_id2 = 0
    ) THEN
        dbms_output.put_line('Nici unul din cei doi studenti nu exista in baza de date');
    ELSIF ( p_id1 = p_id2 ) THEN
        dbms_output.put_line('Introduceti 2 useri diferiti !');
    ELSIF ( (
        p_count_id1 = 1 AND p_nr_note_id1 < 15
    ) OR (
        p_count_id2 = 1 AND p_nr_note_id2 < 15
    ) ) THEN
        dbms_output.put_line('Cel putin unul din studenti are mai putin de 15 note');
    ELSE
        dbms_output.put_line('Studentul 1 are '
                             || p_nr_note_id1
                             || ' note si media '
                             || p_medie_id1);
        dbms_output.put_line('Studentul 2 are '
                             || p_nr_note_id2
                             || ' note si media '
                             || p_medie_id2);
        IF p_medie_id1 > p_medie_id2 THEN
            p_castigator := p_id1;
        ELSIF p_medie_id1 < p_medie_id2 THEN
            p_castigator := p_id2;
        ELSIF p_medie_id1 = p_medie_id2 THEN
            SELECT
                COUNT(valoare),
                valoare
            INTO
                p_count_valoare_id1,
                p_valoare_id1
            FROM
                     note n
                JOIN cursuri c ON c.id = n.id_curs
            WHERE
                    titlu_curs = 'Baze de date'
                AND n.id_student = p_id1
            GROUP BY
                valoare;

            SELECT
                COUNT(valoare),
                valoare
            INTO
                p_count_valoare_id2,
                p_valoare_id1
            FROM
                     note n
                JOIN cursuri c ON c.id = n.id_curs
            WHERE
                    titlu_curs = 'Baze de date'
                AND n.id_student = p_id2
            GROUP BY
                valoare;

            IF p_count_valoare_id1 = 0 THEN
                dbms_output.put_line('Studentul cu id-ul'
                                     || p_id1
                                     || ' nu are nota la Baze de date !');
            ELSIF p_count_valoare_id2 = 0 THEN
                dbms_output.put_line('Studentul cu id-ul'
                                     || p_id2
                                     || ' nu are nota la Baze de date !');
            END IF;

            IF
                p_count_valoare_id1 = 1 AND p_count_valoare_id2 = 1
            THEN
                IF p_valoare_id1 > p_valoare_id2 THEN
                    p_castigator := p_id1;
                ELSIF p_valoare_id1 < p_valoare_id2 THEN
                    p_castigator := p_id2;
                ELSE
                    dbms_output.put_line('Ambii sunt castigatori');
                END IF;
            END IF;

        END IF;

        dbms_output.put_line('Castigator: ' || p_castigator);
    END IF;

END;

/*2. Construituiti o tabela cu numele "Fibonacci" avand campurile id si valoare. 
Adaugati in tabela toate numerele din sirul lui Fibonacci mai mici decat 1000 si strict mai mari decat 1, 
in ordinea in care acestea apar in sir. Campul ID va indica numarul de ordine din tabela.*/
--fiecare num?r reprezint? suma a dou? numere anterioare, ?ncep?nd cu 0 si 1

--varianta cu loop

DROP TABLE fibonacci;
/

CREATE TABLE fibonacci (
    id     NUMBER,
    value  NUMBER
)
/

DECLARE
    p_val1     NUMBER := 1;
    p_val2     NUMBER := 1;
    p_sum      NUMBER;
    p_fibo_id  NUMBER := 1;
BEGIN
    DELETE FROM fibonacci;

    LOOP
        p_sum := p_val1 + p_val2;
        p_val1 := p_val2;
        p_val2 := p_sum;
        EXIT WHEN p_sum > 1000;
        INSERT INTO fibonacci VALUES (
            p_fibo_id,
            p_sum
        );

        p_fibo_id := p_fibo_id + 1;
    END LOOP;

END;
/

SELECT
    *
FROM
    fibonacci;

--varianta cu while

DROP TABLE fibonacci;
/

CREATE TABLE fibonacci (
    id     NUMBER,
    value  NUMBER
)
/

DECLARE
    p_val1     NUMBER := 1;
    p_val2     NUMBER := 2;
    p_sum      NUMBER := 2;
    p_fibo_id  NUMBER := 1;
BEGIN
    DELETE FROM fibonacci;

    WHILE p_sum < 1000 LOOP
        INSERT INTO fibonacci VALUES (
            p_fibo_id,
            p_sum
        );

        p_sum := p_val1 + p_val2;
        p_val1 := p_val2;
        p_val2 := p_sum;
        p_fibo_id := p_fibo_id + 1;
    END LOOP;

END;
/

SELECT
    *
FROM
    fibonacci;

/*3. Scrieti un bloc anonim care afiseaza primele 10 numere naturale in sens invers, de la cel mai mare la cel mai mic.*/

DECLARE
    p_start NUMBER := 1;
BEGIN
    FOR i IN REVERSE p_start..10 LOOP
        dbms_output.put_line(i);
    END LOOP;
END; 

/*4. Utilizand un cursor, afisati id-ul, numele si prenumele studentilor din care au bursa mai mare ca 1000.*/
--varianta 1, fara declararea explicita a cursorului

BEGIN
    FOR i IN (
        SELECT
            *
        FROM
            studenti
        WHERE
            bursa > 1000
        ORDER BY
            bursa
    ) LOOP
        dbms_output.put_line(i.id
                             || ' - '
                             || i.nume
                             || ' - '
                             || i.prenume
                             || ' - '
                             || i.bursa);
    END LOOP;
END;      

--alta varianta, se declara explicit cursorul si se parcurge cu for .. loop
/
DECLARE
    CURSOR c1 IS
    SELECT
        id,
        nume,
        prenume,
        lpad(round(bursa), 7) AS bursa
    FROM
        studenti
    WHERE
        bursa > 1000
    ORDER BY
        bursa DESC;

    c1_record c1%rowtype;
BEGIN
    FOR c1_record IN c1 LOOP
        dbms_output.put_line(c1_record.id
                             || ' - '
                             || c1_record.nume
                             || ' - '
                             || c1_record.prenume
                             || ' - '
                             || c1_record.bursa);
    END LOOP;
END; 
/
--alta varianta, cea mai buna ca performanta
--se lucreaza cu bulk collect, adica toate datele se incarca in acelasi timp - mai intai se declara 2 type-uri, iar datele din select vor fi retinute in array-uri

CREATE OR REPLACE TYPE num_arr AS
    TABLE OF NUMBER;
/

CREATE OR REPLACE TYPE vc_arr AS
    TABLE OF VARCHAR2(2000);
/


DECLARE
    p_id_arr               num_arr;
    p_student_nume_arr     vc_arr;
    p_student_prenume_arr  vc_arr;
    p_student_bursa_arr    num_arr;
BEGIN
    SELECT
        student_id,
        student_nume,
        student_prenume,
        student_bursa
    BULK COLLECT
    INTO
        p_id_arr,
        p_student_nume_arr,
        p_student_prenume_arr,
        p_student_bursa_arr
    FROM
        (
            SELECT
                s.id         AS student_id,
                s.nume       AS student_nume,
                s.prenume    AS student_prenume,
                s.bursa      AS student_bursa
            FROM
                studenti s
            WHERE
                bursa > 1000
        );

    IF p_id_arr.count <> 0 THEN
        FOR i IN 1..p_id_arr.count LOOP
            dbms_output.put_line(p_id_arr(i)
                                 || ' - '
                                 || p_student_nume_arr(i)
                                 || ' - '
                                 || p_student_prenume_arr(i)
                                 || ' - '
                                 || p_student_bursa_arr(i));
        END LOOP;

    END IF;

END;
/
--ultima modalitate de a scrie

DECLARE
    TYPE idtype IS
        TABLE OF studenti.id%TYPE;
    TYPE numetype IS
        TABLE OF studenti.nume%TYPE;
    TYPE prenumetype IS
        TABLE OF studenti.prenume%TYPE;
    TYPE bursatype IS
        TABLE OF studenti.bursa%TYPE;
    id_t        idtype;
    id_nume     numetype;
    id_prenume  prenumetype;
    id_bursa    bursatype;
    CURSOR c1 IS
    SELECT
        id,
        nume,
        prenume,
        bursa
    FROM
        studenti
    WHERE
        bursa > 1000;

BEGIN
    OPEN c1;
    FETCH c1 BULK COLLECT INTO
        id_t,
        id_nume,
        id_prenume,
        id_bursa;
    --aici se proceseaza elementele din colectii
    FOR i IN id_t.first..id_t.last LOOP
        dbms_output.put_line(id_t(i)
                             || ' - '
                             || id_nume(i)
                             || ' - '
                             || id_prenume(i)
                             || ' - '
                             || id_bursa(i));
    END LOOP;
    CLOSE c1;
END;