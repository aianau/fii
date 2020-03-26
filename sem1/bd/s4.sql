-- 2 Afisati studen?ii care au luat nota 10 la materia 'BD'. Singurele valori pe care ave?i voie s? le hardcoda?i în interogare sunt valoarea notei (10) ?i numele cursului ('BD').
SELECT
    s.nr_matricol,
    nume,
    prenume
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
    JOIN cursuri    c ON c.id_curs = n.id_curs
WHERE
    titlu_curs = 'BD'
    AND valoare = 10;

-- 3 Afisa?i profesorii (numele ?i prenumele) impreuna cu cursurile pe care fiecare le ?ine.

SELECT
    TRIM(nume) AS prof,
    titlu_curs
FROM
    profesori   p
    JOIN didactic    d ON p.id_prof = d.id_prof
    JOIN cursuri     c ON c.id_curs = d.id_curs;

-- 4

SELECT
    TRIM(nume) AS prof,
    titlu_curs
FROM
    profesori   p
    LEFT JOIN didactic    d ON p.id_prof = d.id_curs
    LEFT JOIN cursuri     c ON c.id_curs = d.id_curs;


-- 5 Modifica?i interogarea de la punctul 3 pentru a fi afi?ate acele cursuri ce nu au alocate înc? un profesor.

SELECT
    titlu_curs
FROM
    cursuri     c
    LEFT JOIN didactic    d ON c.id_curs = d.id_curs
    LEFT JOIN profesori   p ON p.id_prof = d.id_prof
WHERE
    d.id_prof IS NULL;

--6 Modifica?i interogarea de la punctul 3 astfel încât s? fie afi?a?i atat profesorii care nu au nici un curs alocat cât ?i cursurile care nu sunt înc? predate de nici un profesor.

SELECT
    titlu_curs,
    TRIM(nume) AS nume_prof
FROM
    cursuri     c
    FULL JOIN didactic    d ON c.id_curs = d.id_curs
    FULL JOIN profesori   p ON p.id_prof = d.id_prof
WHERE
    d.id_prof IS NULL
    OR c.id_curs IS NULL;
    
-- 7 

SELECT
    s1.nr_matricol,
    s1.nume,
    s2.nr_matricol,
    s2.nume,
    to_char(s1.data_nastere, 'day') AS zi
FROM
    studenti   s1
    JOIN studenti   s2 ON s1.nr_matricol < s2.nr_matricol
WHERE
    to_char(s1.data_nastere, 'day') = to_char(s2.data_nastere, 'day');

-- 8Sa se afiseze, pentru fiecare student, numele colegilor care au luat nota mai mare ca ei la fiecare dintre cursuri. Formulati rezultatele ca propozitii
----(de forma "Popescu Gigel a luat nota mai mare ca Vasilescu Ionel
---- la matera BD."). Dati un nume corespunzator coloanei [pont: interogarea trebuie s? returneze 118 rânduri].

SELECT
    ( s1.nume
      || ' '
      || s1.prenume
      || ' a luat nota mai mare ca '
      || s2.nume
      || ' '
      || s2.prenume ) AS prop
FROM
    studenti   s1,
    studenti   s2,
    note       n1,
    note       n2,
    cursuri    c
WHERE
    s1.nr_matricol = n1.nr_matricol
    AND s2.nr_matricol = n2.nr_matricol
    AND n1.id_curs = c.id_curs
    AND n2.id_curs = c.id_curs
    AND s1.nr_matricol != s2.nr_matricol
    AND n1.valoare > n2.valoare;

-- E1 afisati concat numele si prenumele studentilor, numele prenumele cu majuscule. titlul cursului cu litere mici, nota luata de acestia
-- si o ultima coloana numita promovabilitate (promovat/ restantier)


-- E2 pt studentii din luna decembrie, afisati nume, prenume, ziua de nastere (ziua), cu prima litera masjuscula si restu litere
-- mici. Varsta in ani (int)


-- E3 Afis nume, prenume, anu studiu incrementat cu unu ("an nou") pt studentii care au bursa si au in componenta numelui litera A sau a


-- E4 Afis nume (uppercase "Nume") si textul "are bursa"/"n-are bursa" ("statut") doar pt stud care au E/e in nume.


-- E5 selectati numele cu trim, gradul didactic al profului si titlul cursului la care preda. Daca profu nu preda sau n-are grad
-- didactic, afiseaza "*". Daca cursul nu are profesor asociat, se va afisa "no prof"

SELECT
    nvl(TRIM(nume), 'no prof'),
    nvl(grad_didactic, '*'),
    titlu_curs
FROM
    profesori   p
    FULL JOIN didactic    d ON d.id_prof = p.id_prof
    FULL JOIN cursuri     c ON c.id_curs = d.id_curs;

-- 1 Afi?a?i studen?ii ?i notele pe care le-au luat si profesorii care le-au pus acele note.

SELECT
    s.nr_matricol,
    s.nume,
    s.prenume,
    TRIM(p.nume) AS prof,
    c.titlu_curs
FROM
    studenti    s,
    profesori   p,
    didactic    d,
    cursuri     c,
    note        n
WHERE
    s.nr_matricol = n.nr_matricol
    AND d.id_prof = p.id_prof
    AND c.id_curs = d.id_curs
    AND n.id_curs = c.id_curs;
    
    
------------------------------------------------------- INTEROGARI CU SELF JOIN -----------------------------------------------
-- E6 pt studenta antonia ioana afisati colegii ei.

SELECT
    s1.nume,
    s1.prenume,
    s2.nume,
    s2.prenume
FROM
    studenti   s1
    JOIN studenti   s2 ON s1.nr_matricol != s2.nr_matricol
WHERE
    s2.an = s1.an
    AND s1.grupa = s2.grupa
    AND lower(s1.nume) = 'antonia'
    AND lower(s1.prenume) = 'ioana';

-- E8 sa se afiseze cupluri de nr matricole impreuna cu un id al unui curs astfel incat studentul avand primul nr matricol a luat
-- nota strict mai mare fata de studentul cu al doilea nr matricol pt curs.
-- afisarea se face doar pt cusrurile cu ide 21 si 34.

SELECT
    n1.nr_matricol   AS m1,
    n2.nr_matricol   AS m2,
    n1.id_curs       AS curs
FROM
    note   n1,
    note   n2
WHERE
    n1.id_curs = n2.id_curs
    AND n1.id_curs IN (
        21,
        24
    )
    AND n1.valoare > n2.valoare;



    
-- E9 pt cursul de BD afisati toate numelde studenti care au luat note fara a afisa dulpicate
-- primu cu nota cea mai mare nota. iar daca sunt 2 cu aceeasi nota, se afiseaza de 2 ori. afisati si notele.

SELECT
    s.nume,
    n.valoare
FROM
    studenti   s,
    cursuri    c,
    note       n
WHERE
    upper(c.titlu_curs) = 'BD';

-- E10 select perechile de cursrui si titlurile lor la care s-au pus aceleasi note in anul 2014. prima coloana "pereche". iar cusrul 1 va fi concat cu cursul 2 
-- printr-un spatiu. a doua coloana "sesiune" iar sesiunea e identificata prin luna si an.



-- E11 afisati toate perechile de profesori ce nu au grad didactic. eliminati duplicatele.

-- E12 Afisati perechile de studenti care nu ai nicio nota. eliminati duplicatele.