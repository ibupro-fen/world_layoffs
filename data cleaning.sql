-- Data cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize data
-- 3. Null values or blank values
-- 4. Remove any unnecessary columns

CREATE TABLE layoffs_staging
LIKE layoffs; -- copies layoffs table columns

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging			
SELECT * 
FROM layoffs;  -- copies data from layoffs table
			   -- make same table because if we make a mistake we have the raw data still
               
               
-- 1) REMOVE DUPLICATES
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num			-- gives duplicates if row_num > 1
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Oda';

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num			-- gives duplicates if row_num > 1
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;            

CREATE TABLE `layoffs_staging2` (
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
FROM layoffs_staging2
WHERE row_num;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num			
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2; 
-- Remove duplicates END

-- Standardizing data (Finding issues in data and fixing it)

SELECT company, TRIM(company) 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'				-- If its LIKE crypto it will just be crypto
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging2 
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2 
ORDER BY 1;

SELECT DISTINCT *
FROM layoffs_staging2 
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2 
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')				-- date coulumn is in text but to put into date format
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET date = STR_TO_DATE(`date`, '%m/%d/%Y');	

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2;
-- END of standardization

-- NULL values or blank values

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT DISTINCT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry = '' OR t1.industry IS NULL)    
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = NULL			-- They were blanks so turn it into NULLS first
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- END of NULL values or BLANKS

-- 4. Remove any unnecessary columns

SELECT * 
FROM  layoffs_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;	
										-- Just an example dont have to always delete it 
DELETE
FROM  layoffs_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;	

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- END






