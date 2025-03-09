CREATE DATABASE opm202403;
--/Users/tiangeng/Public/data/opm_mar2024
/*TABLES*/
/*1*/
CREATE TABLE fact(
	AGYSUB VARCHAR(4),
	LOC CHAR(2),
	AGELVL VARCHAR(1),
	EDLVL VARCHAR(2),
	GSEGRD VARCHAR(2),
	LOSLVL VARCHAR(1),
	OCC VARCHAR(4),
	PATCO VARCHAR(1),
	PP VARCHAR(2),
	PPGRD VARCHAR(5),
	SALLVL VARCHAR(2),
	STEMOCC VARCHAR(4),
	SUPERVIS VARCHAR(1),
	TOA VARCHAR(2),
	WORKSCH VARCHAR(1),
	WORKSTAT VARCHAR(1),
	DATECODE VARCHAR(6),
	EMPLOYMENT VARCHAR(1),
	SALARY NUMERIC(8,1),
	LOS NUMERIC(3,1)
);
/*add data from local file*/
COPY fact FROM '/Users/tiangeng/Public/data/opm_mar2024/FACTDATA_MAR2024.TXT'
WITH (FORMAT CSV, HEADER);
/*EXPLORE TABLE*/
SELECT * FROM fact LIMIT 10;
SELECT COUNT(*) FROM fact;
/*2*/
CREATE TABLE agency(
	agytyp CHAR(1),
	agytypt VARCHAR(52),
	agy VARCHAR(2),
	agyt VARCHAR(78),
	agysub VARCHAR(4),
	agysubt VARCHAR(91)
);
COPY agency FROM '/Users/tiangeng/Public/data/opm_mar2024/DTagy.txt'
WITH (FORMAT CSV, HEADER);

SELECT * FROM agency LIMIT 10;
SELECT COUNT(*) FROM agency;
/*3*/
CREATE TABLE locat(
	loctyp CHAR(1),
	loctypt VARCHAR(17),
	loc CHAR(2),
	loct VARCHAR(36)
);
COPY locat FROM '/Users/tiangeng/Public/data/opm_mar2024/DTloc.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM locat LIMIT 10;
/*4*/
CREATE TABLE age(
	agelvl CHAR(1),
	agelvlt VARCHAR(12)
);
COPY age FROM '/Users/tiangeng/Public/data/opm_mar2024/DTagelvl.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM age LIMIT 10;
/*5*/
CREATE TABLE education(
	edlvltyp VARCHAR(2),
	edlvltypt VARCHAR(27),
	edlvl VARCHAR(3),
	edlvlt VARCHAR(83)
);
COPY education FROM '/Users/tiangeng/Public/data/opm_mar2024/DTedlvl.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM education LIMIT 10;
/*6*/
CREATE TABLE occupation(
	occtyp CHAR(1),
	occtypt VARCHAR(12),
	occfam CHAR(2),
	occfamt VARCHAR(50),
	occ CHAR(4),
	occt VARCHAR(100)
);
COPY occupation FROM '/Users/tiangeng/Public/data/opm_mar2024/DTocc.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM occupation LIMIT 10;
/*7*/
CREATE TABLE occucat(
	patco CHAR(1),
	patcot VARCHAR(20)
);
COPY occucat FROM '/Users/tiangeng/Public/data/opm_mar2024/DTpatco.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM occucat LIMIT 10;
/*8*/
CREATE TABLE stem(
	stemagg CHAR(1),
	stemaggt VARCHAR(25),
	stemtyp VARCHAR(2), /* length = 1 is enough, need further work*/
	stemtypt VARCHAR(25),
	stemocc CHAR(4),
	stemocct VARCHAR(100)
);
COPY stem FROM '/Users/tiangeng/Public/data/opm_mar2024/DTstemocc.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM stem LIMIT 10;
SELECT DISTINCT stemtyp FROM stem;
/*9*/
CREATE TABLE supervisor(
	supertyp CHAR(1),
	supertypt VARCHAR(15),
	supervis CHAR(1),
	supervist VARCHAR(30)
);
COPY supervisor FROM '/Users/tiangeng/Public/data/opm_mar2024/DTsuper.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM supervisor LIMIT 10;
/*10*/
CREATE TABLE appointment(
	toatyp CHAR(1),
	toatypt VARCHAR(15),
	toa CHAR(2),
	toat VARCHAR(50)
);
COPY appointment FROM '/Users/tiangeng/Public/data/opm_mar2024/DTtoa.txt'
WITH (FORMAT CSV, HEADER);
SELECT * FROM appointment LIMIT 10;