/*1.Construiti o procedura (sau functie) care sa primeasca ca parametru o lista de obiecte de tip record care sa contina ID-uri de studenti si procentaj 
de marire a bursei. In cazul in care studentul nu avea bursa, i se va adauga o valoare minima (de 100) dupa care se va opera cresterea specificata. 
Procedura va face modificarile din lista primita ca parametru.*/
DROP TYPE studenti_burse;

DROP TYPE student_bursa;
/

CREATE TYPE student_bursa AS OBJECT (
    id_student      CHAR(4),
    procent_marire  NUMBER
);
/

CREATE TYPE studenti_burse AS
    TABLE OF student_bursa;
/

CREATE OR REPLACE PROCEDURE mareste_bursa (
    in_id_studenti IN studenti_burse
) IS
BEGIN
    FOR c IN (
        SELECT
            id_student,
            procent_marire
        FROM
            TABLE ( in_id_studenti )
    ) LOOP
        UPDATE studenti
        SET
            bursa = nvl(bursa, 100) * ( 1 + c.procent_marire )
        WHERE
            id = c.id_student;

    END LOOP;
END mareste_bursa;
/

SELECT
    id,
    bursa
FROM
    studenti
ORDER BY
    id;
/

BEGIN
    mareste_bursa(studenti_burse(student_bursa(1, 0.5), student_bursa(2, 2)));
END;
/

SELECT
    id,
    bursa
FROM
    studenti
ORDER BY
    id;
/
--eventual dau rollback pentru a reveni la datele de dinainte de apelul procedurii

ROLLBACK;


/*2.Modificati tabela studenti pentru a avea un nou camp in care sa se pastreze o lista cu modificari ale bursei (un history al valorilor anterioare).
Modificati codul de la punctul 1 pentru a face si aceasta adaugare in noul camp.*/

DROP TYPE istoric_burse;

CREATE TYPE istoric_burse AS
    TABLE OF NUMBER(38, 2);
/

ALTER TABLE studenti ADD bursa_veche istoric_burse
NESTED TABLE bursa_veche STORE AS bursa_veche;

UPDATE studenti
SET
    bursa_veche = istoric_burse();

COMMIT;
/
--https://livesql.oracle.com/apex/livesql/file/content_HA9MJBJI8GEU4PE39G2POFR79.html
--aici este descris exact ce face multiset union, e un operator pentru lucrul cu nested tables

CREATE OR REPLACE PROCEDURE mareste_bursa (
    in_id_studenti studenti_burse
) IS
BEGIN
    FOR c IN (
        SELECT
            id_student,
            procent_marire
        FROM
            TABLE ( in_id_studenti )
    ) LOOP
        UPDATE studenti
        SET
            bursa_veche = bursa_veche MULTISET UNION istoric_burse(nvl(bursa, 0)),
            bursa = nvl(bursa, 100) * ( 1 + c.procent_marire )
        WHERE
            id = c.id_student;

    END LOOP;
END mareste_bursa;
/

SELECT
    *
FROM
    studenti
ORDER BY
    id;
/

BEGIN
    mareste_bursa(studenti_burse(student_bursa(4, 0.5), student_bursa(2, 2)));
END;
/
--apelati de mai multe ori procedura si apoi vedeti modificarile legate de bursa, precum si de noul camp adaugat (bursa_veche)

SELECT
    *
FROM
    studenti
WHERE
    id IN (
        1,
        2
    )
ORDER BY
    id;


/*3.Definiti o colectie cu urmatoarele patru coloane: nr id, nume,
prenume, an. Definiti o procedura stocata (sau functie) care sa primeasca un parametru de intrare de tip colectia specificata,
iar in interiorul ei faceti join intre colectie si tabela note si afisati doar numele si media pentru studentii din anii 2 si 3.*/

DROP TYPE std_object FORCE;
/

CREATE OR REPLACE TYPE std_object AS OBJECT (
    id       NUMBER(3),
    nume     VARCHAR2(100),
    prenume  VARCHAR2(100),
    an       NUMBER(3)
);
/

