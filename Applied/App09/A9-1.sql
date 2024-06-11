

---Displays the desc of the table
desc uni.unit

SELECT
    unitcode,
    unitname
FROM
    uni.unit;



---Using the to_date: converting a string to a date format

SELECT
    stuid, stufname, stulname, studob
FROM
    uni.student
WHERE
    studob < TO_DATE('30/Apr/1992', 'dd/Mon/yyyy')
ORDER BY
    stuid;


---Using the to_char: converts from a date to a string according to a format string
SELECT
    to_char(sysdate, 'dd/Mon/yyyy hh24:mi:ss') AS server_date
FROM
    dual;

SELECT
    to_char(sysdate+10/24, 'hh24:mi:ss') AS server_time_plus_10_hrs
FROM
    dual;
