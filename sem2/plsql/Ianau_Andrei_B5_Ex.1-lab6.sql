-- Exercitiu (5pt)
-- Creati o clasa la alegere care sa contina macar doua metode si un constructor explicit
-- ( in afara celuil implicit). Tot in cadrul acestei clase scrieti si o metoda de comparare a doua obiecte
-- (MAP sau ORDER), inserati o serie de obiecte intr-o tabela si incercati sa le ordonati dupa coloana in care
-- este introdus obiectul pentru a demonstra ca obiectele pot fi intr-adevar comparate unul cu celalalt.
-- Construiti o subclasa pentru clasa de mai sus. Suprascrieti macar o metoda din cele existente in clasa de baza.
--
-- Construiti un bloc anonim in care sa demonstrati functionalitatea claselor construite.

create or replace type animal as object
(
    name       varchar2(10),
    age        number(3),
    birth_date date,
    member
    procedure sleep,
    not
    final
    member
    function make_noise return number,
    map
    member
    FUNCTION age_in_days RETURN NUMBER,
    constructor function animal(name_in varchar2, birth_date_in date) return self as result,
    constructor function animal(name_in varchar2) return self as result
) not final;

create or replace type body animal as
    member procedure sleep as
        begin
            dbms_output.put_line(self.NAME);
        end;
    member function make_noise return number as
        begin
            return 1;
        end;
    constructor function animal(name_in varchar2, birth_date_in date) return self as result as
        begin
            self.NAME := name_in;
            self.BIRTH_DATE := birth_date_in;
            SELF.AGE := (sysdate - birth_date_in) / 360;
            return;
        end;
    constructor function animal(name_in varchar2) return self as result as
        begin
            self.NAME := name_in;
            return;
        end;
    map member FUNCTION age_in_days RETURN NUMBER as
        begin
            return (sysdate - self.BIRTH_DATE);
        end;
end;


create or replace type dog under animal
(
    number_eyes number(1),
    number_legs number(1),
    overriding
    member
    function make_noise return number
);

create or replace type body dog as
    overriding
    member function make_noise return number as
        begin
            return 2;
        end;

end;

create table animals
(
    id         number,
    animal_obj animal
);


declare
    v_animal0 animal;
    v_animal1 animal;
    v_animal2 dog;
begin
    v_animal0 := animal('andreo', to_date('10/10/2018', 'dd/mm/yyyy'));
    v_animal1 := animal('andreo1', to_date('9/10/2018', 'dd/mm/yyyy'));
--     v_animal2 := dog(1, 1, 'andreo', to_date('10/10/2018', 'dd/mm/yyyy'));
--     CUM? cum se instantiaza un dog de exemplu? Cum se face apel la constructor superior pt clasa dog? (cum e in java super(argumente))

--     v_animal := animal('andreo');
    DBMS_OUTPUT.PUT_LINE(v_animal0.NAME || v_animal0.AGE);
    DBMS_OUTPUT.PUT_LINE(v_animal0.MAKE_NOISE());
    DBMS_OUTPUT.PUT_LINE(v_animal2.NAME || v_animal2.AGE);

    if (v_animal0 < v_animal1) then
        DBMS_OUTPUT.PUT_LINE(v_animal0.NAME || v_animal0.AGE || ' e mai tanar');
    else
        DBMS_OUTPUT.PUT_LINE(v_animal1.NAME || v_animal1.AGE || ' e mai tanar');
    end if;
end;

begin

    insert into animals
    values (1, animal('andre0', to_date('1/10/2018', 'dd/mm/yyyy')));
    insert into animals
    values (1, animal('andre1', to_date('2/10/2018', 'dd/mm/yyyy')));
    insert into animals
    values (1, animal('andre2', to_date('3/10/2018', 'dd/mm/yyyy')));
    insert into animals
    values (1, animal('andre3', to_date('4/10/2018', 'dd/mm/yyyy')));
    insert into animals
    values (1, animal('andre4', to_date('5/10/2018', 'dd/mm/yyyy')));
    insert into animals
    values (1, animal('andre5', to_date('6/10/2018', 'dd/mm/yyyy')));
end;

select *
from animals
order by animal_obj;


select *
from animals
order by animal_obj desc;