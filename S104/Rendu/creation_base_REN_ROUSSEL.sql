-- Suppresion des tables pour éviter les erreurs
DROP TABLE LIGNEPRESTATION;
DROP TABLE PRESTATION;
DROP TABLE FACTURE;
DROP TABLE SEJOUR;
DROP TABLE PRISEENCHARGE;
DROP TABLE PRATICIEN;
DROP TABLE PATIENT;
DROP TABLE MUTUELLE;
DROP TABLE CONTACT;
DROP TABLE VILLE;

-- Création des tables de la base de données
CREATE TABLE VILLE
(
id_Ville NUMERIC(5) PRIMARY KEY,
codePostaleVille NUMERIC(5) NOT NULL,
nomVille CHAR(40)
);

CREATE TABLE CONTACT
(
id_Contact NUMERIC(20) PRIMARY KEY,
nomContact CHAR(20),
prenomContact CHAR(20),
adresseContact CHAR(40),
telephoneContact NUMERIC(10),
emailContact CHAR(20),
liendeparenteContact CHAR(20),
VilleContact NUMERIC(5),
FOREIGN KEY (VilleContact) REFERENCES VILLE
);

CREATE TABLE MUTUELLE
(
id_Mutuelle NUMERIC(20) PRIMARY KEY NOT NULL,
caisseMutuelle CHAR(20)
);

CREATE TABLE PATIENT
(
id_Patient NUMERIC(9) PRIMARY KEY NOT NULL,
nomPatient CHAR(20) NOT NULL,
nomdenaissancePatient CHAR(20),
prenomPatient CHAR(20),
sexePatient CHAR(8)NOT NULL,
agePatient NUMERIC(3),
adressePatient CHAR(40),
emailPatient CHAR(20),
telephonePatient NUMERIC(10),
portablePatient NUMERIC(10),
numerosecuPatient NUMERIC(15) NOT NULL,
ContactPatient NUMERIC(20),
VillePatient NUMERIC(5),
MutuellePatient NUMERIC(20),
FOREIGN KEY(ContactPatient) REFERENCES CONTACT,
FOREIGN KEY(VillePatient) REFERENCES VILLE,
FOREIGN KEY(MutuellePatient) REFERENCES MUTUELLE
);

CREATE TABLE FACTURE
(
id_Facture NUMERIC(10) PRIMARY KEY,
id_Patient NUMERIC(9),
id_Sejour NUMERIC(10),
FOREIGN KEY(id_Patient) REFERENCES PATIENT,
FOREIGN KEY(id_Sejour) REFERENCES SEJOUR
);

CREATE TABLE PRATICIEN (
id_Praticien NUMERIC(20) PRIMARY KEY,
nomPraticien CHAR(20),
prenomPraticien CHAR(20),
telephonePraticien NUMERIC(10),
emailPraticien CHAR(75),
typePraticien CHAR(75)
);

CREATE TABLE PRISEENCHARGE (
id_PriseEnCharge NUMERIC(20) PRIMARY KEY,
typePriseEnCharge CHAR(75),
datedebutPriseEnCharge date,
datefinPriseEnCharge date,
pourcentagePMSSPriseEnCharge CHAR(3),
MutuellePriseEnCharge NUMERIC(20)
);

CREATE TABLE SEJOUR (
id_Sejour NUMERIC(20) PRIMARY KEY,
entreeprevueSejour datetime,
entreereelleSejour datetime,
sortieprevueSejour datetime,
sortiereelleSejour datetime,
raisonSejour CHAR(75),
forfaitSejour NUMERIC(20),
chambreSejour CHAR(5), /* CHAR car présence de lettres dans le numéro de chambre */
remarquesSejour CHAR(200),
praticienSejour NUMERIC(20),
patientSejour NUMERIC(20),
PECSejour NUMERIC(20),
FOREIGN KEY (praticienSejour) REFERENCES PRATICIEN,
FOREIGN KEY (patientSejour) REFERENCES PATIENT,
FOREIGN KEY (PECSejour) REFERENCES PRISEENCHARGE
);

CREATE TABLE PRESTATION (
id_Prestation NUMERIC(20) PRIMARY KEY,
nomPrestation CHAR(75),
prixPrestation NUMERIC(8),
descriptionPrestation CHAR(75)
);

CREATE TABLE LIGNEPRESTATION (
id_Prestation NUMERIC(20) PRIMARY KEY REFERENCES PRESTATION,
id_Sejour NUMERIC(20) REFERENCES SEJOUR,
datedebutPrestation date,
datefinPrestation date

);


