-- sa se constr un script la al carui rulare, uuseru sa fie intrebat un nume de familie

-- daca nu exista nici macar un student cu acel nume, se va afisa un mesaj informativ asupra acestui fapt.
-- else, afisati: 
-- 1) numarul de studenti avand acel nume de familie
-- 2) id-ul si prenumele studentului care ar fi primul in ordine lexicografica. Sort dupa prenume. (rownum)
-- 3) nota cea mai mica si cea mai mare a studentului de la punctul anterior.
-- 4) numarul a^b, unde a==nota cea mai mare si b==nota cea mai mica
-- 5) scrie cod intr-un bloc anonim in care sa exemplificati diferenta dintre char si varchar2

SET SERVEROUTPUT ON;

declare 
    v_nume studenti.nume%type := 'Popescu';
    v_numar_persoane  NUMBER(5);
    v_id  studenti.id%type;
    v_prenume studenti.prenume%type;
    v_nota_max note.valoare%type;
    v_nota_min note.valoare%type;
begin 
    select count(*)
    into v_numar_persoane
    from studenti s
    where s.nume=v_nume;
    
    IF (v_numar_persoane = 0) 
      THEN 
        DBMS_OUTPUT.PUT_LINE('NU EXISTA STUDENT CU NUMELE ' || v_nume);
      ELSE 
        DBMS_OUTPUT.PUT_LINE(v_numar_persoane);
        select id, prenume
        into v_id, v_prenume
        from 
            (select s1.id, s1.prenume
            from studenti s1
            where s1.nume=v_nume
            order by s1.prenume)
        where rownum = 1;
        
        DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_prenume);
-- 3) nota cea mai mica si cea mai mare a studentului de la punctul anterior.
        select max(n.valoare), min(n.valoare)
        into v_nota_max, v_nota_min 
        from note n
        where n.id = v_id;
        DBMS_OUTPUT.PUT_LINE(v_nota_max || ' ' || v_nota_min);
-- 4) numarul a^b, unde a==nota cea mai mare si b==nota cea mai mica
        DBMS_OUTPUT.PUT_LINE(POWER(v_nota_max, v_nota_min));
    END IF;
    
end;


-- 5) scrie cod intr-un bloc anonim in care sa exemplificati diferenta dintre char si varchar2
declare 
    v_varchar CHAR(50) := 'Popescu';
    v_varchar2 VARCHAR2(50) := 'Popescu';
begin 
    DBMS_OUTPUT.PUT_LINE(length(v_varchar));
    DBMS_OUTPUT.PUT_LINE(length(v_varchar2));

end;

        