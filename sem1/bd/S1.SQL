-- 6
select nume, prenume, an 
from studenti
where extract (year from data_nastere) = 1995;

-- 7
select *
from studenti
where (bursa is 0 or bursa is null);

-- 8
select *
from studenti 
where (an in (2,3) and (bursa is not null or bursa is not 0))
order by nume,prenume desc;

-- 9
select nr_matricol, bursa*1.15
from studenti
where bursa is not null;

-- 10
select nr_matricol
from studenti
where an = 1 and nume like "p%";

-- 11 
select *
from studenti
where prenume like "%a%a%" and 
    prenume not like "%a%a%a%";

-- 12
select *
from studenti
where nume in ('Alex', 'Ana', 'Marius');

-- 13
select *
from studenti
where bursa is not null and
    where grupa like "A%";

-- 14
select nume, prenume
from profesori 
where prenume like "%n";





