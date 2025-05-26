-- Create Tables

CREATE TABLE orderـtable (
	id_order VARCHAR(255),
	type_order VARCHAR(255)
	
);


CREATE TABLE sale_total (
	id_order VARCHAR(255),
	date_order date,
	date_submission date,
	type_submission VARCHAR(255),
	customer VARCHAR(255),
	type_customer VARCHAR(255),
	country VARCHAR(255),
	city VARCHAR(255),
	state VARCHAR(255),
	region VARCHAR(255),
	product_id VARCHAR(255),
	group_product VARCHAR(255),
	sub_group_product VARCHAR(255),
	product_name VARCHAR(255),
	sale_dollor INT,
	sale_count INT,
	discount DECIMAL,
	profit DECIMAL
);

SELECT *
FROM orderـtable 

-- change sale_dollor to sale_dollar

ALTER TABLE sale_total
RENAME COLUMN sale_dollor TO sale_dollar;

-- change datatype of date_order into Text for import data

ALTER TABLE sale_total 
MODIFY COLUMN date_order Text;

-- change datatype of date_submission into Text for import data

ALTER TABLE sale_total 
MODIFY COLUMN date_submission Text;

-- Create BackUp table before changing data

CREATE TABLE sales LIKE sale_total;
INSERT sales SELECT * FROM sale_total ;


-- check for duplicates

SELECT customer, id_order, date_order, product_id, COUNT(*)
FROM sale_total
group by customer, id_order, product_id, date_order, date_submission, sale_dollar 
having count(*)>1;

-- standardzied the data

SELECT id_order , type_submission , customer 
FROM sale_total ;

-- delete extra space in type_submission & customer

UPDATE sale_total 
SET type_submission = TRIM(type_submission), customer = TRIM(customer);


SELECT DISTINCT region 
FROM sale_total ;

UPDATE sale_total 
SET  region = 'West'
WHERE region = 'w';

SELECT DISTINCT product_name
FROM sale_total ;

SELECT product_name
FROM sale_total
WHERE product_name LIKE '%" Recycled Envelopes';

-- Convert data type of date_order and data_submission

ALTER TABLE sale_total 
MODIFY COLUMN date_order DATE;

UPDATE sale_total 
SET date_order = STR_TO_DATE(date_order, '%m/%d/%Y');

UPDATE sale_total 
SET date_submission = STR_TO_DATE(date_submission, '%m/%d/%Y');

-- Check for NULL or '' values / count number of NULL values in each column

SELECT count(*)
FROM sale_total 
where id_order IS NULL OR id_order = '';


UPDATE sale_total 
SET date_order = TRIM(date_order), type_submission = TRIM(type_submission), date_submission = TRIM(date_submission), id_order = TRIM(id_order);


UPDATE sale_total s1
JOIN sale_total s2
  ON s1.customer = s2.customer
  AND s1.type_customer = s2.type_customer 
  AND s1.date_order = s2.date_order
  AND s1.date_submission = s2.date_submission
SET s1.id_order = s2.id_order
WHERE (s1.id_order IS NULL OR s1.id_order = '')
  AND s2.id_order IS NOT NULL
  AND (s1.id_order <> s2.id_order OR s1.id_order IS NULL);

SELECT *
FROM sale_total 
WHERE id_order IS NULL OR id_order = '';


SELECT *
FROM sale_total 
where type_submission IS NULL OR type_submission = '';

UPDATE sale_total s1
JOIN sale_total s2
	ON s1.customer  = s2.customer 
	AND s1.type_customer = s2.type_customer 
	AND s1.date_order = s2.date_order
	AND s1.date_submission = s2.date_submission 
SET s1.type_submission = s2.type_submission 
WHERE (s1.type_submission IS NULL OR s1.type_submission = '')
AND s2.type_submission IS NOT NULL;

Delete 
FROM sale_total 
where type_submission IS NULL OR type_submission = '';

SELECT *
FROM sale_total 
where type_submission IS NULL OR type_submission = '';

SELECT *
FROM sale_total 
where sale_dollar IS NULL OR sale_dollar = '';

SELECT s1.product_id, s1.product_name, s1.type_customer, s1.sale_count
FROM sale_total s1
JOIN sale_total s2
	ON s1.product_id = s2.product_id
	AND s1.product_name = s2.product_name
	AND s1.sale_count  = s2.sale_count
	AND s1.type_customer = s2.type_customer;
GROUP BY s1.product_name ;
HAVING s1.product_name = 'OFF-B1-10000207';

WHERE s1.product_name = s2.product_name;


UPDATE sale_total 
SET sale_dollar = NULL
WHERE sale_dollar = 0;

UPDATE sale_total s1
JOIN sale_total s2
  ON s1.product_id = s2.product_id
  OR s1.date_order = s2.date_order
SET s1.sale_dollar = s2.sale_dollar
WHERE (s1.sale_dollar IS NULL OR s1.sale_dollar = '' )
	AND s2.sale_dollar IS NOT NULL
	AND (s1.sale_dollar <> s2.sale_dollar OR s1.sale_dollar IS NULL);

SELECT *
FROM sale_total 
where sale_dollar IS NULL OR sale_dollar = '';

-- Negative values for lost 

SELECT COUNT(*)
FROM sale_total 
where profit <1;  
