/*Count frequency of the 1500s (maths & stats)*/
SELECT
	OCC,
	COUNT(OCC) AS OCC_COUNT
FROM
	FACT
WHERE
	OCC BETWEEN '1500' AND '1600'
GROUP BY
	OCC
ORDER BY
	OCC_COUNT DESC;
/*Count frequency of occupations joined with occupation labels*/
SELECT
	OCC,
	OCCT,
	OCC_COUNT
FROM
	OCCUPATION O
	INNER JOIN (
		SELECT
			OCC,
			COUNT(OCC) AS OCC_COUNT
		FROM
			FACT
		GROUP BY
			OCC
		ORDER BY
			OCC_COUNT DESC
	) AS F USING (OCC);

/*Count frequency of occupation categories*/
SELECT
	O.PATCO,
	PATCOT,
	OCC
FROM
	OCCUCAT O
	JOIN (
		SELECT DISTINCT
			OCC,
			PATCO
		FROM
			FACT
	) AS OCC_CAT ON O.PATCO = OCC_CAT.PATCO;

/*Ordered occupation counts with descriptions and broader occupation categories*/
SELECT
	PATCO,
	PATCOT,
	OCC,
	OCCT,
	OCC_COUNT
FROM
	OCCUPATION T1
	JOIN (
		SELECT
			OCC,
			COUNT(OCC) AS OCC_COUNT
		FROM
			FACT
		GROUP BY
			OCC
		ORDER BY
			OCC_COUNT DESC
	) AS T2 USING (OCC)
	JOIN (
		SELECT
			T3.PATCO,
			PATCOT,
			OCC
		FROM
			OCCUCAT T3
			JOIN (
				SELECT DISTINCT
					OCC,
					PATCO
				FROM
					FACT
			) AS T4 ON T3.PATCO = T4.PATCO
	) USING (OCC)
ORDER BY
	OCC_COUNT DESC;

/*show pct, cast the numerator to numeric from bigint*/
SELECT
	OCC,
	COUNT(OCC) AS OCC_COUNT,
	ROUND(CAST(COUNT(OCC) AS NUMERIC) / (SELECT COUNT(*)FROM FACT),4) AS PROP
FROM
	FACT GROUP BY OCC
ORDER BY
	PROP DESC;

/* What are the distribution patterns of occupations? (count of job series by agency) */
CREATE TABLE occ_count_by_agency AS
SELECT OCC, COUNT(OCC) AS ct, agysub FROM fact GROUP BY OCC, agysub ORDER BY ct DESC;

/* Which are the job series that BLS hires? */
SELECT * FROM occ_count_by_agency WHERE agysub = 'DLLS';
/* Which are the job series that BEA hires? */
SELECT * FROM occ_count_by_agency WHERE agysub = 'CM53';

/* all patent examining headcounts were in PTO*/
SELECT OCCT, CT, AGYSUBT FROM occ_count_by_agency 
JOIN occupation USING(OCC)
JOIN agency USING(agysub)
WHERE occ = '1224' ;

/* What's the distribution of Data Scientists? */
/* all patent examining headcounts were in PTO*/
SELECT OCCT, CT, AGYSUBT FROM occ_count_by_agency 
JOIN occupation USING(OCC)
JOIN agency USING(agysub)
WHERE occ = '1560' ;

/*bonus code with partition by*/
SELECT * FROM 
(SELECT OCC, AGYSUB, TOA, ROW_NUMBER() OVER 
(PARTITION BY AGYSUB ORDER BY TOA) 
AS row_num FROM FACT) WHERE row_num = 1;

/* by type of appointment and occupation*/
SELECT OCCT, TOAT, COUNT(TOAT) AS headcount FROM FACT
JOIN OCCUPATION USING(OCC)
JOIN APPOINTMENT USING(TOA)
GROUP BY OCCT, TOAT
ORDER BY headcount DESC;