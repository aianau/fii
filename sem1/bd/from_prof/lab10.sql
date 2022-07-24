--1.Afisati numele studentilor care iau cea mai mare bursa acordata.*/
select nr_matricol,nume,prenume,bursa
from studenti
where bursa=
  (select max(bursa)
  from studenti);
  
--2.Afisati numele studentilor care sunt colegi cu un student pe nume Arhire (coleg = acelasi an si aceeasi grupa).*/  
select nr_matricol,nume,prenume,grupa
from studenti
where (an,grupa) in
  (select an,grupa
  from studenti
  where nume='Arhire') and nume<>'Arhire'
order by 1;
  
--varianta cu subinterogare corelata (cu operatorul 'exists') - oficial, se face in laboratorul urmator !
select s1.nr_matricol,s1.nume,s1.prenume,s1.grupa
from studenti s1
where exists
  (select 'X'
  from studenti s2
  where s1.an=s2.an and s1.grupa=s2.grupa and s2.nume='Arhire') and s1.nume<>'Arhire'
order by 1;  

  
--3.Pentru fiecare grupa afisati numele studentilor care au obtinut cea mai mica nota la nivelul grupei.*/  
--avem 7 grupe in total, deci ar trebui sa apara minim 7 studenti
select distinct s.nr_matricol,nume,prenume,grupa,an,valoare
from studenti s join note n on n.nr_matricol=s.nr_matricol
where (valoare,an,grupa) in
  (select min(valoare),an,grupa
  from note n join studenti s on n.nr_matricol=s.nr_matricol
  group by an,grupa)
order by 5,4; 

--sau varianta cu subinterogare corelata
select distinct nume,prenume,an,grupa
from studenti
where nr_matricol in 
  (select s1.nr_matricol 
  from studenti s1 join note n1 on n1.nr_matricol=s1.nr_matricol
  where n1.valoare in
    (select min(n2.valoare)
    from note n2 join studenti s2 on n2.nr_matricol=s2.nr_matricol
    group by s2.an,s2.grupa
    having s1.an=s2.an and s1.grupa=s2.grupa));


--4.Identificati studentii a caror medie este mai mare dec�t media tuturor notelor din baza de date. Afisati numele si media acestora.*/  
--in aceasta interogare am afisat (ultima coloana) si media la nivel de intreaga facultate - evident, o singura valoare
select s.nr_matricol,nume,prenume,round(avg(valoare),2) as medie_student,
  (select round(avg(valoare),2)from note) as medie_generala_facultate
from studenti s join note n on n.nr_matricol=s.nr_matricol
group by s.nr_matricol,nume,prenume
having avg(valoare)>
  (select avg(valoare)
  from note)
order by 4 desc;


--5.Afisati numele si media primilor trei studenti ordonati descrescator dupa medie.*/
select * 
from
  (select s.nr_matricol,nume,prenume,rank()over(order by avg(valoare)desc) as pozitie,round(avg(valoare),2) as medie_student
  from studenti s join note n on n.nr_matricol=s.nr_matricol
  group by s.nr_matricol,nume,prenume)
where pozitie<=3;  

--sau
select *
from (select s.nr_matricol,nume,prenume,round(avg(valoare),2) as medie_student
     from studenti s join note n on s.nr_matricol=n.nr_matricol
     group by s.nr_matricol,nume,prenume 
     order by 4 desc)
where rownum <= 3;

--6.Afisati numele studentului (studentilor) cu cea mai mare medie precum si valoarea mediei (atentie: 
--limitarea num�rului de linii poate elimina studentii de pe pozitii egale; g�siti alt� solutie).*/
select s.nr_matricol,nume,prenume,an,grupa,round(avg(valoare),2) as medie_student
from studenti s join note n on s.nr_matricol = n.nr_matricol
group by s.nr_matricol,nume,prenume,an,grupa
having avg(valoare) in
  (select max(avg(valoare))
  from studenti s join note n on s.nr_matricol = n.nr_matricol
  group by s.nr_matricol);
  
--sau
select * 
from
  (select s.nr_matricol,nume,prenume,round(avg(valoare),2) as medie_student,rank()over(order by avg(valoare)desc) as pozitie
  from studenti s join note n on n.nr_matricol=s.nr_matricol
  group by s.nr_matricol,nume,prenume)
