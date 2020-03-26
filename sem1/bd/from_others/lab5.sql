/*1.Afisati studentii doi cate doi impreuna cu diferenta de varsta dintre ei. Sortati in ordine crescatoare in functie de aceste diferente.
Aveti grija sa nu comparati un student cu el insusi.*/
column matr1 format A4
column nume1 format A10
column prenume1 format A10
column matr2 format A4
column nume2 format A10
column prenume2 format A10
column dif_varsta format A20
select s1.nr_matricol as matr1,s1.nume as nume1,s1.prenume as pren1,s2.nr_matricol as matr2,s2.nume as nume2,s2.prenume as pren2,
  abs(trunc(months_between(s1.data_nastere,s2.data_nastere)/12))||' ani '||
  abs(trunc(to_number(months_between(s1.data_nastere,s2.data_nastere)-(trunc(months_between(s1.data_nastere,s2.data_nastere)/12))*12)))||' luni '||
  abs(trunc(to_number(s1.data_nastere-add_months(s2.data_nastere,trunc(months_between(s1.data_nastere,s2.data_nastere))))))||' zile. ' as dif_varsta
from studenti s1 join studenti s2 on s1.nr_matricol>s2.nr_matricol
order by abs(s1.data_nastere-s2.data_nastere);


/*2.Afisati posibilele prietenii dintre studenti si profesori. Un profesor si un student se pot imprieteni daca numele lor de familie are acelasi numar de litere.*/
select trim(s.nume)||' '||trim(s.prenume)||' prieten cu '||trim(p.nume)||' '||trim(p.prenume) as relation
from studenti s join profesori p on length(s.nume)=length(trim(p.nume))
order by 1;

--varanta prin care se face join cu toate tabelele nu este ok, deoarece sunt profi care nu au pus nici o nota, adica nu exista in tabela didactic
--in tabela didactic sunt trecute doar corespondentele curs-prof care exista !!!
--afiseaza doar 12 inregistrari 
select trim(s.nume)||' '||trim(s.prenume)||' prieten cu '||trim(p.nume)||' '||trim(p.prenume) as relation, length(s.nume) as lungime_nume
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs join didactic d on d.id_curs=n.id_curs join 
  profesori p on p.id_prof=d.id_prof
where length(trim(s.nume))=length(trim(p.nume))  
order by 1;


/*3.Afisati denumirile cursurilor la care s-au pus note cel mult egale cu 8 (<=8).*/
--varianta cu minus
select titlu_curs
from cursuri c join note n on n.id_curs=c.id_curs
minus
select titlu_curs
from cursuri c join note n on n.id_curs=c.id_curs
where valoare>8;
--
select distinct titlu_curs
from cursuri c join note n on n.id_curs=c.id_curs
where c.id_curs not in 
	(select id_curs
	from note
	where valoare>8);
	

/*4.Afisati numele studentilor care au toate notele mai mari ca 7 sau egale cu 7.*/
select s.nr_matricol,s.nume,s.prenume
from studenti s join note n on s.nr_matricol=n.nr_matricol
where valoare is not null
minus
select s.nr_matricol,s.nume,s.prenume
from studenti s join note n on s.nr_matricol=n.nr_matricol
where valoare <7
order by 1;

--varianta 2
select distinct s.nr_matricol,s.nume,s.prenume
from studenti s join note n on s.nr_matricol=n.nr_matricol
where s.nr_matricol not in
	(select nr_matricol 
		from note
		where valoare<7)
order by 1;


/*5.Sa se afiseze studentii care au luat nota 7 sau nota 10 la OOP intr-o zi de marti.*/
select s.nr_matricol,nume,prenume,to_char(data_notare,'day') as zi_notare,titlu_curs,valoare
from studenti s join note n on s.nr_matricol=n.nr_matricol join cursuri c on c.id_curs=n.id_curs
where titlu_curs='OOP' and valoare in(7,10) and trim(to_char(data_notare,'day'))='tuesday';
--ALTER SESSION SET NLS_LANGUAGE= 'ENGLISH';


