--1.Scrie?i o interogare pentru a afi?a numele, prenumele, anul de studiu si data na?terii pentru to?i studen?ii.*/
select nr_matricol,nume,prenume,an,data_nastere
from studenti
order by 4;

--2.Scrie?i ?i executa?i o interogare pentru a afi?a �n mod unic valorile burselor.*/
select distinct bursa
from studenti
where bursa is not null and bursa<>0
order by 1;
/
select distinct bursa
from studenti
order by 1;

--3.Da?i fiec�rei coloane din clauza select de la interogarea 1 un alias. Executa?i �nterogarea.*/
select nr_matricol as cod_student,nume as nume_student,prenume as prenume_student,an as an_studii,data_nastere as data_nastere_student
from studenti
order by 4;

--4.Afi?a?i numele concatenat cu prenumele urmat de virgul� ?i anul de studiu. Ordona?i cresc�tor dup� anul de studiu. Denumi?i coloana �Studen?i pe ani de studiu�.*/
select nume||' '||prenume||', '||an as "Studenti pe ani de studiu"
from studenti
order by an;

--5.Afi?a?i numele, prenumele ?i data de nastere a studen?ilor n�scu?i �ntre 1 ianuarie 1995 si 10 iunie 1997. Ordona?i descendent dup� anul de studiu.*/
select nume,prenume,data_nastere
from studenti
where data_nastere between to_date('01-01-1995','dd/mm/yyyy') and to_date('10-06-1997','dd/mm/yyyy')
order by an desc;
--
select nume,prenume,data_nastere
from studenti
where data_nastere >='01-JAN-1995' and data_nastere<='10-JUN-1997'
order by an desc;

--6.Afi?a?i numele ?i prenumele precum ?i anii de studiu pentru to?i studen?ii n�scu?i �n 1995.*/
select nume,prenume,an
from studenti
where extract(year from data_nastere)=1995
order by 1;

--7.Afi?a?i studen?ii (toate informa?iile pentru ace?tia) care nu iau burs�.*/
select * from studenti
where bursa is null or bursa=0
order by 1;
--
select * from studenti
where bursa is null
union
select * from studenti
where bursa=0
order by 1;

--8.Afi?a?i studen?ii (nume ?i prenume) care iau burs� ?i sunt �n anii 2 ?i 3 de studiu. Ordona?i alfabetic ascendent dup� nume ?i descendent dup� prenume.*/
select nume,prenume,an,bursa
from studenti
where an in(2,3) and (bursa is not null or bursa<>0)
order by nume,prenume desc;
--
select nume,prenume,an,bursa
from studenti
where an in(2,3) and bursa is not null
order by nume,prenume desc;
--
select nume,prenume,an,bursa
from studenti
where an in(2,3) 
intersect
select nume,prenume,an,bursa
from studenti
where(bursa is not null and bursa<>0)
order by nume,prenume desc;


--9.Afi?a?i studen?ii care iau burs�, precum ?i valoarea bursei dac� aceasta ar fi m�rit� cu 15%.*/
select nume,prenume,bursa*1.15 as bursa_marita
from studenti
where bursa is not null and bursa<>0
order by 1;

--10.Afi?a?i studen?ii al c�ror nume �ncepe cu litera P ?i sunt �n anul 1 de studiu.*/
select nume,prenume
from studenti
where an=1 and nume like 'P%'
order by 1;

--11.Afi?a?i toate informa?iile despre studen?ii care au dou� apari?ii ale literei �a� �n prenume.*/
select * from studenti
where prenume like '%a%a%'
order by 1;

--daca dorim sa afisam pentru cazul general in care inclusiv litera de inceput a prenumelui este A
--se observa ca Alexandra nu mai apare, deoarece conforma acestei variante de rezolvare are 3 de a (incluzand aici si initiala) si nu mai respecta conditia !
--apare in schimb Andreea care are 2 de a, dar un a este A, adica initiala !
select * from studenti
where length(prenume)-2 = nvl(length(replace(lower(prenume), 'a','')),0)
order by 1;

--varianta in care se ignora litera 'A'
select * from studenti
where length(prenume)-2 = nvl(length(replace(lower(prenume), 'a','')),0)
minus
select * from studenti
where prenume like 'A%'
order by 1;

--12.Afi?a?i toate informa?iile despre studen?ii al c�ror prenume este �Alexandru�, �Ioana� sau �Marius�.*/
select * from studenti
where prenume in('Alexandru','Ioana','Marius')
order by 1;

--13.Afi?a?i studen?ii bursieri din semianul A*/
select nr_matricol,nume,prenume,bursa,grupa
from studenti
where grupa like 'A_' and (bursa is not null and bursa <>0)
order by 1;
--
delete from studenti where nr_matricol=666;
insert into studenti(nr_matricol,nume,an,grupa,bursa)values('666','Gigi',2,'A1',0);

--14.Afi�a�i numele �i prenumele profesorilor a c�ror prenume se termin� cu litera "n" (�ntrebare capcan�).*/
select nume,prenume
from profesori
where trim(prenume) like '%n'
order by 1;

--Interogari Suplimentare
--Afisati titlurile cursurilor care nu au nici un titular de curs.*/
select titlu_curs
from cursuri
minus
select titlu_curs 
from didactic d join cursuri c on c.id_curs=d.id_curs
order by 1; 

--Sa se afiseze numele si prenumele profesorilor care nu au nici un grad didactic impreuna cu numele si prenumele profesorilor 
care nu au gradul didactic de Conf. Faceti sortarea in ordinea numelui de familie.*/
select nume,prenume
from profesori
where grad_didactic is null or grad_didactic not in ('Conf')
order by nume;

--sau (varianta in care folosim operatorul union)
select nume,prenume
from profesori
where grad_didactic is null 
union 
select nume,prenume
from profesori
where grad_didactic <>'Conf'
order by 1;