where pozitie=1;  

--7.Afisati numele si prenumele tuturor studentilor care au luat aceeasi nota ca si Ciprian Ciobotariu la materia Logic�. 
--Exclude�i-l pe acesta din list�.*/
select s.nr_matricol,nume,prenume,valoare
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
where(valoare,titlu_curs) in
  (select valoare,titlu_curs
  from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
  where nume='Ciobotariu' and prenume='Ciprian' and titlu_curs='Logica') and nume<>'Ciobotariu' and prenume<>'Ciprian'
order by 1;  


--Interogari suplimentare*/
--1.Sa se afiseze cursul (sau cursurile) la care s-au pus cele mai multe note, iar pentru acest curs (sau cursuri) sa se afiseze
--cea mai mica nota, cea mai mare nota, precum si media tuturor notelor. Sa se rotunjeasca media la 2 zecimale superior(cu round).
--Sa se faca sortarea dupa titlul cursului, descrescator.*/
select titlu_curs,count(valoare) as nr_note,min(valoare)nota_min,max(valoare)nota_max,round(avg(valoare),2) as medie
from cursuri c join note n on n.id_curs=c.id_curs
group by titlu_curs
having count(valoare) = 
  (select max(count(valoare)) 
  from note
  group by id_curs)
order by 1 desc;

--2.Sa se afiseze cei mai slabi doi studenti din punct de vedere al mediilor obtinute si sa se 
--afiseze si media acestora. Se vor afisa numarul matricol (coloana nr_matricol din tabela studenti),
--numele acestora (coloana nume din tabela studenti) si media obtinuta (coloana se va numi
--medie). Se iau in considerare absolut toti studentii carora li s-au pus note,
--chiar si cei ce au obtinut note mai mici de 5 !. Media sa se rotunjeasca la 2 zecimale cu functia trunc. Sortarea sa se 
--faca in functie de medie, descrescator.*/
select s.nr_matricol,nume,trunc(avg(valoare),2) as medie
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume
having avg(valoare)<
  (select min(avg(valoare))
  from studenti s inner join note n on s.nr_matricol=n.nr_matricol
  group by n.nr_matricol
    having avg(valoare)>
      (select min(avg(valoare))
      from studenti s inner join note n on s.nr_matricol=n.nr_matricol
      group by n.nr_matricol
        having avg(valoare)>
        (select min(avg(valoare))
        from studenti s inner join note n on s.nr_matricol=n.nr_matricol
        group by n.nr_matricol)))
order by 2;
--varianta cu functia rank(), mult mai simpla !
select * 
from
  (select s.nr_matricol,nume,rank()over(order by avg(valoare)) as pozitie_din_coada,round(avg(valoare),2) as medie_student
  from studenti s join note n on n.nr_matricol=s.nr_matricol
  group by s.nr_matricol,nume,prenume)
where pozitie_din_coada<=2; 

--3.Care este studentul, nerestantier, care are cea mai mica medie? Sa se afiseze doar matricola (coloana se va numi nr_matricol, exact
--ca in tabela studenti),numele si prenumele studentului (coloanele se vor numi nume si prenume exact ca in tabela studenti), 
--precum si media acestuia (coloana se va numi medie).*/
select s.nr_matricol,nume,prenume,avg(valoare) as medie
from note n join studenti s on n.nr_matricol=s.nr_matricol
group by s.nr_matricol, nume,prenume
having avg(valoare) = 
	(select min(avg(valoare))
	from note
	where nr_matricol not in	
		(select nr_matricol
    from note
    where valoare<5)
    group by nr_matricol);

--sau
select *
from
  (select s.nr_matricol,nume,prenume,rank() over(order by avg(valoare))as pozitie_din_coada,trunc(avg(valoare),2) as medie
  from note n join studenti s on n.nr_matricol=s.nr_matricol
  where s.nr_matricol not in
	(select nr_matricol
	from note
	where valoare<5)
  group by s.nr_matricol,nume,prenume)x
where pozitie_din_coada=1; 

