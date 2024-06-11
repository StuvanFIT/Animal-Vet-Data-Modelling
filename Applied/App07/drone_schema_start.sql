/*
Databases Topic 6 Workshop
drone_schema_start.sql
Base schema generated from SQL Developer

Databases Units
Author: FIT Database Teaching Team
License: Copyright Monash University, unless otherwise stated. All Rights Reserved.
COPYRIGHT WARNING
Warning
This material is protected by copyright. For use within Monash University only. NOT FOR RESALE.
Do not remove this notice.

Student Editor Name:
Date Modified:

*/

/* display SQL command when run*/
SET ECHO ON

/* drop all tables*/
DROP TABLE cust_train CASCADE CONSTRAINTS PURGE;

DROP TABLE customer CASCADE CONSTRAINTS PURGE;

DROP TABLE drone CASCADE CONSTRAINTS PURGE;

DROP TABLE drone_type CASCADE CONSTRAINTS PURGE;

DROP TABLE employee CASCADE CONSTRAINTS PURGE;

DROP TABLE manufacturer CASCADE CONSTRAINTS PURGE;

DROP TABLE training CASCADE CONSTRAINTS PURGE;





/* Purple tables shown on slide 40 */
CREATE TABLE cust_train (
    ct_id          NUMBER(4) NOT NULL,
    train_code     CHAR(5) NOT NULL,
    cust_id        NUMBER(4) NOT NULL,
    ct_date_start  DATE NOT NULL,
    ct_date_expire DATE NOT NULL
);

COMMENT ON COLUMN cust_train.ct_id IS
    'Surrogate key added to identify CUST_TRAIN';

COMMENT ON COLUMN cust_train.train_code IS
    'training code (unique for each training)';

COMMENT ON COLUMN cust_train.cust_id IS
    'customer id';

COMMENT ON COLUMN cust_train.ct_date_start IS
    'customer training licence start date';

COMMENT ON COLUMN cust_train.ct_date_expire IS
    'customer training licence expiry date';

ALTER TABLE cust_train ADD CONSTRAINT cust_train_pk PRIMARY KEY ( ct_id );

ALTER TABLE cust_train
    ADD CONSTRAINT cust_train_uq UNIQUE ( train_code,
                                          ct_date_start,
                                          cust_id );

CREATE TABLE customer (
    cust_id    NUMBER(4) NOT NULL,
    cust_fname VARCHAR2(25) NOT NULL,
    cust_lname VARCHAR2(25) NOT NULL,
    cust_phone CHAR(12) NOT NULL
);

COMMENT ON COLUMN customer.cust_id IS
    'customer id';

COMMENT ON COLUMN customer.cust_fname IS
    'customer first name';

COMMENT ON COLUMN customer.cust_lname IS
    'customer last name';

COMMENT ON COLUMN customer.cust_phone IS
    'customer phone number';

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( cust_id );

CREATE TABLE drone (
    drone_id          NUMBER(5) NOT NULL,
    drone_pur_date    DATE NOT NULL,
    drone_pur_price   NUMBER(7, 2) NOT NULL,
    drone_flight_time NUMBER(6, 1) NOT NULL,
    drone_cost_hr     NUMBER(6, 2) NOT NULL,
    drone_decom_date  DATE,
    dt_code           CHAR(4) NOT NULL
);

COMMENT ON COLUMN drone.drone_id IS
    'drone id (unique for each drone)';

COMMENT ON COLUMN drone.drone_pur_date IS
    'drone purchase date';

COMMENT ON COLUMN drone.drone_pur_price IS
    'drone purchase price';

COMMENT ON COLUMN drone.drone_flight_time IS
    'drone flight time completed since purchase - initially 0';

COMMENT ON COLUMN drone.drone_cost_hr IS
    'drone rate per hour';

COMMENT ON COLUMN drone.drone_decom_date IS
    'Date drone is decomissioned';