CREATE OR REPLACE TYPE std_table IS
    TABLE OF std_object;
/

CREATE OR REPLACE PROCEDURE get_average (
    p_students std_table
) AS
    p_medie NUMBER := 0;
BEGIN
    FOR i IN p_students.first..p_students.last LOOP
        IF p_students(i).an = 2 OR p_students(i).an = 3 THEN
            SELECT
                round(AVG(valoare))
            INTO p_medie
            FROM
                note
            WHERE
                id_student = p_students(i).id;

            dbms_output.put_line('Studentul '
                                 || p_students(i).nume
                                 || ' are media '
                                 || round(p_medie, 2));

        END IF;
    END LOOP;
END;
/
--apelul (exemplificare pentru 3 studenti diferiti din baza)
--cautati studenti care au medii, adica nu cei din anul 1 !
--select * from (select id,nume,prenume,an from studenti where an in (2,3)) where rownum<4;

DECLARE
    p_students  std_table;
    p_stud1     std_object;
    p_stud2     std_object;
    p_stud3     std_object;
BEGIN
    SELECT
        std_object(id, nume, prenume, an)
    INTO p_stud1
    FROM
        studenti
    WHERE
        id = 1;

    SELECT
        std_object(id, nume, prenume, an)
    INTO p_stud2
    FROM
        studenti
    WHERE
        id = 4;

    SELECT
        std_object(id, nume, prenume, an)
    INTO p_stud3
    FROM
        studenti
    WHERE
        id = 5;

    p_students := std_table(p_stud1, p_stud2, p_stud3);
    get_average(p_students);
END;
/


-- FROM THE SEMINAR

DECLARE
    TYPE prenume IS
        TABLE OF VARCHAR2(10);
    student prenume;
BEGIN
    student := prenume('Gigel', 'Ionel');
    FOR i IN student.first..student.last LOOP
        dbms_output.put_line(i
                             || ' - '
                             || student(i));
    END LOOP;

END;
/

DECLARE
    TYPE prenume IS
        TABLE OF VARCHAR2(10);
    student prenume;
BEGIN
    student := prenume('Gigel', 'Ionel', 'Maria');
    student.extend(4, 2); -- copii elementul al doilea de 4 ori
    student.DELETE(2); -- sterg elementul al doilea
    FOR i IN student.first..student.last LOOP
        IF student.EXISTS(i) THEN -- daca incerc sa afisez ceva ce nu exista se va produce o eroare
            dbms_output.put_line(i
                                 || ' - '
                                 || student(i));  -- afisam pozitia si valoarea
        END IF;
    END LOOP;

END;
/

DECLARE
    CURSOR curs IS
    SELECT
        *
    FROM
        studenti;

    TYPE linie_student IS
        TABLE OF curs%rowtype;
    lista_studenti linie_student;
BEGIN
    OPEN curs;
    SELECT
        *
    BULK COLLECT
    INTO lista_studenti
    FROM
        studenti;

    CLOSE curs;
    FOR i IN lista_studenti.first..lista_studenti.last LOOP
        IF lista_studenti.EXISTS(i) THEN -- daca incerc sa afisez ceva ce nu exista se va produce o eroare
            dbms_output.put_line(i
                                 || ' - '
                                 || lista_studenti(i).nume);  -- afisam pozitia si valoarea
        END IF;
    END LOOP;

    dbms_output.put_line('Numar studenti: ' || lista_studenti.count);
END;
/

GRANT
    CREATE TYPE
TO student; -- aceasta linie se executa din "SYS as SYSDBA"

CREATE OR REPLACE TYPE lista_prenume AS
    TABLE OF VARCHAR2(10);
/

CREATE TABLE persoane (
    nume     VARCHAR2(10),
    prenume  lista_prenume
)
NESTED TABLE prenume STORE AS asdsandsadsa;
/

INSERT INTO persoane VALUES (
    'Popescu',
    lista_prenume('Ionut', 'Razvan')
);

