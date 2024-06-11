/*
Databases Applied 09
applied9_sql_basic_intermediate.sql

student id: 33155666
student name: Steven Kaing
applied class number: 12pm Wednesday
last modified date: 14/05/2024

*/

/* Part A - Retrieving data from a single table */

-- A1: List the full student details for those students who live in Caulfield. Order the output by student id.


SELECT
    stuid,
    stufname,
    stulname,
    to_char(studob, 'dd-Mon-yyyy') AS date_of_birth,
    stuaddress,
    stuphone,
    stuemail
FROM
    uni.student

    
WHERE
    UPPER(stuaddress) LIKE UPPER(
        '%Caulfield' --Any address that ends with Caufield
    )
ORDER BY
    stuid;


-- A2: List the unit details for all first-year units in the Faculty of Information Technology. Order the output by unit code.



SELECT *


FROM 
    uni.UNIT


WHERE 
    UPPER(UNITCODE) LIKE UPPER('FIT1%')

ORDER BY
    UNITCODE;


-- A3: List the student's id, surname, first name and address for those students who have a surname starting with the letter S and first name
-- which contains the letter i. Order the output by student id.

SELECT 
    STUID,
    STULNAME,
    STUFNAME,
    STUADDRESS

FROM
    UNI.STUDENT

WHERE 
    (UPPER(STULNAME) LIKE UPPER('S%')) and (UPPER(STUFNAME) LIKE UPPER('%i%'))

ORDER BY

    STUID;


-- A4:List the unit code and semester of all units that are offered in 2021. Order the output by unit code, and within a given unit code order by semester.
--To complete this question, you need to use the Oracle function to_char to convert the data type for the year component of the offering date into text.
-- For example, to_char(ofyear,'yyyy') - here we are only using the year part of the date.

SELECT
    unitcode,
    ofsemester
FROM
    uni.offering
WHERE
    to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    unitcode,
    ofsemester;

-- A5: List the year and unit code for all units that were offered in either semester 2 of 2019 or semester 2 of 2020.
--- Order the output by year and then by unit code. To display the offering year correctly in Oracle, you need to use the to_char function.
---For example, to_char(ofyear,'yyyy').

SELECT
    to_char(ofyear, 'yyyy') AS curr_year,
    unitcode
    

FROM
    uni.offering


WHERE

    
    (OFSEMESTER = 2 AND to_char(ofyear, 'yyyy') = '2019') OR (OFSEMESTER = 2 AND to_char(ofyear, 'yyyy') = '2020')

ORDER BY
    curr_year,
    unitcode;



-- A6: List the student id, unit code and mark for those students who have failed any unit in semester 2 of 2021. Order the output by student id then order by unit code.

SELECT

    STUID,
    UNITCODE,
    ENROLMARK

FROM
    uni.ENROLMENT

WHERE

    (OFSEMESTER = 2 AND to_char(ofyear, 'yyyy') = '2021' AND ENROLGRADE = 'N') 

ORDER BY

    STUID,
    UNITCODE;



