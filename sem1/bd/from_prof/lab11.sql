--subinterogari corelate
--1.Afisati toti studentii care au �n an cu ei m�car un coleg care s� fie mai mic ca ei (vezi data nasterii).*/
select s1.nr_matricol,s1.nume,s1.prenume,s1.an,s1.grupa
from studenti s1
where exists(
  select 'X'
  from studenti s2
  where s1.an=s2.an and s1.grupa=s2.grupa and s1.data_nastere>s2.data_nastere)
order by 1;

--daca vrem sa afisam toate combinatiile folosim self join
select s1.nr_matricol,s1.nume,s1.prenume,s1.data_nastere,s1.an,s2.nr_matricol,s2.nume,s2.prenume,s2.data_nastere,s2.an
from studenti s1 join studenti s2 on s1.nr_matricol<>s2.nr_matricol
where s1.an=s2.an and s1.data_nastere>s2.data_nastere
order by 4,5,6;


--2.Afisati toti studentii care au media mai mare dec�t media tuturor studentilor din an cu ei. Pentru acestia afisati numele, prenumele si media lor.*/
select s1.nume,s1.prenume,s1.an,round(avg(n1.valoare),2) as medie_student
from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
group by s1.nr_matricol,s1.nume,s1.prenume,s1.an
having avg(n1.valoare)>
  (select avg(n2.valoare) 
  from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol
  where s2.an=s1.an)
order by 4;  

--dorim sa afisam si media pentru fiecare an in parte
select s.nr_matricol,s.nume,s.prenume,s.an,s.medie_student,ani.medie_an
  from (select s1.nr_matricol,s1.nume,s1.prenume,s1.an,round(avg(n1.valoare),2) as medie_student
        from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
        group by s1.nr_matricol, s1.nume, s1.prenume, s1.an
        having avg(n1.valoare) >= (select avg(n2.valoare)
                                  from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol where s2.an = s1.an)) s
  join (select s1.an, round(avg(n1.valoare), 2) as medie_an
        from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
        group by s1.an) ani
  on s.an = ani.an
  order by 4,5;


--3.Afisati numele, prenumele si grupa celui mai bun student din fiecare grupa �n parte.*/
select s1.nume,s1.prenume,s1.grupa,s1.an,round(avg(n1.valoare),2) as medie_student
from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
group by s1.nr_matricol,s1.nume,s1.prenume,s1.grupa,s1.an
having avg(n1.valoare) =
  (select max(avg(n2.valoare))
  from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol
  where s2.an=s1.an and s2.grupa=s1.grupa
  group by s2.nr_matricol)
order by 4,5 desc;


--4.G�si�i to�i studen�ii care au m�car un coleg �n acela�i an care s� fi luat aceea�i nota ca �i el la m�car o materie.*/
select distinct s1.nr_matricol,s1.nume,s1.prenume,s1.grupa,s1.an
from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
where exists(
  select 'X'
  from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol
  where s2.an = s1.an and n2.valoare = n1.valoare)
order by 1;  

--varianta cu in
select distinct s1.nr_matricol,s1.nume,s1.prenume,s1.grupa,s1.an
from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
where n1.valoare in (
  select n2.valoare
  from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol
  where s1.nr_matricol<>s2.nr_matricol and s2.an = s1.an and n2.valoare = n1.valoare)
order by 1;  

--5.Afisati toti studentii care sunt singuri �n grup� (nu au alti colegi �n aceeasi grup�).*/
select s1.nr_matricol,s1.nume,s1.prenume
from studenti s1
where not exists	
	(select 'X'
	from studenti s2 
	where s1.an=s2.an and s1.grupa=s2.grupa and s2.nr_matricol<>s1.nr_matricol)
order by 1;


