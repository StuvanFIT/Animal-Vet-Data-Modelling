/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T4-pf-mods.sql

--Student ID: 33155666
--Student Name: STEVEN KAING


/* Comments for your marker:




*/

/*(a)*/

ALTER TABLE visit ADD (visit_service_charged_count NUMBER(6,2) DEFAULT 0);

COMMENT ON COLUMN visit.visit_service_charged_count IS 'Number of services in visit,not charged at standard cost';

UPDATE visit v
SET visit_service_charged_count = (
    SELECT
        COUNT(NVL(CASE WHEN vs.visit_service_linecost != s.service_std_cost THEN 1 END, 0))
    FROM
        visit_service vs
        JOIN service s ON vs.service_code = s.service_code
    WHERE
        vs.visit_id = v.visit_id
        AND vs.visit_service_linecost != s.service_std_cost
        AND vs.visit_service_linecost IS NOT NULL
        AND s.service_std_cost IS NOT NULL
)
WHERE v.visit_id IN (
    SELECT
        v.visit_id
    FROM
        visit_service vs
    JOIN service s ON vs.service_code = s.service_code
    WHERE
        vs.visit_service_linecost IS NOT NULL
        AND s.service_std_cost IS NOT NULL
    GROUP BY
        v.visit_id
    HAVING
        COUNT(NVL(CASE WHEN vs.visit_service_linecost != s.service_std_cost THEN 1 END, 0))>0
);


-- provide appropriate select and desc statements to show the
-- changes you have made. Select to show any data changes that have occurred, and desc
-- tablename, e.g., desc customer, to show any table structural changes.


DESC visit; --show addition of new column: visit_service_charged_count

--Show visit_service_charged_count (not the standard costs) for all visits
SELECT visit_id, visit_service_charged_count
FROM visit
ORDER BY visit_id;

COMMIT;


/*(b)*/


--Create look up table for Payment Method
DROP TABLE payment_method CASCADE CONSTRAINTS;

CREATE TABLE payment_method (

    payment_method_id NUMBER(3) NOT NULL,

    payment_method_desc VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN payment_method.payment_method_id IS
    'Payment Method ID Identifier';

COMMENT ON COLUMN payment_method.payment_method_desc IS
    'Payment method type/or description';


ALTER TABLE payment_method ADD CONSTRAINT payment_meth_id_pk PRIMARY KEY (payment_method_id);

ALTER TABLE payment_method ADD CONSTRAINT payment_meth_desc_unique UNIQUE (payment_method_desc);

--Create Payment methods using look up table:
INSERT INTO payment_method (payment_method_id, payment_method_desc)
VALUES (1, 'No Payment Method');

INSERT INTO payment_method (payment_method_id, payment_method_desc)
VALUES (2, 'Card');

INSERT INTO payment_method (payment_method_id, payment_method_desc)
VALUES (3, 'Cash');

INSERT INTO payment_method (payment_method_id, payment_method_desc)
VALUES (4, 'Historical');





--Drop existing Payment table
DROP TABLE payment CASCADE CONSTRAINTS PURGE;

--We need a payment table
--PF plans to include other payments methods in the future.

CREATE TABLE payment (
    visit_id NUMBER(5) NOT NULL,
    visit_date_time DATE NOT NULL,
    payment_method_id NUMBER(5) NOT NULL,
    payment_status VARCHAR2(50) NOT NULL,
    payment_amount NUMBER(6,2) NOT NULL
);

--We include visit ID, as each visit we either pay in full or partially
COMMENT ON COLUMN payment.visit_id IS 'Identifier for visit';

COMMENT ON COLUMN payment.visit_date_time IS 'Date and Time of Visit/Payment';

COMMENT ON COLUMN payment.payment_method_id IS 'Payment Method Identifier';

COMMENT ON COLUMN payment.payment_status IS 'Payment status';

COMMENT ON COLUMN payment.payment_amount IS 'Amount Paid in this payment';

--Include pk constraints:
--We can have payment dates on the same day but different times, thus we do not make payment dates unique U
ALTER TABLE payment ADD CONSTRAINT pay_pk PRIMARY KEY (visit_id, visit_date_time);

--Include fk constraints:
ALTER TABLE payment
    ADD CONSTRAINT visit_payment_fk  FOREIGN KEY (visit_id)
        REFERENCES visit ( visit_id );
        
ALTER TABLE payment
    ADD CONSTRAINT payment_method_pay_fk FOREIGN KEY ( payment_method_id )
        REFERENCES payment_method ( payment_method_id );


--All currently completed visits in the system must be recorded as being fully paid on their visit date.
--The payment method for these visits must be recorded as Historical.


--Add entries into the payment table
-- Populate the payment table for existing visits marked as fully paid on their visit date
INSERT INTO payment (visit_id, visit_date_time, payment_amount, payment_status, payment_method_id)
SELECT
    visit_id,
    visit_date_time,
    visit_total_cost AS payment_amount, --Owner has paid in their visit
    'Completed' AS payment_status,
    
    (
        SELECT
            payment_method_id
        FROM
            payment_method
        WHERE 
            upper(payment_method_desc) = upper('Historical')

    ) AS payment_method_id



FROM
    visit
WHERE
    visit_total_cost IS NOT NULL;


-- Add entries for visits that have not yet been paid
-- The visits that have visit_total_cost as 0 are not yet paid
INSERT INTO payment (visit_id, visit_date_time, payment_amount, payment_status, payment_method_id)

SELECT
    visit_id,
    visit_date_time,
    0 AS payment_amount,  -- Owner Has not paid yet
    'No Payment' AS payment_status,
    (
        SELECT
            payment_method_id
        FROM
            payment_method
        WHERE 
            upper(payment_method_desc) = upper('No Payment Method')

    ) AS payment_method_id

FROM
    visit
WHERE
    visit_total_cost IS NULL;



--Display:
SELECT * 
FROM
    payment
ORDER BY
    visit_id;

SELECT *
FROM
    payment_method
ORDER BY
    payment_method_id;


COMMIT;

