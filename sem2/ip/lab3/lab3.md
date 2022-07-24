tearmatica
# Tematica
1. Ingineria cerinţelor: Actori, Scenarii de utilizare
2. Diagrame UML: Diagrame Use Case (actori + use-case-uri), Diagrame de clase (clase + atribute +
metode + relații între clase)
3. Coordonarea echipei, negociere
4. Mod de lucru: în cazul că membrii grupei decid distribuția egală a punctajului,
coordonatorul de laborator va decide cine va prezenta soluțiile săptămâna următoare.


# Cerinte lab

1) Pe o temă pe care o primiți la laborator, realizaţi Fișa Cerințelor pe modelul prezentat la curs
(doar descriere, actori și scenarii de utilizare (doar descrierea, fără detalii)). În stabilirea
punctajului se va ține cont de complexitatea Fișei Cerințelor, de identificarea corecta a posibililor
actori și de modul în care sunt descrise Scenariile de Utilizare. (0..4 puncte)
2) Pentru Fișa Cerințelor creată la 1) de mai sus realizați diagramele Use Case. În stabilirea
punctajului se va ţine cont de identificarea corectă a actorilor şi a use case-urilor şi de stabilirea
corectă a relaţiilor dintre ele. (0..6 puncte)
3) Pentru Fișa Cerințelor creata la 1) de mai sus realizați diagramele de clase (clase + atribute +
metode + relații între clase). În stabilirea punctajului se va ţine cont de identificarea corectă a
claselor şi de stabilirea relaţiilor dintre ele. (0..6 puncte)
4) O persoană din cele 4 va şti ce au făcut toţi membrii echipei şi va face prezentarea pe scurt a
componentelor realizate de aceştia. De asemenea această persoană va stabili şi va negocia
punctajul pe care-l merită echipa (0..4 puncte)
Bonus de maxim 4 puncte pentru cei care surprind cat mai multe aspecte (relații de tip include, extinde la
diagrame use case, relații de agregare, compoziţie la diagramele de clasă).


## Cerinta clientului
Prof la faculta de info. 
Statistici despre el:
* un tabel cu publicatiile lui stiintifice. 
El are deja asta, da' e dispersata. Pe google scholar de exemplu. 
* nu se stie lista publicatiilor lui.
* Afilierile pe care le-a avut la publicatii
* Numarul de citari pe articol
* si co-autorii. 

## Fisa a cerintelor 

* reuniunea site-urilor in care informatiile sunt dispersate;
* categorisirea publictiilor care sunt jurnale
* categorisirea publictiilor care sunt conferinte
* toate publicatiile tb sa fie clastificate A/ B/ C/ D 
( A - zona rosie, B - zona galbena, C - zona alba, D - zona gri) luate automat. 
Toate aceste categorii sunt luate de pe site-ul *Ministerului de Stiinte*.  
Daca un titlu nu se gaseste in lista Ministerului, va avea categoria D.

## Actori 
-prof: logare, export, vizualizare date,  introducere surse cautare, sortare tabel, cautare publicatie
-aplicatie: categorisire,  generare tabel, eliminare duplicate, primire date
-stud: vizualizare date, cautare profesor
-web: trimitere date
-baza de date credentiale: stocare date.
-baza de date informatii stiintifice: stocare date.

## Use cases
ID - 100
Scenariu utilizare profesor:
1. Introduce credentiale pentru logare
2. Click buton logare
3. Intrat in aplicatie.

ID - 101
Scenaiiu utilizare student:
1. Acceseaza aplicatia
2. Cauta profesor
3. Profesor inexistent in baza de date
4. Cauta alt profesor
5. Vizualizeaza date.

ID - 102
Scenariu utilizare web:
1. Furnizeaza date.

ID - 103
 Utilizare aplicatie:
1. Primeste date
2. Elimina duplicate
3. Categoriseste date
4. Genereaza tabel.

ID - 104
Scenariu utilizare web:
1. Furnizeaza date.

ID - 105
Scenariu utilizare baza de date:
1. Stocheaza date.

ID - 106
Scenaiiu utilizare student - vizualizare date cu eroare:
 Acceseaza aplicatia
1. Cauta profesor
2. Click buton "Vizualizeaza date"
3. Eroare la generare tabel
4. Click buton "Try Again"
5. Click buton "Vizualizeaza date"
6. Vizualizare date.

ID - 107
Scenariu utilizare facultate are profesor nou:
1. Acceseaza aplicatia
2. Click inregistare profesor
3. Completeaza detalii
4. Trimite detalii
5. Toate sunt ok, intra in aplicatie.

ID - 108
Scenariu utilizare facultate are profesor nou cu eroare:
1. Acceseaza aplicatia
2. Click inregistare profesor
3. Completeaza detalii
4. Trimite detalii
5. Profesor are username deja folosit. Eroare.
6. Completeaza detalii noi
7. Trimite detalii
8. Acceptare. Intra in aplicatie.