/*6.O sesiune este identificata prin luna si anul in care au fost tinute. 
Scrieti numele si prenumele studentilor ce au promovat examenele in fiecare sesiune impreuna cu notele luate de acestia si sesiunea in care a fost promovata materia.
Formatul ce identifica sesiunea este "LUNA, AN", fara alte spatii suplimentare (De ex. "JUNE, 2015" sau "FEBRUARY, 2014"). 
In cazul in care luna in care s-a tinut sesiunea a avut mai putin de 30 de zile afisati simbolul "+" pe o coloana suplimentara,
indicand faptul ca acea sesiune a fost mai grea (avand mai putine zile), in caz contrar (cand luna are mai mult de 29 de zile) valoarea coloanei va fi null.*/
column matr format A4
column nume format A10
column prenume format A10
column valoare format 99999
column sesiune format A20
column sesiune_grea format A10
select s.nr_matricol as matr,nume,prenume,valoare,upper(to_char(data_notare,'month'))||', '||extract(year from data_notare) as sesiune,  
  decode(trim(to_char(data_notare,'month')),'february','+') as sesiune_grea
from studenti s join note n on s.nr_matricol=n.nr_matricol
where valoare>=5
order by extract(year from data_notare),to_char(data_notare,'month'),to_char(data_notare,'day'),1; 

--Interogari suplimentare
--EXEMPLE CU LEFT-JOIN (e posibil unele interogari sa se mai repete prin alte locuri)
--1.Afisati DOAR studentii (nr_matricol,nume,prenume,an,grupa) ce nu au nici o nota.
--foarte important de pus id_curs is null, altfel se afiseaza atatea tuple cate linii sunt in tabela de note
select s.nr_matricol,nume,prenume,an,grupa
from studenti s left join note n on n.nr_matricol=s.nr_matricol
where id_curs is null
order by 1;

--2.Afisati toti studentii impreuna cu notele lor, chiar si pe aceia ce nu au note.
--La cei ce nu au note, scrieti un mesaj corespunzator.
select s.nr_matricol,nume,prenume,an,grupa,nvl(to_char(valoare),'fara nota !') as nota
from studenti s left join note n on n.nr_matricol=s.nr_matricol
order by 1;

--3.Afisati DOAR profesorii ce nu sunt titulari de curs.
select trim(nume)||' '||trim(prenume) as nume_prof
from profesori p left join didactic d on d.id_prof=p.id_prof
where id_curs is null
order by 1;

--4.Afisati toti profesorii impreuna cu disciplinele pe care le tin, chiar si pe aceia ce nu tin nici o disciplina.
--In cazul acelora ce nu tin nici un curs, afisati un mesaj corespunzator.
select trim(nume)||' '||trim(prenume) as nume_prof,nvl(titlu_curs,'nu tine curs !') as titlu_curs
from profesori p left join didactic d on d.id_prof=p.id_prof left join cursuri c on c.id_curs=d.id_curs
order by 1;

--5.Afisati DOAR cursurile ce nu au nici un titular de curs.
select titlu_curs
from cursuri c left join didactic d on d.id_curs=c.id_curs
where d.id_prof is null
order by 1;

--6.Afisati toate cursurile impreuna cu profesorii care le tin, chiar si acelea ce nu au nici un titular.
select titlu_curs,nvl(trim(nume||' '||prenume),'nu are titular !') as nume_prof
from cursuri c left join didactic d on d.id_curs=c.id_curs left join profesori p on p.id_prof=d.id_prof
order by 1;

--7.Afisati studentii ce nu au nici o nota la BD.
--aici cel mai simplu e de folosit operatorul minus
--am scazut din toti studentii CARE AU CEL PUTIN O NOTA pe acei studenti ce au note la BD
--evident, rezultatul reprezinta STUDENTII CE AU CEL PUTIN O NOTA, dar nu au nota la BD
select s.nr_matricol,nume,prenume,s.an,grupa
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
minus
select s.nr_matricol,nume,prenume,s.an,grupa
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
where titlu_curs='BD'
order by 1;

--daca pun in from-ul din primul select left join atunci imi vor fi afisati inclusiv studentii CE NU AU NICI O NOTA, deci implicit nu au nota nici la BD
select s.nr_matricol,nume,prenume,s.an,grupa
from studenti s left join note n on n.nr_matricol=s.nr_matricol left join cursuri c on c.id_curs=n.id_curs
minus
select s.nr_matricol,nume,prenume,s.an,grupa
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
where titlu_curs='BD'
order by 1;

/*8.Identificati toate cursurile predate in facultate si toate cadrele didactice ale facultatii.
Veti afisa: titlul cursului, numarul de credite alocate, numele si prenumele cadrului didactic care preda cursul.
Vor aparea si cursurile care inca nu au asociati profesori, precum si profesorii care inca nu au asignat vreun curs.*/	
--cel mai usor se face cu full join
select titlu_curs,credite,nume,prenume
from cursuri c full join didactic d on d.id_curs=c.id_curs full join profesori p on p.id_prof=d.id_prof;


