/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-pf-json.sql

--Student ID: 33155666
--Student Name: STEVEN KAING


/* Comments for your marker:




*/

-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT TO GENERATE 

SELECT JSON_OBJECT(

    '_id' VALUE cli.clinic_id,

    'name' VALUE cli.clinic_name,

    'address' VALUE cli.clinic_address,

    'phone' VALUE cli.clinic_phone,

    'head_vet' VALUE JSON_OBJECT(
        'id' VALUE cli.vet_id,
        'name' VALUE (SELECT
                        v.vet_givenname || ' ' || v.vet_familyname 
                      FROM
                        vet v 
                      WHERE
                        v.vet_id = cli.vet_id)
    ),

    'no_of_vets' VALUE
    (SELECT
        COUNT(*) 
    FROM
        vet v 
    WHERE
        v.clinic_id = cli.clinic_id),



    'vets' VALUE JSON_ARRAYAGG(
        JSON_OBJECT(
            'id' VALUE v.vet_id,
            'name' VALUE v.vet_givenname || ' ' || NVL(v.vet_familyname, ''),
            'specialisation' VALUE NVL(s.spec_description, 'N/A')
        )
        ORDER BY CLI.CLINIC_ID
        


    ) FORMAT JSON
    



) AS PF_clinic_jsons



-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer



FROM
    clinic cli

JOIN
    vet v ON cli.clinic_id = v.clinic_id
    LEFT JOIN specialisation s ON v.spec_id = s.spec_id

GROUP BY
    cli.clinic_id,
    cli.clinic_name,
    cli.clinic_address,
    cli.clinic_phone,
    cli.vet_id;



