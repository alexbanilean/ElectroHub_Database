-------------------------------------- Proiect BD ElectroHub Database --------------------------------------

---------- TARI ----------

CREATE TABLE TARI
(
    id_tara NUMBER(8, 0) CONSTRAINT PKEY_TARI PRIMARY KEY,
    nume_tara VARCHAR2(30) CONSTRAINT nume_tara NOT NULL,
    nr_locuitori NUMBER(15, 0),
    suprafata NUMBER(15, 0)
);

INSERT INTO TARI VALUES (1, 'România', 19290000, 238397);
INSERT INTO TARI VALUES (2, 'Germania', 83222442, 357588);
INSERT INTO TARI VALUES (3, 'Franța', 67813000, 543940);
INSERT INTO TARI VALUES (4, 'Italia', 58983122, 302073);
INSERT INTO TARI VALUES (5, 'Spania', 47326687, 505990);

--SELECT * FROM TARI;

---------- Regiuni ----------

CREATE TABLE REGIUNI
(
    id_regiune NUMBER(8, 0) CONSTRAINT PKEY_REGIUNI PRIMARY KEY,
    id_tara NUMBER(8, 0) CONSTRAINT id_tara_nn NOT NULL,
    nume_regiune VARCHAR2(30) CONSTRAINT nume_regiune NOT NULL,
    resedinta VARCHAR2(30),
    CONSTRAINT FK_REGIUNI_TARI FOREIGN KEY (id_tara) REFERENCES TARI(id_tara)
);

INSERT INTO REGIUNI VALUES (1, 1,'Muntenia', 'București');
INSERT INTO REGIUNI VALUES (2, 1,'Moldova', 'Iași');
INSERT INTO REGIUNI VALUES (3, 1,'Transilvania', 'Cluj-Napoca');
INSERT INTO REGIUNI VALUES (4, 1,'Dobrogea', 'Constanța');
INSERT INTO REGIUNI VALUES (5, 1,'Maramureș', 'Baia Mare');

--SELECT * FROM REGIUNI;

---------- Orase ----------

CREATE TABLE ORASE
(
    id_oras NUMBER(8, 0) CONSTRAINT PKEY_ORASE PRIMARY KEY,
    id_regiune NUMBER(8, 0) CONSTRAINT id_regiune_nn NOT NULL,
    nume_oras VARCHAR2(30) CONSTRAINT nume_oras NOT NULL,
    CONSTRAINT FK_ORASE_REGIUNI FOREIGN KEY (id_regiune) REFERENCES REGIUNI(id_regiune)
);

INSERT INTO ORASE VALUES (1, 1,'București');
INSERT INTO ORASE VALUES (2, 2,'Iași');
INSERT INTO ORASE VALUES (3, 3,'Cluj-Napoca');
INSERT INTO ORASE VALUES (4, 4,'Constanța');
INSERT INTO ORASE VALUES (5, 5, 'Baia Mare');

--SELECT * FROM ORASE;

---------- Locatii ----------

CREATE TABLE LOCATII
(
    id_locatie NUMBER(8, 0) CONSTRAINT PKEY_LOCATII PRIMARY KEY,
    id_oras NUMBER(8, 0) CONSTRAINT id_oras_nn NOT NULL,
    adresa VARCHAR2(50) CONSTRAINT adresa_locatie NOT NULL,
    nr_cladiri NUMBER(8, 0),
    CONSTRAINT FK_LOCATII_ORASE FOREIGN KEY (id_oras) REFERENCES ORASE(id_oras)
);

INSERT INTO LOCATII VALUES (1, 1,'Str. Academiei, nr. 33', 1);
INSERT INTO LOCATII VALUES (2, 1,'Str. Lalelelor, nr. 2', 2);
INSERT INTO LOCATII VALUES (3, 1,'Str. Mihai Eminescu, nr. 1', 1);
INSERT INTO LOCATII VALUES (4, 3,'Str. Crizantemelor, nr. 25', 1);
INSERT INTO LOCATII VALUES (5, 3,'Str. Liviu Rebreanu, nr. 17', 2);

--SELECT * FROM LOCATII;

---------- Departamente ----------

CREATE TABLE DEPARTAMENTE
(
    id_departament NUMBER(8, 0) CONSTRAINT PKEY_DEPARTAMENTE PRIMARY KEY,
    id_locatie NUMBER(8, 0) CONSTRAINT id_locatie_nn NOT NULL,
    denumire VARCHAR2(30) CONSTRAINT denumire_departament NOT NULL,
    id_manager NUMBER(8, 0),
    CONSTRAINT FK_DEPARTAMENTE_LOCATII FOREIGN KEY (id_locatie) REFERENCES LOCATII(id_locatie)
);

