/*
Databases Applied 10
applied10_sql_advanced.sql

student id: 33155666
student name: Steven Kaing
last modified date: 20/05/2024
*/
--1. Find the oldest student/s in FIT9132. Display the student’s id, full name and the date of birth. Sort the list by student id.

SELECT
    s.stuid,
    stufname
    || ' '
    || stulname AS fullname,
    to_char(studob, 'dd/mm/yyyy') AS date_of_birth
FROM
         uni.student s
    JOIN uni.enrolment e ON s.stuid = e.stuid
WHERE
        upper(e.unitcode) = 'FIT9132'
    AND studob = (
        SELECT
            MIN(studob)
        FROM
                 uni.student s
            JOIN uni.enrolment e ON s.stuid = e.stuid
        WHERE
            upper(e.unitcode) = 'FIT9132'
    )
ORDER BY
    s.stuid;



--2 A unit offering is an instance of a particular unit in a particular semester - for example FIT1045 offered in semester 1 of 2019 - is a unit offering.
--  All unit offerings are listed in the OFFERING table. Find the unit offering/s with the highest number of enrolments for any unit offering which occurred in the year 2019.
--Display the unit code, offering semester and number of students enrolled in the offering. Sort the list by semester then by unit code


SELECT
    unitcode,
    ofsemester,
    to_char(ofyear, 'yyyy') AS year,
    COUNT(stuid) AS num_enrolments
 


FROM
    uni.enrolment
WHERE
    to_char(ofyear, 'YYYY') = '2019'


GROUP BY
    unitcode,
    OFSEMESTER,
    ofyear

HAVING
    COUNT(stuid) = (

        SELECT 
            MAX(COUNT(stuid))
        FROM
            uni.enrolment
        WHERE
            to_char(ofyear, 'yyyy') = '2019'
        GROUP BY
            unitcode,
            ofsemester,
            ofyear
    )

ORDER BY
    unitcode,
    ofsemester


--3. Find all students enrolled in FIT3157 in semester 1, 2020 who have scored more than the average mark for FIT3157 in the same offering.
--- Display the students' name and the mark.
--Sort the list in the order of the mark from the highest to the lowest then in increasing order of student name.



SELECT distinct
    stufname || ' ' || stulname as stu_name,
    enrolmark

FROM

    uni.offering o
    JOIN uni.enrolment e ON e.unitcode = o.unitcode
    JOIN uni.student s ON s.stuid = e.stuid

WHERE
    e.ofsemester = 1
    AND to_char(e.ofyear, 'yyyy') = '2020'
    AND upper(e.unitcode) = 'FIT3157'

    AND enrolmark > (

        SELECT 
            AVG(enrolmark)
        FROM
            uni.enrolment e
        WHERE
            e.ofsemester = 1
            AND to_char(e.ofyear, 'yyyy') = '2020'
            AND upper(e.unitcode) = 'FIT3157'
    )


ORDER BY
    enrolmark DESC,
    stu_name



--4.  Assuming that the student's name is unique, display Claudette Serman’s academic record.
--Include the unit code, unit name, year, semester, mark and explained_grade in the listing.
--The Explained Grade column must show Fail for N, Pass for P, Credit for C, Distinction for D and High Distinction for HD.
--Order by year, within the same year order the list by semester, and within the same semester order the list by the unit code.

SELECT
    u.unitcode,
    u.unitname,
    to_char(e.ofyear, 'yyyy') AS Year,
    e.ofsemester,
    enrolmark,

    CASE
        WHEN e.enrolgrade = 'N' THEN 'Fail'
        WHEN e.enrolgrade = 'P' THEN 'Pass'
        WHEN e.enrolgrade = 'C' THEN 'Credit'
        WHEN e.enrolgrade = 'D' THEN 'Distinction'
        WHEN e.enrolgrade = 'HD' THEN 'High distinction'
        
    END AS explained_grade


FROM
    uni.enrolment e
    JOIN uni.student s ON s.stuid = e.STUID
    JOIN uni.unit u ON u.unitcode = e.unitcode

WHERE 
    upper(stufname) = upper('Claudette') 
    AND upper(stulname) = upper('Serman')

ORDER BY
    Year,
    e.ofsemester,
    u.unitcode
    