COMMENT ON COLUMN drone.dt_code IS
    'drone type code';

ALTER TABLE drone ADD CONSTRAINT drone_pk PRIMARY KEY ( drone_id );

CREATE TABLE drone_type (
    dt_code     CHAR(4) NOT NULL,
    dt_model    VARCHAR2(50) NOT NULL,
    dt_carry_kg NUMBER(3) NOT NULL,
    train_code  CHAR(5) NOT NULL,
    manuf_id    NUMBER(3) NOT NULL
);

COMMENT ON COLUMN drone_type.dt_code IS
    'drone type code';

COMMENT ON COLUMN drone_type.dt_model IS
    'drone type model';

COMMENT ON COLUMN drone_type.dt_carry_kg IS
    'drone type carrying capacity (kg)';

COMMENT ON COLUMN drone_type.train_code IS
    'training code (unique for each training)';

COMMENT ON COLUMN drone_type.manuf_id IS
    'Identifier for manufacturer';

ALTER TABLE drone_type ADD CONSTRAINT drone_type_pk PRIMARY KEY ( dt_code );

CREATE TABLE employee (
    emp_no    NUMBER(3) NOT NULL,
    emp_fname VARCHAR2(25),
    emp_lname VARCHAR2(25),
    emp_type  CHAR(1) NOT NULL
);

ALTER TABLE employee
    ADD CONSTRAINT chk_emp_type CHECK ( emp_type IN ( 'C', 'F' ) );

COMMENT ON COLUMN employee.emp_no IS
    'Identifier for employee';

COMMENT ON COLUMN employee.emp_fname IS
    'Customers first name';

COMMENT ON COLUMN employee.emp_lname IS
    'Customers last name';

COMMENT ON COLUMN employee.emp_type IS
    'Type of employee (Fixed or Contract)';

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY ( emp_no );

CREATE TABLE manufacturer (
    manuf_id   NUMBER(3) NOT NULL,
    manuf_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN manufacturer.manuf_id IS
    'Identifier for manufacturer';

COMMENT ON COLUMN manufacturer.manuf_name IS
    'Name of manufacturer';

ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pk PRIMARY KEY ( manuf_id );

CREATE TABLE training (
    train_code CHAR(5) NOT NULL,
    train_desc VARCHAR2(100) NOT NULL,
    train_hrs  NUMBER(2) NOT NULL
);

COMMENT ON COLUMN training.train_code IS
    'training code (unique for each training)';

COMMENT ON COLUMN training.train_desc IS
    'training description';

COMMENT ON COLUMN training.train_hrs IS
    'training number of hours';

ALTER TABLE training ADD CONSTRAINT training_pk PRIMARY KEY ( train_code );

ALTER TABLE cust_train
    ADD CONSTRAINT customer_cust_train_fk FOREIGN KEY ( cust_id )
        REFERENCES customer ( cust_id );

ALTER TABLE drone
    ADD CONSTRAINT drone_type_drone_fk FOREIGN KEY ( dt_code )
        REFERENCES drone_type ( dt_code );

ALTER TABLE drone_type
    ADD CONSTRAINT manufacturer_drone_type_fk FOREIGN KEY ( manuf_id )
        REFERENCES manufacturer ( manuf_id );

ALTER TABLE cust_train
    ADD CONSTRAINT training_cust_train_fk FOREIGN KEY ( train_code )
        REFERENCES training ( train_code );

ALTER TABLE drone_type
    ADD CONSTRAINT training_drone_type_fk FOREIGN KEY ( train_code )
        REFERENCES training ( train_code );

--- STUDENTS Add SQL code below here ---------------------------

---Drop tables DRONE_SERVICE---
DROP TABLE DRONE_SERVICE CASCADE CONSTRAINTS PURGE;

---Drop Rental DRONE_SERVICE---
DROP TABLE Rental CASCADE CONSTRAINTS PURGE;


