 USE practise_dc_eda;
SELECT * FROM laptop;

-- 1. Create Backup and remove duplicates rows from table

CREATE TABLE laptop_backup LIKE laptop;
INSERT INTO laptop_backup SELECT DISTINCT * FROM laptop;

-- 2. Check number of rows

SELECT COUNT(*) FROM laptop; -- 1272

-- 3. Check memory consumption for refrence

SELECT  DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'practise_dc_eda'
AND TABLE_NAME = 'laptop'; -- 256 KB

-- 4. Change col name 'Unnamed: 0 to index'

ALTER TABLE laptop
CHANGE COLUMN `Unnamed: 0` `index` INTEGER;

-- 5. Check null values -> No null values found

SELECT * FROM laptop
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory is NULL AND Gpu is NULL AND OpSys IS NULL AND
Weight IS NULL AND Price IS NULL;

-- 6. Price -> round-off price & change data type

UPDATE laptop
SET price = ROUND(price);

ALTER TABLE laptop
MODIFY COLUMN price INTEGER;

DESCRIBE laptop;

-- 7. Weight -> remove kg and change data type

SELECT * FROM laptop
WHERE Weight LIKE '%?%';

DELETE FROM laptop
WHERE `index` = 208;

UPDATE laptop
SET Weight = REPLACE(Weight,'kg','');

ALTER TABLE laptop
MODIFY COLUMN Weight DOUBLE;

-- 8. Change OpSys 
-- macOS , Mac OS X --> mac
-- Windows 10, Windows 10 S, Windows 7  --> windows
-- Linux --> linux
-- Chrome OS, Android --> other 

UPDATE laptop
SET OpSys = CASE
WHEN OpSys LIKE '%Windows%' THEN 'windows'
WHEN OpSys LIKE '%mac%' THEN 'macos'
WHEN OpSys LIKE '%Linux%' THEN 'linux'
WHEN OpSys = 'No OS' THEN 'n/a'
ELSE 'other'
END;

-- 9. GPU -> make new cols gpu_brand , gpu_name
ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

UPDATE laptop
SET gpu_brand =  TRIM(SUBSTRING_INDEX(Gpu,' ',1));


UPDATE laptop
SET gpu_name = TRIM(REPLACE(Gpu,gpu_brand,''));

ALTER TABLE laptop
DROP COLUMN Gpu;

-- 10. Memory -> memory_type , primary_storgae , secondary_storage

ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

SELECT * FROM laptop 
WHERE Memory LIKE '%?%';

DELETE FROM laptop
WHERE `index` = 770;

UPDATE laptop
SET memory_type = CASE 
  WHEN Memory LIKE '%+%' THEN 'Hybrid'
  WHEN Memory LIKE '%SSD' THEN 'SSD'
  WHEN Memory LIKE '%HDD' THEN 'HDD'
  WHEN Memory LIKE '%Flash%' THEN 'Flash Storage'
  ELSE 'Hybrid'  
END;

UPDATE laptop
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE 
 WHEN Memory LIKE '%+%' 
 THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+')
 ELSE 0
END;

UPDATE laptop
SET primary_storage = primary_storage*1024
WHERE primary_storage <= 2;

UPDATE laptop
SET secondary_storage =  secondary_storage*1024
WHERE  secondary_storage <= 2;

ALTER TABLE laptop
DROP COLUMN Memory;

-- 11. RAM -> remove GB and change datatype

UPDATE laptop
SET Ram =  REPLACE(Ram,'GB','');

ALTER TABLE laptop
MODIFY COLUMN RAM INTEGER;

-- 12. CPU -> cpu_brand , cpu_name, cpu_speed

ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DOUBLE AFTER cpu_name;

UPDATE laptop
SET cpu_brand = TRIM(SUBSTRING_INDEX(Cpu,' ',1)),
cpu_name =  SUBSTRING_INDEX(TRIM(REPLACE(Cpu,cpu_brand,'')),' ',2),
cpu_speed = REPLACE(SUBSTRING_INDEX(Cpu,' ',-1),'GHz','');

ALTER TABLE laptop
DROP COLUMN Cpu;

-- 13. ScreenResolution -> resolution_width, resolution_height,

ALTER TABLE laptop
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution, 
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

UPDATE laptop
SET resolution_width  = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1); 

ALTER TABLE laptop
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

UPDATE laptop
SET touchscreen = CASE 
  WHEN  ScreenResolution LIKE '%Touchscreen%' THEN 1
  ELSE 0
END;

ALTER TABLE laptop
DROP COLUMN ScreenResolution;





















