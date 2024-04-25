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







