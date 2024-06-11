
/* Part B - Retrieving data from multiple tables */

-- B1. List all the unit codes, semesters and name of chief examiners (ie. the staff who is responsible for the unit) for all the units that are offered in 2021.
--Order the output by semester then by unit code.


SELECT

    unitcode,
    ofsemester,
    STAFFFNAME,
    STAFFLNAME

FROM 
    uni.offering o JOIN uni.staff s

    
    ON o.staffid = s.staffid

WHERE
    to_char(ofyear, 'yyyy') ='2021'

ORDER BY
    ofsemester,
    unitcode;



-- B2. List the student id, student name (firstname and surname) as one attribute and the unit name of all enrolments for semester 1 of 2021
--Order the output by unit name, within a given unit name, order by student id

SELECT distinct
    e.stuid,
    stufname
    || ' '
    || stulname AS studentname,
    unitname,
    e.enrolmark
FROM
    uni.student s 
    JOIN uni.enrolment e ON s.stuid = e.stuid
    JOIN uni.unit      u ON u.unitcode = e.unitcode
WHERE
    ofsemester = 1
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    unitname,
    stuid;



-- B3. List the unit code, semester, class type (lecture or tutorial), day, time and duration (in minutes) for all units taught by Windham Ellard in 2021.
-- Sort the list according to the unit code, within a given unit code, order by offering semester.
SELECT
    unitcode,
    ofsemester,
    cltype,
    clday,
    to_char(
        cltime, 'HHAM'
    )               AS time,
    clduration * 60 AS duration,

    s.stafffname ||' '|| s.stafflname AS staffname


FROM


    uni.staff s
    JOIN uni.schedclass sc ON s.staffid = sc.staffid


WHERE

    to_char(
        ofyear, 'yyyy'
    ) = '2021'
    AND upper(stafffname) = upper(
        'Windham'
    )
    AND upper(stafflname) = upper(
        'Ellard'
    )
    
ORDER BY
    unitcode,
    ofsemester;

-- Create a study statement for Brier Kilgour. A study statement contains unit code, unit name, semester and year the study was attempted, the mark and grade
--If the mark and/or grade is unknown, show the mark and/or grade as ‘N/A’. Sort the list by year, then by semester and unit code.


SELECT

    e.unitcode,
    unitname,
    ofsemester,
    to_char(ofyear, 'yyyy') AS year,
    NVL(to_char(enrolmark), 'N/A') AS mark,
    NVL(enrolgrade, 'N/A') AS grade



FROM

    uni.enrolment e
    JOIN uni.UNIT u ON e.UNITCODE = u.UNITCODE
    JOIN uni.STUDENT s ON e.stuid = s.stuid


WHERE 
    upper(stufname) = upper('Brier') AND upper(stulname) = upper('Kilgour')


ORDER BY

    year,
    ofsemester,
    e.unitcode;

-- List the unit code, unit name and the unit code and unit name of the prerequisite units for all units in the database which have prerequisites
--Order the output by unit code and prerequisite unit code.

SELECT
    u1.unitcode,
    u1.unitname,

    PREREQUNITCODE AS prereq_unit_code,
    u2.unitname AS prereq_unit_name





FROM
    uni.unit u1
    JOIN uni.prereq p ON u1.unitcode = p.unitcode
    JOIN uni.unit u2 ON u2.unitcode = p.PREREQUNITCODE

ORDER BY

    u1.unitcode,
    prereq_unit_code;



-- B6. List the unit code and unit name of the prerequisite units of the Introduction to data science unit. Order the output by prerequisite unit code.


SELECT
    prerequnitcode AS prereq_unitcode,
    u2.unitname    AS prereq_unitname
FROM
    uni.unit u1
    JOIN uni.prereq p ON u1.unitcode = p.unitcode

    JOIN uni.unit   u2 ON u2.unitcode = p.prerequnitcode --
WHERE
    upper(
        u1.unitname
    ) = upper(
        'Introduction to data science'
    )
ORDER BY
    prereq_unitcode;




-- B7. Find all students (list their id, firstname and surname) who have received an HD for FIT2094 in semester 2 of 2021. Sort the list by student id.
SELECT
    s.stuid AS studentID,
    stufname,
    stulname




FROM
    uni.student s
    JOIN uni.enrolment e ON e.stuid = s.stuid


WHERE
    upper(enrolgrade) = upper('HD') AND to_char(ofyear, 'yyyy') = '2021' AND ofsemester = 2 AND upper(unitcode) = upper('FIT2094')


    
ORDER BY
    studentID;
-- B8. List the student's full name, unit code for those students who have no mark in any unit in semester 1 of 2021. Sort the list by student full name.


SELECT
    s.stufname || ' ' || s.stulname AS name,
    unitcode



FROM 
    uni.STUDENT s
    JOIN uni.enrolment e ON e.stuid = s.stuid

WHERE

    enrolmark IS null AND to_char(ofyear, 'yyyy') ='2021' AND ofsemester = 1

ORDER BY
    name;