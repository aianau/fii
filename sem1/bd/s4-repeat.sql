-- 1 Afi?a?i studen?ii ?i notele pe care le-au luat si profesorii care le-au pus acele note.
SELECT
    s.nume,
    s.prenume,
    n.valoare,
    p.nume      AS nume_prof,
    p.prenume   AS prenume_prof
FROM
    studenti    s
    JOIN note        n ON s.nr_matricol = n.nr_matricol
    JOIN didactic    d ON d.id_curs = n.id_curs
    JOIN profesori   p ON d.id_prof = p.id_prof;

-- 2 Afisati studen?ii care au luat nota 10 la materia 'BD'. Singurele valori pe care ave?i voie s? le hardcoda?i în interogare sunt valoarea notei (10) ?i numele cursului ('BD').

SELECT
    s.nume,
    s.prenume
FROM
    studenti   s
    JOIN note       n ON n.nr_matricol = s.nr_matricol
    JOIN cursuri    c ON c.id_curs = n.id_curs
WHERE
    lower(c.titlu_curs) = 'bd'
    AND n.valoare = 10;

-- 3 Afisa?i profesorii (numele ?i prenumele) impreuna cu cursurile pe care fiecare le ?ine.

SELECT
    p.nume,
    p.prenume,
    c.titlu_curs
FROM
    profesori   p
    LEFT JOIN didactic    d ON p.id_prof = d.id_prof
    LEFT JOIN cursuri     c ON c.id_curs = d.id_curs;

-- 4 Modifica?i interogarea de la punctul 3 pentru a fi afi?a?i ?i acei profesori care nu au înc? alocat un curs.

SELECT
    p.nume,
    p.prenume,
    nvl(c.titlu_curs, 'no curs')
FROM
    profesori   p
    LEFT JOIN didactic    d ON p.id_prof = d.id_prof
    LEFT JOIN cursuri     c ON c.id_curs = d.id_curs;

-- 5 Modifica?i interogarea de la punctul 3 pentru a fi afi?ate acele cursuri ce nu au alocate înc? un profesor.

SELECT
    p.nume,
    p.prenume,
    c.titlu_curs
FROM
    profesori   p
    RIGHT JOIN didactic    d ON p.id_prof = d.id_prof
    RIGHT JOIN cursuri     c ON c.id_curs = d.id_curs;

-- 6 Modifica?i interogarea de la punctul 3 astfel încât s? fie afi?a?i atat profesorii care nu au nici un curs alocat cât ?i cursurile care nu sunt înc? predate de nici un profesor.

SELECT
    p.nume,
    p.prenume,
    c.titlu_curs
FROM
    profesori   p
    FULL JOIN didactic    d ON p.id_prof = d.id_prof
    FULL JOIN cursuri     c ON c.id_curs = d.id_curs;

/*
-- 7 In tabela studenti exist? studen?i care s-au nascut în aceeasi zi a s?pt?mânii. De exemplu, Cobzaru George ?i Pintescu Andrei
s-au n?scut amândoi într-o zi de marti. Construiti o list? cu studentii care s-au n?scut in aceea?i zi grupându-i doi câte doi
în ordine alfabetic? a numelor (de exemplu in rezultat va apare combinatia Cobzaru-Pintescu dar nu va apare ?i Pintescu-Cobzaru). 
Lista va trebui s? con?in? doar numele de familie a celor doi împreun? cu ziua în care cei doi s-au n?scut. Evident, dac? exist? ?i
al?i studenti care s-au n?scut marti, vor apare si ei in combinatie cu cei doi aminti?i mai sus. Lista va fi ordonat? în func?ie de ziua 
s?pt?mânii în care s-au n?scut si, în cazul în care sunt mai mult de trei studen?i n?scu?i în aceea?i zi, rezultatele vor fi 
ordonate ?i dup? numele primei persoane din list? [pont: interogarea trebuie s? returneze 10 rânduri daca nu se iau in 
considerare si perechile de studenti care au acelasi nume, 12 randuri daca se iau in considerare si studentii care au acelasi 
nume].
*/

SELECT
    s1.nume,
    s2.nume,
    to_char(s1.data_nastere, 'Day') AS zi
FROM
    studenti   s1
    JOIN studenti   s2 ON to_char(s1.data_nastere, 'd') = to_char(s2.data_nastere, 'd')
                        AND s1.nr_matricol < s2.nr_matricol;

-- 8 Sa se afiseze, pentru fiecare student, numele colegilor care au luat nota mai mare ca ei la fiecare dintre cursuri. Formulati rezultatele ca propozitii (de forma "Popescu Gigel a luat nota mai mare ca Vasilescu Ionel la matera BD."). Dati un nume corespunzator coloanei [pont: interogarea trebuie s? returneze 118 rânduri].
select s1.nume, s1.prenume, s2.nume, s2.prenume, n1.valoare, n2.valoare
from studenti s1, studenti s2, note n1, note n2, cursuri c
where
    s1.nr_matricol = n1.nr_matricol and 
    s2.nr_matricol = n2.nr_matricol and
    n1.id_curs = c.id_curs and
    n2.id_curs = c.id_curs and    
    s1.nr_matricol != s2.nr_matricol and 
    n2.valoare > n1.valoare;
    



-- afiseaza toti stuedtnii care au bursa si au peste nota 7 la BD

SELECT
    s.nume,
    s.prenume,
    s.bursa,
    n.valoare,
    c.titlu_curs
FROM
    studenti   s
    JOIN note       n ON s.nr_matricol = n.nr_matricol
    JOIN cursuri    c ON c.id_curs = n.id_curs
WHERE
    s.bursa IS NOT NULL
    AND lower(c.titlu_curs) = 'bd'
    AND n.valoare > 7;
    
    