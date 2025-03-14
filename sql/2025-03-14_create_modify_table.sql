/* median length of service by agency*/
SELECT AGYSUB, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY LOS) AS median_los FROM FACT GROUP BY AGYSUB;

/* agency headcount with median length of service*/
DROP TABLE IF EXISTS agency_headcount_median_los_sep2024;
CREATE TABLE agency_headcount_median_los_sep2024 AS
SELECT AGYSUBT, TRIM(AGYSUB) AS AGYSUB, COUNT(*) AS "count", T2.MEDIAN_LOS
FROM FACT
INNER JOIN AGENCY USING(AGYSUB)
INNER JOIN 
(SELECT AGYSUB, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY LOS) AS median_los 
FROM FACT GROUP BY AGYSUB) AS T2 USING(AGYSUB)
GROUP BY AGYSUBT, AGYSUB, T2.MEDIAN_LOS
ORDER BY AGYSUB;

START TRANSACTION;
ALTER TABLE agency_headcount_median_los_sep2024 ADD COLUMN time DATE;
UPDATE agency_headcount_median_los_sep2024 SET time = '2024-09-01';
COMMIT;
--ROLLBACK;

COPY agency_headcount_median_los_sep2024 TO
'/Users/tiangeng/Public/data/agency_headcount_median_los_sep2024.csv'
DELIMITER ',' CSV HEADER;

