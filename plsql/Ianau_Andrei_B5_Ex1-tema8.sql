declare
  v_xml_clob   clob;
begin
  select xmlserialize(document xmlelement("a", 'lalal') as clob) into v_xml_clob from dual;
  Dbms_xslprocessor.CLOB2FILE(cl => x_xml_clob, flocation => 'YOUR_DIR_NAME', fname => 'somename.xml');
end;

declare
    fp       utl_file.file_type;
    type t_tab is table of varchar2(1000);
    rws      t_tab;
    filename varchar2(100);
begin
    select  XMLELEMENT("Entry", xmlforest(S.ID, S.NR_MATRICOL, S.NUME, S.PRENUME, S.AN, S.GRUPA, S.BURSA, S.DATA_NASTERE, S.EMAIL,
                             N.ID,
                             N.VALOARE, N.ID_STUDENT, N.ID_CURS))  as out
        bulk collect
    into rws
    from STUDENTI S
             JOIN NOTE N on S.ID = N.ID_STUDENT;

    filename := 'catalog' || '.xml';
    fp := utl_file.fopen('MYDIR', filename, 'w');

    for i in 1..rws.COUNT
        loop
            DBMS_OUTPUT.put_line(i);
            DBMS_OUTPUT.put_line(rws(i));
        end loop;

    utl_file.fclose(fp);

end;


SELECT XMLELEMENT("Emp",
   XMLFOREST(e.employee_id, e.last_name, e.salary))
   "Emp Element"
   FROM employees e WHERE employee_id = 204;