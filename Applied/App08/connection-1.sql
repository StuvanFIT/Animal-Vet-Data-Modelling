SET ECHO ON;

CREATE TABLE cust_balance(

    cust_id NUMBER(4) NOT NULL,
    cust_bal NUMBER(4) NOT NULL
);


INSERT INTO cust_balance VALUES(
    1,
    100
);

INSERT INTO cust_balance VALUES(
    2,
    200
);


--UPDATES BALANCE
UPDATE cust_balance

SET cust_bal = 110

WHERE cust_id = 1;


select cust_bal FROM cust_balance WHERE cust_id = 1;