--4.Pentru fiecare student aflati disciplinele la care a luat o nota peste media acelor discipline sau cel putin egala. 
--Afisati numele studentilor in coloana nume, denumirea disciplinelor in coloana titlu_curs, 
--notele studentilor in coloana valoare si media disciplinei in coloana medie.
select nume,titlu_curs,valoare,round((select avg(valoare) from note n where n.id_curs=n1.id_curs),2) as medie
from cursuri c join note n1 on c.id_curs=n1.id_curs join studenti s on s.nr_matricol=n1.nr_matricol
where valoare >= 
  (select avg(valoare) 
  from note n join cursuri c on c.id_curs=n.id_curs) 
order by 2;

--5.Pentru toti studentii nerestantieri din anii 2 si 3 afisati notele de 10 ale acestora si disciplinele aferente.
--Sa se afiseze numele si prenumele studentilor in coloanele nume si prenume, titlul cursului in coloana titlu_curs si valoarea notei in coloana valoare.
--Evident valoare notei este doar 10 !*/
select s.nr_matricol,nume,prenume,titlu_curs,valoare
from cursuri c join note n on c.id_curs=n.id_curs join studenti s on s.nr_matricol=n.nr_matricol
where s.an in (2,3) and valoare=10 and s.nr_matricol not in
  (select nr_matricol
  from note
  where valoare <5)
order by 1;  

--6.Sa se afiseze numele, prenumele, numarul matricol si media trunchiata la 2 zecimale pentru toti studentii 
--care au EXACT o restanta (au o singura nota mai mica decat 5). Coloana mediei se va numi "Media".*/
select nume, prenume, s.nr_matricol, trunc(avg(valoare),2) as "Media" 
from studenti s join note n on n.nr_matricol=s.nr_matricol
group by nume, prenume, s.nr_matricol
having (s.nr_matricol,1) in 
  (select nr_matricol, count(*) 
  from note 
  where valoare<5 
  group by nr_matricol)
order by 4 desc;

--7.Identificati primele patru cursuri cu cea mai mare medie a tuturor notelor puse. 
--Pentru acestea afisati titlul cursului cu aliasul "Titlu curs" si media tuturor notelor puse la acel curs cu aliasul "Medie curs".*/
select * from
  (select titlu_curs as "Titlu curs", avg(valoare) as "Medie curs"
  from note n join cursuri c on c.id_curs=n.id_curs
  group by titlu_curs
  order by 2 desc)
where rownum<=4; 

--8.Identificati primele doua grupe in care se obtine,
--insumat peste toti studentii, cea mai mica suma a burselor. Pentru acestea afisati anul, grupa si suma burselor cu aliasul "Bursa insumata".*/
select * from
  (select an,grupa,sum(bursa) as "Bursa insumata"
  from studenti
  group by an,grupa
  order by 3)
where rownum<3;

--9.Afisati numele concatenat cu prenumele prin semnul *  in coloana "N*P",numarul matricol in coloana "Nr.M" al
--studentului bursier cu cel mai mic nr_matricol din tabela.*/
select nume||'*'||prenume as "N*P",nr_matricol as "Nr.M" 
from studenti 
where nr_matricol=
  (select min(nr_matricol)
  from studenti 
  where bursa is not null);
  
--10.Selectati numele si prenume studentului care are media notelor mai mica decat media notelor luate la toate materiile care au id-ul cursului numar par.*/  
select nume, prenume 
from studenti s join note n on s.nr_matricol =  n.nr_matricol
group by nume, prenume ,s.nr_matricol
having avg(valoare) < 
  (select avg(valoare) 
  from note 
  where mod(id_curs, 2)=0);
  
--11. Afisati numele,prenumele si media rotunjita la doua zecimale a studentului sau studentilor cu cea mai mare medie.*/  
select nume,prenume,round(avg(valoare),2) as medie
from studenti s join note n on s.nr_matricol = n.nr_matricol
group by s.nr_matricol,nume,prenume
having avg(valoare) =
  (select max(avg(valoare))
  from studenti s join note n on s.nr_matricol = n.nr_matricol
  group by s.nr_matricol);
  
--12.Selectati numele, prenumele si numarul matricol al studentului cu numar matricol maxim.*/  
select nume,prenume,nr_matricol
from studenti
where nr_matricol = 
  (select max(nr_matricol) from studenti);
  
