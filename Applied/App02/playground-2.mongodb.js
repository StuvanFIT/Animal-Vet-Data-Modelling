// Databases Applied 2
// applied2_student.mongodb.js

// student id: 33155666
// student name: Steven Kaing
// last modified date: 6 March 2024

use ("skai0008")

db.student.drop();

db.student.insertMany([{
    "_id": 12489379,
    "firstName": "Gilberto",
    "lastName": "Bwy",
    "address": "5664 Loomis Parkway, Melbourne",
    "phone": "7037621034",
    "email":"Gilberto.Bwy@student.monash.edu"
},
{
    "_id": 12511467,
    "firstName": "Francyne",
    "lastName": "Rigney",
    "address": "75 Buhler Street, Mulgrave",
    "phone": "6994152403",
    "email":"Francyne.Rigney@student.monash.edu"
},
{
    "_id": 12609485,
    "firstName": "Cassondra",
    "lastName": "Sedcole",
    "address": "6507 Tennessee Alley, Melbourne",
    "phone": "8343944500",
    "email":"Cassondra.Sedcole@student.monash.edu"
},
{
    "_id": 12802225,
    "firstName": "Friedrick",
    "lastName": "Geist",
    "address": "99271 Eliot Pass, Dingley",
    "phone": "6787553656",
    "email":"Friedrick.Geist@student.monash.edu"
},
{
    "_id": 12842838,
    "firstName": "Herminia",
    "lastName": "Mendus",
    "address": "64186 East Lane, Moorabbin",
    "phone": "4896374903",
    "email":"Herminia.Mendus@student.monash.edu"
},
{
    "_id": 13028303,
    "firstName": "Herculie",
    "lastName": "Mendus",
    "address": "44 Becker Street, Mulgrave",
    "phone": "2309618710",
    "email":"Herculie.Mendus@student.monash.edu"
},
{
    "_id": 13119134,
    "firstName": "Shandra",
    "lastName": "Lindblom",
    "address": "9241 Rieder Parkway, Chelsea",
    "phone": "4384142213",
    "email":"Shandra.Lindblom@student.monash.edu"
},
{
    "_id": 13390148,
    "firstName": "Brier",
    "lastName": "Kilgour",
    "address": "79776 Dryden Plaza, Moorabbin",
    "phone": "6981280319",
    "email":"Brier.Kilgour@student.monash.edu"
}]); 

db.student.find({"address":/.*Moorabbin*./});