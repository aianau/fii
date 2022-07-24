--1.Afisati numarul de studenti din fiecare an.*/
select an,count(nr_matricol) as nr_studenti
from studenti
group by an
order by 1;

--2.Afisati numarul de studenti din fiecare grupa a fiecarui an de studiu. Ordonati crescator dupa anul de studiu si dupa grupa.*/
select an,grupa,count(nr_matricol) as nr_studenti
from studenti
group by an,grupa
order by 1,2;

--3.Afisati numarul de studenti din fiecare grupa a fiecarui an de studiu si specificati cati dintre acestia sunt bursieri.*/
select an,grupa,count(nr_matricol) as total_studenti,count(bursa) as bursieri
from studenti
group by an,grupa
order by 1,2;

--varianta cu limbaj procedural (cursori)
declare
	cursor c1 is 
	select an,grupa,count(nr_matricol) as nr_studenti
	from studenti
	group by an,grupa
	order by 1;
	cursor c2 is 
	select an,grupa,count(nr_matricol) as nr_bursieri
	from studenti
	where bursa is not null
	group by an,grupa
	order by 1;
begin
	dbms_output.put_line('Total studenti');
	for c1_record in c1 loop
		dbms_output.put_line('An - '||c1_record.an||' Grupa - '||c1_record.grupa||' Nr std - '||c1_record.nr_studenti);	
	end loop;
	dbms_output.put_line('Nr bursieri');
	for c2_record in c2 loop
		dbms_output.put_line('An - '||c2_record.an||' Grupa - '||c2_record.grupa||' Nr bursieri - '||c2_record.nr_bursieri);
	end loop; 
end;	

--4.Afisati suma totala cheltuita de facultate pentru acordarea burselor.*/
select sum(bursa) as total_burse
from studenti;


--5.Afisati valoarea bursei/cap de student (se consider� c� studentii care nu sunt bursieri primesc 0 RON); 
altfel spus: c�t se cheltuieste �n medie pentru un student?*/
select round(sum(nvl(bursa,0))/count(nr_matricol),2) as valoare_bursa_per_cap
from studenti;

--evident, daca ii luam in seama doar pe cei ce au burse, atunci media va fi (mult) mai mare
select round(sum(bursa)/count(nr_matricol),2) as valoare_bursa_per_cap
from studenti
where bursa is not null;


--6.Afisati num�rul de note de fiecare fel (c�te note de 10, c�te de 9,etc.). Ordonati descresc�tor dup� valoarea notei.*/
select valoare as nota,count(valoare) as nr_aparitii
from note
group by valoare
order by 1;


--7.Afisati numarul de note pus �n fiecare zi a s�pt�m�nii. Ordonati descresc�tor dup� numarul de note.*/
select to_char(data_notare,'day') as zi_sapt,count(valoare) as nr_note
from note
group by to_char(data_notare,'day')
order by 2 desc;


--8.Afisati num�rul de note pus �n fiecare zi a s�pt�m�nii. Ordonati cresc�tor dup� ziua saptamanii: Sunday, Monday, etc.*/
--varianta clasica, dar afisarea nu e tocmai cum se doreste (desi rezultatul e ok)
--apare mai intai friday, apoi monday, saturday, etc, deoarece se ia in seamna ordinea lexicografica
select to_char(data_notare,'day') as zi_nota,count(valoare) as nr_note
from note
group by to_char(data_notare,'day')
order by to_char(data_notare,'day');

--pentru a afisa fix in ordinea, mai adaugam in group by o grupare cu 'd', iar sortarea se face dupa 'd' (care intoarce un intreg, si anume nr zilei din sapt)
select to_char(data_notare,'day') as zi,count(valoare) as nr
from note
group by to_char(data_notare,'day'),to_char(data_notare,'d')
order by to_char(data_notare,'d');


--9.Afisati pentru fiecare student care are m�car o not�, numele si media notelor sale. Ordonati descresc�tor dup� valoarea mediei*/
select s.nr_matricol,nume,prenume,round(avg(valoare),2)as medie_student
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
having count(valoare)>=1
order by 4 desc;

--nu e nevoie de folosit si clauza having, deoarece automat inner joinul preia toti studentii ce au macar o nota (adica al caror nr_matricol apare in tabela note)
select s.nr_matricol,nume,prenume,round(avg(valoare),2)as medie_student
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
order by 4 desc;


--10.Modificati interogarea 9 pentru a afisa si studentii f�r� nici o not�. Media acestora va fi null.*/
--aici afisam impreuna atat cei cu note cat si cei fara note
select s.nr_matricol,nume,prenume,round(avg(valoare),2)as medie_student
from studenti s left join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
order by 4 desc;


--11.Modificati interogarea 10 pentru a afisa pentru elevii f�r� nici o not� media 0.*/
select s.nr_matricol,nume,prenume,nvl(round(avg(valoare),2),0)as medie_student
from studenti s left join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
order by 4 desc;


--12.Modificati interogarea de mai sus pentru a afisa doar studentii cu media mai mare ca 8.*/
select s.nr_matricol,nume,prenume,count(valoare) as nr_note,round(avg(valoare),2)as medie_student
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
having avg(valoare)>8
order by 5 desc;