INSERT INTO DEPARTAMENTE VALUES (1, 1, 'Resurse umane', NULL);
INSERT INTO DEPARTAMENTE VALUES (2, 1, 'IT', NULL); 
INSERT INTO DEPARTAMENTE VALUES (3, 1, 'Vânzări', NULL);
INSERT INTO DEPARTAMENTE VALUES (4, 3, 'Resurse umane', NULL);
INSERT INTO DEPARTAMENTE VALUES (5, 3, 'IT', NULL);

--SELECT * FROM DEPARTAMENTE;

---------- Depozite ----------

CREATE TABLE DEPOZITE
(
    id_depozit NUMBER(8, 0) CONSTRAINT PKEY_DEPOZITE PRIMARY KEY,
    id_locatie NUMBER(8, 0) CONSTRAINT depozite_id_locatie_nn NOT NULL,
    capacitate NUMBER(8, 0) CONSTRAINT depozite_capacitate NOT NULL,
    suprafata NUMBER(8, 0) CONSTRAINT depozite_suprafata NOT NULL,
    este_plin VARCHAR2(5),
    CONSTRAINT FK_DEPOZITE_LOCATII FOREIGN KEY (id_locatie) REFERENCES LOCATII(id_locatie)
);

INSERT INTO DEPOZITE VALUES (1, 1, 5000, 2000, 'Nu');
INSERT INTO DEPOZITE VALUES (2, 3, 10000, 4000, 'Nu');
INSERT INTO DEPOZITE VALUES (3, 5, 4000, 1800, 'Nu');
INSERT INTO DEPOZITE VALUES (4, 2, 2000, 1000, 'Nu');
INSERT INTO DEPOZITE VALUES (5, 4, 1000, 200, 'Da');

--SELECT * FROM DEPOZITE;

---------- Magazine ----------

CREATE TABLE MAGAZINE
(
    id_magazin NUMBER(8, 0) CONSTRAINT PKEY_MAGAZINE PRIMARY KEY,
    id_locatie NUMBER(8, 0) CONSTRAINT magazine_id_locatie_nn NOT NULL,
    nr_angajati NUMBER(8, 0),
    CONSTRAINT FK_MAGAZINE_LOCATII FOREIGN KEY (id_locatie) REFERENCES LOCATII(id_locatie)
);

INSERT INTO MAGAZINE VALUES (1, 1, 24);
INSERT INTO MAGAZINE VALUES (2, 3, 60);
INSERT INTO MAGAZINE VALUES (3, 5, 22);
INSERT INTO MAGAZINE VALUES (4, 2, 12);
INSERT INTO MAGAZINE VALUES (5, 4, 5);

--SELECT * FROM MAGAZINE;

---------- Joburi ----------

CREATE TABLE JOBURI
(
    id_job NUMBER(8, 0) CONSTRAINT PKEY_JOBURI PRIMARY KEY,
    nume_job VARCHAR2(30) CONSTRAINT nume_job NOT NULL,
    salariu_minim NUMBER(8, 0),
    salariu_maxim NUMBER(8, 0)
);

INSERT INTO JOBURI VALUES (1, 'Programator', 3000, 12000);
INSERT INTO JOBURI VALUES (2, 'Consultant vânzări', 2000, 6000);
INSERT INTO JOBURI VALUES (3, 'Contabil', 3000, 8000);
INSERT INTO JOBURI VALUES (4, 'Manager vânzări', 4000, 8000);
INSERT INTO JOBURI VALUES (5, 'Manager resurse umane', 4000, 8000);

--SELECT * FROM JOBURI;

---------- Angajati ----------

