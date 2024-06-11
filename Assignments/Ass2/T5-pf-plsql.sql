--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-pf-plsql.sql

--Student ID: 33155666
--Student Name: STEVEN KAING

/* Comments for your marker:


*/


--(a)
--Write your trigger statement,
--finish it with a slash(/) followed by a blank line <--------ask on ed and clarify


SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER check_service_cost BEFORE 
    INSERT OR UPDATE ON visit_service

    FOR EACH ROW
DECLARE
    --use NUMBER or %type (will determine the most appropriate type, based on the previous column definition)
    service_std_cost service.service_std_cost%TYPE; --holds the service_std_cost

    visit_lower_cost service.service_std_cost%TYPE; --holds the min bound

    visit_upper_cost service.service_std_cost%TYPE; --holds the max bound

BEGIN
    -- Get the standard cost for the service
    SELECT
        service_std_cost INTO service_std_cost
    FROM
        service
    WHERE
        service_code = :NEW.service_code;

    -- Calculate the minimum and maximum allowed costs (the boundaries)
    visit_lower_cost := service_std_cost - (service_std_cost * 0.10);

    visit_upper_cost := service_std_cost + (service_std_cost * 0.10);


    -- Then, we need to check if the cost is within the range: below or above 10% of the standard service cost
    IF (:NEW.visit_service_linecost < visit_lower_cost) OR (:NEW.visit_service_linecost > visit_upper_cost) THEN
        DBMS_OUTPUT.PUT_LINE('There is an ERROR when inserting this service cost!');

        RAISE_APPLICATION_ERROR(-20000, 'The provided service cost MUST be within 10% range of the standard cost (above or below).');
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('The provided service cost is within the 10% range of the standard cost');

    END IF;

END;
/ 



-- Write Test Harness for (a)


/*The FAILING TEST CASE: this should produce an error*/

--BEFORE VALUE
SELECT * FROM visit_service;

--INSERT
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (12, 'S001', 50);

--AFTER VALUE
SELECT * FROM visit_service;


/*The PASSING TEST CASE: should create the row*/

--BEFORE VALUE
SELECT * FROM visit_service;

--INSERT
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (13, 'S002', 48);

--AFTER VALUE
SELECT * FROM visit_service;


/*The PASSING TEST CASE: should create the row*/

--BEFORE VALUE
SELECT * FROM visit_service;

--INSERT
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (12, 'S001', 65);

--AFTER VALUE
SELECT * FROM visit_service;



--Closes Transaction
rollback;
--End of TESTING HARNESS part (a)






--(b)
-- Complete the procedure below

--The procedure must check if the previous visit is a valid visit and whether the inputted date is a valid date
--date is valid if the follow up visit comes after the previous visit date
--check if it has a valid date structure?
CREATE OR REPLACE PROCEDURE prc_followup_visit (
    p_prevvisit_id IN NUMBER,
    p_newvisit_datetime IN DATE,
    p_newvisit_length IN NUMBER,
    p_output OUT VARCHAR2

) AS 
    v_prev_datetime visit.visit_date_time%TYPE;
    v_prev_animal_id visit.animal_id%TYPE;
    v_prev_clinic_id visit.clinic_id%TYPE;
    v_prev_vet_id visit.vet_id%TYPE;

