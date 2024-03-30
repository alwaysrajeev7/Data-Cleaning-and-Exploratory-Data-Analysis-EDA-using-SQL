-- EDA using SQL

-- Feature Engineering 

ALTER TABLE laptop
ADD COLUMN ppi DOUBLE AFTER resolution_height,
ADD COLUMN screen_size VARCHAR(255) AFTER Inches;

UPDATE laptop
SET ppi = ROUND(SQRT(POW(resolution_width,2)+ POW(resolution_height,2))/Inches);


UPDATE laptop
SET screen_size = 
CASE
  WHEN Inches < 14.0 THEN 'small'
  WHEN Inches >= 14.0 AND Inches < 17.0 THEN 'medium'
  ELSE 'large'
END;

-- Types of Column

-- numerical -> Inches , ppi , cpu_speed, RAM ,primary_storage, secondary_storage, weight, price

-- categorical -> Company , TypeName,screen_size touch_screen,cpu_brand, cpu_name , memory_type , gpu_brand , gpu_name, OpSys



-- Start
 
-- head
SELECT * FROM laptop ORDER BY `index` ASC LIMIT 5;

-- tail
SELECT * FROM laptop ORDER BY `index` DESC LIMIT 5; 

-- sample
SELECT * FROM laptop ORDER BY rand()  LIMIT 5 ;

-- Univarite Analysis on Numerical Column

-- 1. Inches

SELECT COUNT(*) AS 'count',MIN(Inches) AS 'min_inches', 
MAX(Inches) AS 'max_inches', ROUND(AVG(ppi),2) AS 'mean_inches',
ROUND(STD(Inches),2) AS 'STD' FROM laptop;

SELECT * FROM laptop WHERE Inches IS NULL; -- no null values


-- 2. ppi