--13.Afisati numele, cea mai mare not�, cea mai mic� not� si media doar pentru acei studenti care au cea mai mic� not� mai mare sau egal� cu 7.*/
select nume,prenume,max(valoare) as nota_maxima,min(valoare) as nota_minima,round(avg(valoare),2) as medie_student
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
having min(valoare)>=7
order by 1;


--14.Afisati numele si mediile studentilor care au cel putin un num�r de 4 note puse �n catalog.*/
select nume,prenume,count(valoare) as nr_note,round(avg(valoare),2) as medie
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
having count(valoare)>=4
order by 4 desc;


--15.Afisati numele si mediile studentilor din grupa A2 anul 3.*/
select s.nr_matricol,nume,prenume,round(avg(valoare),2) as medie_student
from studenti s join note n on s.nr_matricol=n.nr_matricol
where grupa='A2' and an=3
group by s.nr_matricol,nume,prenume
order by 4 desc;


--16.Afisati cea mai mare medie obtinut� de vreun student.*/
select round(max(avg(valoare)),2) as medie_maxima
from note
group by nr_matricol;

--daca dorim sa afisam si studentul
select s.nr_matricol,nume,prenume,round(avg(valoare),2) as medie_student
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol,nume,prenume
having avg(valoare)=
  (select max(avg(valoare))
  from note
  group by nr_matricol);
  
--dorim sa afisam primii 4 studenti, ca medie
--folosim rownum, dar nu este deloc cea mai buna varianta, deoarece este foarte posibil sa existe 2 sau mai multi studenti cu aceeasi medie, caz in care
--este afisat doar unul din ei, nu toti !
select student,medie from
  (select s.nr_matricol ||' '|| nume||' ' ||prenume as student, round(avg(valoare),2) as medie
  from studenti s join note n on s.nr_matricol=n.nr_matricol
  group by s.nr_matricol,nume,prenume
  order by avg(valoare)desc) 
where rownum <=4;
  
--sau daca vrem sa vedem cei mai buni 4 studenti, si locul pe care ei il ocupa, folosim functia rank
--varianta mai corecta, intamplator si doar intamplator (!!!) da acelasi rezultat ca si in varianta cu rownum
select * 
from
  (select s.nr_matricol,nume,prenume,round(avg(valoare),2) as medie_student,rank()over(order by avg(valoare)desc) as pozitie
  from studenti s join note n on s.nr_matricol=n.nr_matricol
  group by s.nr_matricol,nume,prenume)
where pozitie<=4; 

--17.Pentru fiecare disciplin� de studiu afi?ati titlul acesteia, cea mai mic� ?i cea mai mare not� pus�.*/
select titlu_curs,max(valoare) as nota_maxima,min(valoare) as nota_minima
from cursuri c join note n on n.id_curs=c.id_curs
group by titlu_curs
order by 1;

--Suplimentar
--1.Afisati numarul total de studenti, numarul de studenti bursieri si
numarul de tipuri de burse = un tip insemnand burse cu aceeasi valoare.*/
select count(nr_matricol) as "Nr.studs",count(bursa) as "Nr.Studs.Burs.",count(distinct bursa) as "Nr.Burse"
from studenti;

--2.Pentru grupele in care toate notele obtinute de studenti
sunt mai mari strict decat 6 afisati grupa, anul, cea mai mica nota cu aliasul "Minim" si cea mai mare nota cu aliasul "Maxim".
De asemenea afisati si nr de note per grupa. Ordonati crescator dupa an.*/
select grupa,an,min(valoare) as "Minim", max(valoare) as "Maxim", count(valoare) as Nr_Note
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by grupa,an
having min(valoare)>6
order by 2;
  
--3.Pentru studentii cu medii mai mari (>) de 7, afisati pe trei coloane: numele, prenumele, media notelor sale cu aiasul "Medie".*/
select nume,prenume,trunc(avg(valoare),2) as "Medie"
from studenti s join note n on s. nr_matricol=n.nr_matricol
group by nume,prenume,s.nr_matricol
having avg(valoare)>7; 

--4.Interogand tabela note afisati pentru fiecare nota posibila (nota este o valoare intreaga intre 4 si 10,
deci veti avea un numar de 7 linii) valoarea acesteia cu aliasul "Nota" si numarul de studenti care au fost notati cu acea nota cu aliasul "Nr. studenti". 
Nu numarati un student de mai multe ori, adica daca un student are doua note de 4 el nu va fi insumat de doua ori pentru intrarea corespunzatoare notei 4.*/
select valoare as "Nota",count(distinct nr_matricol) as "Nr. studenti" 
from note
group by valoare;

--5.Pentru disciplinele (cursurile) pentru care s-au pus doar note de trecere (cea mai mica nota este mai mare sau egala cu 5) 
afisati titlul acesteia cu aliasul "Titlu curs", cea mai mica nota pusa cu aliasul "Minim" si cea mai mare nota pusa cu aliasul "Maxim".*/
select titlu_curs as "Titlu curs",min(valoare) as "Minim",max(valoare) as "Maxim"
from note n join cursuri c on n.id_curs=c.id_curs
group by titlu_curs
having min(valoare)>=5;

