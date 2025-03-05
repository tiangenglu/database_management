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
	ROUND(
		CAST(COUNT(OCC) AS NUMERIC) / (
			SELECT
				COUNT(*)
			FROM
				FACT),4) AS PROP
FROM
	FACTGROUP BY OCC
ORDER BY
	PROP DESC;

	