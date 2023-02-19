-- Selection des prestations coûtant 10€ ou plus

SELECT nomPrestation

FROM PRESTATION

WHERE prixPrestation >= 10;

-- Sélection des noms des patients habitant Massy

SELECT P.nomPatient

FROM PATIENT P

INNER JOIN VILLE V

ON P.VillePatient = V.id_Ville

WHERE V.nomVille = "Massy";

-- Sélection des patients ayant pour praticien le docteur Maboul (pour pouvoir le contacter s'il y a un problème)

SELECT Pa.prenomPatient, Pa.nomdenaissancePatient, Pa.nomPatient

FROM PATIENT PA

INNER JOIN SEJOUR SJ ON PA.id_Patient = SJ.patientSejour

INNER JOIN PRATICIEN PR ON SJ.praticienSejour = PR.id_Praticien

WHERE PR.nomPraticien = "DOCTEUR" AND PR.prenomPraticien = "Maboul";

-- Sélection des patients ayant comme contact un "Ami"

SELECT prenomPatient FROM PATIENT P

INNER JOIN CONTACT C

ON C.id_Contact = P.ContactPatient

WHERE liendeparenteContact = "Ami";

-- Sélection du nom du praticien qui se charge du (ou des) proche(s) de Romain

SELECT DISTINCT prenomPraticien, nomPraticien

FROM PRATICIEN PR

INNER JOIN SEJOUR SJ ON PR.id_Praticien = SJ.praticienSejour

INNER JOIN PATIENT PA ON SJ.patientSejour = PA.id_Patient

INNER JOIN CONTACT C ON PA.ContactPatient = C.id_Contact

WHERE C.prenomContact = "Romain";

-- Sélection des patients encore présents dans l'établissement

SELECT nomPatient,prenomPatient FROM PATIENT P

INNER JOIN SEJOUR S

ON S.patientSejour = P.id_Patient

WHERE sortiereelleSejour = "Toujours présente";

-- Sélection des factures ayant comme prestation la télévision

SELECT id_Facture FROM FACTURE F

INNER JOIN SEJOUR S

ON S.id_Sejour = F.id_Sejour

INNER JOIN LIGNEPRESTATION LP

ON LP.id_Sejour = S.id_Sejour

INNER JOIN PRESTATION PR

ON LP.id_Prestation = PR.id_Prestation

WHERE nomPrestation = "Télévision";

-- Sélection de la prestation commençant le 20 novembre 2022

SELECT nomPrestation

FROM PRESTATION PR

INNER JOIN LIGNEPRESTATION LP ON PR.id_Prestation = LP.id_Prestation

WHERE LP.datedebutPrestation = "20/11/2022";

-- Comptage des patients dans la clinique

SELECT COUNT(*) AS NombrePatients

FROM PATIENT;

-- Sélection des noms et prénoms des patients ayant demandé la télévision comme prestation durant leurs séjours

SELECT nomPatient,prenomPatient FROM PATIENT P

INNER JOIN SEJOUR S

ON S.patientSejour = P.id_Patient

INNER JOIN LIGNEPRESTATION LP

ON LP.id_Sejour = S.id_Sejour

INNER JOIN PRESTATION PR

ON LP.id_Prestation = PR.id_Prestation

WHERE nomPrestation = "Télévision";

-- Comptage du nombre de patients dont l'Inspecteur Gadget s'occupe

SELECT COUNT(*) AS NombrePatients

FROM PATIENT PA

INNER JOIN SEJOUR SJ ON PA.id_Patient = SJ.patientSejour

INNER JOIN PRATICIEN PR ON SJ.praticienSejour = PR.id_Praticien

WHERE PR.nomPraticien = "INSPECTEUR" AND PR.prenomPraticien = "Gadget";

-- Sélection de tous les séjours pris en charge par une mutuelle

SELECT id_Sejour FROM SEJOUR S

INNER JOIN PRISEENCHARGE PEC

ON PEC.id_PriseEnCharge = PECSejour

INNER JOIN MUTUELLE MU

ON MU.id_Mutuelle = PEC.MutuellePriseEnCharge;

-- Sélection du noms et prénoms des patients ayant eu durant des gynécologues comme praticien responsable de leurs séjours

SELECT nomPatient,prenomPatient FROM PATIENT P

INNER JOIN SEJOUR S

ON P.id_Patient = S.patientSejour

INNER JOIN PRATICIEN PR

ON PR.id_Praticien = S.praticienSejour

WHERE typePraticien = "Gynécologue";

-- Sélection des patients inscrits à la mutuelle Korelio qui sont déjà sortis de la clinique
SELECT PA.nomPatient, PA.prenomPatient
FROM PATIENT PA
INNER JOIN MUTUELLE MU ON PA.MutuellePatient = MU.id_Mutuelle
INNER JOIN SEJOUR SE ON PA.id_Patient = SE.patientSejour
WHERE MU.caisseMutuelle = 'Korelio';

-- Comptage du nombre de patients par mutuelle
SELECT MU.caisseMutuelle, COUNT(*)
FROM MUTUELLE MU
INNER JOIN PATIENT PA ON PA.MutuellePatient = MU.id_Mutuelle
GROUP BY MU.caisseMutuelle;

-- Sélection des remarques du séjour pour chaque PATIENT
SELECT DISTINCT PA.nomPatient, PA.prenomPatient, SE.remarquesSejour
FROM PATIENT PA
INNER JOIN SEJOUR SE ON PA.id_Patient = SE.patientSejour
WHERE SE.remarquesSejour IS NOT NULL
ORDER BY PA.nomPatient;

-- Comptage du nombre de patients par type de praticien
SELECT PR.typePraticien, COUNT(PA.id_Patient) as nbPatients
FROM PRATICIEN PR
INNER JOIN SEJOUR SE ON PR.id_Praticien = SE.praticienSejour
INNER JOIN PATIENT PA ON SE.patientSejour = PA.id_Patient
GROUP BY PR.typePraticien;

-- Sélection des types de prise en charges pour chaque patient
SELECT PA.nomPatient, PA.prenomPatient, PEC.typePriseEnCharge
FROM PATIENT PA
INNER JOIN SEJOUR SE ON SE.patientSejour = PA.id_Patient
INNER JOIN PRISEENCHARGE PEC ON SE.PECSejour = PEC.id_PriseEnCharge;

-- Sélection des raisons de séjour pour chaque patient
SELECT DISTINCT PA.nomPatient, PA.prenomPatient, se.raisonSejour
FROM PATIENT PA
INNER JOIN SEJOUR SE ON SE.patientSejour = PA.id_Patient
ORDER BY PA.nomPatient;

-- Sélection de ce que les patients doivent payer en matière de prestations
SELECT PA.nomPatient, PA.prenomPatient, SUM(PR.prixPrestation*(LP.datefinPrestation-LP.datedebutPrestation)) AS prixAPayer
FROM PATIENT PA
INNER JOIN SEJOUR SE ON PA.id_Patient = SE.patientSejour
INNER JOIN LIGNEPRESTATION LP ON SE.id_Sejour = LP.id_Sejour
INNER JOIN PRESTATION PR ON LP.id_Prestation = PR.id_Prestation
WHERE PA.prenomPatient != "Faustin"
GROUP BY PA.nomPatient, PA.prenomPatient;
-- PS : J'ai retiré Faustin car son prix à payer est négatif. SQLite ne prend pas les mois ni la fonction MONTHS_BETWEEN...