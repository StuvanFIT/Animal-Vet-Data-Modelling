/* Part C - Aggregate Function, Group By and Having */

-- C1. List the average mark for each offering of FIT9136.
-- In the listing, include the year and semester number. Sort the result according to the year then the semester.
SELECT
    to_char(ofyear, 'yyyy') AS year,
    ofsemester,
    to_char(AVG(enrolmark), '990.000') AS average_mark



FROM
    uni.enrolment

WHERE 
    upper(unitcode) = upper('FIT9136')

GROUP BY
    to_char(ofyear, 'yyyy'), ofsemester --We need include all attributes that are used in the SELECT, HAVING, ORDER BY into the GROUP BY (only the column attributes with commmon values)
                                        --In this case, average markd doesnt include common values
ORDER BY
    year,
    ofsemester;




-- C2. Find the number of students enrolled in FIT1045 in the year 2019, under the following conditions (note two separate selects are required):
--Repeat students are counted multiple times in each semester of 2019

SELECT
    COUNT(stuid) AS num_stud_1045


FROM
    uni.ENROLMENT

WHERE
    upper(unitcode) = upper('FIT1045') AND to_char(ofyear, 'yyyy') = '2019'



--Repeat students are only counted once across 2019

 SELECT 
    COUNT(distinct stuid) AS num_stud_1045

FROM
    uni.ENROLMENT

where
    upper(unitcode) = upper('FIT1045') AND to_char(ofyear, 'yyyy') = '2019'



-- C3. Find the total number of prerequisite units for each unit which has prerequisites. Order the list by unit code.

SELECT
    unitcode,
    COUNT(prerequnitcode) AS num_prereq

FROM
    uni.prereq 

GROUP BY
    unitcode

ORDER BY
    unitcode;



-- C4.Find the total number of students whose marks are being withheld (grade is recorded as WH) for each unit offered in semester 2 2020 which has withheld grades.
-- Sort the list by descending order of the total number of students whose marks are being withheld, then by the unit code.

SELECT 
    unitcode,
    COUNT(stuid) AS total_num_WH


FROM

    uni.ENROLMENT


WHERE
    upper(enrolgrade) = upper('WH') AND ofsemester = 2 AND to_char(ofyear, 'yyyy') = '2020'

GROUP BY
    UNITCODE
ORDER BY
    total_num_WH DESC,
    unitcode;


-- C5. Find the total number of enrolments per semester for each unit in the year 2019. The list should include the unitcode, semester and the total number of enrolment. Order the list in increasing order of enrolment numbers
-- For units with the same number of enrolments, display them by the unitcode order then by the semester order.
SELECT
    unitcode,
    ofsemester,
    COUNT(stuid) AS enrol_per_unit



FROM
    uni.enrolment

WHERE 
    to_char(ofyear, 'yyyy') = '2019'

GROUP BY
    unitcode,
    ofsemester
   
ORDER BY
    enrol_per_unit,
    unitcode,
    ofsemester
   

-- C6
SELECT
    u2.unitcode,
    u2.unitname,
    COUNT(prerequnitcode) as pre_count

FROM
    uni.unit u
    JOIN uni.prereq p ON p.unitcode = u.unitcode
    JOIN uni.unit u2 ON u2.unitcode = p.prerequnitcode  --THIS u2 is used to grab the unit name and unit code of the prerequisite units

GROUP BY
    prerequnitcode,
    u2.unitcode,
    u2.unitname

ORDER BY
    prerequnitcode,
    pre_count



----OR---- better solution
SELECT
    prerequnitcode    AS unitcode,
    u.unitname,
    COUNT(u.unitcode) AS no_times_used
FROM
    uni.prereq p
    JOIN uni.unit u ON u.unitcode = p.prerequnitcode
GROUP BY
    prerequnitcode,
    u.unitname
ORDER BY
    unitcode

-- 7. Display the unit code and unit name of units which had at least 2 students who were granted a deferred exam
--(grade is recorded as DEF) in semester 2 2021. Order the list by unit code.
SELECT
    u.unitcode,
    u.unitname

FROM
    uni.enrolment e
    JOIN uni.unit u ON u.unitcode =  e.unitcode

WHERE
    ofsemester =2
    AND to_char(OFYEAR, 'yyyy') = '2021'
    AND upper(enrolgrade) = upper('DEF')

GROUP BY
    u.unitcode,
    u.unitname

HAVING
    COUNT(*) >= 2

ORDER BY
    u.unitcode;
