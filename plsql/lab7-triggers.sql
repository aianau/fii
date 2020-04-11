CREATE OR REPLACE TRIGGER dml_stud
   BEFORE INSERT OR UPDATE OR DELETE ON studenti
BEGIN
  dbms_output.put_line('Operatie DML in tabela studenti !');
  -- puteti sa vedeti cine a declansat triggerul:
  CASE
     WHEN INSERTING THEN DBMS_OUTPUT.PUT_LINE('INSERT');
     WHEN DELETING THEN DBMS_OUTPUT.PUT_LINE('DELETE');
     WHEN UPDATING THEN DBMS_OUTPUT.PUT_LINE('UPDATE');
     -- WHEN UPDATING('NUME') THEN .... // vedeti mai jos trigere ce se executa doar la modificarea unui anumit camp
  END CASE;
END;
/

delete from studenti where id=10000;


CREATE OR REPLACE TRIGGER marire_nota
  before UPDATE OF valoare ON note   -- aici se executa numai cand modificam valoarea !
  FOR EACH ROW
BEGIN
  dbms_output.put_line('ID nota: ' || :OLD.id); -- observati ca aveti acces si la alte campuri, nu numai la cele modificate...
  dbms_output.put_line('Vechea nota: ' || :OLD.valoare);
  dbms_output.put_line('Noua nota: ' || :NEW.valoare);

  -- totusi nu permitem sa facem update daca valoarea este mai mica (conform regulamentului universitatii):
  IF (:OLD.valoare>:NEW.valoare) THEN :NEW.valoare := :OLD.valoare;
  end if;
END;
/

update note set valoare =8 where id in (1,2,3,4);

create or replace trigger mutate_example
after delete on note for each row
declare
   v_ramase int;
begin
   dbms_output.put_line('Stergere nota cu ID: '|| :OLD.id);
   select count(*) into v_ramase from note;
   dbms_output.put_line('Au ramas '|| v_ramase || ' note.');
end;

delete from note where id between 101 and 110;

create view std as select * from studenti;


CREATE OR REPLACE TRIGGER delete_student
  INSTEAD OF delete ON std
BEGIN
  dbms_output.put_line('Stergem pe:' || :OLD.nume);
  delete from note where id_student=:OLD.id;
  delete from prieteni where id_student1=:OLD.id;
  delete from prieteni where id_student2=:OLD.id;
  delete from studenti where id=:OLD.id;
END;

delete from std where id=75;


























