CREATE OR REPLACE TYPE student AS OBJECT
(
    nume         varchar2(10),
    prenume      varchar2(10),
    grupa        varchar2(4),
    an           number(1),
    data_nastere date,
    member
    procedure afiseaza_foaie_matricola,
    CONSTRUCTOR FUNCTION student(nume varchar2, prenume varchar2)
        RETURN SELF AS RESULT
);

CREATE OR REPLACE TYPE BODY student AS
    MEMBER PROCEDURE afiseaza_foaie_matricola IS
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Aceasta procedura calculeaza si afiseaza foaia matricola');
        END afiseaza_foaie_matricola;
    CONSTRUCTOR FUNCTION student(nume varchar2, prenume varchar2)
        RETURN SELF AS RESULT
        AS
        BEGIN
            SELF.nume := nume;
            SELF.prenume := prenume;
            SELF.data_nastere := sysdate;
            SELF.an := 1;
            SELF.grupa := 'A1';
            RETURN;
        END;
END;

drop table studenti_oop;

CREATE TABLE studenti_oop
(
    nr_matricol VARCHAR2(4),
    obiect      STUDENT
);

set serveroutput on;
DECLARE
    v_student1 STUDENT;
    v_student2 STUDENT;
    v_student3 STUDENT;
BEGIN
    v_student1 := student('Popescu', 'Ionut', 'A2', 3, TO_DATE('11/04/1994', 'dd/mm/yyyy'));
    v_student2 := student('Vasilescu', 'George', 'A4', 3, TO_DATE('22/03/1995', 'dd/mm/yyyy'));
    v_student3 := student('GOIGI', 'GOIGI');
    v_student1.afiseaza_foaie_matricola();
    dbms_output.put_line(v_student1.nume);
    dbms_output.put_line(v_student3.nume);
    insert into studenti_oop values ('100', v_student1);
    insert into studenti_oop values ('101', v_student2);
    insert into studenti_oop values ('102', v_student3);
END;