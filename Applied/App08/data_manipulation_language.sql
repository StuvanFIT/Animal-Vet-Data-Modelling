
DROP TABLE student;

CREATE TABLE student(
    stu_nbr NUMBER(10) NOT NULL,
    stu_lname VARCHAR(50) NOT NULL,
    stu_fname VARCHAR(50) NOT NULL,
    stu_dob DATE NOT NULL
);




INSERT INTO student VALUES (
    11111111,
    'Bloggs',
    'Fred',
    to_date('01-Jan-2003','dd-Mon-yyyy')
);

INSERT INTO student VALUES (
    11111112,
    'Nice',
    'Nick',
    to_date('10-Oct-2004','dd-Mon-yyyy')
);

INSERT INTO student VALUES (
    11111113,
    'Wheat',
    'Wendy',
    to_date('05-May-2005','dd-Mon-yyyy')
);

INSERT INTO student VALUES (
    11111114,
    'Sheen',
    'Cindy',
    to_date('25-Dec-2004','dd-Mon-yyyy')
);



CREATE TABLE unit(
    unit_code VARCHAR(7) NOT NULL,
    unit_name VARCHAR(50) NOT NULL
);

INSERT INTO unit VALUES (
    'FIT9999',
    'FIT Last Unit'
);

INSERT INTO unit VALUES (
    'FIT9132',
    'Introduction to Databases'
);

INSERT INTO unit VALUES (
    'FIT9161',
    'Project'
);

INSERT INTO unit VALUES (
    'FIT5111',
    'Student''s Life'
);



DROP TABLE enrolment;

CREATE TABLE enrolment(
    stu_nbr NUMBER(10) NOT NULL,
    unit_code VARCHAR(7) NOT NULL,
    enrol_year NUMBER(4) NOT NULL,
    enrol_sem NUMBER(10) NOT NULL,
    enrol_mark NUMBER(10),
    enrol_grade VARCHAR(2) 
);

INSERT INTO enrolment VALUES (
    11111111,
    'FIT9132',
    2022,
    '1',
    35,
    'N'
);

INSERT INTO enrolment VALUES (
    11111111,
    'FIT9161',
    2022,
    '1',
    61,
    'C'
);

INSERT INTO enrolment VALUES (
    11111111,
    'FIT9132',
    2022,
    '2',
    42,
    'N'
);

INSERT INTO enrolment VALUES (
    11111111,
    'FIT5111',
    2022,
    '2',
    76,
    'D'
);

INSERT INTO enrolment VALUES (
    11111111,
    'FIT9132',
    2023,
    '1',
    NULL,
    NULL
);

INSERT INTO enrolment VALUES (
    11111112,
    'FIT9132',
    2022,
    '2',
    83,
    'HD'
);

INSERT INTO enrolment VALUES (
    11111112,
    'FIT9161',
    2022,
    '2',
    79,
    'D'
);

INSERT INTO enrolment VALUES (
    11111113,
    'FIT9132',
    2023,
    '1',
    NULL,
    NULL
);

INSERT INTO enrolment VALUES (
    11111113,
    'FIT5111',
    2023,
    '1',
    NULL,
    NULL
);


COMMIT;


DROP SEQUENCE student_seq;

CREATE SEQUENCE student_seq START WITH 11111115 INCREMENT BY 1;

SELECT
    *
FROM
    cat;


INSERT INTO student VALUES (
    student_seq.NEXTVAL,
    'Mouse',
    'Mickey',
    to_date('03-Feb-2004','dd-Mon-yyyy')
);