--6.Afisati profesorii care au m�car un coleg (profesor) ce are media notelor puse la fel ca si el.*/
--facem perechi
select p1.nume,p2.nume,round(avg(n1.valoare),2) as medie
from profesori p1 join didactic d1 on p1.id_prof=d1.id_prof join note n1 on n1.id_curs=d1.id_curs join profesori p2 on p1.id_prof<p2.id_prof join 
	didactic d2 on d2.id_prof=p2.id_prof join note n2 on n2.id_curs=d2.id_curs
group by p1.id_prof,p2.id_prof,p1.nume,p2.nume
having avg(n1.valoare)=avg(n2.valoare)
order by 1;

--corelat
select p1.nume,avg(n1.valoare) as medie 
from profesori p1 join didactic d1 on d1.id_prof=p1.id_prof join note n1 on n1.id_curs=d1.id_curs
where exists	
	(select 'X'
	from profesori p2 join didactic d2 on d2.id_prof=p2.id_prof join note n2 on n2.id_curs=d2.id_curs 
	where p1.id_prof<>p2.id_prof
	having round(avg(n1.valoare))=round(avg(n2.valoare)))
group by p1.id_prof,p1.nume;


--7.Fara a folosi join, afisati numele si media fiecarui student.*/
select s.nr_matricol,s.nume,nvl(to_char(round(t1.medie,2)),'nu are note') as medie
from studenti s left join (select nr_matricol,avg(nvl(valoare,0)) as medie from note group by nr_matricol) t1 on s.nr_matricol=t1.nr_matricol;


--8.Afisati cursurile care au cel mai mare numar de credite din fiecare an (pot exista si mai multe pe an).
-- - Rezolvati acest exercitiu si corelat si necorelat (se poate in ambele moduri). Care varianta este mai eficienta ?*/
--necorelat
select titlu_curs,an,credite
from cursuri 
where (an,credite) in
	(select an,max(credite)
	from cursuri
	group by an);

--corelat (mai eficienta ca timp de executie)
select titlu_curs,an,credite
from cursuri c1
where credite=
  (select max(credite)
  from cursuri c2
  where c2.an=c1.an); 



--Interogari suplimentare
--1.Pentru fiecare grupa din fiecare an identificati cel mai in varsta student (cu cea mai mica data de nastere). Afisati numele lui, anul si grupa.*/ 
select s1.nume,s1.an,s1.grupa
from studenti s1
where s1.data_nastere=
  (select min(s2.data_nastere)
  from studenti s2
  where s1.grupa=s2.grupa and s1.an=s2.an)
order by 2,3;

--2.Afisati numele, prenumele, media rotunjita la 2 zecimale sub coloana "Medie" si Semianul, pentru studentii cu cea mai mica medie din fiecare semian.*/ 
select s1.nume,s1.prenume,round(avg(valoare),2) as "Medie",substr(s1.grupa,1,1) as "Semian"
from studenti s1 join note n on s1.nr_matricol=n.nr_matricol
group by s1.nume,s1.prenume,s1.nr_matricol,an,substr(s1.grupa,1,1)
having avg(valoare)=(
  select min(avg(valoare))
  from studenti s2 join note n on s2.nr_matricol=n.nr_matricol
  where substr(s2.grupa,1,1)=substr(s1.grupa,1,1)
  group by s2.nr_matricol);
  
--3.Selectati, pentru fiecare grupa (identificata prin grupa si an): anul, grupa, 
--numarul matricol, numele si prenumele studentilor cu varsta cea mai mica (in acea grupa), ordonand crescator dupa an si grupa. 
--[hints: months_between, sysdate]*/
select s1.an,s1.grupa,s1.nr_matricol,s1.nume,s1.prenume 
from studenti s1
group by s1.an,s1.grupa,s1.nr_matricol,s1.nume,s1.prenume,s1.data_nastere
having months_between(sysdate,s1.data_nastere)=
  (select min(months_between(sysdate,s2.data_nastere))
  from studenti s2
  where s1.an=s2.an and s1.grupa=s2.grupa
  group by s2.grupa,s2.an)
order by s1.an,s1.grupa; 