SELECT MIN(ppi) AS 'min_ppi', MAX(ppi) AS 'max_ppi', 
ROUND(AVG(ppi),2) AS 'mean_ppi', ROUND(STD(ppi),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE ppi IS NULL; -- no null values



-- 3. cpu_speed

SELECT MIN(cpu_speed) AS 'min', MAX(cpu_speed) AS 'max', 
ROUND(AVG(cpu_speed),2)AS 'mean', ROUND(STD(cpu_speed),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE cpu_speed IS NULL; -- no null values



-- 4. RAM

SELECT MIN(RAM) AS 'min', MAX(RAM) AS 'max', 
ROUND(AVG(RAM),2)AS 'mean', ROUND(STD(RAM),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE RAM IS NULL; -- no null values

-- frequency count of different ram category
SELECT ram_type,COUNT(*) AS 'count' FROM (SELECT RAM ,
CASE
  WHEN RAM BETWEEN 1 AND 4 THEN '1 - 4'
  WHEN RAM BETWEEN 6 AND 8 THEN '6 - 8'
  WHEN RAM BETWEEN 12 AND 16 THEN '12 - 16'
  WHEN RAM BETWEEN 24 AND 32 THEN '24 - 32'
  ELSE '>32'
END 'ram_type'  
FROM laptop)t
GROUP BY ram_type
ORDER BY count DESC;



-- 5. primary_storage

SELECT MIN(primary_storage) AS 'min', 
MAX(primary_storage) AS 'max', 
ROUND(AVG(primary_storage),2)AS 'mean', 
ROUND(STD(primary_storage),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE primary_storage IS NULL; -- no null values



-- 6. secondary_storage

SELECT MIN(secondary_storage) AS 'min',
MAX(secondary_storage) AS 'max', ROUND(AVG(secondary_storage),2)
AS 'mean', ROUND(STD(secondary_storage),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE secondary_storage IS NULL; -- no null values



-- 7. weight

SELECT MIN( weight) AS 'min', MAX( weight) AS 'max', 
ROUND(AVG( weight),2)AS 'mean', ROUND(STD( weight),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE weight IS NULL; -- no null values



-- 8. price

SELECT MIN(price) AS 'min', MAX(price) AS 'max', 
ROUND(AVG(price),2)AS 'mean', ROUND(STD(price),2) AS 'STD' 
FROM laptop;

SELECT * FROM laptop WHERE price IS NULL; -- no null values

-- Histogram based on different price category

SELECT price_type,REPEAT('*',COUNT(*)/5) AS 'count' FROM (SELECT price,
CASE 
WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
WHEN price BETWEEN 25001 AND 50000 THEN '25-50K'
WHEN price BETWEEN 50001 AND 75000 THEN '50-75K'
WHEN price BETWEEN 75001 AND 100000 THEN '75-100K'
ELSE '>100K'
END AS 'price_type'
FROM laptop) t
GROUP BY price_type;



-- Univariate Analysis on Categorical Column

-- 1. Company
-- Conclusion -> Mostly laptops are from Lenovo than Dell and so on

SELECT Company , COUNT(Company) AS 'count' FROM
laptop GROUP BY Company ORDER BY count DESC;

SELECT * FROM laptop WHERE Company IS NULL; -- no missing values



-- 2. OpSys
-- Conclusion -> Mostly laptops have windows as Operating Sysytem

SELECT OpSys , COUNT(OpSys) AS 'count' FROM
laptop GROUP BY OpSys ORDER BY count DESC;



-- 3. Typename
SELECT Typename , COUNT(Typename) AS 'count' FROM
laptop GROUP BY Typename ORDER BY count DESC;



-- 4. Touchscreen
-- Conclusion -> Mostly laptops are not Touchscreen

SELECT Touchscreen , COUNT(Touchscreen) AS 'count' FROM
laptop GROUP BY Touchscreen ORDER BY count DESC;



-- 5. cpu_brand
-- Conclusion -> Most used cpu_brand -> Intel

SELECT cpu_brand , COUNT(cpu_brand) AS 'count' FROM
laptop GROUP BY cpu_brand ORDER BY count DESC;



-- 6. cpu_name
-- Conclusion -> Most used cpu_name -> Corei7

SELECT cpu_name , COUNT(cpu_name) AS 'count' FROM
laptop GROUP BY cpu_name ORDER BY count DESC;



-- 7. memory_type
-- Conclusion -> Mostly laptops have SSD as memory_type

SELECT memory_type , COUNT(memory_type) AS 'count' FROM
laptop GROUP BY memory_type ORDER BY count DESC;



-- 8. gpu_brand
-- Conclusion -> Most used gpu_brand -> Intel

SELECT gpu_brand , COUNT(gpu_brand) AS 'count' FROM
laptop GROUP BY gpu_brand ORDER BY count DESC;




-- Bivariate Analysis

-- a. Numerical - Numerical

-- Generally numerical - numerical is bestly done with the help
-- of correlation coff and charts like scatterplot, 2KDE plot,
-- 2D histplot



-- 1. Inches, price
-- no a strong relationship b/w inches and price

SELECT Inches, ROUND(AVG(price)) AS 'avg_price' FROM laptop
GROUP BY Inches ORDER BY Inches ASC;



-- 2. cpu_speed , price
-- price of laptop gradually increases with cpu_speed

SELECT cpu_speed, ROUND(AVG(price)) AS 'avg_price' FROM laptop
GROUP BY cpu_speed ORDER BY cpu_speed DESC;



-- 3. RAM, price 
-- price of laptop gradually increases with size of RAM

SELECT RAM, ROUND(AVG(price)) AS 'avg_price' FROM laptop
GROUP BY RAM ORDER BY avg_price DESC;



-- 4. primary_storage, price
-- no strong relationship b/w them
SELECT primary_storage, ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY primary_storage ORDER BY primary_storage DESC;



-- 5. secondary_storage, price
-- price of laptop increase with size of secondary_storage

SELECT  secondary_storage,ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY secondary_storage ORDER BY avg_price DESC;



-- 6. weight , price
-- laptops weight b/w 4-5kg has highest price then comes 3-4kg

SELECT weight, ROUND(AVG(price)) AS 'avg_price' FROM laptop
GROUP BY weight ORDER BY weight ASC;

SELECT weight_category,ROUND(AVG(price)) AS 'avg_price' 
FROM (SELECT weight, price,
CASE
  WHEN weight < 1 THEN '<1kg'
  WHEN weight BETWEEN 1 AND 1.99 THEN '1-2kg'
  WHEN weight BETWEEN 2 AND 2.99 THEN '2-3kg'
  WHEN weight BETWEEN 3 AND 3.99 THEN '3-4kg'
  WHEN weight BETWEEN 4 AND 4.99 THEN '4-5kg'
  WHEN weight BETWEEN 5 AND 5.99 THEN '5-6kg'
  WHEN weight BETWEEN 6 AND 8 THEN '6-8kg'
  ELSE '>8kg'
END AS 'weight_category'
FROM laptop)t
GROUP BY weight_category
ORDER BY avg_price DESC;




-- b. Numerical - Categorical



-- 1. Company , price

SELECT Company , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY Company ORDER BY avg_price DESC;




-- 2. Typename , price
SELECT Typename , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY Typename  ORDER BY avg_price DESC;




-- 3. touchscreen , price
-- tochscreen laptops have higher price than others

SELECT  touchscreen , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY touchscreen ORDER BY avg_price DESC;




-- 4. cpu_brand , price
-- latops that Intel as cpu_brand have higher price 

SELECT cpu_brand , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY cpu_brand  ORDER BY avg_price DESC;




-- 5. cpu_name , price
SELECT cpu_name , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY cpu_name ORDER BY avg_price DESC;




-- 6. memory_type , price
-- laptops that have Hyrbrid as memory_type have higher price

SELECT memory_type , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY memory_type ORDER BY avg_price DESC;




-- 7. gpu_brand,price
-- latops that have graphic card of Nvidia have higher price

SELECT gpu_brand , MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY gpu_brand ORDER BY avg_price DESC;



-- 8. OpSys , price
-- latops that have OS as mac-os have higher price than 
-- comes windows

SELECT OpSys, MIN(price) AS 'min_price', 
MAX(price) AS 'max_price', ROUND(AVG(price)) AS 'avg_price' 
FROM laptop GROUP BY OpSys ORDER BY avg_price DESC;



-- 9. screen_size , price 
-- price of laptops linerally increases with screen_size

SELECT screen_size, ROUND(AVG(price)) AS 'avg_price' FROM laptop
GROUP BY screen_size;



-- c. Categorical - Categorical -> Contengency Table

-- 1. Company , touchscreen

SELECT Company,
SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'touchscreen',
SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'not_touchscreen'
FROM laptop
GROUP BY Company;



-- 2. Company cpu_brand

SELECT Company,
SUM(CASE WHEN cpu_brand  = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'AMD',
SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'Samsung'
FROM laptop
GROUP BY Company;



-- 3. Company, OpSys

SELECT Company,
SUM(CASE WHEN OpSys = 'macos' THEN 1 ELSE 0 END) AS 'MacOs',
SUM(CASE WHEN OpSys = 'windows' THEN 1 ELSE 0 END) AS 'Windows',
SUM(CASE WHEN OpSys = 'linux' THEN 1 ELSE 0 END) AS 'Linux',
SUM(CASE WHEN OpSys = 'n/a' THEN 1 ELSE 0 END) AS 'N/A'
FROM laptop
GROUP BY Company;



-- 4. Company , gpu_brand

SELECT Company,
SUM(CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
SUM(CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'AMD',
SUM(CASE WHEN gpu_brand = 'Nvidia' THEN 1 ELSE 0 END) AS 'Nvidia',
SUM(CASE WHEN gpu_brand = 'ARM' THEN 1 ELSE 0 END) AS 'ARM'
FROM laptop
GROUP BY Company;



-- 5. Company , memory_type

SELECT Company,
SUM(CASE WHEN memory_type = 'SSD' THEN 1 ELSE 0 END) AS 'SSD',
SUM(CASE WHEN memory_type = 'HDD' THEN 1 ELSE 0 END) AS 'HDD',
SUM(CASE WHEN memory_type = 'Flash Storage' THEN 1 ELSE 0 END) AS 'Flash',
SUM(CASE WHEN memory_type = 'Hybrid' THEN 1 ELSE 0 END) AS 'Hybrid'
FROM laptop
GROUP BY Company;



-- One Hot Encoding

SELECT gpu_brand ,
CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'Intel',
CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END AS 'AMD',
CASE WHEN gpu_brand = 'Nvidia' THEN 1 ELSE 0 END AS 'Nvidia',
CASE WHEN gpu_brand = 'ARM' THEN 1 ELSE 0 END AS 'ARM' 
FROM laptop;