--13.Selectati in coloana "ID" id-ul cursurilor a caror medie a notelor este mai mare decat media tuturor notelor puse in anul 2015, 
--iar in coloana "Medie" media respectiva rotunjita cu 2 zecimale.*/  
select id_curs as "ID", round(avg(valoare),2) as "Medie" 
from note
group by id_curs
having avg(valoare) > 
  (select avg(valoare)
  from note 
  where extract(year from data_notare)=2015);
  
--14.Selectati numele concatenat printr-un spatiu cu prenumele in coloana "Profesori buni", media notelor puse de acestia in coloana "Medie", 
--pentru profesorii a caror medie a notelor puse este mai mare decat media tuturor notelor.*/  
select trim(nume)||' '||trim(prenume) as "Profesori buni",round(avg(valoare),2) as "Medie"
from profesori p join didactic d on d.id_prof=p.id_prof join note n on n.id_curs=d.id_curs 
group by trim(nume)||' '||trim(prenume),d.id_prof
having avg(valoare)>
  (select avg(valoare) from note);
  
--15.Aceeasi intrebare ca la 13, dar dorim sa afisam si media tuturor notelor. Evident, va fi aceeasi valoare pe toate liniile.*/  
select trim(nume)||' '||trim(prenume) as "Profesori buni",round(avg(valoare),2) as "Medie",
  (select round(avg(valoare),2)from note) as medie_generala_facultate
from profesori p join didactic d on d.id_prof=p.id_prof join note n on n.id_curs=d.id_curs 
group by trim(nume)||' '||trim(prenume),d.id_prof
having avg(valoare)>
  (select avg(valoare) from note);
  
--16.Afisati studentul cu cele mai multe note de 10. Sa se afiseze si cate astfel de note are.*/
select s.nr_matricol,nume,prenume,count(valoare) as "Note de 10"
from studenti s join note n on n.nr_matricol=s.nr_matricol 
where valoare=10
group by s.nr_matricol,nume,prenume
having count(valoare)=
	(select max(count(valoare))
  from note
  where valoare=10
  group by nr_matricol);
  
--17.Afisati studentii ce au media notelor mai mare decat media tuturor notelor de la BD.*/
select prenume,nume,avg(valoare) as "AVG"
from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
group by prenume,nume,s.nr_matricol
having avg(valoare)>
	(select avg(valoare)
  from studenti s join note n on n.nr_matricol=s.nr_matricol join cursuri c on c.id_curs=n.id_curs
	where titlu_curs='BD');
  
--18.Afisati titlurile cursurilor la care s-au pus cele mai multe note.*/
select titlu_curs
from cursuri c join note n on n.id_curs=c.id_curs
group by titlu_curs
having count(valoare)=
  (select max(count(valoare))
  from note
  group by id_curs);
  
--19.Afisati numarul de studenti adunat cu numarul de profesori intr-o coloana "NumarPersoane"*/  
select count(*) as "NumarPersoane"
from 
  (select id_prof||nume from profesori 
  union
  select nr_matricol||nume from studenti);
  
--20.Sa se afiseze profesorul(sau profesorii) care tin(e) disciplina cu cea mai mica medie a notelor.
--Sa se afiseze numele profesorului folosind trim in coloana "Prof", denumirea disciplinei in coloana "Curs" si media generala
--a respectivei discipline in coloana "Medie" (rotunjita cu 2 zecimale).*/
--select trim(nume) as "Prof",titlu_curs as "Curs",round(avg(valoare),2) as "Medie"
from note n join cursuri c on c.id_curs=n.id_curs join didactic d on d.id_curs=n.id_curs
	join profesori p on p.id_prof=d.id_prof
group by trim(nume),titlu_curs
having avg(valoare)=
  (select min(avg(valoare))
  from note
  group by id_curs);  
  
--21.Afisati cursul cu cei mai multi studenti picati impreuna cu numarul acestora. Coloanele se vor numi "CURS" si "NR PICATI"*/  
select titlu_curs as "CURS",count(nr_matricol) as "NR PICATI"
from note n join cursuri c on c.id_curs=n.id_curs
where valoare<5
group by titlu_curs
having count(nr_matricol)=
  (select max(count(nr_matricol))
  from note
  where valoare<5
  group by id_curs);
  
  




