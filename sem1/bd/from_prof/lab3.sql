--1.Scrie?i o interogare pentru a afi?a data de azi. Eticheta?i coloana "Astazi".*/
select sysdate as astazi
from dual;

--sau
select current_date as astazi
from dual;


--2.Pentru fiecare student afi?a?i numele, data de nastere si num�rul de luni �ntre data curent� ?i data na?terii.*/
select nr_matricol,nume,prenume,data_nastere,round(months_between(sysdate,data_nastere)) as diferenta
from studenti
order by 5 desc;

--3.Afi?a?i ziua din s�pt�m�n� �n care s-a n�scut fiecare student.*/
select nr_matricol,nume,prenume,nvl(to_char(data_nastere,'day'),'data nec') as zi_nastere
from studenti
order by 4;

--4.Utiliz�nd functia de concatenare, ob?ine?i pentru fiecare student textul 'Studentul <prenume> este in grupa <grupa>'.*/
select 'Studentul '|| nvl(prenume,'fara prenume') ||' este in grupa '||grupa as "studenti / grupe"
from studenti
order by 1;

--sau
select concat(concat(concat('Studentul ',nvl(prenume,'fara prenume')),' este in grupa '),grupa)as "studenti / grupe"
from studenti
order by 1;

--5.Afisati valoarea bursei pe 10 caractere, completand valoarea numerica cu caracterul $.*/
select nr_matricol,nume,prenume,nvl(rpad(bursa,10,'$'),'nu are bursa') as bursa
from studenti
order by 4 desc;
--sau
select nr_matricol,nume,prenume,nvl(lpad(bursa,10,'$'),'nu are bursa') as bursa
from studenti
order by 4 desc;

--6.Pentru profesorii al c�ror nume �ncepe cu B, afi?a?i numele cu prima litera mic� si restul mari, precum ?i lungimea (nr. de caractere a) numelui.*/
select concat(lower(substr(nume,1,1)),upper(substr(nume,2))) as nume,length(trim(nume)) as lungime_nume
from profesori
where nume like 'B%'
order by 1;

--sau fara a folosi functia concat
select lower(substr(nume,1,1))||upper(substr(nume,2)) as nume,length(trim(nume)) as lungime_nume
from profesori
where nume like 'B%'
order by 1;


--7.Pentru fiecare student afi?a?i numele, data de nastere, data la care studentul urmeaza sa isi sarbatoreasca ziua de nastere si prima zi de duminic� de dupa.*/
--floor(floor(months_between(current_date,data_nastere)/12)*12)+12) intoarce nr de luni de la nasterea studentului
select nr_matricol,nume,data_nastere,
	add_months(data_nastere,floor(floor(months_between(current_date,data_nastere)/12)*12)+12) as sarbatoare,
	next_day(add_months(data_nastere,(floor(floor(months_between(current_date,data_nastere)/12)*12)+12)),'SUNDAY') as prima_duminica_dupa
from studenti
order by 1;

--varianta in care folosim pentru rotunjire functia ceil
column nr_matricol format A11
column data_nastere format A15
column sarbatoare format A12
column prima_duminica_dupa format A25
select nr_matricol,nume,data_nastere,
	add_months(data_nastere,ceil(ceil(months_between(current_date,data_nastere)/12)*12)) as sarbatoare,
	next_day(add_months(data_nastere,ceil(ceil(months_between(current_date,data_nastere)/12)*12)),'SUNDAY') as prima_duminica_dupa
from studenti
order by 1;

--8.Ordona?i studen?ii care nu iau burs� �n func?ie de luna cand au fost n�scu?i; se va afi?a doar numele, prenumele ?i luna corespunz�toare datei de na?tere.*/
select nume,prenume,nvl(to_char(extract(month from data_nastere)),'luna nec') as luna_nastere
from studenti
where bursa is null or bursa=0
order by 3;
--
select nume,prenume,to_char(data_nastere,'month') as luna_nastere
from studenti
where bursa is null or bursa=0
order by extract(month from data_nastere);

--9.Pentru fiecare student afi?ati numele, valoarea bursei si textul: 'premiul 1' pentru valoarea 450, 'premiul 2' pentru valoarea 350, 
'premiul 3' pentru valoarea 250 ?i 'mentiune' pentru cei care nu iau bursa.*/
select nr_matricol,nume,prenume,decode(bursa,450,'premiul 1',350,'premiul 2',250,'premiul 3','mentiune') as premiu
from studenti
order by 4;

--varianta cu case
select nr_matricol,nume,prenume,
  case bursa
    when 450 then 'premiul 1'
    when 350 then 'premiul 2'
    when 250 then 'premiul 3'
    else 'mentiune'
  end as premiu
from studenti
order by 4;  

--10.Afi�a�i numele tuturor studen?ilor �nlocuind apari�ia literei i cu a si apari�ia literei a cu i.*/
select translate(nume,'aiAI','iaIA') as nume_modificate
from studenti
order by nume;

select translate(nume,'ai','ia') as nume_modificate
from studenti
order by nume;

