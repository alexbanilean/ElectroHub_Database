--------------------------------------- Exerciții ---------------------------------------

-----------------------------------------------------------------------------------------
-- 1. Formulați în limbaj natural și implementați 5 cereri SQL complexe ce vor utiliza, în 
--    ansamblul lor, următoarele elemente: 
--    • operație join pe cel puțin 4 tabele
--    • filtrare la nivel de linii
--    • subcereri sincronizate în care intervin cel puțin 3 tabele
--    • subcereri nesincronizate în care intervin cel puțin 3 tabele
--    • grupări de date, funcții grup, filtrare la nivel de grupuri
--    • ordonări
--    • utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, a 
--      funcțiilor NVL și DECODE, a cel puțin unei expresii CASE
--    • utilizarea a cel puțin 1 bloc de cerere (clauza WITH)

-- 1. Să se afișeze toate comenzile primite de magazinul la care lucrează angajatul Ionescu Doru.

SELECT cm.id_client, c.id_comanda, c.adresa_livrare
FROM comenzi c
JOIN comanda_magazin cm ON c.id_comanda = cm.id_comanda
JOIN magazine m ON cm.id_magazin = m.id_magazin
WHERE m.id_magazin = 
(
    SELECT id_magazin
    FROM angajati a
    WHERE LOWER(a.nume) LIKE '%ionescu%' AND TRIM(BOTH ' ' FROM UPPER(a.prenume)) = 'DORU'
)
ORDER BY c.id_comanda;

-- 2. Să se afișeze pentru fiecare angajat ce a fost angajat în urmă cu minim 12 ani salariul, data angajării, numele și id-ul managerului, dacă există. 

SELECT a.nume || ' ' || a.prenume AS "Nume angajat", TO_CHAR(a.data_angajare, 'DD-MM-YY') AS "Data angajare",
       DECODE(a.id_manager, NULL, 'Nu are manager', 'Are manager') AS "Manager", a.salariu AS "Salariu"       
FROM angajati a
JOIN joburi j ON a.id_job = j.id_job
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM a.data_angajare) >= 12;

-- 3. Să se afișeze pentru fiecare client media suprafeței depozitelor la care au ajuns coletele din comenzile sale, unde această medie trebuie să fie mai mare de 2000.         
WITH clienti_orase AS
(
    SELECT c.id_client, c.nume, c.prenume, d.capacitate, d.suprafata
    FROM clienti c
    JOIN comanda_magazin cm ON cm.id_client = c.id_client
    JOIN comenzi cz ON cz.id_comanda = cm.id_comanda
    JOIN colete cl ON cl.id_comanda = cz.id_comanda
    JOIN depozite d ON d.id_depozit = cl.id_depozit
)
SELECT id_client , nume, prenume, AVG(suprafata) AS "MEDIE"
FROM clienti_orase 
GROUP BY id_client, nume, prenume
HAVING AVG(suprafata) >= 2000
ORDER BY AVG(suprafata) DESC;

-- 4. Să se afișeze pentru fiecare angajat care lucrează la un departament din București dacă acesta are manager.

SELECT id_angajat, nume || ' ' || prenume AS "Nume", CASE(NVL(id_manager, -1)) WHEN -1 THEN 'Nu are manager' ELSE 'Are manager' END AS "Manager"
FROM angajati
WHERE id_angajat IN (
                      SELECT id_angajat
                      FROM angajati a
                      JOIN departamente d ON a.id_departament = d.id_departament
                      JOIN locatii l ON l.id_locatie = d.id_locatie
                      JOIN orase o ON o.id_oras = l.id_oras
                      WHERE LOWER(nume_oras) = 'bucurești'
                    );

-- 5. Afișați joburile a căror valoare a salariului minim estimată este respectată. 

SELECT id_job, nume_job
FROM joburi
WHERE salariu_minim < ALL (
                            SELECT salariu
                            FROM angajati a
                            JOIN magazine m ON a.id_magazin = m.id_magazin
                            JOIN locatii l ON l.id_locatie = m.id_locatie
                            WHERE a.id_job = id_job
                          );

-----------------------------------------------------------------------------------------

-- 2. Implementarea a 3 operații de actualizare sau suprimare a datelor utilizând subcereri.

-- Să se scadă salariul cu un procent de 20% angajaților ce lucrează la magazinele cu număr minim de comenzi.

UPDATE angajati
SET salariu = salariu * 0.8
WHERE id_magazin IN (
                        SELECT cm.id_magazin
                        FROM comanda_magazin cm
                        GROUP BY cm.id_magazin
                        HAVING COUNT(cm.id_comanda) = (
                                                        SELECT MIN(COUNT(id_comanda))
                                                        FROM comanda_magazin
                                                        GROUP BY id_magazin
                                                      )
                    );

-- Să se dubleze prețul produselor ce au o medie a rating-ului mai mare de 7 și au o greutate mai mică de 1 kg.

UPDATE produse
SET pret = 2 * pret
WHERE id_produs IN (
                        SELECT p.id_produs
                        FROM produse p
                        JOIN review_produs rp ON rp.id_produs = p.id_produs
                        JOIN reviews r ON rp.id_review = r.id_review
                        WHERE p.greutate < 1000
                        GROUP BY p.id_produs
                        HAVING AVG(r.rating) > 7
                    );
      
-- Să se șteargă utilizatorii ce nu au avut nicio accesare.

