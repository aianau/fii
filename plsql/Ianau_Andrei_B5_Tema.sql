-- Tema (2pt)
-- Creati triggere care sa adauge intr-o tabela de LOG-uri operatiile DML (INSERT / UPDATE / DELETE) efectuate asupra
-- tabelului note. In acest tabel de LOG-uri vor fi stocate ID-ul notei, vechea valoare, noua valoare, tipul operatiei,
-- momentul in care s-a executat operatia si de catre cine (userul curent autentificat - SELECT USER FROM DUAL) - aveti
-- nevoie de macar 2 utilizatori care sa aiba acces la aceiasi schema (check this:
-- https://profs.info.uaic.ro/~bd/wiki/index.php/Doi_utilizatori_cu_aceeasi_schema respectiv
-- http://www.java2s.com/Code/Oracle/User-Previliege/Getcurrentusername.htm ).

create table LOGS
(
    id_nota          integer,
    valoare_veche    integer,
    valoare_noua     integer,
    tip_operatie     varchar2(100),
    moment_efectuare date,
    operator         varchar2(100)
);

create or replace trigger trg_delete_nota
    after delete or insert or update
    on NOTE
    for each row
begin
    case
        when deleting then
            insert into LOGS values (:OLD.id, :OLD.valoare, -1, 'delete', sysdate, (select USER from dual));
        when inserting then
            insert into LOGS values (:NEW.id, -1, :NEW.valoare, 'insert', sysdate, (select USER from dual));
        when updating then
            insert into LOGS values (:OLD.id, :OLD.valoare, :NEW.valoare, 'update', sysdate, (select USER from dual));
    end case;
end;