ID - 109
Scenariu utilizare aplicatie - eliminare duplicate cu eroare:
1. Primeste date 
2. Incercare de eliminare duplicate
3. Eroare la eliminare duplicate
4. Reincercare de eliminare duplicate
5. Eliminare duplicate
6. Categorisire date
7. Genereaza tabel.

ID - 110
Scenariu utilizare aplicatie - un server nu are curent:
1. Primeste cerere
2. Cererea este redirectata catre alt server
3. Celalalt server primeste date
4. Celalalt server elimina duplicatele
5. Celalalt server categoriseste datele
6. Celalalt server genereaza tabel.

ID - 111
 Utilizare aplicatie - eroare la primirea datelor:
1. Cere date
2. Eroare la baza de date - nu primeste date
3. Utilizare date backup
4. Elimina duplicate
5. Categoriseste date
6. Genereaza tabel.

## Refs
Recomandări
1. Înainte de laborator: (1) realizați o diagramă use-case din cursul 2 folosind unul din link-urile
utile de mai jos. (2) Citiți https://www.guru99.com/learn-software-requirements-analysis-withcase-study.html
2. La laborator: Discutați la început toți membrii echipei și identificați Actorii și Scenariile de
utilizare. După care 2 persoane se vor ocupa de detaliile Fișei Cerințelor și 2 persoane se vor
ocupa de diagramele use-case. Atenție la sincronizarea detaliilor între cele 2 activități!
Link-uri utile:
https://creately.com/diagram-type/use-case
https://www.smartdraw.com/use-case-diagram/
http://argouml.tigris.org/

Recomandări
1. Înainte de laborator: realizați o diagramă de clase din cursul 3.
2. În timpul laboratorului: Discutați la început toți membrii echipei și identificați Actorii și Scenariile de
utilizare. După care 1 persoană se va ocupa de detaliile Fișei Cerințelor, 1 persoană se va ocupa de
Diagramele de Clase, 1 persoană se va ocupa de Diagramele de tip Use-case, iar 1 persoană de
sincronizare.
Linkuri utile:
Dorel Lucanu, POO, POO – Principii (Relaţii de generalizare, asociere, compoziţie):
http://profs.info.uaic.ro/~dlucanu/cursuri/poo/resurse/principiiPOO.pps
1. Acceseaza aplicatia
2. Click inregistare profesor
3. Completeaza detalii
4. Trimite detalii
5. Profesor are username deja folosit. Eroare.
6. Completeaza detalii noi
7. Trimite detalii
8. Acceptare. Intra in aplicatie.

ID - 109
Scenariu utilizare aplicatie - eliminare duplicate cu eroare:
1. Primeste date 
2. Incercare de eliminare duplicate
3. Eroare la eliminare duplicate
4. Reincercare de eliminare duplicate
5. Eliminare duplicate
6. Categorisire date
7. Genereaza tabel.

ID - 110
Scenariu utilizare aplicatie - un server nu are curent:
1. Primeste cerere
2. Cererea este redirectata catre alt server
3. Celalalt server primeste date
4. Celalalt server elimina duplicatele
5. Celalalt server categoriseste datele
6. Celalalt server genereaza tabel.

ID - 111
 Utilizare aplicatie - eroare la primirea datelor:
1. Cere date
2. Eroare la baza de date - nu primeste date
3. Utilizare date backup
4. Elimina duplicate
5. Categoriseste date
6. Genereaza tabel.

## Refs
Recomandări
1. Înainte de laborator: (1) realizați o diagramă use-case din cursul 2 folosind unul din link-urile
utile de mai jos. (2) Citiți https://www.guru99.com/learn-software-requirements-analysis-withcase-study.html
2. La laborator: Discutați la început toți membrii echipei și identificați Actorii și Scenariile de
utilizare. După care 2 persoane se vor ocupa de detaliile Fișei Cerințelor și 2 persoane se vor
ocupa de diagramele use-case. Atenție la sincronizarea detaliilor între cele 2 activități!
Link-uri utile:
https://creately.com/diagram-type/use-case
https://www.smartdraw.com/use-case-diagram/
http://argouml.tigris.org/

Recomandări
1. Înainte de laborator: realizați o diagramă de clase din cursul 3.
2. În timpul laboratorului: Discutați la început toți membrii echipei și identificați Actorii și Scenariile de
utilizare. După care 1 persoană se va ocupa de detaliile Fișei Cerințelor, 1 persoană se va ocupa de
Diagramele de Clase, 1 persoană se va ocupa de Diagramele de tip Use-case, iar 1 persoană de
sincronizare.
Linkuri utile:
Dorel Lucanu, POO, POO – Principii (Relaţii de generalizare, asociere, compoziţie):
http://profs.info.uaic.ro/~dlucanu/cursuri/poo/resurse/principiiPOO.pps
