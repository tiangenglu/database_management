/* Head count and % by tenure group in cm63 MD HQ */
CREATE TABLE cm63_hq_mar2024_toa AS
SELECT TOAT AS "tenure-type", COUNT(TOA) AS HEADCOUNT,
ROUND(100*CAST(COUNT(TOA) AS NUMERIC)/(SELECT COUNT(*) FROM FACT WHERE AGYSUB = 'CM63' AND loc = '24'),2) AS PCT
FROM FACT
JOIN APPOINTMENT USING(TOA)
WHERE AGYSUB = 'CM63' AND loc = '24'
GROUP BY TOAT
ORDER BY TOAT, HEADCOUNT;
/*Add column*/
ALTER TABLE cm63_hq_mar2024_toa ADD COLUMN time DATE;
/*set column value*/
UPDATE cm63_hq_mar2024_toa SET time = '2024-03-01';
/*export*/
COPY cm63_hq_mar2024_toa TO '/Users/tiangeng/Public/data/cm63_hq_mar2024_toa.csv'
DELIMITER ',' CSV HEADER;