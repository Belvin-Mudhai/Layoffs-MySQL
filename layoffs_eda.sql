USE world_layoffs;

--  EDA
SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
	AND total_laid_off IS NOT NULL;

-- Most affected companies and the workforce involved
SELECT *
FROM layoffs_staging2
WHERE total_laid_off > (SELECT AVG(total_laid_off)
						FROM layoffs_staging2)
				AND percentage_laid_off = 1
ORDER BY total_laid_off DESC;
                
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, industry
ORDER BY 2 DESC;
-- USA has the most number of layoffs

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
-- Consumer and Retail are industries with most layoffs

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;
--  Companies in the Post IPO stage were the most affected by the downsizing and closures

SELECT MIN(`date`)
FROM layoffs_staging2;
-- The data dates back from the beginning of the pandemic

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;
-- 2022 had the most layoffs recorded yet

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;
-- The trend of the job layoffs

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;
-- The order that companies did lay offs through the years

WITH Company_Year (Company, Years, Total) AS 
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`))
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total DESC) AS Yearly_Ranking
FROM Company_Year
WHERE Years AND Total IS NOT NULL;
-- Assessed the order of companies that made most layoffs per year

-- A look at the companies with most layoffs through the years
WITH Company_Year (Company, Years, Total) AS 
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)),
Company_Year_Rank AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total DESC) AS Yearly_Ranking
FROM Company_Year
WHERE Years AND Total IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Yearly_Ranking <= 5;

-- A look at the industries with most layoffs through the years
WITH Industry_Year (industry, Years, Total) AS 
(SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)),
Industry_Year_Rank AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total DESC) AS Yearly_Ranking
FROM Industry_Year
WHERE Years AND Total IS NOT NULL)
SELECT *
FROM Industry_Year_Rank
WHERE Yearly_Ranking <= 5;



