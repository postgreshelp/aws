-- Creating the procedure
CREATE OR REPLACE PROCEDURE get_employee_data IS
    -- Declare variables to hold employee data
    v_employee_id   employees.employee_id%TYPE;
    v_first_name    employees.first_name%TYPE;
    v_last_name     employees.last_name%TYPE;
    v_email         employees.email%TYPE;
BEGIN
    -- Open the cursor
    FOR emp_rec IN (SELECT * FROM employees where EMPLOYEE_ID=100) LOOP
        -- Fetch data from the cursor
        v_employee_id := emp_rec.employee_id;
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_email := emp_rec.email;
        -- Process or display the fetched data (you can modify this part based on your requirements)
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id || ', Name: ' || v_first_name || ' ' || v_last_name || ', Email: ' || v_email);
    END LOOP;

    -- Close the cursor (implicitly done when the loop finishes)
END;
/

CREATE TABLE IDENTITY_TST (COL1 NUMBER GENERATED BY DEFAULT AS IDENTITY(START WITH 100
INCREMENT BY 10), COL2 VARCHAR2(30));

INSERT INTO IDENTITY_TST(COL2) VALUES('A');
INSERT INTO IDENTITY_TST(COL1, COL2) VALUES(DEFAULT, 'B');


CREATE OR REPLACE PROCEDURE get_employee_info (
    p_department_id IN employees.department_id%TYPE
)
IS
BEGIN
    FOR emp_rec IN (SELECT ROWID, last_name
                    FROM employees
                    WHERE department_id = p_department_id)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ROWID: ' || emp_rec.ROWID || ', Last Name: ' || emp_rec.last_name);
    END LOOP;
END;
/

CREATE TABLE SYSTEM_EVENTS (
 EVENT_ID NUMBER,
 EVENT_CODE VARCHAR2(10) NOT NULL,
 EVENT_DESCIPTION VARCHAR2(200),
 EVENT_TIME DATE NOT NULL,
 CONSTRAINT PK_EVENT_ID PRIMARY KEY(EVENT_ID))
 ORGANIZATION INDEX;

INSERT INTO SYSTEM_EVENTS VALUES(9, 'EVNT-A1-10', 'Critical', '01-JAN-2017');
INSERT INTO SYSTEM_EVENTS VALUES(1, 'EVNT-C1-09', 'Warning', '01-JAN-2017');
INSERT INTO SYSTEM_EVENTS VALUES(7, 'EVNT-E1-14', 'Critical', '01-JAN-2017');

commit;