CREATE TABLE ANGAJATI
(
    id_angajat NUMBER(8, 0) CONSTRAINT PKEY_ANGJATI PRIMARY KEY,
    id_departament NUMBER(8, 0),
    nume VARCHAR2(30) CONSTRAINT angajati_nume NOT NULL,
    prenume VARCHAR2(30) CONSTRAINT angajati_prenume NOT NULL,
    email VARCHAR2(50) CONSTRAINT angajati_email NOT NULL,
    nr_telefon VARCHAR2(15),
    data_angajare DATE CONSTRAINT angajati_data_angajare NOT NULL,
    salariu NUMBER(8, 0) DEFAULT 0,
    id_job NUMBER(8, 0) CONSTRAINT anajati_id_job_nn NOT NULL,
    id_manager NUMBER(8, 0),
    id_depozit NUMBER(8, 0),
    id_magazin NUMBER(8, 0),
    CONSTRAINT FK_ANGAJATI_DEPARTAMENTE FOREIGN KEY (id_departament) REFERENCES DEPARTAMENTE(id_departament),
    CONSTRAINT FK_ANGAJATI_JOBURI FOREIGN KEY (id_job) REFERENCES JOBURI(id_job),
    CONSTRAINT FK_ANGAJATI_MANAGERI FOREIGN KEY (id_manager) REFERENCES ANGAJATI(id_angajat),
    CONSTRAINT FK_ANGAJATI_DEPOZITE FOREIGN KEY (id_depozit) REFERENCES DEPOZITE(id_depozit),
    CONSTRAINT FK_ANGAJATI_MAGAZINE FOREIGN KEY (id_magazin) REFERENCES MAGAZINE(id_magazin)
);

INSERT INTO ANGAJATI VALUES (1, 1, 'Popescu', 'Ion', 'popion@gmail.com', '0722467569', TO_DATE('2007-10-11', 'YYYY-MM-DD'), 4000, 1, NULL, 2, NULL);
INSERT INTO ANGAJATI VALUES (2, 2, 'Georgescu', 'Marcel', 'marecelgg@gmail.com', '0725467868', TO_DATE('2010-05-06', 'YYYY-MM-DD'), 3000, 2, NULL, NULL, 4);
INSERT INTO ANGAJATI VALUES (3, 3, 'Ionescu', 'Doru', 'dionescu@gmail.com', '0725367368', TO_DATE('2012-07-06', 'YYYY-MM-DD'), 2700, 3, NULL, NULL, 1);
INSERT INTO ANGAJATI VALUES (4, 4, 'Popa', 'Mircea', 'mpopa@gmail.com', '0723267368', TO_DATE('2010-08-12', 'YYYY-MM-DD'), 5000, 4, NULL, 3 ,NULL);
INSERT INTO ANGAJATI VALUES (5, 4, 'Titulescu', 'Bogdan', 'bogdantt@gmail.com', '0735464864', TO_DATE('2012-08-25', 'YYYY-MM-DD'), 4500, 5, NULL, NULL, 5);

ALTER TABLE DEPARTAMENTE
ADD CONSTRAINT FK_DEPARTAMENTE_ANGAJATI FOREIGN KEY (id_manager) REFERENCES ANGAJATI(id_angajat);

--SELECT * FROM ANGAJATI;

---------- Clienti ----------

CREATE TABLE CLIENTI
(
    id_client NUMBER(8, 0) CONSTRAINT PKEY_CLIENTI PRIMARY KEY,
    nume VARCHAR2(30) CONSTRAINT clienti_nume NOT NULL,
    prenume VARCHAR2(30) CONSTRAINT clienti_prenume NOT NULL,
    email VARCHAR2(50),
    nr_telefon VARCHAR2(15),
    adresa VARCHAR2(50)
);

INSERT INTO CLIENTI VALUES (1, 'Cristea', 'Mihai', 'mcristea@gmail.com', '0729486537', NULL);
INSERT INTO CLIENTI VALUES (2, 'Cristescu', 'Ștefan', 'stefcristescu@gmail.com', '0726484531', NULL);
INSERT INTO CLIENTI VALUES (3, 'Mircescu', 'Robert', 'rmircescu@gmail.com', '0725436532', NULL);
INSERT INTO CLIENTI VALUES (4, 'Rotaru', 'David', 'davidrt@gmail.com', '0729426232', NULL);
INSERT INTO CLIENTI VALUES (5, 'Nae', 'Cristian', 'cristinae@gmail.com', '0749446547', NULL);

--SELECT * FROM CLIENTI;

---------- Utilizatori ----------

CREATE TABLE UTILIZATORI
(
    id_utilizator NUMBER(8, 0) CONSTRAINT PKEY_UTILIZATORI PRIMARY KEY,
    id_client NUMBER(8, 0) CONSTRAINT utilizatori_id_client NOT NULL,
    nume_utilizator VARCHAR2(30) CONSTRAINT utilizatori_nume NOT NULL,
    parola VARCHAR2(30) CONSTRAINT utilizatori_parola NOT NULL,
    preferinte VARCHAR2(50),
    email VARCHAR2(50) CONSTRAINT utilizatori_email NOT NULL,
    data_creare DATE CONSTRAINT utilizatori_data_creare NOT NULL,
    CONSTRAINT FK_UTILIZATORI_CLIENTI FOREIGN KEY (id_client) REFERENCES CLIENTI(id_client)
);

