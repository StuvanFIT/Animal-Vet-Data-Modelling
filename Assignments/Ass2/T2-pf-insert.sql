/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-pf-insert.sql

--Student ID:33155666
--Student Name: STEVEN KAING

/* Comments for your marker:
*/








--------------------------------------
--INSERT INTO visit
--------------------------------------



/*

-9 complete visits
-2 follow up visits
-
A visit is considered incomplete if visit_total_cost is NULL.
This indicates that the visit is either scheduled for the future or has not been finalised yet (i.e., the cost has not been recorded).
-No need to add visit_Drug and visit_service for incomplete bookings and the dosages,drug medications are not prescribed yet in the visit, as the visit hasnt occurred
*/


--Completed visit 1, animal id = 1
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (1, TO_DATE('2024-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, 'Routine checkup', 30, 168, 1, 1001, 1, NULL); 

--Completed visit 2, animal id = 2
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (2, TO_DATE('2024-04-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 40, 'Receive booster shot', 25, 144.99, 2, 1002, 2, NULL);

--Completed visit 3, animal id = 3
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (3, TO_DATE('2024-04-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 40, NULL, NULL, 320, 3, 1003, 3, NULL);

--Completed visit 4, animal id = 4 
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (4, TO_DATE('2024-04-04 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 32, 'Clean Bacteria', 32,  210 , 4, 1004, 4, NULL);


--Visit 5 is a follow up visit from visit 1, animal id = 1
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (5, TO_DATE('2024-04-04 11:01:29', 'YYYY-MM-DD HH24:MI:SS'), 30, 'Routine checkup', 31.5, 145 , 1, 1001, 1, 1);


--Completed visit 6 animal id = 5
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (6, TO_DATE('2024-04-05 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 60, 'Bird Flea', 12,  130, 5, 1005, 5, NULL); 

--Completed visit 7, animal id = 6
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (7, TO_DATE('2024-04-05 20:30:05', 'YYYY-MM-DD HH24:MI:SS'), 60, NULL, 5.6,  93  , 6, 1006, 1, NULL); 



--Completed visit 8, animal id = 1
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (8, TO_DATE('2024-04-06 14:10:50', 'YYYY-MM-DD HH24:MI:SS'), 90, 'Dog Flea', 25,  305  , 1 , 1007, 2, NULL); 

--Visit 9 is a follow up visit from visit 8, animal id = 1
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (9, TO_DATE('2024-04-09 13:10:50', 'YYYY-MM-DD HH24:MI:SS'), 80, 'Low General Health', 27.9, 157.5, 1 , 1007, 2, 8); 

--Completed visit 10, animal id = 10
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (10, TO_DATE('2024-04-10 12:00:10', 'YYYY-MM-DD HH24:MI:SS'), 55, 'Dog Joint', 99.9, 316 , 10, 1010, 2, NULL); 

--Completed visit 11, animal id = 8
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (11, TO_DATE('2024-04-20 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 72, 'Dog Cancer', 13.2,  628  , 8, 1011, 3, NULL); 

--Incomplete visit, scehdules for the future and not payed yet:
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (12, TO_DATE('2024-05-21 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, NULL, NULL, NULL, 11, 1011, 2, NULL);
--Incomplete visit, scehdules for the future and not payed yet:
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (13, TO_DATE('2024-05-21 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 90, NULL, NULL, NULL, 1 , 1007, 2, NULL);


UPDATE visit SET from_visit_id = 1 WHERE visit_id = 5; --Visit 5 is a follow up visit from visit 1
UPDATE visit SET from_visit_id = 8 WHERE visit_id = 9; --Visit 9 is a follow up visit from visit 8


--------------------------------------
--INSERT INTO visit_service
--------------------------------------
---No need to add visit_Drug and visit_service for incomplete bookings and the dosages,drug medications are not prescribed yet in the visit, as the visit hasnt occurred

INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (1, 'S001', 60);


INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (2, 'S002', 45);

INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (3, 'S003', 70);

INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (4, 'S004', 150);

INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (5, 'S012', 100);

INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (6, 'S008', 40);

INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (7, 'S007', 45); --discount of $5 (50-5)


--require more than one service in a single visit
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (8, 'S008', 40);
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (8, 'S009', 85);

--require more than one service in a single visit
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (9, 'S011', 80); --discount of $10 (90-10)
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (9, 'S019', 40); --discount of $10 (50-10)

--require more than one service in a single visit
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (10, 'S012', 100);
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (10, 'S013', 110);

--require more than one service in a single visit
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (11, 'S015', 140);
INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
VALUES (11, 'S016', 130); 


--------------------------------------
--INSERT INTO visit_drug
--------------------------------------

---No need to add visit_Drug and visit_service for incomplete bookings and the dosages,drug medications are not prescribed yet in the visit, as the visit hasnt occurred


INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (1, 101, '5 mg per kg', 'Twice Daily', 9 , 108);


INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (2, 102, '500 mg', 'Yearly Checkup', 1 , 99.99);

INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (3, 103, '9 mg per kg', 'Once Monthly', 5 , 250);

INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (4, 101, '5 mg per kg', 'Twice Daily', 5 , 60);

INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (5, 112, '5 mg per kg', 'Once A Week', 3 , 45);

INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (6, 108, '9.5 mg per kg', 'Once Monthly', 2 , 90);

INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (7, 107, '0.1 mg per kg', 'Once Monthly', 3 , 48);


INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (8, 108, '9.5 mg per kg', 'Once Monthly', 4 , 180);


--More than one drug prescribed in single visit
INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (9, 111, '25 mg', 'Once Daily', 20 , 24);
INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (9, 117, '500 mg', 'Once Daily', 9 , 13.5);

--More than one drug prescribed in single visit
INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (10, 112, '20 mg per kg', 'Once Daily', 8 , 100); --discount of $20 (120-20)
INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (10, 113, '30 mg per kg', 'As Needed', 2 , 6);

--More than one drug prescribed in single visit
INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (11, 115, '0.09 mg per kg', 'Twice Daily', 9 , 350); --dscount of $100 (450-100)
INSERT INTO visit_drug (visit_id, drug_id, visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost)
VALUES (11, 116, '10 mg per kg', 'Twice Daily', 1 , 8);


COMMIT;