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