--5  Find the number of scheduled classes assigned to each staff member for each semester in 2019.
--If the number of classes is 2 then this should be labelled as a correct load, more than 2 as an overload and less than 2 as an underload
--Include the staff id, staff first name, staff last name, semester, number of scheduled classes and load in the listing.
--Sort the list by decreasing order of the number of scheduled classes and when the number of classes is the same, sort by the staff id then by the semester.
SELECT
    s.staffid,
    s.stafffname as STAFF_FIRST_NAME,
    s.stafflname as STAFF_LAST_NAME,
    ofsemester,
    COUNT(*) AS NUMBERCLASSES, --since we grouped them, count(*) coutns the number of rows for each group = COUNT(unitcode) and since eahc row has the same mathcing unit code of the group
    
    CASE
        WHEN COUNT(*) = 2 THEN 'Correct Load'
        WHEN COUNT(*) > 2 THEN 'Over Load'
        WHEN COUNT(*) < 2 THEN 'Under Load'

    END AS LOAD


FROM
    uni.schedclass sc
    JOIN uni.staff s ON s.staffid = sc.staffid

WHERE 
    to_char(ofyear, 'yyyy') = '2019'

GROUP BY
    s.staffid,
    ofsemester,
    s.stafffname,
    s.stafflname

ORDER BY
    NUMBERCLASSES DESC,
    s.staffid,
    ofsemester




--6. Find the total number of prerequisite units for all units. Include in the list the unit code of units that do not have a prerequisite.
--Order the list in descending order of the number of prerequisite units and where several units have the same number of prerequisites order then by unit code.

SELECT
    u.unitcode,
    COUNT(p.prerequnitcode) AS NO_OF_PREREQ


FROM
    uni.unit u
    LEFT OUTER JOIN uni.prereq p ON p.unitcode = u.unitcode --we pick LEFT OUTER JOIN, as we need to show all units 
                                                            --If uni.unit u was on the RHS, the we would use RIGHT OUTER JOIN



GROUP BY
    u.unitcode

ORDER BY
    NO_OF_PREREQ DESC,
    u.unitcode


--7. Display the unit code and unit name for units that do not have a prerequisite. Order the list by unit code.
--There are many approaches that you can take in writing an SQL statement to answer this query.
--You can use the SET OPERATORS, OUTER JOIN and a SUBQUERY. Write SQL statements based on all three approaches. 
/* Using outer join */
SELECT
    u.unitcode,
    u.unitname


FROM 
    uni.unit u

    LEFT OUTER JOIN uni.prereq p ON p.unitcode = u.unitcode


GROUP BY
    u.unitcode,
    u.unitname

HAVING
    COUNT(p.PREREQUNITCODE) = 0

ORDER BY
    u.unitcode,
    u.unitname





/* Using set operator MINUS */

SELECT
    u.unitcode,
    u.unitname


FROM 
    uni.unit u

WHERE 
    unitcode IN (

        SELECT
            UNITCODE
        FROM
            uni.unit
        
        MINUS

        SELECT
            unitcode
        FROM
            uni.prereq
    )


/* Using subquery */

SELECT *


FROM
    uni.unit

WHERE
    unitcode NOT IN(

        SELECT
            UNITCODE
        FROM
            uni.prereq
    )

ORDER BY
    unitcode

--8. List the unit code, semester, number of enrolments and the average mark for each unit offering in 2019.
--A unit offering is a particular unit in a particular semester for a particular year -
--for example the offering of FIT3176 in semester 2 of 2019 is one offering. Include offerings without any enrolment in the list. Round the average to 2 digits after the decimal point. If the average result is 'null', display the average as 0.00. The average must be shown with two decimal digits and right aligned. Order the list by the average mark, and when the average mark for several offerings
--is the same, sort by the semester then by the unit code.

SELECT
    unitcode,
    ofsemester,
    COUNT(*) AS num_enrolments,

    lpad(to_char(nvl(round(AVG(enrolmark), 2), 0), '990.99'), 20, ' ') AS average_mark

FROM
    uni.offering 
    LEFT OUTER JOIN uni.enrolment
    USING ( ofyear,
        ofsemester,
        unitcode )

WHERE 
    to_char(ofyear, 'yyyy') = '2019'

GROUP BY
    unitcode,
    ofsemester

ORDER BY
    average_mark,
    unitcode,
    ofsemester






--9. List all units offered in semester 2 2019 which do not have any students enrolled. Include the unit code, unit name, and the chief examiner's name in a single column titled ce_name. Order the list based on the unit code.
SELECT
    o.unitcode,
    unitname,
    s.stafffname || ' ' || s.stafflname AS CE_name


FROM 
    uni.offering o

    --Matches everything on the left with the right table  ON the below conditions
    LEFT OUTER JOIN uni.enrolment e ON e.UNITCODE = o.UNITCODE AND e.ofsemester = o.ofsemester AND e.ofyear = o.ofyear
    
    JOIN uni.unit u ON u.UNITCODE = o.UNITCODE
    JOIN uni.staff s ON s.staffid = o.staffid
WHERE
    
    o.ofsemester = 2
    AND to_char(o.ofyear, 'yyyy') = '2019'