--6. Interogand tabela Profesori afisati, doar pentru profesorii ce au grad didactic,
numarul total de profesori cu aliasul "Profesori" si numarul de grade didactice posibile cu aliasul "Grade".*/
select count(id_prof) as "Profesori",count(distinct grad_didactic) as "Grade" 
from profesori;

--7.Interogand tabela cursuri aflati pentru fiecare semestru al fiecarui an de studiu,
numarul de cursuri si media creditelor. Afisati semestrul, anul, numarul de cursuri cu aliasul "Cursuri" si media creditelor cu aliasul "Credite".*/
select semestru,an,count(id_curs) as "Cursuri",avg(credite) as "Credite"
from cursuri
group by semestru, an
order by 2,1;

--8.Identificati studentii care au medii intre 5 si 6. Pentru acestia afisati numele, prenumele si media cu aliasul "Medie".*/
select nume,prenume,avg(valoare) as "Medie"
from note n join studenti s on s.nr_matricol=n.nr_matricol
group by nume,prenume,s.nr_matricol
having avg(valoare) between 5 and 6;

--9.Interogand tabela NOTE aflati cum sunt distribuite notele. Astfel, veti afisa fiecare valoare a notei cu aliasul "Nota",
numarul de studenti care au luat acea nota (se vor numara toate aparitiile acelei note) cu aliasul "Studenti" 
si numarul de cursuri distincte la care s-a obtinut nota cu aliasul "Cursuri".
(In total 7 linii, corespunzatoare notelor de la 4 la 10)*/ 
select valoare as "Nota",count(valoare) as "Studenti",count(distinct id_curs) as "Cursuri"
from note
group by valoare
order by 1;

--10.Afisati suma notelor pare sub coloana "Suma note pare" si media notelor impare sub coloana "Medie note impare" pentru fiecare student care are note.
--este clar ca vom partitiona tabela de note in doua: n1 reprezinta notele ce vor intra in calculul sumei, iar n2 reprezinta notele ce vor in calculul mediei
--foloseste si functii de grupare, sum si avg
--Cand aveti functii de grupare (in general sunt 5 foarte folosite si anume sum, avg, min, max si count...si ar mai fi stddev, deviatia standard,
dar e rar utilizata) sunteti obligati sa folositi clauza group by (obligatoriu se pune dupa where !!!), iar in group by punem acele campuri libere, adica 
acelea care nu au functie de grupare in fata. Aici nu avem astfel de campuri, asa cum se observa din select, caz in care suntem obligati oricum sa facem o
grupare, iar gruparea o facem dupa matricolele studentilor (evident, dupa matricole, si nu dupa note, deoarece trebuie luate in seama toate tuplele
ce indeplinesc conditia) !*/
select sum(n1.valoare) as "Suma note pare",avg(n2.valoare) as "Medie note impare"
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol 
  join studenti s2 on s1.nr_matricol<>s2.nr_matricol 
  join note n2 on s2.nr_matricol=n2.nr_matricol
where mod(n1.valoare,2)=0 and mod(n2.valoare,2)<>0
group by s1.nr_matricol,s2.nr_matricol;


--11.Afisati perechile de cursuri din anul 2, in functie de media acestora. Primul va fi afisat cursul cu media mai mare.*/
select c1.titlu_curs,round(avg(n1.valoare),2) as medie_curs1,c2.titlu_curs,round(avg(n2.valoare),2) as medie_curs2
from cursuri c1 join cursuri c2 on c1.id_curs<>c2.id_curs join note n1 on n1.id_curs=c1.id_curs join note n2 on n2.id_curs=c2.id_curs
where c1.an=2
group by c1.titlu_curs,c2.titlu_curs
having avg(n1.valoare)>avg(n2.valoare);


--12.Selectati perechile de cursuri (adica titlurile lor) la care s-a pus acelasi numar de note in sesiunile din anul 2014.
Prima coloana se va numi "Pereche", iar cursul 1 va fi concantenat cu cursul 2 printr-un spatiu.
A doua coloana se va numi "Sesiune", iar o sesiune este identificata prin luna si an (vezi lab 5, de exemplu FEBRUARY, 2014).
Atentie la spatiul dintre luna si an ! Eliminati duplicatele.*/
select distinct c1.titlu_curs||' '||c2.titlu_curs as "Pereche",
  trim(to_char(n1.data_notare,'MONTH'))||', '||extract(year from n1.data_notare) as "Sesiune"
from cursuri c1 join cursuri c2 on c1.id_curs<c2.id_curs join note n1 on n1.id_curs=c1.id_curs join note n2 on n2.id_curs=c2.id_curs
where extract(year from n1.data_notare)=2014 and extract(year from n2.data_notare)=2014
group by c1.titlu_curs,c2.titlu_curs,n1.data_notare,n2.data_notare
having count(c1.id_curs)=count(c2.id_curs);
 