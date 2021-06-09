/*
||||| This sql script can run in oracle with the "START" command followed by
||||| the full file path or the full file path in single quotes.

||||| This sql script was developed by:
||||| - Emma Green.
||||| - Harry Marsden.
||||| - Morgan Moloney.
*/

SET TERM OFF;

----- DELETING ANY PREVIOUSLY CREATED SEQUENCES OR TABLES, IF THERE ARE NO EXISTING TABLES
----- A HARMLESS ERROR WILL OCCOUR, INFORMING OF SUCH. THS IS EXPECTED BEHAVIOUR.
DROP SEQUENCE cust_id_sequence;
DROP SEQUENCE sub_id_sequence;
DROP SEQUENCE set_id_sequence;
DROP SEQUENCE mag_id_sequence;

DROP TABLE mGMagazines;
DROP TABLE mGSubscriptions;
DROP TABLE mGMagSets;
DROP TABLE mGCustomer;

----- SEQUENCES FOR ALL PRIMARY KEYS ARE DEFINED HERE. THIS TAKES CARE OF THE REQUIRED
----- AUTONUMBER CONSTRAINT AS ORACLE VERSION 11 DOESN'T SUPPORT THE "IDENTITY" COMMAND.
CREATE SEQUENCE cust_id_sequence
INCREMENT BY 1
START WITH 1
NOMINVALUE
NOMAXVALUE
NOCYCLE
CACHE 2;

CREATE SEQUENCE sub_id_sequence
INCREMENT BY 1
START WITH 1
NOMINVALUE
NOMAXVALUE
NOCYCLE
CACHE 2;

CREATE SEQUENCE set_id_sequence
INCREMENT BY 1
START WITH 1
NOMINVALUE
NOMAXVALUE
NOCYCLE
CACHE 2;

CREATE SEQUENCE mag_id_sequence
INCREMENT BY 1
START WITH 1
NOMINVALUE
NOMAXVALUE
NOCYCLE
CACHE 2;

SET TERM ON;

----- CREATING TABLES FOR THE CUSTOMER, MAGAZINE SET, SUBSCRIPTONS AND MAGAZINES,
----- THE REASON THEY ARE IN THIS ORDER IS TO PREVENT TABLES BEING REFERENCED BEFORE CREATION.
PROMPT mGCustomer;
CREATE TABLE mGCustomer (
custID NUMBER(2) NOT NULL PRIMARY KEY,
Title VARCHAR(5) NOT NULL,
FirstName VARCHAR(10) NOT NULL,
LastName VARCHAR(10) NOT NULL,
Address VARCHAR(50) NOT NULL,
DOB DATE,
Email VARCHAR(30) NOT NULL
);

PROMPT mGMagSets;
CREATE TABLE mGMagSets (
setID NUMBER(2) NOT NULL PRIMARY KEY,
subSet VARCHAR(4) NOT NULL
);

/*
Here two user constraints are defined:
- subCust_FK establishes the many to one 
  relationship from the subscriptions table to the customer table.

- setID_FK outlines the many to one relationship from
  the subscriptions table to the magazine-set table.
*/
PROMPT mGSubscriptions;
CREATE TABLE mGSubscriptions (
subID NUMBER(4) NOT NULL PRIMARY KEY,
subCust NUMBER(4) NOT NULL,
setID NUMBER(4) NOT NULL,
subStart DATE NOT NULL,
subEnd DATE,
CONSTRAINT subCust_FK FOREIGN KEY(subCust) REFERENCES mGCustomer(custID),
CONSTRAINT setID_FK FOREIGN KEY(setID) REFERENCES mGMagSets(setID)
);

/*
Here one user constraint is defined:
- magSetID_FK outlines the many to one relationship from the
  magazine table to the magazine-set table.
*/
PROMPT mGMagazines;
CREATE TABLE mGMagazines (
magID NUMBER(4) NOT NULL PRIMARY KEY,
setId NUMBER(4) NOT NULL,
magTitle VARCHAR(25) NOT NULL,
magIssue VARCHAR (10),
magRelease DATE NOT NULL,
magPublisher VARCHAR (30) NOT NULL,
CONSTRAINT magSetID_FK FOREIGN KEY(setID) REFERENCES mGMagSets(setID)
);