BEGIN
    --Grab the date, animal, clinic and vet id and store them
    --The follow-up visit for an animal must be scheduled at the same clinic and with the same attending vet as the previous visit
    --Thus, we want the date time, animal_id, clinic_id, vet_id.
    SELECT
        visit_date_time, animal_id, clinic_id, vet_id
    INTO
        v_prev_datetime, v_prev_animal_id, v_prev_clinic_id, v_prev_vet_id
    FROM 
        visit
    WHERE
        visit_id = p_prevvisit_id;



    --If the new follow up visit date time < v_prev_datetime, then raise error
    IF p_newvisit_datetime <= v_prev_datetime THEN
        p_output := 'ERROR: The new visit date must be after the original visit date time.';
        RETURN;

    ELSE
        p_output := 'The new follow up visit date time is VALID';
        DBMS_OUTPUT.PUT_LINE('The new follow up visit date time is VALID');
    END IF;



    --Else, we insert the new follow up visit:
    --(visit_id, visit_date_time, visit_length, visit_notes, visit_weight, animal_id, vet_id, clinic_id, from_visit_id)

    -- Insert the follow-up visit:
    INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, animal_id, clinic_id, vet_id, from_visit_id)
    VALUES (
        visit_sequence.NEXTVAL, --seqeuence in task 3
        p_newvisit_datetime,
        p_newvisit_length,
        'General Consultation visit',
        NULL, --visit_weight, does not necessarily mean it stays the same as last visit
        v_prev_animal_id,
        v_prev_clinic_id,
        v_prev_vet_id,
        p_prevvisit_id 
    ); 


    --Insert the visit service session for this visit:
    -- The default service for follow-up visits is the General Consultation
    INSERT INTO visit_service(visit_id, service_code, visit_service_linecost)
    VALUES (

        visit_sequence.CURRVAL,
        (
            SELECT
                service_code
            FROM
                SERVICE
            WHERE
                upper(service_desc) = upper('General Consultation') 
        ),
        (
            SELECT
                service_std_cost
            FROM
                SERVICE
            WHERE
                upper(service_desc) = upper('General Consultation') 
        )
    );


    p_output := 'Follow-up visit inserted successfully.';

END;
/



-- Write Test Harness for (b)

--You may do manual look up when writing the test harness.


/*The PASSING TEST CASE: should create the row*/
--follow up visit is same day different time:

--BEFORE VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;

--execute the procedure
DECLARE
    p_output VARCHAR2(100);

BEGIN
    prc_followup_visit(11, TO_DATE('2024-04-20 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 80, p_output );
    DBMS_OUTPUT.PUT_LINE(p_output); --'Passing test case message'
END;
/

--AFTER VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;


/*The PASSING TEST CASE: should create the row*/
--follow up visit is in 1000 years AND is another follow up visit from the previous follow up visit

--BEFORE VALUE
SELECT * FROM visit_service;

SELECT * FROM visit
ORDER BY visit_id;

--execute the procedure
DECLARE
    p_output VARCHAR2(100);

BEGIN
    prc_followup_visit(2, TO_DATE('3024-04-20 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 80, p_output );
    DBMS_OUTPUT.PUT_LINE(p_output); --'Passing test case message'
END;
/

--AFTER VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;





/*The FAILING TEST CASE: returns error*/
--follow up visit time is before previous visit time

--BEFORE VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;

--execute the procedure
DECLARE
    p_output VARCHAR2(100);

BEGIN
    prc_followup_visit(9, TO_DATE('2024-04-09 09:10:50', 'YYYY-MM-DD HH24:MI:SS'), 50, p_output );
    DBMS_OUTPUT.PUT_LINE(p_output); --'Failing test case message'
END;
/

--AFTER VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;




/*The FAILING TEST CASE: returns error*/
--What if the new follow up visit date time differed by 1 SECOND?

--BEFORE VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;

--execute the procedure
DECLARE
    p_output VARCHAR2(100);

BEGIN
    prc_followup_visit(7, TO_DATE('2024-04-05 20:30:04', 'YYYY-MM-DD HH24:MI:SS'), 50, p_output );
    DBMS_OUTPUT.PUT_LINE(p_output); --'Failing test case message'
END;
/

--AFTER VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;


/*The FAILING TEST CASE: returns error*/
--follow up visit date is only 1 day before previous date?

--BEFORE VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;

--execute the procedure
DECLARE
    p_output VARCHAR2(100);

BEGIN
    prc_followup_visit(6, TO_DATE('2024-04-04 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 50, p_output );
    DBMS_OUTPUT.PUT_LINE(p_output); --'Failing test case message'
END;
/

--AFTER VALUE
SELECT * FROM visit_service;
SELECT * FROM visit
ORDER BY visit_id;


--Closes Transaction
rollback;
--End of TESTING HARNESS part (b)