DELETE FROM utilizatori
WHERE id_utilizator NOT IN (
                                SELECT DISTINCT id_utilizator
                                FROM accesari
                            );
                            
COMMIT                            
          
-----------------------------------------------------------------------------------------
                            
-- 3. Crearea unei vizualizări compuse. Dați un exemplu de operație LMD permisă pe vizualizarea respectivă și un exemplu de operație LMD nepermisă.

-- Vizualizare care conține date despre clienții ce au făcut minim 2 comenzi fizice(la un magazin, nu online).

CREATE OR REPLACE VIEW vizualizare_clienti_produse
AS
SELECT id_client, nume || ' ' || prenume AS "Nume client", nr_telefon, id_comanda, adresa_livrare 
FROM clienti c
JOIN comanda_magazin cm USING (id_client)
JOIN comenzi cz USING (id_comanda)
WHERE id_client IN (
                            SELECT id_client
                            FROM comanda_magazin
                            GROUP BY id_client
                            HAVING COUNT(*) > 1
                        );
                        
UPDATE vizualizare_clienti_produse SET "Nume client" = 'Cristian' WHERE id_client = 1; -- nepermisă, update pe coloana virtuală, nu e updatable

DELETE FROM vizualizare_clienti_produse WHERE id_client = 3; -- permisă, șterge două linii din comanda_magazin, nu și din comenzi deoarece ON DELETE CASCADE nu e activat

COMMIT

-----------------------------------------------------------------------------------------

-- 4.  Crearea unui index care să optimizeze o cerere de tip căutare cu 2 criterii. Specificați cererea.

CREATE INDEX idx_email_angajat ON angajati(email);

-- Să se afișeze email-urile angajaților ce conțin litera 'n' și au fost angajați înainte de 15 martie 2015.

SELECT id_angajat, email, data_angajare
FROM angajati
WHERE LOWER(email) LIKE '%n%' AND data_angajare < TO_DATE('2015-03-15', 'YYYY-MM-DD');

COMMIT

-----------------------------------------------------------------------------------------

-- 5. Formulați în limbaj natural și implementați în SQL: o cerere ce utilizează operația outerjoin pe minimum 4 tabele și două cereri ce utilizează operația division.

-- Să se afișeze pentru fiecare client orașele în care se află magazinele la care a făcut minim o comandă.

SELECT c.id_client, c.nume || ' ' || c.prenume AS "Nume client", o.nume_oras 
FROM clienti c
LEFT OUTER JOIN comanda_magazin cm ON c.id_client = cm.id_client
LEFT OUTER JOIN magazine m ON cm.id_magazin = m.id_magazin 
LEFT OUTER JOIN locatii l ON m.id_locatie = l.id_locatie
LEFT OUTER JOIN orase o ON l.id_oras = o.id_oras;

-- Să se afișeze toți angajații al căror departament se află la o locație cu cel mult o clădire.

SELECT a.id_angajat, a.nume || ' ' || a.prenume AS "Nume"
FROM angajati a
WHERE NOT EXISTS
(
    SELECT 1
    FROM locatii l
    WHERE l.nr_cladiri > 2 AND NOT EXISTS
    (
        SELECT 'c'
        FROM departamente d
        WHERE d.id_locatie = l.id_locatie AND d.id_departament = a.id_departament
    )
);

-- Să se afișeze toți clienții care au dat cel mult o comandă.

SELECT c.id_client, c.nume || ' ' || c.prenume AS "Nume"
FROM clienti c
WHERE NOT EXISTS
(
    SELECT 'x'
    FROM comenzi cz
    WHERE 
    (SELECT COUNT(*) 
     FROM comanda_magazin cm1
     WHERE cm1.id_client = c.id_client
    ) > 1 
    AND
    NOT EXISTS
    (
        SELECT 'y'
        FROM comanda_magazin cm
        WHERE cm.id_client = c.id_client AND cm.id_comanda = cz.id_comanda
    )
);

-----------------------------------------------------------------------------------------

-- 6. Să se afișeze numele angajaților ce lucrează la departamentul ce se află la locația cu id-ul 4 și au salariul strict mai mare de 3500 RON.

-- varianta inițială
SELECT a.id_angajat, a.nume, a.prenume
FROM angajati a
JOIN departamente d ON d.id_departament = a.id_departament
WHERE a.salariu > 3500 AND d.id_locatie = 3;

-- Expresia algebrică:
-- R1 = JOIN(angajati, departamente)
-- R2 = SELECT(R1, salariu > 3500)
-- R3 = SELECT(R2, id_locatie = 3)
-- REZULTAT = R4 = PROJECT(R3, id_angajat, nume, prenume)

-- varianta optimizată

SELECT t1.id_angajat, t1.nume, t1.prenume
FROM
(
    SELECT id_angajat, nume, prenume, id_departament
    FROM angajati
    WHERE salariu > 3500
) t1
JOIN
(
    SELECT id_departament
    FROM departamente
    WHERE id_locatie = 3
) t2 ON (t1.id_departament = t2.id_departament);

-- Expresia algebrică:
-- R1 = SELECT(angajati, salariu > 3500)
-- R2 = PROJECT(R1, id_angajat, nume, prenume, id_departament)
-- R3 = SELECT(departamente, id_locatie = 3)
-- R4 = PROJECT(R3, id_departament)
-- REZULTAT = R5 = JOIN(R2, R4)