INSERT INTO UTILIZATORI VALUES (1, 1, 'user1', '1234', NULL, 'user1@yahoo.com', TO_DATE('2020-06-12', 'YYYY-MM-DD'));
INSERT INTO UTILIZATORI VALUES (2, 1, 'user2', 'abcd', NULL, 'user2@yahoo.com', TO_DATE('2020-07-12', 'YYYY-MM-DD'));
INSERT INTO UTILIZATORI VALUES (3, 2, 'user3', '12', 'Dark theme', 'user3@yahoo.com', TO_DATE('2020-06-16', 'YYYY-MM-DD'));
INSERT INTO UTILIZATORI VALUES (4, 4, 'user4', '2345', 'Light theme', 'user4@yahoo.com', TO_DATE('2020-08-10', 'YYYY-MM-DD'));
INSERT INTO UTILIZATORI VALUES (5, 5, 'user5', 'xyz', NULL, 'user5@yahoo.com', TO_DATE('2020-02-17', 'YYYY-MM-DD'));

--SELECT * FROM UTILIZATORI;

---------- Accesari ----------

CREATE TABLE ACCESARI
(
    id_accesare NUMBER(8, 0) CONSTRAINT PKEY_ACCESARI PRIMARY KEY,
    data_accesare DATE CONSTRAINT accesari_data_accesare NOT NULL,
    id_utilizator NUMBER(8, 0) CONSTRAINT accesari_id_utilzator NOT NULL,
    CONSTRAINT FK_ACCESARI_UTILIZATORI FOREIGN KEY (id_utilizator) REFERENCES UTILIZATORI(id_utilizator)
);

INSERT INTO ACCESARI VALUES (1, TO_DATE('2020-04-15', 'YYYY-MM-DD'), 1);
INSERT INTO ACCESARI VALUES (2, TO_DATE('2021-05-15', 'YYYY-MM-DD'), 2);
INSERT INTO ACCESARI VALUES (3, TO_DATE('2020-06-15', 'YYYY-MM-DD'), 2);
INSERT INTO ACCESARI VALUES (4, TO_DATE('2020-08-15', 'YYYY-MM-DD'), 3);
INSERT INTO ACCESARI VALUES (5, TO_DATE('2021-09-15', 'YYYY-MM-DD'), 3);

--SELECT * FROM ACCESARI;

---------- Comenzi----------

CREATE TABLE COMENZI
(
    id_comanda NUMBER(8, 0) CONSTRAINT PKEY_COMENZI PRIMARY KEY,
    adresa_livrare VARCHAR2(50) CONSTRAINT comenzi_adresa NOT NULL,
    id_utilizator NUMBER(8, 0),
    CONSTRAINT FK_COMENZI_UTILIZATORI FOREIGN KEY (id_utilizator) REFERENCES UTILIZATORI(id_utilizator)
);

INSERT INTO COMENZI VALUES (1, 'Str. Crinului, nr. 22', NULL);
INSERT INTO COMENZI VALUES (2, 'Str. Crinului, nr. 22', NULL);
INSERT INTO COMENZI VALUES (3, 'Str. Crinului, nr. 22', NULL);
INSERT INTO COMENZI VALUES (4, 'Str. Crinului, nr. 22', NULL);
INSERT INTO COMENZI VALUES (5, 'Str. Crinului, nr. 22', NULL);
INSERT INTO COMENZI VALUES (6, 'Str. Speranței, nr. 34', NULL);
INSERT INTO COMENZI VALUES (7, 'Str. Speranței, nr. 34', NULL);
INSERT INTO COMENZI VALUES (8, 'Str. Cireșului, nr. 12', NULL);
INSERT INTO COMENZI VALUES (9, 'Str. Pinului, nr. 7', NULL);
INSERT INTO COMENZI VALUES (10, 'Str. Revoluției, nr. 3', NULL);

--SELECT * FROM COMENZI;

---------- Colete ----------

