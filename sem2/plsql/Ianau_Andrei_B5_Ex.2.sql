-- 	
--
-- Construiti o functie PLSQL care sa primeasca ca parametri numele si prenumele unui student si care sa returneze media
-- si, in caz ca nu exista acel student (dat prin nume si prenume) sa arunce o exceptie definita de voi. Dintr-un bloc
-- anonim care contine intr-o structura de tip colectie mai multe nume si prenume (trei studenti existenti si trei care
-- nu sunt in baza de date), apelati functia cu diverse valori. Prindeti exceptia si afisati un mesaj corespunzator
-- atunci cand studentul nu exista sau afisati valoarea returnata de functie daca studentul exista. (2pct)


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

