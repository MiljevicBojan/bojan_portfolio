#US Household Income Data Cleaning 

#ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`; 

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

SELECT COUNT(id)
FROM us_project.us_household_income;

#DUPLICATE REMOVAL

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_project.us_household_income
) AS Row_Table
WHERE row_num > 1
;


DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_project.us_household_income
		) AS Row_Table
	WHERE row_num > 1
);

#We do not have any duplicates in this table :) 
SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;


SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;


SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY 1
;

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND Place = ''
AND City = 'Vinemont'
;




SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
AND (AWater = 0 OR AWater = '' OR AWater IS NULL)
;




##############EXPLORATORY DATA ANALYSIS


SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;


SELECT *
FROM us_project.us_household_income u
RIGHT JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE i.id IS NULL                                       #some records did not come in from us_project.us_household_income
;



SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;


SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;


SELECT Type,COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
;

SELECT * 
FROM us_household_income
WHERE Type = 'Community'                      #this is Puerto Rico
;

SELECT u.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean), 1) DESC
;






































