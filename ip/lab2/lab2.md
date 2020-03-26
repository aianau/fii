# Lab 2 - usecase si fisa a cerintelor.


Laborator 2 – Termen limita: laborator curent – timp de lucru 1 oră - (grupe de maxim 4)
Tematica Laboratorului:
1. Ingineria cerinţelor: Actori, Scenarii de utilizare
2. Diagrame UML: Diagrame use case
3. Lucrul în echipă: Comunicare, Sincronizare
4. Mod de lucru: în cazul că membrii grupei decid distribuția egală a punctajului,
coordonatorul de laborator va decide cine va prezenta soluțiile săptămâna următoare.

## TEMATICA
Prof la faculta de info. 
Statistici despre el:
* un tabel cu publicatiile lui stiintifice. 
El are deja asta, da' e dispersata. Pe google scholar de exemplu. 
* nu se stie lista publicatiilor lui.
* Afilierile pe care le-a avut la publicatii
* Numarul de citari pe articol
* si co-autorii. 

## Fisa a cerintelor 
Problema 1 [punctaj 10 puncte]
Pe o tematică pe care o primiți la laborator, realizaţi “Fișa Cerințelor”, care va conține:
1) descrierea problemei (2-5 rânduri),
    Descriere: Un instrument pentru agregare de informatii in legatura cu publicatiile si conferintele stiintifice ale unui profesor.
    Aplicatia va fi capabila de:
* reuniunea site-urilor in care informatiile sunt dispersate;
* categorisirea publictiilor care sunt jurnale
* categorisirea publictiilor care sunt conferinte
* toate publicatiile tb sa fie clastificate A/ B/ C/ D 
( A - zona rosie, B - zona galbena, C - zona alba, D - zona gri) luate automat. 
Toate aceste categorii sunt luate de pe site-ul *Ministerului de Stiinte*.  
Daca un titlu nu se gaseste in lista Ministerului, va avea categoria D.

2) principalii actori și rolul pe care acesta-l îndeplinesc atunci când interacționează cu
   aplicația (descriere pe scurt: 1-2 rânduri de actor),
-prof: logare, export, vizualizare date,  introducere surse cautare, sortare tabel, cautare publicatie
-sistem: categorisire,  generare tabel, eliminare duplicate, primire date
-stud: vizualizare date, cautare profesor
-web: trimitere date
-baza de date: stocare date.

3) principalele scenarii de utilizare pentru fiecare actor (denumire scenariu, scurtă
   descriere (1-2 rânduri de scenariu), eventualele excepții care pot apare).
Scenariu utilizare profesor:
* introduce credentiale pentru logare
* click buton logare

Scenariu utilizare student:
* Aceseaza aplciatia
* Cauta profesor
* Vizualizeaza date

Scenairu utilizare web:
* Furnizeaza date

Scenairu utilizare sistem:
* Primeste date
* elimina duplicate
* categoriseste date
* genereaza tabel.

Scenairu utilizare web:
* Furnizeaza date

Scenairu utilizare baza de date:
* stocheaza date


În stabilirea punctajului se va ține cont de complexitatea “Fișei Cerințelor”, de identificarea
corectă a posibililor actori și de modul în care se fac Scenariile de Utilizare.


## Usecase
Problema 2 [punctaj 10 puncte]
Pentru “Fișa Cerințelor” creată la Problema 1 de mai sus realizați diagramele de tip use-case. În
stabilirea punctajului se va ţine cont de identificarea corectă a actorilor și a use-case-urilor şi de
stabilirea corectă a relaţiilor dintre aceștia. Bonus 2 puncte pentru soluții deosebite.



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

