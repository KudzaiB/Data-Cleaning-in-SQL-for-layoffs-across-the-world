-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

CREATE TABLE layoffs_stagging
LIKE layoffs;

SELECT *
FROM layoffs_stagging;

INSERT layoffs_stagging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_stagging;

-- Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num #WHEN row_num is 2 and above it has duplicates
FROM layoffs_stagging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num #WHEN row_num is 2 and above it has duplicates
FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_stagging
WHERE company = 'Casper';

#CANNOT DELETE UPDATE STATEMENT
WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num #WHEN row_num is 2 and above it has duplicates
FROM layoffs_stagging
)
DELETE #CANNOT DELETE UPDATE STATEMENT
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_stagging2` (
	`company` text,
    `location` text,
    `industry` text,
    `total_laid_off` int DEFAULT NULL,
    `percentage_laid_off` text,
    `date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_stagging2;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num #WHEN row_num is 2 and above it has duplicates
FROM layoffs_stagging;

SELECT * 
FROM layoffs_stagging2
WHERE row_num > 1;

DELETE
FROM layoffs_stagging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_stagging2
WHERE row_num > 1;


-- Standardizing Data

SELECT company, TRIM(COMPANY)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_stagging2
ORDER BY 1;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry Like 'Crypto%';

#CHECK AGAIN FOR UPDATE
SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_stagging2
ORDER BY 1;

#FIND THE PROBLEM

SELECT *
FROM layoffs_stagging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_stagging2
ORDER BY 1;

UPDATE layoffs_stagging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_stagging2
ORDER BY 1;


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_stagging2;

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL;


SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_stagging2
WHERE industry IS NULL
	OR industry = '';
    


SELECT *
FROM layoffs_stagging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


SELECT 
	t1.industry,
    t2.industry
FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry = '';



UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;


SELECT* 
FROM layoffs_stagging2;

DELETE
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT* 
FROM layoffs_stagging2;


ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;


SELECT* 
FROM layoffs_stagging2;