SET TERM OFF;

----- INSERTING VALUES INTO TABLES, THIS POPULATES THE DATABASE AND PROVIDES A REFERENCE/
----- FRAMEWORK FOR INSERTING NEW ENTRIES TO ANY OF THE TABLES.
--(Customer)
INSERT INTO mGCustomer(custID, Title, FirstName, LastName, Address, DOB, Email) 
VALUES(
cust_id_sequence.NEXTVAL, 'Miss', 'Jenny', 'Harris', '67 The Street, Boughton, Kent, ME13 9UL', '21-AUG-1978', 'jennyharris@aol.com'
);
INSERT INTO mGCustomer(custID, Title, FirstName, LastName, Address, Email) 
VALUES(
cust_id_sequence.NEXTVAL, 'Mr', 'Alex', 'Berry', '45 Hillview Drive, Canterbury, Kent, CT1 RT4', 'alexharris@hotmail.com'
);
INSERT INTO mGCustomer(custID, Title, FirstName, LastName, Address, DOB, Email) 
VALUES(
cust_id_sequence.NEXTVAL, 'Mr', 'Adam', 'Potter', '12 Berkely Close, Cambridge, Kent, CA71 R4', '16-FEB-1991', 'adampotter12@gmail.com'
);

--(Magazine Sets)
INSERT INTO mGMagSets (setID, subSet) VALUES (
set_id_sequence.NEXTVAL, 'FB22'
);
INSERT INTO mGMagSets (setID, subSet) VALUES (
set_id_sequence.NEXTVAL, 'RD11'
);
INSERT INTO mGMagSets (setID, subSet) VALUES (
set_id_sequence.NEXTVAL, 'YS24'
);

---(Subscriptions)
--(Customer 1/Jenny - ONE ACTIVE SUB)
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart, subEnd) 
VALUES(
sub_id_sequence.NEXTVAL, 1, 2, '01-NOV-2018', '06-AUG-2019'
);
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart) 
VALUES(
sub_id_sequence.NEXTVAL, 1, 3, '06-AUG-2019'
);

--(Customer 2/Alex - ALL SUBBED)
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart) 
VALUES(
sub_id_sequence.NEXTVAL, 2, 1, '12-JAN-2017'
);
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart) 
VALUES(
sub_id_sequence.NEXTVAL, 2, 2, '28-FEB-2018'
);
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart) 
VALUES(
sub_id_sequence.NEXTVAL, 2, 3, '16-JUN-2018'
);

--(Customer 3/Adam - NO ACTIVE SUBS)
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart, subEnd) 
VALUES(
sub_id_sequence.NEXTVAL, 3, 2, '16-JUN-2018', '24-NOV-2019'
);
INSERT INTO mGSubscriptions(subID, subCust, setID, subStart, subEnd) 
VALUES(
sub_id_sequence.NEXTVAL, 3, 1, '16-JUN-2018', '21-NOV-2019'
);

---(Magazines)
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 1, 'SCIENCE!', '32', '01-MAR-2016', 'Special And You');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 1, 'Nerd Rage', '32', '21-NOV-2016', 'Harold Books');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 1, 'Bloody Mess', '32', '14-JUN-2016', 'Mysterious Stranger Books');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 2, 'Little Leaguer', '26', '02-DEC-2018', 'Harold Books');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 2, 'Lead Belly', '26', '06-FEB-2017', 'Special And You');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 2, 'Animal Friend', '26',  '11-MAY-2017', 'Harold Books');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 3, 'Impartial Meditation', '18', '16-JUL-2018', 'Special And You');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 3, 'Grim Reapers Spirit', '18', '13-JAN-2018', 'Mysterious Stranger Books');
INSERT INTO mGMagazines(magId, setId, magTitle, magIssue, magRelease, magPublisher) VALUES (
mag_id_sequence.NEXTVAL, 3, 'Mister Sandman', '18', '18-FEB-2018', 'Mysterious Stranger Books');

SET TERM ON;
PROMPT All tables have been populated with default values.;