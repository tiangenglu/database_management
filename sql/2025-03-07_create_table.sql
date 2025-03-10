/* Head count and % by tenure group in cm63 MD HQ */
DROP TABLE IF EXISTS cm63_hq_sep2024_toa;
CREATE TABLE cm63_hq_sep2024_toa AS
SELECT TOATYPT AS "tenure-type",TOAT AS "tenure", COUNT(TOA) AS headcount,
ROUND(100*CAST(COUNT(TOA) AS NUMERIC)/(SELECT COUNT(*) FROM FACT WHERE AGYSUB = 'CM63' AND loc = '24'),2) AS PCT
FROM FACT
JOIN APPOINTMENT USING(TOA)
WHERE AGYSUB = 'CM63' AND loc = '24'
GROUP BY TOATYPT,TOAT
ORDER BY TOATYPT DESC,TOAT, HEADCOUNT;
/*Add column*/
ALTER TABLE cm63_hq_sep2024_toa ADD COLUMN time DATE;
/*set column value*/
UPDATE cm63_hq_sep2024_toa SET time = '2024-09-01';
/*export*/
COPY cm63_hq_sep2024_toa TO '/Users/tiangeng/Public/data/cm63_hq_sep2024_toa.csv'
DELIMITER ',' CSV HEADER;

/* Commerce subcomponents from the headcout table, not case sensitive search using ilike */
SELECT * FROM agency_headcount_sep2024 WHERE agysub ILIKE 'CM%';

/* Commerce total headcount*/
SELECT SUM(HEADCOUNT) AS TOTAL FROM agency_headcount_sep2024 WHERE agysub ILIKE 'CM__';

/* Employee by State*/
DROP TABLE IF EXISTS geo_distribution;
CREATE TABLE geo_distribution AS
SELECT LOCTYPT,LOCT, LOC FROM FACT JOIN LOCAT USING(LOC);

SELECT * FROM geo_distribution LIMIT 10;

/* 97.7% in the United States (excluding U.S. Territories) */
SELECT LOCTYPT, COUNT(LOCTYPT), 
ROUND(100*CAST(COUNT(LOCTYPT) AS NUMERIC) / (SELECT COUNT(*) FROM geo_distribution),4) AS "percent"
FROM geo_distribution GROUP BY LOCTYPT ORDER BY "percent" DESC;

/* Distribution by states, including "US-SUPPRESSED"*/
/*
https://www.fedscope.opm.gov/datadefn/
For security purposes, FedScope does not provide detailed location information for the:

-Federal Bureau of Investigation (Justice Department)
-Drug Enforcement Agency (Justice Department)
-Bureau of Alcohol, Tobacco, and Firearms (Treasury/Treasury and Justice Department beginning in 2003)
-Secret Service (Treasury/Homeland Security Department beginning in 2003); or
-Bureau of the Mint (Treasury Department)
Employees of these agencies that work in the Washington,
DC-MD-VA-WV Metropolitan Statistical Area (see Metropolitan Statistical Area), 
which includes parts of Maryland, Virginia, and West Virginia, 
are all reported as working in the District of Columbia (under the United States category).  
Other employees are reported as "Suppressed" (a separate value under the United States category).  
As a result, FedScope overstates employment for the District of Columbia 
and understates employment for all states, territories, and foreign countries.
*/

/* both work fine as long as they are in SINGLE quotation marks */
SELECT * FROM geo_distribution WHERE LOCTYPT IN ('United States');
SELECT * FROM geo_distribution WHERE LOCTYPT ILIKE 'United States';

/* headcount by U.S. states, excluding foreign countries and U.S. territories*/
DROP TABLE IF EXISTS state_distribution;
CREATE TABLE state_distribution AS
SELECT LOCT, COUNT(LOCT),
ROUND(100*CAST(COUNT(LOCT) AS NUMERIC) / (SELECT COUNT(*) FROM geo_distribution), 4) AS "percent"
FROM (SELECT * FROM geo_distribution WHERE LOCTYPT = 'United States')
GROUP BY LOCT ORDER BY LOCT;

START TRANSACTION;
ALTER TABLE state_distribution ADD COLUMN "state" VARCHAR(100);
UPDATE state_distribution SET "state" =  ltrim(split_part(LOCT,'-',2));
COMMIT;
--ROLLBACK;
COPY
(SELECT "state","count","percent" FROM state_distribution)
TO '/Users/tiangeng/Public/data/state_distribution_sep2024.csv'
DELIMITER ',' CSV HEADER;

