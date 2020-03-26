SELECT
    an,
    COUNT(nr_matricol)
FROM
    studenti
GROUP BY
    an;
    
-- Afi?a?i num?rul de studen?i din fiecare an.
--Afi?a?i num?rul de studen?i din fiecare grup? a fiec?rui an de studiu. Ordona?i cresc?tor dup? anul de studiu ?i dup? grup?.

SELECT
    COUNT(nr_matricol)
FROM
    studenti
GROUP BY
    an,
    grupa
ORDER BY
    an,
    grupa DESC;
--Afi?a?i num?rul de studen?i din fiecare grup? a fiec?rui an de studiu ?i specifica?i câ?i dintre ace?tia sunt bursieri.

--Afi?a?i suma total? cheltuit? de facultate pentru acordarea burselor.

SELECT
    SUM(bursa)
FROM
    studenti;
--Afi?a?i valoarea bursei/cap de student (se consider? c? studentii care nu sunt bursieri primesc 0 RON); altfel spus: cât se cheltuie?te în medie pentru un student?

SELECT
    AVG(nvl(bursa, 0)) AS medie
FROM
    studenti;
--Afi?a?i num?rul de note de fiecare fel (câte note de 10, câte de 9,etc.). Ordona?i descresc?tor dup? valoarea notei.

SELECT
    valoare,
    COUNT(valoare)
FROM
    note
GROUP BY
    valoare
ORDER BY
    valoare;
--Afi?a?i num?rul de note pus în fiecare zi a s?pt?mânii. Ordona?i descresc?tor dup? num?rul de note.

SELECT
    to_char(data_notare, 'day'),
    COUNT(nr_matricol)
FROM
    note
GROUP BY
    to_char(data_notare, 'day')
ORDER BY
    2 DESC;
--Afi?a?i num?rul de note pus în fiecare zi a s?pt?mânii. Ordona?i cresc?tor dup? ziua saptamanii: Sunday, Monday, etc.

SELECT
    to_char(data_notare, 'day') AS zi,
    COUNT(nr_matricol) AS nr_note
FROM
    note
GROUP BY
    to_char(data_notare, 'day'),
    to_char(data_notare, 'd')
ORDER BY
    to_char(data_notare, 'd');

--Afi?a?i pentru fiecare elev care are m?car o not?, numele ?i media notelor sale. Ordona?i descresc?tor dup? valoarea mediei.

SELECT
    s.nume,
    AVG(n.valoare) AS medie
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
GROUP BY
    s.nr_matricol,
    s.nume;

--Modifica?i interogarea anterioar? pentru a afi?a ?i elevii f?r? nici o not?. Media acestora va fi null.

SELECT
    s.nume,
    AVG(n.valoare) AS medie
FROM
    studenti   s
    LEFT JOIN note       n ON s.nr_matricol = n.nr_matricol
GROUP BY
    s.nr_matricol,
    s.nume;

--Modifica?i interogarea anterioar? pentru a afi?a pentru elevii f?r? nici o not? media 0.

SELECT
    s.nume,
    AVG(nvl(n.valoare, 0)) AS medie
FROM
    studenti   s
    LEFT JOIN note       n ON s.nr_matricol = n.nr_matricol
GROUP BY
    s.nr_matricol,
    s.nume;

--Modificati interogarea de mai sus pentru a afisa doar studentii cu media mai mare ca 8.

SELECT
    s.nume,
    AVG(nvl(n.valoare, 0)) AS medie
FROM
    studenti   s
    LEFT JOIN note       n ON s.nr_matricol = n.nr_matricol
GROUP BY
    s.nr_matricol,
    s.nume
HAVING
    AVG(nvl(n.valoare, 0)) > 8;

--Afi?a?i numele, cea mai mare not?, cea mai mic? not? ?i media doar pentru acei studenti care au primit doar note mai mari sau egale cu 7 (au cea mai mic? not? mai mare sau egal? cu 7).

SELECT
    s.nume,
    MAX(n.valoare),
    MIN(n.valoare)
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
WHERE
    n.valoare > 6
GROUP BY
    s.nr_matricol,
    s.nume;

--Afi?a?i numele ?i mediile studen?ilor care au cel pu?in un num?r de 4 note puse în catalog.

SELECT
    s.nume,
    AVG(nvl(n.valoare, 0))
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
GROUP BY
    s.nr_matricol,
    s.nume
HAVING
    COUNT(n.valoare) = 4;
--Afi?a?i numele ?i mediile studen?ilor din grupa A2 anul 3.

SELECT
    s.nume,
    AVG(nvl(n.valoare, 0))
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
WHERE
    s.grupa = 'A2'
    AND s.an = 3
GROUP BY
    s.nr_matricol,
    s.nume;
--Afi?a?i cea mai mare medie ob?inut? de vreun student.

SELECT
    MAX(AVG(valoare))
FROM
    note
GROUP BY
    nr_matricol;

SELECT
    s.nr_matricol,
    s.nume,
    AVG(n.valoare)
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
GROUP BY
    s.nr_matricol,
    s.nume
HAVING
    AVG(n.valoare) = (
        SELECT
            MAX(AVG(valoare))
        FROM
            note
        GROUP BY
            nr_matricol
    );


--Pentru fiecare disciplin? de studiu afi?ati titlul acesteia, cea mai mic? ?i cea mai mare not? pus?.

SELECT
    c.titlu_curs,
    MIN(n.valoare),
    MAX(n.valoare)
FROM
    cursuri   c
    JOIN note      n ON n.id_curs = c.id_curs
GROUP BY
    c.titlu_curs;
    
-- BONUS
-- 1 afisati nr total de studenti, nr de studneti bursieri, si numarul de tipuri de bursa
select count(nr_matricol), count(bursa), count(distinct bursa)
from studenti;

-- 2 pt grupele in care toate notele obtinute de studenti sunt mai mari strict decat 6, afisati grupa, anul, cea mai mare/min nota. Ord cresc dupa an
select s.grupa, s.an, max(n.valoare), min(n.valoare), count(n.nr_matricol)
from studenti s join note n on s.nr_matricol = n.nr_matricol
group by s.grupa, s.an
having min(n.valoare)>=6;
-- 3 interogand doar tabela de note, afisati pt fiecare nota posibila valoarea acesteie = "nota". si numarul de studenti care au fost notati cu acea nota.
select valoare, count(distinct valoare), count(distinct nr_matricol)
from note
group by valoare;
-- 4 interogand tabela profesori afisati numarul total de profesori cu nr total de profesori. si numarul de grade didactice

-- 5 interogand tabela note, aflati cum sunt distribuite notele. Afisati notele cu "nota", nr de studneti care au luat acea nota 
--      (se vor numara toate aparitiile acelei note)
--      si numarul de cursuri distincte la care s-a obtinut nota cu aliasul cursului.

-- 6 afisati suma notelor pare ="note pare" si media notelor impare ="medie note impare"

-- 7  afisati perechile de cursuri din anu 2, in functie de media acestora. primul va fi afisat cu media mai mare. 



