CREATE TABLE COLETE
(
    id_colet NUMBER(8, 0) CONSTRAINT PKEY_COLETE PRIMARY KEY,
    id_depozit NUMBER(8, 0) CONSTRAINT colete_id_depozit NOT NULL,
    id_comanda NUMBER(8, 0) CONSTRAINT colete_id_comanda NOT NULL,
    data_preluare DATE CONSTRAINT colete_data_preluare NOT NULL,
    data_livrare DATE,
    greutate NUMBER(4, 0),
    volum NUMBER(4, 0),
    CONSTRAINT FK_COLETE_DEPOZITE FOREIGN KEY (id_depozit) REFERENCES DEPOZITE(id_depozit),
    CONSTRAINT FK_COLETE_COMENZI FOREIGN KEY (id_comanda) REFERENCES COMENZI(id_comanda)
);

-- Secvență

CREATE SEQUENCE SECV_COLETE
INCREMENT BY 1
START WITH 1
NOCYCLE
ORDER;

INSERT INTO COLETE VALUES (SECV_COLETE.nextval, 1, 2, TO_DATE('2020-06-05', 'YYYY-MM-DD'), NULL, 2, 1);
INSERT INTO COLETE VALUES (SECV_COLETE.nextval, 2, 5, TO_DATE('2020-03-05', 'YYYY-MM-DD'), NULL, 10, 5);
INSERT INTO COLETE VALUES (SECV_COLETE.nextval, 1, 4, TO_DATE('2020-06-03', 'YYYY-MM-DD'), NULL, 2, 1);
INSERT INTO COLETE VALUES (SECV_COLETE.nextval, 3, 10, TO_DATE('2021-06-17', 'YYYY-MM-DD'), NULL, 4, 3);
INSERT INTO COLETE VALUES (SECV_COLETE.nextval, 4, 3, TO_DATE('2019-04-02', 'YYYY-MM-DD'), NULL, 5, 1);

--SELECT * FROM COLETE;

---------- Comanda_Magazin ----------

CREATE TABLE COMANDA_MAGAZIN
(
    id_magazin NUMBER(8, 0),
    id_client NUMBER(8, 0),
    id_comanda NUMBER(8, 0),
    CONSTRAINT PK_COMANDA_MAGAZIN PRIMARY KEY (id_magazin, id_client, id_comanda),
    CONSTRAINT FK_COMANDA_MAGAZIN_MAGAZINE FOREIGN KEY (id_magazin) REFERENCES MAGAZINE(id_magazin),
    CONSTRAINT FK_COMANDA_MAGAZIN_CLIENTI FOREIGN KEY (id_client) REFERENCES CLIENTI(id_client),
    CONSTRAINT FK_COMANDA_MAGAZIN_COMENZI FOREIGN KEY (id_comanda) REFERENCES COMENZI(id_comanda)
);

INSERT INTO COMANDA_MAGAZIN VALUES (1, 2, 1);
INSERT INTO COMANDA_MAGAZIN VALUES (1, 2, 2);
INSERT INTO COMANDA_MAGAZIN VALUES (2, 1, 3);
INSERT INTO COMANDA_MAGAZIN VALUES (2, 2, 4);
INSERT INTO COMANDA_MAGAZIN VALUES (2, 3, 5);
INSERT INTO COMANDA_MAGAZIN VALUES (3, 4, 6);
INSERT INTO COMANDA_MAGAZIN VALUES (3, 3, 7);
INSERT INTO COMANDA_MAGAZIN VALUES (4, 4, 8);
INSERT INTO COMANDA_MAGAZIN VALUES (5, 4, 9);
INSERT INTO COMANDA_MAGAZIN VALUES (5, 5, 10);

--SELECT * FROM COMANDA_MAGAZIN;

---------- Produse ----------

CREATE TABLE PRODUSE
(
    id_produs NUMBER(8, 0) CONSTRAINT PK_PRODUSE PRIMARY KEY,
    ambalaj VARCHAR2(50),
    pret NUMBER(8, 0) CONSTRAINT produse_pret NOT NULL,
    dimensiune VARCHAR2(50),
    greutate NUMBER(8, 0),
    descriere VARCHAR2(50)
);

CREATE SEQUENCE SECV_PRODUSE
INCREMENT BY 1
START WITH 1
NOCYCLE
ORDER;