--4.Afisati numele, prenumele si grupa studentilor pentru care in grupa lor s-a obtinut macar o nota de 10.*/  
select nume, prenume, grupa
from studenti s1
where exists 
  (select 'X' 
  from studenti s2 join note n on s2.nr_matricol=n.nr_matricol 
  where valoare=10 and s1.grupa=s2.grupa and s1.an=s2.an)
order by s1.grupa;

--5.Pentru fiecare disciplina de studiu identificati numele studentului (studentilor) 
--care au obtinut cea mai mare nota pusa. Veti afisa titlul cursului, numele si prenumele studentului si valoarea notei primite.*/  
select c1.titlu_curs,s1.nume,s1.prenume,n1.valoare
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol join cursuri c1 on c1.id_curs=n1.id_curs
where n1.valoare=
  (select max(n2.valoare) 
  from note n2 where n2.id_curs=n1.id_curs)
order by c1.titlu_curs;

--6.Afisati pe o singura coloana "Profesor" numele profesorilor pentru care exista macar inca un coleg profesor care sa predea acelasi curs. Nu vor aparea duplicate.*/
select nume as "Profesor"
from profesori p1 join didactic d1 on d1.id_prof=p1.id_prof
where exists
  (select 'X' 
  from profesori p2 join didactic d2 on d2.id_prof=p2.id_prof
  where d1.id_curs=d2.id_curs and p1.id_prof<>p2.id_prof);  

--7.Pentru fiecare semestru din fiecare an de studiu (din tabela Cursuri) identificati cursul (sau cursurile)
--la care se pun in medie cele mai mari note. Veti afisa semestrul, anul, titlul cursului si media tuturor notelor puse la acel curs cu aliasul "Medie".
--sortati descrescator dupa coloana "Medie".*/
select c1.semestru,c1.an,c1.titlu_curs,avg(n1.valoare) as "Medie"
from cursuri c1 join note n1 on c1.id_curs=n1.id_curs
group by c1.semestru,c1.an,c1.titlu_curs
having avg(n1.valoare)=
  (select max(avg(n2.valoare))
  from cursuri c2 join note n2 on c2.id_curs=n2.id_curs
  where c1.semestru=c2.semestru and c1.an=c2.an
  group by n2.id_curs)
order by 4 desc; 

--8.Consideram cursurile impartite in doua categorii: cursuri cu id par si cursuri cu id impar. Sa se afiseze id-ul,
--titlul si media notelor puse (in coloana "Medie") pentru cursul/cursurile din fiecare din cele doua categorii
--care au cea mai mica medie in cadrul categoriei din care fac parte (se iau in considerare doar cursurile la care exista cel putin o nota pusa).*/
select c1.id_curs, c1.titlu_curs, avg(n1.valoare) as "Medie" 
from cursuri c1 join note n1 on c1.id_curs=n1.id_curs 
group by c1.id_curs, c1.titlu_curs, n1.id_curs
having avg(n1.valoare) = 
  (select min(avg(n2.valoare))
  from cursuri c2 join note n2 on c2.id_curs=n2.id_curs 
  where mod(to_number(c2.id_curs),2)=mod(to_number(c1.id_curs),2) 
  group by n2.id_curs);
  
--9.Afisati numele, prenumele, bursa si anul pentru studentii care au bursa mai mare strict decat media burselor din anul sau.*/  
select s1.nume,s1.prenume,s1.bursa,s1.an 
from studenti s1 
where s1.bursa > 
  (select avg(s2.bursa) 
  from studenti s2
  where s1.an = s2.an);

--10.Sa se afiseze numele si prenumele studentilor care au bursa si care mai au in grupa 
--(identificata prin an si grupa) un alt coleg care are bursa. Se vor afisa doar numele si prenumele, nu si alte informatii.*/
select s1.nume,s1.prenume 
from studenti s1 
where s1.bursa is not null and exists (
  select s2.nume 
  from studenti s2
  where s2.bursa is not null and s2.an=s1.an and s2.grupa=s2.grupa and s2.nr_matricol<>s1.nr_matricol);