GROUP BY
    o.unitcode,
    unitname,
    s.stafffname || ' ' || s.stafflname


HAVING
    COUNT(stuid) = 0

ORDER BY
    unitcode






--10. List the id and full name (in a single column titled student_full_name)
--of students who are enrolled in both Introduction to databases and Introduction to computer architecture
--and networks (note: both unit names are unique) in semester 1 2020. You should note that the case provided for these unit names
--does not necessarily match the case in the database.
--Order the list by the student id.

SELECT
    stuid,
    stufname || ' ' || stulname AS student_full_name
FROM
    uni.student
WHERE
    stuid IN (
        SELECT
            stuid
        FROM
            uni.enrolment
            NATURAL JOIN uni.unit
        WHERE
            lower(unitname) = lower('Introduction to databases')
            AND ofsemester = 1
            AND to_char(ofyear, 'yyyy') = '2020'
        INTERSECT
        SELECT
            stuid
        FROM
            uni.enrolment
            NATURAL JOIN uni.unit
        WHERE
            lower(unitname) = lower('Introduction to computer architecture and networks')
            AND ofsemester = 1
            AND to_char(ofyear, 'yyyy') = '2020'
    )
ORDER BY
    stuid;



--11. Given that the payment rate for a tutorial is $42.85 per hour and the payment rate for a lecture is $75.60 per hour,
--calculate the weekly payment per type of class for each staff member in semester 1 2020.
--In the display, include staff id, staff name, type of class (lecture - L or tutorial - T),
--number of classes, number of hours (total duration), and weekly payment (number of hours * payment rate).
--The weekly payment must be displayed to two decimal points and right aligned. Order the list by the staff id and
--for a given staff id by the type of class.

--The naive approach:
SELECT
    s.staffid,
    s.stafffname || ' ' || s.stafflname AS staffname,
    
    CASE
        WHEN sc.cltype ='L' THEN 'Lecture'

        WHEN sc.cltype ='T' THEN 'Tutorial'

    END AS TYPE,

    COUNT(*) AS num_classes,
    SUM(sc.CLDURATION) AS DURATION,

    CASE
        WHEN sc.cltype ='L' THEN to_char(ROUND((SUM(sc.CLDURATION) *75.60),2),'$990.99')
        WHEN sc.cltype ='T' THEN to_char(ROUND((SUM(sc.CLDURATION) *42.85),2),'$990.99')

    END AS PAYMENT



FROM
    uni.schedclass sc
    JOIN uni.staff s ON s.staffid = sc.staffid

WHERE 
    to_char(sc.ofyear, 'yyyy') = '2020'
    AND sc.ofsemester = 1

GROUP BY
    s.staffid,
    cltype,
    s.stafffname || ' ' || s.stafflname
    

ORDER BY
    s.staffid,
    cltype
    

--The union approach

SELECT
    staffid,
    stafffname
    || ' '
    || stafflname AS staffname,
    'Lecture' AS type,
    COUNT(*) AS no_of_classes,
    SUM(clduration) AS total_hours,
    lpad(to_char(SUM(clduration) * 75.60, '$999.99'), 14, ' ') AS weekly_payment
FROM
    uni.schedclass
    NATURAL JOIN uni.staff
WHERE
    upper(cltype) = 'L'
    AND ofsemester = 1
    AND to_char(ofyear, 'yyyy') = '2020'
GROUP BY
    staffid,
    stafffname
    || ' '
    || stafflname




UNION





SELECT
    staffid,
    stafffname
    || ' '
    || stafflname AS staffname,
    'Tutorial' AS type,
    COUNT(*) AS no_of_classes,
    SUM(clduration) AS total_hours,
    lpad(to_char(SUM(clduration) * 42.85, '$999.99'), 14, ' ') AS weekly_payment
FROM
    uni.schedclass
    NATURAL JOIN uni.staff
WHERE
    upper(cltype) = 'T'
    AND ofsemester = 1
    AND to_char(ofyear, 'yyyy') = '2020'
GROUP BY
    staffid,
    stafffname
    || ' '
    || stafflname
ORDER BY
    staffid, type;

    
--12
SELECT distinct

    s.staffid,
    s.stafffname || ' ' || s.stafflname AS staff_name,

    (SELECT

        SUM(clduration) *42.85 

    FROM
        uni.schedclass sc1
    WHERE
        to_char(ofyear, 'yyyy') = '2020'
        AND ofsemester = 1
        AND cltype = 'L'
        AND sc1.staffid = sc.staffid

    ) AS TUTORIAL_PAYMENT




    

FROM 
    uni.staff s
    LEFT OUTER JOIN uni.schedclass sc ON sc.staffid = s.staffid








    
--13




