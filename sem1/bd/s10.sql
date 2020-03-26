/*
SUBINTEROGARI CORELATE

exists == "macar"/"cel putin unul"
fc. de grupare. ("din anul ... afisati cea mai mare medie")



*/

-- 1. Afi?a?i to?i studen?ii care au în an cu ei m?car un coleg care s? fie mai mic ca ei (vezi data na?terii).
select s1.nume, s1.prenume, s1.an, s1.data_nastere
from studenti s1
where exists ( select * from studenti s2 where s1.an=s2.an and s1.data_nastere > s2.data_nastere); 

-- 2. Afi?a?i to?i studen?ii care au media mai mare decât media tuturor studen?ilor din an cu ei. Pentru ace?tia afi?a?i numele, prenumele ?i media lor.
select s1.nume, s1.prenume,  s1.an, avg(n1.valoare) as medie
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol
group by s1.nr_matricol, s1.nume, s1.prenume,  s1.an
having avg(n1.valoare) > (select avg(valoare) from studenti s2 join note n2 on s2.nr_matricol=n2.nr_matricol where s1.an=s2.an);

-- 3. Afi?a?i numele, prenumele si grupa celui mai bun student din fiecare grupa în parte.
select s1.nume, s1.prenume, s1.grupa, avg(n1.valoare) as medie
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol
group by s1.nr_matricol, s1.nume, s1.prenume,  s1.grupa, s1.an
having avg(n1.valoare) = ( select max(avg(n2.valoare))  
                        from studenti s2 join note n2 on s2.nr_matricol=n2.nr_matricol
                        where s1.an = s2.an
                        group by s2.nr_matricol);

-- 4. G?si?i to?i studen?ii care au m?car un coleg în acela?i an care s? fi luat aceea?i nota ca ?i el la m?car o materie.
select distinct s1.nume, s1.prenume
from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol join cursuri c1 on n1.id_curs=c1.id_curs
where exists (select *
                from studenti s2 join note n2 on s2.nr_matricol=n2.nr_matricol join cursuri c2 on n2.id_curs=c2.id_curs 
                where s1.an=s2.an and n1.valoare=n2.valoare and c1.titlu_curs=c2.titlu_curs and s1.nr_matricol!=s2.nr_matricol); 
-- 5. Afi?a?i to?i studen?ii care sunt singuri în grup? (nu au al?i colegi în aceea?i grup?).
select nume, prenume
from studenti s1
where not exists (select * from studenti s2 where s1.nr_matricol!=s2.nr_matricol and s1.grupa=s2.grupa and s1.grupa=s2.grupa);
-- 6. Afi?a?i profesorii care au m?car un coleg (profesor) ce are media notelor puse la fel ca ?i el.
select nume, prenume
from profesori p join didactic d on p.id_prof=d.id_prof join note n on n.id_curs=d.id_curs 
where exists (select *
                from profesori p1 join didactic d1 on p1.id_prof=d1.id_prof join note n1 on n1.id_curs=d1.id_curs
                having round(avg(n.valoare),2)=round(avg(n1.valoare),2));
-- 7. Fara a folosi join, afisati numele si media fiecarui student.
select s.nume, (select avg(valoare) 
                from note n 
                where n.nr_matricol=s.nr_matricol)
from studenti s;
-- 8. Afisati cursurile care au cel mai mare numar de credite din fiecare an (pot exista si mai multe pe an). - Rezolvati acest 
--  exercitiu si corelat si necorelat (se poate in ambele moduri). Care varianta este mai eficienta ?
select c.titlu_curs
from cursuri c
where c.credite = (select max(c1.credite) from cursuri c1 where c.an=c1.an);
-- SAU
select titlu_curs
from cursuri 
where (an,credite) in (select an,max(credite) from cursuri group by an);




-- EXTRA
-- 1. pt fiecare grupa, din fiecare an, identificati cel mai in varsta student
select distinct nume, prenume
from studenti 
where (data_nastere, grupa, an) in (select min(data_nastere), grupa, an from studenti group by grupa, an);