INSERT INTO persoane VALUES (
    'Ionescu',
    lista_prenume('Elena', 'Madalina')
);

    INSERT INTO persoane VALUES (
        'Rizea',
        lista_prenume('Mircea', 'Catalin')
    );
/

SELECT
    *
FROM
    persoane;
/

CREATE OR REPLACE TYPE varr IS
    VARRAY(5) OF VARCHAR2(10);
/

-- DE PE NET. 

CREATE TYPE address_t AS OBJECT (
    street  VARCHAR2(30),
    city    VARCHAR2(20),
    state   CHAR(2),
    zip     CHAR(5)
);
/

CREATE TYPE address_tab IS
    TABLE OF address_t;
/

CREATE TABLE customers (
    custid   NUMBER,
    address  address_tab
)
NESTED TABLE address STORE AS customer_addresses;

-- efectiv pot sa pun si "dsadsadsadas" in loc de "customer_addresses" ca nu influenteaza cu nimic. :D

    INSERT INTO customers VALUES (
        1,
        address_tab(address_t('101 First', 'Redwood Shores', 'CA', '94065'), address_t('123 Maple', 'Mill Valley', 'CA', '90952'))
    );
/

SELECT
    *
FROM
    customers;
/

SELECT
    c.custid,
    u.*
FROM
    customers              c,
    TABLE ( c.address )      u;
/

-- LEARN MULTISET UNION
CREATE OR REPLACE TYPE strings_nt IS TABLE OF VARCHAR2 (1000) ;
/


CREATE OR REPLACE PACKAGE authors_pkg 
IS 
   steven_authors   strings_nt; 
   veva_authors     strings_nt; 
   eli_authors      strings_nt; 
 
   PROCEDURE show_authors (title_in IN VARCHAR2, authors_in IN strings_nt); 
 
   PROCEDURE init_authors; 
END;
/

CREATE OR REPLACE PACKAGE BODY authors_pkg 
IS 
   PROCEDURE show_authors (title_in IN VARCHAR2, authors_in IN strings_nt) 
   IS 
   BEGIN 
      DBMS_OUTPUT.put_line (title_in); 
 
      FOR indx IN 1 .. authors_in.COUNT 
      LOOP 
         DBMS_OUTPUT.put_line (indx || ' = ' || authors_in (indx)); 
      END LOOP; 
   END show_authors; 
 
   PROCEDURE init_authors 
   IS 
   BEGIN 
      steven_authors := 
         strings_nt ('ROBIN HOBB' 
                   , 'ROBERT HARRIS' 
                   , 'DAVID BRIN' 
                   , 'SHERI S. TEPPER' 
                   , 'CHRISTOPHER ALEXANDER' 
                   , 'PIERS ANTHONY'); 
      veva_authors := 
         strings_nt ('ROBIN HOBB', 'SHERI S. TEPPER', 'ANNE MCCAFFREY'); 
 
      eli_authors := 
         strings_nt ('PIERS ANTHONY', 'SHERI S. TEPPER', 'DAVID BRIN'); 
   END; 
END;
/


DECLARE 
   our_authors   strings_nt; 
BEGIN 
   authors_pkg.init_authors; 
   our_authors := 
      authors_pkg.steven_authors MULTISET UNION authors_pkg.veva_authors; 
 
   authors_pkg.show_authors ('Steven and Veva', our_authors); 
 
   /* Use MULTISET UNION inside SQL */ 
   DBMS_OUTPUT.put_line ('Union inside SQL'); 
 
   FOR rec IN (  SELECT COLUMN_VALUE 
                   FROM TABLE ( 
                           authors_pkg.veva_authors 
                              MULTISET UNION authors_pkg.steven_authors) 
               ORDER BY COLUMN_VALUE) 
   LOOP 
      DBMS_OUTPUT.put_line (rec.COLUMN_VALUE); 
   END LOOP; 
 
   our_authors := 
      authors_pkg.steven_authors 
         MULTISET UNION DISTINCT authors_pkg.veva_authors; 
 
   authors_pkg.show_authors ('Steven then Veva with DISTINCT', our_authors); 
END; 
/


