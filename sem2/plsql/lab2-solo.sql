 --GRUPA B5
/*1.(3p) Construiti un script care sa indice (prin intermediul ID-urilor)
care sunt prietenii care au valorile mediilor trunchiate egale (de exemplu daca studentul cu ID-ul 1 are media 7.25 si are ca si prieteni pe 
studentii cu ID-urile 2 (cu 8.33), 3 (cu 7.99) respectiv 4 (cu 7.25), se vor afisa cuplurile 1-3 si 1-4). 
Daca studentul nu exista in baza de date, afisati un mesaj corespunzator*/
--1p - scrierea corecta a cursorului
--1p - afisarea corecta a perechilor de id-uri (adica studentul dat impreuna cu toti prietenii sai)
--1p - dupa punerea conditiei sa ramana doar perechile care satisfac conditia
set serveroutput on;

declare
    p_id                 studenti.id%type :=2;
    cursor c_medii is
        select s1.id as id1, trunc( avg(n1.valoare),2) as medie1, trunc( avg(n1.valoare)) as medie_intreaga1,
                s2.id as id2, trunc( avg(n2.valoare),2) as medie2, trunc( avg(n2.valoare)) as medie_intreaga2
        from studenti s1 join note n1 on s1.id=n1.id_student join prieteni p on s1.id=p.id_student1 join
            studenti s2 on s2.id=p.id_student2 join note n2 on s2.id=n2.id_student
        group by s1.id, s2.id;
    c_it c_medii%rowtype;
    
begin
    for c_it in c_medii loop
        if c_it.id1=p_id then
            dbms_output.put_line(c_it.id1 ||' - '||  c_it.medie1 ||' - '|| c_it.medie_intreaga1 ||' - '|| c_it.id2 ||' - '||  c_it.medie2 ||' - '|| c_it.medie_intreaga2);
        end if;
    end loop;  
    for c_it in c_medii loop
        if c_it.id1=p_id and c_it.medie_intreaga1=c_it.medie_intreaga2 then
            dbms_output.put_line(c_it.id1 ||' - '|| c_it.id2);

        end if;
    end loop;   
end;
/

/*2.(1p) Scrieti un bloc anonim PL/SQL care sa afiseze tabla inmultirii (de la 1 pana la 10) cu n - 
in care n este o valoare care se da. In cazul in care dati de la tastatura n = 0 tratati exceptia si afisati un mesaj corespunzator !*/
declare
    n  INTEGER := 2;
    
begin
    for i in 1..10 loop
       dbms_output.put_line( i * n);
    end loop;   
end;

/*3.(1p) Scrieti un bloc anonim care sa compare doua date calendaristice din punctul de vedere al unei facturi. 
Sa se determine daca factura poate sa mai astepte pana ce va fi platita, daca data scadenta este azi sau daca deja s-a intarziat cu plata.*/
declare
    data_factura DATE := CURRENT_DATE;
    
    
begin
    if (data_factura > CURRENT_DATE) then
        dbms_output.put_line('expirat');
    else
        dbms_output.put_line('NE expirat');
    end if;
end;

