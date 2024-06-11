
SET ECHO ON;

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE prc_drone_cost_increase10
IS BEGIN
    UPDATE drone
    SET drone_cost_hr = drone_cost_hr * 1.1;

    dbms_output.put_line('Drone cost per hour has been increased by 10%');
END;
/



--before value
select * from drone;
--execute the procedure
exec prc_drone_cost_increase10();
--after value
select * from drone;
--closes transaction - YOU MUST UNDO ALL OF THE CHANGES, AND RETURN BACK TO THE PREVIOUS COMMIT
rollback;



CREATE OR REPLACE PROCEDURE prc_return_rental (p_rent_no IN NUMBER, p_hours_flown IN NUMBER, p_output
OUT VARCHAR2) IS
 p_drone_id NUMBER;
BEGIN
 IF(p_hours_flown <=0) THEN
 p_output := 'Invalid number of hours flown by the drone, the value must be a positive value';

 ELSE
 UPDATE rental
 SET rent_in = sysdate
 WHERE rent_no = p_rent_no;

 SELECT drone_id into p_drone_id
 FROM rental WHERE rent_no = p_rent_no;


UPDATE DRONE
 SET drone_flight_time = drone_flight_time + p_hours_flown
 WHERE drone_id = p_drone_id;

 p_output := 'Rental ' || p_rent_no || ' has been returned, and drone '
 ||p_drone_id||' total flight time has been updated';
 END IF;

 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 dbms_output.put_line('Rental number ' || p_rent_no || ' does not exist');
 WHEN OTHERS THEN
 dbms_output.put_line( SQLERRM );
END;
/


--initial data
insert into rental values (101,200,sysdate,sysdate+7,null, 100);
--before value
select * from drone;
select * from rental;
--call the procedure - error rental number
--call the procedure - success
DECLARE
 output VARCHAR2(200);
BEGIN
 prc_return_rental(101,40,output);
 dbms_output.put_line(output);
END;
/
--after value
select * from drone;
select * from rental;
--closes transaction
rollback;