--EXEMPLE CU SELF-JOIN
/*1.Pentru studenta Antonie Ioana afisati care sunt colegii ei. Nu o afisati si pe ea !
Coleg = acelasi an, aceeasi grupa. Afisati 3 coloane, exact asa cum sunt in baza de date: nr_matricol, nume, prenume.*/
--studenti s1 reprezinta Popescu Bogdan, iar studenti s2 sunt colegii lui (am partitionat tabela studenti in doua)
--evident s1.nr_matricol<>s2.nr_matricol, deoarece s1.nr_matricol este matricola lui Popescu Bogdan, iar s2.nr_matricol reprezinta matricolele colegilor
--s1.grupa=s2.grupa and s1.an=s2.an deoarece coleg inseamna sa fie din acelasi an si aceeasi grupa cu cel caruia ii afisam colegii
select s2.nr_matricol,s2.nume,s2.prenume
from studenti s1 join studenti s2 on s1.nr_matricol<>s2.nr_matricol
where s1.grupa=s2.grupa and s1.an=s2.an and s1.nume='Antonie' and s1.prenume='Ioana'
order by s2.nr_matricol;


--2.Pentru fiecare prof afisati colegii acestuia, impreuna cu cursurile tinute.
--Coleg inseamna sa tina acelasi curs cu el. Afisarea o vom face sub forma unei propozitii.
select trim(p1.nume) ||' are coleg pe '||trim(p2.nume)||' si tine cursul de '||c1.titlu_curs as Propozitie
from profesori p1 join profesori p2 on p1.id_prof<>p2.id_prof 
  join didactic d1 on d1.id_prof=p1.id_prof join didactic d2 on d2.id_prof=p2.id_prof 
  join cursuri c1 on c1.id_curs=d1.id_curs join cursuri c2 on c2.id_curs=d2.id_curs and c2.id_curs=c1.id_curs;
  
/*3.Sa se afiseze cupluri de numere matricole impreuna cu un ID al unui curs astfel 
incat studentul avand primul numar matricol a luat nota strict mai mare decat studentul 
avand cel de-al doilea numar matricol la cursul cu ID-ul dat de cea de-a treia coloana.
Afisarea se va face doar pentru cursurile cu ID-urile 21 si 24. Coloanele se vor numi "M1", "M2", "curs".*/
select n1.nr_matricol as M1,n2.nr_matricol as M2,n1.id_curs as curs
from note n1 join note n2 on n1.valoare>n2.valoare 
where n1.id_curs=n2.id_curs and n1.id_curs in ('21','24');  
  
/*4.Pentru cursul de BD, afisati toate perechile de studenti ce au luat note, dar fara a afisa duplicate.
Primul va fi afisat studentul ce a luat nota mai mare (iar daca sunt doi cu aceeasi cota, se vor afisa de doua ori,
adica si a cu b, dar si b cu a). Afisati si notele !*/  
select s1.nr_matricol||' '||s1.nume||' '||s1.prenume||' '||n1.valoare as student1,s2.nr_matricol||' '||s2.nume||' '||s2.prenume||' '||n2.valoare as student2
from studenti s1 join studenti s2 on s1.nr_matricol<>s2.nr_matricol 
  join note n1 on s1.nr_matricol=n1.nr_matricol join note n2 on n2.nr_matricol=s2.nr_matricol
  join cursuri c on c.id_curs=n1.id_curs and c.id_curs=n2.id_curs and n1.valoare>=n2.valoare
where titlu_curs='BD';  


/*5.Afisati toate perechile de profesori ce nu au grad didactic. Eliminati duplicatele.
Prima coloana se va numi "prof1", iar a doua se va numi "prof2".*/
select p1.nume||' '||p1.prenume as prof1,p2.nume||' '||p2.prenume as prof2
from profesori p1 join profesori p2 on p1.id_prof<p2.id_prof 
where p1.grad_didactic is null and p2.grad_didactic is null
order by p1.nume;

/*6.Afisati perechile de cursuri la care s-a pus cel putin o nota de 10. Eliminati duplicatele.
Vor fi deci doua coloane, numite "Curs1" si "Curs2".*/
select distinct c1.titlu_curs as "Curs1",c2.titlu_curs as "Curs2"
from cursuri c1 join cursuri c2 on c1.id_curs<c2.id_curs join note n1 on n1.id_curs=c1.id_curs join note n2 on n2.id_curs=c2.id_curs
where n1.valoare=10 and n2.valoare=10;

