-- 6
SELECT LOWER(SUBSTR(NUME, 1, 1)) || UPPER(SUBSTR(NUME, 2)) AS NUME, LENGTH(TRIM(NUME))
FROM PROFESORI
WHERE NUME LIKE "B%";

-- 7 Pentru fiecare student afi?a?i numele, data de nastere, data la care studentul urmeaza sa isi sarbatoreasca ziua de nastere si prima zi de duminic? de dupa.
SELECT NUME, DATA_NASTERE, ADD_MONTHS(DATA_NASTERE,CEIL(MONTHS_BETWEEN(SYSDATE, DATA_NASTERE)/12 )* 12 ) AS SARBATOARE,
        NEXT_DAY(ADD_MONTHS(DATA_NASTERE, CEIL(MONTHS_BETWEEN(SYSDATE, DATA_NASTERE)/12 )* 12 ), 'SUNDAY') AS DUMINICA
FROM STUDENTI ;

-- 8 Ordona?i studen?ii care nu iau burs? în func?ie de luna cand au fost n?scu?i; se va afi?a doar numele, prenumele ?i luna corespunz?toare datei de na?tere.
SELECT NUME, PRENUME, EXTRACT(MONTH FROM DATA_NASTERE) AS LUNA
FROM STUDENTI
WHERE BURSA IS NULL
ORDER BY LUNA;

-- 9 Pentru fiecare student afi?ati numele, valoarea bursei si textul: 'premiul 1' pentru valoarea 450, 'premiul 2' pentru valoarea 350, 'premiul 3' pentru valoarea
-- 250 ?i 'mentiune' pentru cei care nu iau bursa. Pentru cea de a treia coloana dati aliasul "Premiu".
SELECT NUME, BURSA, DECODE(bursa, 450, 'premiul 1', 350, 'premiul 2', 250, 'premiul 3', 'mentiune') 
FROM studenti;

-- 10 Afi?a?i numele tuturor studen?ilor înlocuind apari?ia literei i cu a ?i apari?ia literei a cu i.
SELECT TRANSLATE(NUME, 'aiAI', 'iaIA') AS NUME
FROM STUDENTI;

-- 11 Afi?a?i pentru fiecare student numele, vârsta acestuia la data curent? sub forma '<x> ani <y> luni ?i <z> zile' (de ex '19 ani 3 luni ?i 2 zile') ?i num?rul de zile pân? î?i va s?rb?tori (din nou) ziua de na?tere.
SELECT NUME, TO_CHAR(MONTHS_BETWEEN(EXTRACT(YEAR FROM SYSDATE), EXTRACT(YEAR FROM DATA_NASTERE))/12) || ' ANI ' || 
    TO_CHAR(EXTRACT(MONTH FROM SYSDATE) - EXTRACT(MONTH FROM DATA_NASTERE)) || ' LUNI ' || TO_CHAR(EXTRACT(DAY FROM SYSDATE) - EXTRACT(DAY FROM DATA_NASTERE))
FROM STUDENTI;

-- 12 Presupunând c? în urm?toarea lun? bursa de 450 RON se m?re?te cu 10%, cea de 350 RON cu 15% ?i cea de 250 RON cu 20%, afi?a?i pentru fiecare student numele acestuia, data corespunz?toare primei zile din 
-- luna urmatoare ?i valoarea bursei pe care o va încasa luna urm?toare. Pentru cei care nu iau bursa, se va afisa valoarea 0.
SELECT NUME, LAST_DAY(SYSDATE)+1 AS DATAAA, DECODE(BURSA, 450, 450*1.1, 350, 350*1.15, 250, 250*0.2) AS BURSAAA
FROM STUDENTI;

-- 13 Pentru studentii bursieri (doar pentru ei) afisati numele studentului si bursa in stelute: fiecare steluta valoreaza 50 RON. In tabel, alineati stelutele la dreapta.
SELECT NUME, PRENUME, RPAD(' ', BURSA/50, '*') AS BURSA
FROM STUDENTI
WHERE BURSA IS NOT NULL
ORDER BY BURSA DESC;

-- 14 considerand ca in US vasrsta majoratului e 21, afla care studenti sunt majori.afisati numele concatenau cu numele
SELECT NUME 
FROM STUDENTI
WHERE MONTHS_BETWEEN(SYSDATE, DATA_NASTERE) > 21*12;


-- 15 selectati titltul, anul si nr de credite, pt fiecare curs, usb formatul: "cursaul <titlu curs> se face in anul <nr an> si are un nr de <nr credite> credite"
-- doar pt cursurile care se fac in anul 1 indiferent de numele cursului si numele se scrie cu majuscule. 

-- ...

-- 16 afisati doar pt studentii bursieri: nume, pren, data_nastere, iar data nasterii are urmatorul format: "Vineri, 17 Februarie 1995"
-- ord studs in functie de luna si an

-- TO_CHAR(DATA_NASTERE, 'DAY, DD, MONTH YYYY', 'NLS_DATE_LANGUAGE = ROMANIAN')

-- 17 sa se afiseze suma dintre valoare si nr matricol din tabela note in coloana "suma"
-- in alta coloana numita "nota" se va regasi 'x' daca suna e para. alftel, nota ramane neschimbata
SELECT VALOARE+NR_MATRICOL, DECODE(MOD(VALOARE+NR_MATRICOL, 2), 0, 'X', VALOARE) AS PUNCTAJ
FROM NOTE;
