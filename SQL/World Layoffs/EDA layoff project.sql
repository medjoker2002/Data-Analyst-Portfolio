-- Exploratory Data Analysis

SELECT *
FROM layoff_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_staging2;

SELECT *
FROM layoff_staging2
where percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT max(date), min(date)
FROM layoff_staging2;

SELECT industry, SUM(total_laid_off) total_laid_off, ROW_NUMBER() over(order by sum(total_laid_off) DESC) rank_total_laid_off
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT date, SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY date
ORDER BY 2 DESC;

SELECT year(date) year, SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY year(date)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT substr(date, 1, 7) month, 
		quarter(date) quarter,
        SUM(total_laid_off) monthly_total_laid_off
FROM layoff_staging2
WHERE substr(date, 1, 7) is NOT NULL
GROUP BY month, quarter
ORDER BY 1 ;

WITH cte_monthly_lo AS
(
	SELECT substr(date, 1, 7) month,
		quarter(date) quarter,
        SUM(total_laid_off) month_lo
	FROM layoff_staging2
	WHERE substr(date, 1, 7) is NOT NULL
	GROUP BY month, quarter
	ORDER BY 1 
), cte_monthly_rolling_tlo AS
(
	SELECT *, sum(month_lo) OVER(ORDER BY month) rolling_monthly_tlo
	FROM cte_monthly_lo
)
SELECT substr(month, 1, 4) year, quarter, sum(month_lo) total_laid_off
FROM cte_monthly_lo
GROUP BY year, quarter;

WITH company_year AS
(
	SELECT company, year(date) years , SUM(total_laid_off) total_laid_off
	FROM layoff_staging2
    WHERE year(date) is NOT NULL
	GROUP BY company, year(date)
), company_ranking AS
(
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) ranking
    FROM company_year
)
SELECT *
FROM company_ranking
WHERE ranking <= 5;