/*7.Afisati perechile de cursuri la care nu s-a pus nici o nota. Eliminati duplicatele.
Vor fi deci doua coloane, numite "Curs1" si "Curs2".*/
select c1.titlu_curs as "Curs1",c2.titlu_curs as "Curs2"
from cursuri c1 join cursuri c2 on c1.id_curs<c2.id_curs left join note n1 on n1.id_curs=c1.id_curs left join note n2 on n2.id_curs=c2.id_curs
where n1.id_curs is null and n2.id_curs is null;

/*8.Afisati perechile de studenti (matricol, nume, prenume) care nu au nici o nota. Eliminati duplicatele*/
--evident ca in baza noastra de date cei ce nu au note sunt cei din anul 1, dar sub nici o forma la examenul final sa nu faceti hardcodari
--veti fi penalizati !!!!
select s1.nr_matricol||' '||s1.nume||' '||s1.prenume as student1,
  s2.nr_matricol||' '||s2.nume||' '||s2.prenume as student2
from studenti s1 join studenti s2 on s1.nr_matricol<s2.nr_matricol left join note n1 on s1.nr_matricol=n1.nr_matricol
  left join note n2 on s2.nr_matricol=n2.nr_matricol
where n1.nr_matricol is null and n2.nr_matricol is null;

/*9.Afisati perechile de profesorii ce nu tin nici un curs. Eliminati duplicatele.*/
select p1.nume||' '||p1.prenume as prof1, p2.nume||' '||p2.prenume as prof2
from profesori p1 join profesori p2 on p1.id_prof<p2.id_prof left join didactic d1 on p1.id_prof=d1.id_prof
   left join didactic d2 on d2.id_prof=p2.id_prof
where d1.id_curs is null and d2.id_curs is null;

/*10.Afisati perechile de studenti ce au aceeasi nota la materiile din anul 1. Eliminati duplicatele.
Afisati si cursurile si notele ! Sunt deci doar 2 coloane. Coloanele se vor numi "student1" si "student2"*/
select s1.nr_matricol||' '||s1.nume||' '||s1.prenume||' '||c1.titlu_curs||' '||n1.valoare as student1,
  s2.nr_matricol||' '||s2.nume||' '||s2.prenume||' '||c2.titlu_curs||' '||n2.valoare as student2  
from studenti s1 join studenti s2 on s1.nr_matricol<s2.nr_matricol join note n1 on s1.nr_matricol=n1.nr_matricol
  join note n2 on n2.nr_matricol=s2.nr_matricol join cursuri c1 on c1.id_curs=n1.id_curs 
  join cursuri c2 on c2.id_curs=n2.id_curs
where n1.valoare=n2.valoare and c1.an=1 and c2.an=1
order by 1;  
  
  
--11.Sa se afiseze numele si prenumele profesorilor care nu au nici un grad didactic impreuna cu numele si prenumele profesorilor 
--care nu au gradul didactic de Conf. Faceti sortarea in ordinea numelui de familie.
select nume,prenume
from profesori
where grad_didactic is null 
union 
select nume,prenume
from profesori
where grad_didactic <>'Conf'
order by 1;  

--12.Afisati numele inversat concatenat cu prenumele intr-o coloana numita "Studs" (ucsepoPBogdan), bursa marita cu 15 ron pentru cei
ce au bursa si cu 1500 pentru cei ce nu au intr-o coloana numita "Bursieri" si o a treia coloana numita "value" unde veti avea nr 
matricol adunat cu bursa (unde bursa este null ramane null).*/
select reverse(nume) || prenume as Studs,bursa+15 as Bursieri,bursa+to_number(nr_matricol) as value
from studenti 
where bursa is not null
union all
select reverse(nume) || prenume as Studs,1500 as Bursieri,null as value
from studenti
where bursa is null
order by 2;


/*13.Selectati in coloana "Informatii", concatenate prin '*': numele, prenumele si anul de studiu al studetilor care au un nr matricol 
nr impar si care au bursa cuprinsa intre 200 si 400 lei. In aceeasi coloana, folosind aceeasi concatenare, afisati id-ul, numele si gradul didactic al
profesorilor care au minim un 'a' in nume, minim un 'i' in prenume si care au gradul de Prof. Nu mai folositi TRIM ! HINT: 4 inregistrari.*/
select nume||'*'||prenume||'*'||an as "Informatii"
from studenti
where mod(to_number(nr_matricol),2)<>0 and bursa between 200 and 400 
union
select id_prof||'*'||nume||'*'||grad_didactic as "Informatii"
from profesori
where nume like '%a%' and prenume like '%i%' and grad_didactic='Prof'
order by 1 desc;