INSERT INTO PRODUSE VALUES (SECV_PRODUSE.nextval, 'plastic', 75, '18 cm x 12 cm x 2 cm', 50, 'Husa telefon');
INSERT INTO PRODUSE VALUES (SECV_PRODUSE.nextval, 'carton', 450, '21 cm x 5 cm x 1 cm', 250, 'Smartwatch');
INSERT INTO PRODUSE VALUES (SECV_PRODUSE.nextval, 'plastic', 1800, '18 cm x 12 cm x 2 cm', 450, 'Smartphone');
INSERT INTO PRODUSE VALUES (SECV_PRODUSE.nextval, 'silicon', 5000, '30 cm x 20 cm x 5 cm', 1800, 'Ultrabook');
INSERT INTO PRODUSE VALUES (SECV_PRODUSE.nextval, 'plastic', 25, '200 cm x 500 mm x 500 mm', 30, 'Cablu USB-C');

--SELECT * FROM PRODUSE;

---------- Cantitati ----------

CREATE TABLE CANTITATI
(
    id_comanda NUMBER(8, 0),
    id_produs NUMBER(8, 0),
    cantitate NUMBER(4, 0) DEFAULT 1,
    CONSTRAINT PK_CANTITATI PRIMARY KEY (id_comanda, id_produs),
    CONSTRAINT FK_CANTITATI_COMENZI FOREIGN KEY (id_comanda) REFERENCES COMENZI(id_comanda),
    CONSTRAINT FK_CANTITATI_PRODUSE FOREIGN KEY (id_produs) REFERENCES PRODUSE(id_produs)
);

INSERT INTO CANTITATI VALUES (1, 1, 2);
INSERT INTO CANTITATI VALUES (1, 2, 3);
INSERT INTO CANTITATI VALUES (1, 4, 5);
INSERT INTO CANTITATI VALUES (2, 1, 1);
INSERT INTO CANTITATI VALUES (2, 3, 1);
INSERT INTO CANTITATI VALUES (3, 3, 3);
INSERT INTO CANTITATI VALUES (4, 5, 2);
INSERT INTO CANTITATI VALUES (5, 1, 4);
INSERT INTO CANTITATI VALUES (4, 4, 3);
INSERT INTO CANTITATI VALUES (5, 2, 1);

--SELECT * FROM CANTITATI;

---------- Reviews ----------

CREATE TABLE REVIEWS
(
    id_review NUMBER(8, 0) CONSTRAINT PK_REVIEWS PRIMARY KEY,
    descriere VARCHAR2(50),
    rating NUMBER(2, 0) CONSTRAINT review_rating_nn NOT NULL,
    CONSTRAINT reviews_rating CHECK (rating > 0 AND rating < 11)
);

INSERT INTO REVIEWS VALUES (1, 'Un produs bun!', 9);
INSERT INTO REVIEWS VALUES (2, NULL, 5);
INSERT INTO REVIEWS VALUES (3, 'Excelent!', 10);
INSERT INTO REVIEWS VALUES (4, 'Raport calitate preț satisfăcător', 6);
INSERT INTO REVIEWS VALUES (5, 'Calitate îndoielnică!', 2);

--SELECT * FROM REVIEWS;

---------- Review_Produs ----------

CREATE TABLE REVIEW_PRODUS
(
    id_produs NUMBER(8, 0),
    id_client NUMBER(8, 0),
    id_review NUMBER(8, 0),
    CONSTRAINT PK_REVIEW_PRODUS PRIMARY KEY (id_produs, id_client, id_review),
    CONSTRAINT FK_REVIEW_PRODUS_PRODUSE FOREIGN KEY (id_produs) REFERENCES PRODUSE(id_produs),
    CONSTRAINT FK_REVIEW_PRODUS_CLIENTI FOREIGN KEY (id_client) REFERENCES CLIENTI(id_client),
    CONSTRAINT FK_REVIEW_PRODUS_REVIEWS FOREIGN KEY (id_review) REFERENCES REVIEWS(id_review)
);

INSERT INTO REVIEW_PRODUS VALUES (1, 2, 3);
INSERT INTO REVIEW_PRODUS VALUES (1, 1, 4);
INSERT INTO REVIEW_PRODUS VALUES (2, 4, 1);
INSERT INTO REVIEW_PRODUS VALUES (2, 5, 3);
INSERT INTO REVIEW_PRODUS VALUES (3, 1, 2);
INSERT INTO REVIEW_PRODUS VALUES (3, 3, 1);
INSERT INTO REVIEW_PRODUS VALUES (4, 4, 2);
INSERT INTO REVIEW_PRODUS VALUES (4, 5, 1);
INSERT INTO REVIEW_PRODUS VALUES (5, 2, 1);
INSERT INTO REVIEW_PRODUS VALUES (5, 3, 3);

--SELECT * FROM REVIEW_PRODUS;

COMMIT