--11.Afi�a�i numele si prenumele concatenate printr-un spatiu in coaloana "Student", anul, grupa, si media trunchiata la 2 zecimale
--a celui mai slab student din fiecare grupa �n parte(cea mai mica medie din grupa). Redenumiti coloana pentru medie cu "Medie"*/
select s1.nume||' '||s1.prenume as "Student",s1.an,s1.grupa,trunc(avg(n1.valoare),2) as "Medie"
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol
group by s1.nume||' '||s1.prenume,s1.grupa,s1.an,s1.nr_matricol
having avg(n1.valoare)=
  (select min(avg(n2.valoare))
  from studenti s2 join note n2 on s2.nr_matricol=n2.nr_matricol 
  where s2.an=s1.an and s2.grupa=s1.grupa 
  group by s2.nr_matricol)
order by 2,3;  

--12.Sa se afiseze numarul matricol, numele, prenumele si media trunchiata la doua
--zecimale pentru toti studentii care au MAI MULT de o restanta (cel putin doua note strict mai mici decat 5). Numiti coloana mediei "MEDIE".*/
select s1.nr_matricol,s1.nume,s1.prenume,trunc(avg(valoare),2) as medie
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol
where 1<
  (select count(n2.nr_matricol)
  from studenti s2 join note n2 on s2.nr_matricol=n2.nr_matricol
  where n2.valoare<5 and s1.nr_matricol=s2.nr_matricol)
group by s1.nr_matricol,s1.nume,s1.prenume;  

--13.Pentru fiecare an de studiu sa se afiseze anul si titlul cursului (sau a cursurilor) cu numarul maxim de credite pentru acel an.
--Sa se afiseze si nr de credite.*/
select titlu_curs,an,credite
from cursuri c1
where credite=
  (select max(credite)
  from cursuri c2
  where c2.an=c1.an);

--14.Afisati numele si prenumele studentilor care in tabelul studenti nu mai au nici un coleg de grupa (grupa este identificata prin an si grupa).*/
select s1.nume,s1.prenume 
from studenti s1 
where not exists 
  (select 'X' 
  from studenti s2 
  where s2.an=s1.an and s2.grupa=s1.grupa and s2.nr_matricol<>s1.nr_matricol);

--15.Fiecarui student din facultate i se va adauga la bursa curenta, fie ea chiar 0 (null), 
--valoarea bursei colegului de grupa cu cea mai mare bursa (grupa se identifica prin an, grupa).
--Afisati numele, prenumele si noua bursa (in coloana "Bursa"). Pentru cei care in continuare nu au bursa, se va afisa 0.*/
select s1.nume, s1.prenume, nvl(s1.bursa,0)+
  nvl((select max(s2.bursa) 
      from studenti s2
      where s1.grupa=s2.grupa and s1.an=s2.an),0) as "Bursa" 
from studenti s1;

--16.Afisati numele si prenumele studentilor ce au macar un coleg de an (in afara de el insusi) nascut in aceeasi luna.*/
select s1.nume,s1.prenume
from studenti s1
where exists
  (select 'X'
  from studenti s2
  where extract(month from s1.data_nastere)=extract(month from s2.data_nastere) and s1.an=s2.an and s1.nr_matricol<>s2.nr_matricol);
  
--17.Afisati numele, prenumele, anul si grupa pntru studentii care au un coleg de grupa numit Ciprian. Cei numiti Ciprian, se exclud.*/
--exemplu de interogare ce se poate rezolva atat cu subinterogare corelata cat si cu subinterogare necorelata
--varianta cu subinterogare corelata
select s1.nume,s1.prenume,s1.an,s1.grupa
from studenti s1
where exists
  (select 'X'
  from studenti s2
  where s1.an=s2.an and s1.grupa=s2.grupa and s2.prenume='Ciprian') and s1.prenume<>'Ciprian';
  
