######################Practice Final Project1 (Module 4)########################

-- Find the total milk production for the year 2023. -> 91812000000

SELECT SUM(Value) 
FROM milk_production  
WHERE year=2023; 

-- Show coffee production data for the year 2015. What is the total value? -> 6600000

SELECT SUM(value) 
FROM coffee_production  
WHERE year=2015; 

-- Find the average honey production for the year 2022. -> 3133275

SELECT AVG(value) 
FROM honey_production 
where year=2022; 

-- the state names with their corresponding ANSI codes from the state_lookup table.
-- What number is Iowa? -> 19

SELECT state_ANSI, state
FROM state_lookup 

SELECT state_ANSI 
FROM state_lookup   
WHERE state='IOWA'; 

-- Find the highest yogurt production value for the year 2022. -> 793256000

SELECT MAX(value) 
FROM yogurt_production 
WHERE year=2022;

-- Find states where both honey and milk were produced in 2022.
-- Did State_ANSI "35" produce both honey and milk in 2022? > NO

SELECT  m.State_ANSI, s.state
FROM (honey_production AS h INNER JOIN milk_production AS m
ON h.State_ANSI = m.State_ANSI ) INNER JOIN state_lookup AS s 
ON m.state_ANSI = s.state_ANSI
WHERE (h.year=2022 AND m.year=2022);

SELECT  m.State_ANSI, s.state
FROM (honey_production AS h INNER JOIN milk_production AS m
ON h.State_ANSI = m.State_ANSI ) INNER JOIN state_lookup AS s 
ON m.state_ANSI = s.state_ANSI
WHERE (h.year=2022 AND m.year=2022 AND m.State_ANSI =35); #NO

-- OR you can use below solution for question : Did State_ANSI "35" produce both honey and milk in 2022? 
SELECT CASE
    WHEN EXISTS (
        SELECT 1
        FROM honey_production AS h
        INNER JOIN milk_production AS m ON h.State_ANSI = m.State_ANSI
        INNER JOIN state_lookup AS s ON m.state_ANSI = s.state_ANSI
        WHERE h.year = 2022 AND m.year = 2022 AND m.State_ANSI = 35
    ) THEN '35 does exists'
    ELSE '35 does not exist'
END AS result; # 35 does not exist

-- Find the total yogurt production for states that also produced cheese in 2022. -> 1171095000

SELECT SUM(y.Value)
FROM yogurt_production y
WHERE y.Year = 2022 AND y.State_ANSI IN (
    SELECT DISTINCT c.State_ANSI 
    FROM cheese_production c 
    WHERE c.Year = 2022 
);

######################Practice Final Project2 (Module 4)########################

-- What is the total milk production for 2023?  91812000000

SELECT SUM(value) 
FROM milk_production  
WHERE year=2023; 

-- Which states had cheese production greater than 100 million in April 2023? CALIFORNIA, WISCONSIN
-- How many states are there? 2

SELECT State,State_ANSI
FROM state_lookup
WHERE State_ANSI IN 
(
	SELECT DISTINCT state_ANSI 
	FROM cheese_production  
	WHERE value > 100000000 AND Period='APR' AND year=2023
);

SELECT COUNT(DISTINCT State_ANSI)
FROM cheese_production
WHERE Value > 100000000 
  AND Period = 'APR' 
  AND Year = 2023;

-- What is the total value of coffee production for 2011? 7600000

SELECT SUM(value) 
FROM coffee_production 
WHERE year=2011

--  Find the average honey production for 2022 3133275

SELECT AVG(value) 
FROM honey_production 
WHERE year=2022 

-- list of all states names with their corresponding ANSI codes
-- What is the State_ANSI code for Florida? 12

SELECT DISTINCT state, state_ANSI 
FROM state_lookup;

SELECT DISTINCT state, state_ANSI 
FROM state_lookup 
WHERE state = 'FLORIDA' ;

-- all states with their cheese production values, even if they didn't produce any cheese in April of 2023?
-- What is the total for NEW JERSEY? 4889000

SELECT  c.value, s.state
FROM cheese_production AS c LEFT JOIN state_lookup AS s 
ON 
	c.State_ANSI = s.State_ANSI 
	AND year = 2023 
	AND Period = 'APR';

SELECT SUM(c.value)
FROM cheese_production c JOIN state_lookup s
ON c.State_ANSI = s.State_ANSI 
WHERE s.state = 'NEW JERSEY' AND year = 2023 AND Period = 'APR';

-- the total yogurt production for states in the year 2022 which also have cheese production data from 2023?
# 1171095000

SELECT SUM(y.Value)
FROM yogurt_production y
WHERE y.Year = 2022 AND y.State_ANSI IN (
    SELECT DISTINCT c.State_ANSI FROM cheese_production c WHERE c.Year = 2023 #1171095000
);

-- List all states from state_lookup that are missing from milk_production in 2023.
-- How many states are there? ۲۶

SELECT s.state
FROM state_lookup s
LEFT JOIN milk_production m 
ON s.State_ANSI = m.State_ANSI AND m.Year = 2023
WHERE m.State_ANSI IS NULL;

SELECT COUNT(s.State_ANSI)
FROM state_lookup s
LEFT JOIN milk_production m 
ON s.State_ANSI = m.State_ANSI AND m.Year = 2023
WHERE m.State_ANSI IS NULL;


-- states with their cheese production values, including states that didn't produce any cheese in April 2023.
-- Did Delaware produce any cheese in April 2023? NO

SELECT  s.state, COALESCE(c.value, 0)
FROM state_lookup AS s LEFT JOIN cheese_production AS c
ON c.State_ANSI = s.State_ANSI 
AND c.year = 2023 
AND c.period = 'APR' ;

SELECT  c.value, s.state
FROM (cheese_production AS c INNER JOIN state_lookup AS s 
ON c.State_ANSI = s.State_ANSI ) 
WHERE c.year=2023 AND period='APR' and s.state='Delaware'; 


-- Find the average coffee production for all years where the honey production exceeded 1 million
#6495873.23943662

SELECT AVG(cp.value)
FROM coffee_production cp
WHERE cp.State_ANSI IN(
	SELECT h.state_ANSI 
	FROM honey_production h 
	WHERE h.value>1000000
);







