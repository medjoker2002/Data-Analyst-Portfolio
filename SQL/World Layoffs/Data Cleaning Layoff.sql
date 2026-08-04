-- Data Cleaning 

-- Making Staging Tables

SELECT * FROM layoffs;

create table layoff_staging
like layoffs;

insert layoff_staging
select *
from layoffs;

create table layoff_staging2
like layoff_staging;

ALTER TABLE layoff_staging2
ADD COLUMN row_num INT;

INSERT INTO layoff_staging2
select *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions ) row_num from layoff_staging;

-- 1- Removing Duplicates
DELETE FROM layoff_staging2
WHERE row_num > 1;

SELECT * FROM layoff_staging2 WHERE row_num > 1;

-- 2- Standardizing Data

SELECT DISTINCT company
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET company = trim(company);

SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET industry = "crypto"
WHERE industry LIKE "crypto%";

SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET country = "United States"
WHERE country like "United States.%";

UPDATE layoff_staging2
SET date = str_to_date(date, "%m/%d/%Y");

ALTER TABLE layoff_staging2
MODIFY COLUMN date DATE;

ALTER TABLE layoff_staging2
MODIFY COLUMN percentage_laid_off DECIMAL(6, 2);

-- Fix Empty and Null Industry Using Valid Data From The Same company In The Table
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
where (t1.industry is NULL or t1.industry = "")
and (t2.industry is NOT NULL and t2.industry != "");

-- 3- Drop Useless Columns And Rows

ALTER TABLE layoff_staging2
DROP COLUMN row_num;

DELETE
FROM layoff_staging2
WHERE total_laid_off is NULL
	and percentage_laid_off is NULL;
    
SELECT *
FROM layoff_staging2;