--varianta cu subinterogare necorelata
select nume, prenume,an ,grupa
from studenti
where (an,grupa) in
  (select an,grupa 
  from studenti
  where prenume = 'Ciprian') and prenume <> 'Ciprian';
  
--18.Afisati nr_matricol, nume, prenume, an, grupa si valoare notei (in coloana "Nota") pentru acei studenti al caror
--nume sau prenume coincide cu al unui alt student. 
--Ordonati crescator dupa an si grupa. Atentie: doar nota va avea alias pe coloana, celelalte campuri isi vor pastra denumirea din baza de date.*/
select s1.nr_matricol,s1.nume,s1.prenume,s1.an,s1.grupa,valoare as "Nota"
from studenti s1 join note n on s1.nr_matricol=n.nr_matricol
where s1.nume in (select s2.nume from studenti s2 having count(s2.nume)>1 group by s2.nume)
  or s1.prenume in (select s2.prenume from studenti s2 having count(s2.prenume)>1 group by s2.prenume)
order by 1;  

--19.Selectati in coloana "Student" numarul matricol, iar in coloana "Numar de note" numarul de note
--pentru TOTI studentii care sunt baieti si au cel putin o colega de grupa. Grupa este indentificata prin an si grupa. Ordonati crescator dupa numarul de note.
--Hint: diferenta fete/baieti se face pe baza ultimei litere din prenume (este sau nu 'a'). Atentie sa nu uitati vreun student!*/
--varianta cu in 
select s1.nr_matricol as "Student",count(valoare) as "Numar de note" 
from studenti s1 left join note n on s1.nr_matricol = n.nr_matricol
where prenume not like '%a' and (an,grupa) in 
	(select s2.an,s2.grupa
  from studenti s2 
  where s2.prenume like '%a')
group by s1.nr_matricol
order by 2;

--varianta cu operatorul EXISTS (necorelata)
select s1.nr_matricol as "Student",count(valoare) as "Numar de note" 
from studenti s1 left join note n on s1.nr_matricol = n.nr_matricol
where prenume not like '%a' and exists
  (select 'X'
  from studenti s2 
  where s2.prenume like '%a' and s1.an=s2.an and s1.grupa=s2.grupa)
group by s1.nr_matricol
order by 2;  

--20.Pentru fiecare curs in parte la care s-a pus cel putin o nota afisati procentul studentilor promovati. Coloanele sunt "Curs" si "Procent".*/
select c1.titlu_curs as "Curs",
  (select count(c2.titlu_curs)
  from cursuri c2 left join note n on n.id_curs=c2.id_curs 
  where (valoare>=5) and c1.titlu_curs=c2.titlu_curs
  group by c1.titlu_curs)*100/ 
  (select count(c2.titlu_curs) 
  from cursuri c2 left join note n on n.id_curs=c2.id_curs 
  where c1.titlu_curs=c2.titlu_curs
  group by c1.titlu_curs) as "Procent"
from cursuri c1 join note n on c1.id_curs=n.id_curs
group by c1.titlu_curs;  

--21.Pentru fiecare semian ('A' si 'B'), scrieti in coloana "%" rata celor NEPROMOVATI. 
--Semianul va fi scris in coloana "Semian". A fi nepromovat inseamna a avea o nota sub 5 
--sau a nu avea nicio nota la o materie la care S-AU PUS note pana in momentul de fata.
--(Deci Sec. Info., Limbaje Formale si DSFUM nu intra in calcul). Media va fi lasata asa cum este.*/
select substr(s1.grupa,1,1) as "Semian",
  (select count(distinct s2.nr_matricol)
  from studenti s2 left join note n on n.nr_matricol=s2.nr_matricol 
  where substr(s1.grupa,1,1)=substr(s2.grupa,1,1) and (valoare<5 or valoare is null) 
  group by substr(s1.grupa,1,1))*100/ 
  (select count(distinct s2.nr_matricol)
  from studenti s2 left join note n on n.nr_matricol=s2.nr_matricol 
  where substr(s1.grupa,1,1)=substr(s2.grupa,1,1)
  group by substr(s1.grupa,1,1)) as "%" 
