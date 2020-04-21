create or replace procedure csv_unload
as
    type t_tab is table of NOTE%rowtype;
    rws      t_tab;
    fp       utl_file.file_type;
    filename varchar2(100);
begin

    select *
        bulk collect
    into rws
    from NOTE;

    filename := 'note' || '.csv';
    fp := utl_file.fopen('MYDIR', filename, 'w');

    for i in 1 .. rws.count
        loop
            utl_file.put_line(fp, rws(i).ID || ',' || rws(i).ID_STUDENT || ',' || rws(i).ID_CURS || ',' || rws(i).VALOARE || ',' ||
                                  rws(i).DATA_NOTARE || ',' || rws(i).CREATED_AT || ',' || rws(i).UPDATED_AT);
        end loop;

    utl_file.fclose(fp);

end csv_unload;

create or replace procedure csv_load
as
    fp            UTL_FILE.FILE_TYPE;
    v_line        VARCHAR2(1000);
    v_id          note.id%type;
    v_id_student  note.ID_STUDENT%type;
    v_id_curs     note.ID_CURS%type;
    v_valoare     note.VALOARE%type;
    v_data_notare note.DATA_NOTARE%type;
    v_created_at  note.CREATED_AT%type;
    v_updated_at  note.UPDATED_AT%type;
begin
    fp := utl_file.fopen('MYDIR', 'note.csv', 'R');

    IF UTL_FILE.IS_OPEN(fp) THEN
        LOOP
            BEGIN
                UTL_FILE.GET_LINE(fp, v_line, 1000);
                IF v_line IS NULL THEN
                    EXIT;
                END IF;
                v_id := to_number(REGEXP_SUBSTR(v_line, '[^,]+', 1, 1));
                v_id_student := to_number(REGEXP_SUBSTR(v_line, '[^,]+', 1, 2));
                v_id_curs := to_number(REGEXP_SUBSTR(v_line, '[^,]+', 1, 3));
                v_valoare := to_number(REGEXP_SUBSTR(v_line, '[^,]+', 1, 4));
                v_data_notare := to_date(REGEXP_SUBSTR(v_line, '[^,]+', 1, 5), 'YYYY/MM/DD');
                v_created_at := to_date(REGEXP_SUBSTR(v_line, '[^,]+', 1, 6), 'YYYY/MM/DD');
                v_updated_at := to_date(REGEXP_SUBSTR(v_line, '[^,]+', 1, 7), 'YYYY/MM/DD');
                INSERT INTO NOTE
                VALUES (v_id, v_id_student, v_id_curs, v_valoare, v_data_notare, v_created_at, v_updated_at);
                COMMIT;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    EXIT;
            END;
        END LOOP;
    END IF;

    utl_file.fclose(fp);
end csv_load;


begin
    csv_unload();
end;

begin
    delete from note;
    csv_load();
end;

