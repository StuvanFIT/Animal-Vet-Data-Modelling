/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T3-pf-dml.sql

--Student ID: 33155666
--Student Name: STEVEN KAING

/* Comments for your marker:




*/
/*(a)*/

DROP SEQUENCE visit_sequence;

--This sequence must start at 100 and increment by 10
CREATE SEQUENCE visit_sequence START WITH 100 INCREMENT BY 10;


/*(b)*/


INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (visit_sequence.NEXTVAL, 
        TO_DATE('2024-05-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        30 ,
        'General Consultation (service code: S001)',
        NULL,
        NULL,
        (
            SELECT
                animal_id
            FROM
                animal
            WHERE
                upper(animal_name) = upper('Oreo')
                AND animal_born  = TO_DATE('2018-06-01', 'YYYY-MM-DD')
                AND owner_id = (
                        
                        SELECT
                            owner_id
                        FROM 
                            owner
                        WHERE
                            upper(owner_givenname) = upper('Jack') AND upper(owner_familyname) = upper('JONES')
                        )
        ),

        (
            SELECT
                vet_id
            FROM
                vet
            WHERE
                upper(vet_givenname) = upper('Anna') AND upper(vet_familyname) = upper('KOWALSKI')
        ),

        3,
        NULL
        );

COMMIT;

/*(c)*/

--She decided to record an ear infection treatment service
INSERT INTO visit_service
VALUES (visit_sequence.CURRVAL,
        (
            SELECT
                service_code

            FROM
                service

            WHERE
                upper(service_desc) = upper('ear infection treatment')
        ),

        (
            SELECT
                service_std_cost
            FROM
                service
            WHERE
                upper(service_desc) = upper('ear infection treatment')
        )
);
--She gave (and charged) 1 bottle of Clotrimazole to Jack
--You may make up (invent) any other required information when making these changes.

INSERT INTO visit_drug
VALUES (visit_sequence.CURRVAL,
        (
            SELECT
                drug_id
            FROM
                drug
            WHERE
                upper(drug_name) = upper('Clotrimazole') 
            ),
            
        '0.01 mg per kg',

        'Once Daily',

        1,

        1*(SELECT drug_std_cost FROM drug WHERE upper(drug_name) = upper('Clotrimazole') 

        )

);

--UPDATE THE TOTAL VISIT COST:
--visit_date_time is always unique

UPDATE visit
SET visit_total_cost = (

    SELECT
        (visit_drug_linecost) + (visit_service_linecost) AS visit_total_cost
    FROM
        visit_drug d
        JOIN visit_service s ON s.visit_id = d.visit_id
        JOIN drug dd ON dd.drug_id = d.drug_id
        JOIN service sv ON sv.service_code = s.service_code

    WHERE
        upper(drug_name) = upper('Clotrimazole')
        AND upper(service_desc) = upper('ear infection treatment')
)

WHERE
    visit_date_time = TO_DATE('2024-05-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS')
    AND animal_id = (
            SELECT
                animal_id
            FROM
                animal
            WHERE
                upper(animal_name) = upper('Oreo')
                AND animal_born  = TO_DATE('2018-06-01', 'YYYY-MM-DD')
                AND owner_id = (
                        
                        SELECT
                            owner_id
                        FROM 
                            owner
                        WHERE
                            upper(owner_givenname) = upper('Jack') AND upper(owner_familyname) = upper('JONES')
                        )
            );

    
--Dr. KOWALSKI also scheduled a follow-up visit for Oreo at 2 PM seven days after this visit for another ear infection treatment at the same clinic.
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id)
VALUES (visit_sequence.NEXTVAL, 
        TO_DATE('2024-05-26 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        30 ,
        'Ear Infection Treatment',
        NULL,
        NULL,
        (
            SELECT
                animal_id
            FROM
                animal
            WHERE
                upper(animal_name) = upper('Oreo')
                AND animal_born  = TO_DATE('2018-06-01', 'YYYY-MM-DD')
                AND owner_id = (
                        
                        SELECT
                            owner_id
                        FROM 
                            owner
                        WHERE
                            upper(owner_givenname) = upper('Jack') AND upper(owner_familyname) = upper('JONES')
                        )
        ),

        (
            SELECT
                vet_id
            FROM
                vet
            WHERE
                upper(vet_givenname) = upper('Anna') AND upper(vet_familyname) = upper('KOWALSKI')
        ),

        3,
        
        (SELECT MAX(visit_id) FROM visit)

        );

COMMIT;

/*(d)*/
--On 21 May 2024, Jack called PF and cancelled Oreo’s 19 May follow-up visit since he has to go overseas for a work emergency.


DELETE FROM VISIT

WHERE

    visit_id = (
    SELECT
        visit_id

    FROM
        visit

    WHERE
        from_visit_id = (
            SELECT
                visit_id

            FROM
                VISIT

            WHERE
                visit_date_time = TO_DATE('2024-05-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS')
        )
    )

    AND
        visit_date_time = (
        SELECT
            visit_date_time

        FROM
            visit

        WHERE
            from_visit_id = (
                SELECT
                    visit_id

                FROM
                    VISIT

                WHERE
                    visit_date_time = TO_DATE('2024-05-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS')
            )
        );

COMMIT;