-- 2. afisati numele prenumele, round(medie,2), semian pt studnetii pt cea mai mica medie din fiecare semian.
select s.nume, s.prenume, round(avg(n.valoare), 2)
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol, s.nume, s.prenume, s.an, s.grupa   -- NU UITA SA PUI TOATE DIN WHERE-UL AL 2-LEA IN GRUOUP BY-UL PRINCIPAL.
having avg(valoare) = (select min(avg(n1.valoare)) 
                        from studenti s1 join note n1 on s1.nr_matricol=n1.nr_matricol
                        where s.an=s1.an and substr(s.grupa, 1,1)=substr(s1.grupa, 1,1)
                        group by s1.nr_matricol);

-- 3. pt fiecare curs identif numele stud care a obtinut cea mai mare nota : titlu curs, nume, prenume, nota

-- 4. afis numele profs pt care exista macar un coleg care sa predea acelasi curs. 
select p.nume, p.prenume
from profesori p join didactic d on p.id_prof=d.id_prof join cursuri c on d.id_curs=c.id_curs
where exists (select *
                from profesori p1 join didactic d1 on p1.id_prof=d1.id_prof join cursuri c1 on d1.id_curs=c1.id_curs
                where c.titlu_curs=c1.titlu_curs and p.id_prof!=p1.id_prof);
-- 5. pt fiecare semestru din fiecare an identificati cursurl sau cursurile la care se pun in medie cele mai mari note


-- 6. consideram cursrurile impartite in 2 categs (id par si impar). sa se afis id, titlul, si media notelor pt cursul/urile din fiecare din cele 2 categs
--      care au cea mai mica medie

-- 7. afis nume, pren, brsa, an, pt studs care au bursa strict mai mare decat media burselor din anul sau.

-- 8. afis nume, pren, care au bursa si care mai au in grupa un alt coleg care are bursa.
select s1.nume, s1.prenume
from studenti s1 
where exists (select * from studenti s2 where bursa is not null and s1.nr_matricol!=s2.nr_matricol and s1.grupa=s2.grupa and s1.an=s2.an);

-- 9. sa se afiseze matricola, nume, prenume, media trunc(2) pt studs care au mai mult de o restanta
select s1.nume, s1.prenume, round(avg(n.valoare), 2)
from studenti s1 join note n on n.nr_matricol=s1.nr_matricol
where exists (select * from note n where n.nr_matricol=s1.nr_matricol)
group by s1.nr_matricol, s1.nume, s1.prenume;

-- 10. fiecarui stud din facultate se va adauga la bursa curenta (fie ea 0 sau null) valoarea bursei colegului de grupa 
--      cu cea mai mare bursa. Afisati nume, prenume, si noua bursa. Pt cei care inca nu au, se afiseaza 0.
select s1.nume, s1.prenume, nvl(s1.bursa, 0)+nvl((select max(s2.bursa) from studenti s2 where s1.an=s2.an and s1.grupa=s2.grupa), 0) as bursa
from studenti s1;

-- 11. afis nume, pren studs care au macar un coleg de an nascut in aceeasi luna.

-- 12. afis matr, numne, prenu, an, grupa, nota pt acei studs al caror nume sau prenume coincide cu al altui student.

-- 13. afis matr, nr note pt toti studs care-s baieti si au cel putin o colega de grupa. 

-- 14. pt fiecare curs la care s-a pus cel putin o nota, afisati procenutl studentilor promovati. 

-- 15. pt fiacre semian, afisati rata celor nepromovati sau a nu avea nicio nota la materiile la care nu s-au pus note.

-- 16. afisati anul si grupa in care exista macar 2 sutds bursieri. 

-- 17. afis numele si prenumele studs restantieri ce au in aceeasi rupa macar un alt student restantier 

-- 18. afis numele si prenumele studs din grupa celui mai bun student. 

-- 19. afisati titlul cursurilor care au o pereche (adica predate in acelasi an si cu acelasi nr de credite). 

-- 20. afis numele, prenumele si grupa studs bursieri. care mai au in grupa macar un coleg cu acelasi bursa cu a lui. 


