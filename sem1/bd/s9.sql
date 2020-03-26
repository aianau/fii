-- nu merge dubla agregare. cand am atribute libere
-- select man, nume, max(avg(valoare))

-- 1. Afi?a?i numele studen?ilor care iau cea mai mare bursa acordat?.
select nume, prenume
from studenti
where bursa = (select max(bursa) from studenti);
-- 2. Afi?a?i numele studen?ilor care sunt colegi cu un student pe nume Arhire (coleg = acela?i an si aceea?i grup?).
select nume, prenume
from studenti
where (an, grupa) in ( select an, grupa from studenti where nume='Arhire')
        and nume!='Arhire';

-- 3. Pentru fiecare grup? afi?a?i numele studen?ilor care au ob?inut cea mai mic? not? la nivelul grupei.
select s.nume, s.prenume, n.valoare
from studenti s join note n on s.nr_matricol=n.nr_matricol
where (s.an, s.grupa, n.valoare) in (select s.an, s.grupa, min(n.valoare)
                                    from studenti s join note n on s.nr_matricol=n.nr_matricol
                                    group by  s.an, s.grupa)
order by s.an, s.grupa;

-- 4. Identifica?i studen?ii a c?ror medie este mai mare decât media tuturor notelor din baza de date. Afi?a?i numele ?i media acestora.
select s.nume, s.prenume, avg(n.valoare)
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol, s.nume, s.prenume
having avg(n.valoare) >= (select avg(valoare) from note);

-- 5. Afi?a?i numele ?i media primelor trei studen?i ordona?i descresc?tor dup? medie.
select * 
from (  select s.nume, s.prenume, avg(n.valoare)
        from studenti s join note n on s.nr_matricol=n.nr_matricol
        group by s.nr_matricol, s.nume, s.prenume
        order by avg(n.valoare) desc)
where rownum < 4;

-- VAR2
select * 
from (  select s.nume, s.prenume, round(avg(n.valoare),2) as medie, RANK () OVER (order by avg(valoare) desc) as pozitie
        from studenti s join note n on s.nr_matricol=n.nr_matricol
        group by s.nr_matricol, s.nume, s.prenume
        order by 4 desc)
where pozitie < 4; -- aici merge si pozitie = 3. DAR LA ROWNUM NU MEREG EGAL.
-- 6. Afi?a?i numele studentului (studen?ilor) cu cea mai mare medie precum ?i valoarea mediei (aten?ie: limitarea num?rului de 
--linii poate elimina studen?ii de pe pozi?ii egale; g?si?i alt? solu?ie).
select s.nr_matricol, s.nume, s.prenume, round(avg(n.valoare))
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol, s.nume, s.prenume
having avg(n.valoare)=( select max(avg(valoare)) 
                        from note 
                        group by nr_matricol);

-- 7. Afi?a?i numele ?i prenumele tuturor studen?ilor care au luat aceea?i nota ca ?i Ciprian Ciobotariu la materia Logic?. 
-- Exclude?i-l pe acesta din list?.
select s.nr_matricol, s.nume, s.prenume
from studenti s join note n on s.nr_matricol=n.nr_matricol
where (n.valoare) in (select n.valoare 
                        from studenti s join note n on s.nr_matricol=n.nr_matricol join cursuri c on n.id_curs=c.id_curs
                        where s.nume = 'Ciobotariu' and s.prenume='Ciprian' and c.titlu_curs='Logica')
    and s.nume != 'Ciobotariu' and s.prenume!='Ciprian';   

-- 8. Din tabela studenti, afisati al cincilea prenume in ordine alfabetica.

select * 
from (  select nume, prenume, DENSE_RANK () OVER (order by prenume) as pozitie -- dense_rank e ca sa ii ia pe toti la rand, cum treubie.
        from studenti
        order by pozitie)
where pozitie = 5; 
-- 9. Punctajul unui student se calculeaza ca fiind o suma intre produsul dintre notele luate si creditele la materiile la care
-- au fost luate notele. Afisati toate informatiile studentului care este pe locul 3 in acest top./


----------------------------  EXTRA ----------------------------  
-- 1. sa se afiseze cursul/cursurile la care s-au pus cele mai multe note. Iar pentru acest curs, sa se afiseze cea mai mare/mica/media notelor.

-- 2.  Care este studentul nerestantier care are cea mai mica medie.

-- 3. pt fiecare studenti aflati disciplinele la care a luat o nota peste media acelor discipline sau cel putin egala.
select s.nr_matricol, s.nume, s.prenume, c.titlu_curs, round((select avg(n.valoare) from note n where n.id_curs = n1.id_curs),2) as medie_curs
from cursuri c join note n1 on c.id_curs=n1.id_curs join studenti s on n1.nr_matricol=s.nr_matricol
where n1.valoare >= (select avg(n.valoare) from note n join cursuri c on n.id_curs=c.id_curs);

-- 4. \forall std nerestentaieri, afisati notele de 10 ale acestora si disciplinele aferente.
select s.nume, s.prenume, n.valoare, c.titlu_curs, min(n.valoare)
from studenti s join note n on s.nr_matricol=n.nr_matricol join cursuri c on c.id_curs=n.id_curs
where n.valoare=10
group by s.nr_matricol, s.nume, s.prenume, n.valoare, c.titlu_curs
having min(n.valoare) >=5;

-- 5. nume, pren, matr, media trunchiata la 2 zec, doar pt studentii care au exact o restanta. 
select s.nr_matricol, s.nume, s.prenume, round(avg(n.valoare),2) as medie
from studenti s join note n on s.nr_matricol=n.nr_matricol
group by s.nr_matricol, s.nume, s.prenume, n.valoare
having count() =1;

-- VARIANTA BUNA:
select s.nr_matricol, s.nume, s.prenume, trunc(avg(n.valoare),2) as medie
from studenti s join note n on s.nr_matricol=n.nr_matricol
where (s.nr_matricol, 1) in (select nr_matricol, count(*)
                                from note where valoare < 5 group by nr_matricol)
group by s.nr_matricol, s.nume, s.prenume, n.valoare;


-- 5'. afisati cursurile care au fix o nota de 10.


-- 6. afisati numele concat cu pren, nr matricol al bursierului cu cel mai mic matricol din tabela.

-- 7. Select id cursurilor ale caror medie a notelor este mai mare decat media tuturor notelor puse in anul 2015.

-- 8. afisati studn care are cele mai multe note de 10 si cate are.

-- 9. af std. ce au media notelor mai mare decat media tuturor notelor la bd.

-- 10. sa se afiseze profesoru/profesorii care tin disciplina cu cea mai mica medie a notelor.
select p.nume, c.titlu_curs, avg(n.valoare)
from profesori p join didactic d on p.id_prof=d.id_prof join cursuri c on c.id_curs=d.id_curs join note n on c.id_curs=n.id_curs
group by p.nume, c.titlu_curs
having avg(n.valoare)=(select min(avg(valoare)) from note group by id_curs);

-- 11. afisati cursul cu cei mai multi studenti picati si nr acestora.
select c.titlu_curs, count(n.valoare)
from cursuri c join note n on c.id_curs=n.id_curs
group by c.titlu_curs
having count(*) = (select count(valoare) from note n join cursuri c on c.id_curs=n.id_curs);