from studenti s1 
group by substr(s1.grupa,1,1);


--22.Afisati anul si grupa in care exista macar 2 studenti bursieri*/
select distinct s1.an,s1.grupa
from studenti s1
where 2<=
  (select count(s2.nr_matricol)
  from studenti s2 
  where s2.bursa is not null and s1.an=s2.an and s1.grupa=s2.grupa);

--23.Afisati numele si prenumele studentilor restantieri ce au in aceeasi grupa macar un alt coleg restantier.*/
select s1.nume,s1.prenume
from studenti s1 join note n1 on n1.nr_matricol=s1.nr_matricol
where n1.valoare<5 and exists
	(select 'X'
  from studenti s2 join note n2 on n2.nr_matricol=s2.nr_matricol
  where s1.an=s2.an and s1.grupa=s2.grupa and n2.valoare<5 and s1.nr_matricol<>s2.nr_matricol);
  
--24.Afisati numele si prenumele tuturor studentilor din grupa studentului cel mai bun (care are media cea mai mare din facultate; grupa se identifica prin an,grupa).
--Studentul respectiv va fi inclus si el in rezultat. */
select nume, prenume 
from studenti
where (an, grupa) in 
  (select an, grupa 
  from studenti
  where nr_matricol in 
    (select nr_matricol 
    from note 
    group by nr_matricol 
    having avg(valoare)=
      (select max(avg(valoare)) 
      from note 
      group by nr_matricol)));  
      
--25.Afisati titlurile cursurilor care au o pereche (adica predate in acelasi an si au acelasi nr de credite).*/      
select distinct c1.titlu_curs
from cursuri c1
where exists
	(select 'X'
  from cursuri c2 
  where c2.an=c1.an and c1.credite=c2.credite and c1.titlu_curs<>c2.titlu_curs);
  
--26.Afisati studentii care au media notelor mai mare sau egala cu media grupei din care fac parte. Se iau in seama si studentii fara note.*/  
select s1.nume,s1.prenume,avg(n1.valoare) as "Medie"
from studenti s1 left join note n1 on s1.nr_matricol = n1.nr_matricol
group by s1.nr_matricol,s1.nume,s1.prenume,s1.an,s1.grupa
having avg(n1.valoare)>=
  (select avg(n2.valoare) 
  from studenti s2 left join note n2 on s2.nr_matricol = n2.nr_matricol
  where s2.an=s1.an and s2.grupa=s1.grupa);
  
--27.Afisati numele,prenume si grupa studentilor bursieri care mai au in grupa (grupa inseamna, evident, acelasi an si aceeasi grupa)
--macar un coleg cu aceeasi bursa cu a lui. De exemplu, grupa A2 din anul 2 nu este aceeasi cu grupa A2 din anul 3 !!!*/  
select s1.nume,s1.prenume,s1.grupa
from studenti s1
where s1.bursa is not null and exists
	(select 'x'
  from studenti s2
  where s2.bursa is not null and s1.bursa=s2.bursa and s1.an=s2.an and s1.grupa=s2.grupa and s1.nr_matricol<>s2.nr_matricol);
  
--28.Pentru fiecare grupa afisati numele, prenumele, media si grupa studentului cu cea mai mare medie.*/
select s1.nume,s1.prenume,round(avg(valoare),2) as "Medie",s1.grupa,s1.an
from studenti s1 join note n on s1.nr_matricol=n.nr_matricol
group by s1.nume,s1.prenume,s1.nr_matricol,an,s1.grupa,s1.an
having avg(valoare)=(
  select min(avg(valoare))
  from studenti s2 join note n on s2.nr_matricol=n.nr_matricol
  where s1.grupa=s2.grupa
  group by s2.nr_matricol)
order by 5,4;
  