--11.Afi?a?i pentru fiecare student numele, v�rsta acestuia la data curent� sub forma '<x> ani <y> luni ?i <z> zile'
(de ex '19 ani 3 luni ?i 2 zile') ?i num�rul de zile p�n� �?i va s�rb�tori (din nou) ziua de na?tere.*/
column nr_matricol format A3
column nume format A8
column prenume format A9
column varsta format A25
column nr_zile format A30
select nr_matricol,nume,prenume,
  trunc(months_between(sysdate,data_nastere)/12)||' ani '||
  floor(to_number(months_between(sysdate,data_nastere)-(trunc(months_between(sysdate,data_nastere)/12))*12))||' luni '||
  floor(to_number(sysdate-add_months(data_nastere,trunc(months_between(sysdate,data_nastere)))))||' zile. ' as varsta,
  floor(to_number(add_months(data_nastere,ceil(months_between(sysdate,data_nastere)/12)*12)-sysdate))||' zile pana la urmatoarea zi de nastere ' as nr_zile
from studenti
order by 1;
 

--12.Presupun�nd c� �n urm�toarea lun� bursa de 450 RON se m�re?te cu 10%, cea de 350 RON cu 15% ?i cea de 250 RON cu 20%, 
afi?a?i pentru fiecare student numele acestuia, data corespunz�toare primei zile din luna urmatoare ?i valoarea bursei pe care o va �ncasa luna urm�toare.
Pentru cei care nu iau bursa, se va afisa valoarea 0.*/
select nr_matricol,nume,prenume,last_day(sysdate)+1 as prima_zi,ceil(decode(bursa,450,450*1.1,350,350*1.15,250,250*1.2,0)) as bursa_viitoare
from studenti
order by 5;

--13.Pentru studentii bursieri (doar pentru ei) afisati numele studentului si bursa in stelute: 
fiecare steluta valoreaza 50 RON. In tabel, alineati stelutele la dreapta.*/
select nr_matricol,nume,prenume,bursa,nvl(rpad(' ',bursa/50,'*'),'nu are bursa') as bursa_stelute
from studenti
order by 5 desc;
--sau
column nr_matricol format a3
column nume format a15
column prenume format a9
column bursa format 9999999
column bursa_stelute format a15
select nr_matricol,nume,prenume,bursa,to_char(rpad(' ',bursa/50,'*')) as bursa_stelute
from studenti
where bursa is not null and bursa<>0
order by 5 desc;

--Interogari suplimentare
--exemplu de utilizare a functiei nullif
--1.Sa se compare lungimea numelui cu lungimea prenumelui pentru fiecare student, iar in cazul in care acestea sunt egale se 
returneaza null, altfel se returneaza lungimea data de prenume. Deci se vor afisa in ordine:
prenumele studentului, nr de caractere al prenumelui, numele studentului si nr de caractere al numelui*/
select prenume,length(prenume) as expr1,nume,length(nume) as expr2,nullif(length(prenume),length(nume)) as Result
from studenti
order by 2;

--2.Considerand ca in USA varsta majoratului este 21, identificati studentii care au cel putin 21 de ani impliniti. Afisati numele concatenat cu prenumele.*/
select nume||' '||prenume as "Major in America"
from studenti
where months_between(sysdate,data_nastere)/12 >= 21;

--Selectati titlul,anul si numarul de credite pentru fiecare curs sub formatul : 'Cursul <titlu_curs> se face in anul <an> si are un numar de <credite> credite.'
pentru cursurile care se fac in semestrul 1 (indiferent de anul de studiu) si al carui titlu se scrie cu caractere majuscule. Denumiti coloana "Curs".*/
select 'Cursul '||titlu_curs||' se face in anul '||an||' si are un numar de '||credite||' credite.' as "Curs"
from cursuri 
where semestru=1 and titlu_curs=upper(titlu_curs);

--3.Afisati doar pentru studentii bursieri numele ("Nume"), prenumele ("Prenume") si data nasterii ("Data nasterii") 
folosind un num�r minim de functii, unde data nasterii are un format precum acesta: 
"Vineri , 17 Februarie 1995". Ordonati studentii cresc�tor �n functie anul si luna �n care s-au n�scut.*/
select nume as "Nume",prenume as "Prenume",to_char(data_nastere, 'Day, DD Month YYYY', 'nls_date_language = romanian') as "Data nasterii"
from studenti
where bursa is not null
order by to_char(data_nastere,'YYYY'),to_char(data_nastere,'MM');

--4.Sa se afiseze suma dintre valoare si nr_matricol din tabelul Note intr-o coloana numita "SUMA". 
In alta coloana numita "NOTA" se va regasi 'x' daca suma aceasta este para; altfel, nota ramane neschimbata. 
Sa se ordoneze descrescator dupa SUMA. (Exemplu: 128 x sau 127 8) (Hint: functia DECODE)*/
SELECT valoare+nr_matricol as SUMA, DECODE(mod(valoare+nr_matricol,2),0, 'x',valoare) as NOTA
FROM note
order by SUMA desc;

--5.Afisati numele si prenumele (concatenate cu un spatiu) �n coloana "Student", iar �n coloana "Bursa" afisati bursa fiec�rui student �nmultit�
cu codul ascii al primei litere din prenumele studentului. Pentru cei care nu iau burs� se va afisa doar codul Ascii. 
Ordonati rezultatele cresc�tor dup� nume. Ex: (Arhire Alexandra 65, Cobzaru George 24850).*/
select nume || ' ' ||  prenume as Student, NVL(ASCII(substr(prenume, 1, 1)) * bursa, ASCII(substr(prenume, 1, 1))) as Bursa 
from studenti
order by nume;


 
