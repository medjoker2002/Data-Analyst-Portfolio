# World Layoffs Analysis — SQL Data Cleaning & EDA

> **End-to-end SQL project** cleaning and analyzing global tech layoffs data (2020–2023) to uncover trends by company, industry, country, and funding stage.

---

## 📌 Business Problem

The tech industry experienced massive layoffs between 2020 and 2023. This project seeks to answer:

- Which companies laid off the most employees, and when?
- Which industries and countries were hit the hardest?
- Is there a relationship between funding raised and layoff severity?
- How did layoffs trend over time — monthly, quarterly, and yearly?
- Which funding stages (Seed, Series A–H, Post-IPO, Acquired) saw the most cuts?

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **MySQL** | Data cleaning, transformation, and exploratory analysis |
| **MySQL Workbench** | Query development and result visualization |

---

## 📊 Dataset Overview

- **Source:** Global tech layoffs dataset
- **Original Table:** `layoffs`
- **Cleaned Table:** `layoff_staging2`
- **Key Fields:**
  - `company` — Company name
  - `location` — City/region
  - `industry` — Business sector
  - `total_laid_off` — Number of employees laid off
  - `percentage_laid_off` — % of workforce affected
  - `date` — Layoff announcement date
  - `stage` — Funding stage (Seed, Series A–H, Post-IPO, Acquired, Unknown)
  - `country` — Country
  - `funds_raised_millions` — Total funding raised ($M)

---

## 🔧 Data Cleaning Process

### Step 1: Create Staging Tables
Created copies of the raw data to preserve the original while cleaning:

```sql
CREATE TABLE layoff_staging LIKE layoffs;
INSERT INTO layoff_staging SELECT * FROM layoffs;

CREATE TABLE layoff_staging2 LIKE layoff_staging;
ALTER TABLE layoff_staging2 ADD COLUMN row_num INT;

INSERT INTO layoff_staging2
SELECT *, 
  ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, 
                 percentage_laid_off, date, stage, country, funds_raised_millions
  ) AS row_num
FROM layoff_staging;
```

### Step 2: Remove Duplicates
Used `ROW_NUMBER()` window function to identify and delete exact duplicate records:

```sql
DELETE FROM layoff_staging2 WHERE row_num > 1;
```

### Step 3: Standardize Data

**a) Trim whitespace from company names:**
```sql
UPDATE layoff_staging2 SET company = TRIM(company);
```

**b) Consolidate industry variations:**
```sql
UPDATE layoff_staging2 SET industry = 'crypto' WHERE industry LIKE 'crypto%';
```
> Fixed variations like "Crypto", "Crypto Currency", etc.

**c) Fix country naming inconsistencies:**
```sql
UPDATE layoff_staging2 
SET country = 'United States' 
WHERE country LIKE 'United States.%';
```
> Fixed "United States." trailing punctuation.

**d) Convert date strings to proper DATE format:**
```sql
UPDATE layoff_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE layoff_staging2 MODIFY COLUMN date DATE;
```

**e) Fix data types:**
```sql
ALTER TABLE layoff_staging2 MODIFY COLUMN percentage_laid_off DECIMAL(6, 2);
```

### Step 4: Handle NULL & Empty Values

**Self-join to populate missing industry values** using valid data from the same company:
```sql
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND (t2.industry IS NOT NULL AND t2.industry != '');
```

### Step 5: Drop Useless Data

**Remove helper column:**
```sql
ALTER TABLE layoff_staging2 DROP COLUMN row_num;
```

**Delete records with no layoff data:**
```sql
DELETE FROM layoff_staging2 
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
```

---

## 🔍 Exploratory Data Analysis (EDA)

### 1. Extreme Cases
```sql
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoff_staging2;
```
> Identified companies with 100% workforce layoffs — ordered by funds raised to see if better-funded startups failed harder.

### 2. Total Layoffs by Industry

| Rank | Industry | Total Laid Off |
|------|----------|----------------|
| 1 | Consumer | 45,182 |
| 2 | Retail | 43,613 |
| 3 | Other | 36,289 |
| 4 | Transportation | 33,748 |
| 5 | Finance | 28,344 |
| 6 | Healthcare | 25,953 |
| 7 | Food | 22,855 |
| 8 | Real Estate | 17,565 |
| 9 | Travel | 17,159 |
| 10 | Hardware | 13,828 |

> **Insight:** Consumer and Retail industries lead in total layoffs, likely reflecting post-pandemic demand corrections and e-commerce normalization.

### 3. Total Layoffs by Country

| Country | Total Laid Off |
|---------|----------------|
| United States | 256,559 |
| India | 35,993 |
| Netherlands | 17,220 |
| Sweden | 11,264 |
| Brazil | 10,391 |
| Germany | 8,701 |
| United Kingdom | 6,398 |
| Canada | 6,319 |
| Singapore | 5,995 |
| China | 5,905 |

> **Insight:** The United States dominates with ~256K layoffs — nearly 7× more than India (2nd place). This reflects the concentration of tech companies in the U.S.

### 4. Top Companies by Year (Top 5 Per Year)

Used **CTEs + DENSE_RANK()** to find the biggest layoffs per year:

```sql
WITH company_year AS (
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoff_staging2
  WHERE YEAR(date) IS NOT NULL
  GROUP BY company, YEAR(date)
),
company_ranking AS (
  SELECT *, 
    DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM company_year
)
SELECT * FROM company_ranking WHERE ranking <= 5;
```

| Year | Top Companies | Layoffs |
|------|--------------|---------|
| **2020** | Uber | 7,525 |
| | Booking.com | 4,375 |
| | Groupon | 2,800 |
| | Swiggy | 2,250 |
| | Airbnb | 1,900 |
| **2021** | Bytedance | 3,600 |
| | Katerra | 2,434 |
| | Zillow | 2,000 |
| | Instacart | 1,877 |
| | WhiteHat Jr | 1,800 |
| **2022** | Meta | 11,000 |
| | Amazon | 10,150 |
| | Cisco | 4,100 |
| | Peloton | 4,084 |
| | Carvana | 4,000 |
| **2023** | Google | 12,000 |

> **Insight:** Layoffs accelerated dramatically in 2022–2023. Big Tech (Meta, Amazon, Google) led the wave, signaling a major industry correction after pandemic-era overhiring.

### 5. Time-Series Trends

**By Year:**
```sql
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC;
```

**By Month (with rolling totals):**
```sql
WITH cte_monthly_lo AS (
  SELECT SUBSTR(date, 1, 7) AS month,
         QUARTER(date) AS quarter,
         SUM(total_laid_off) AS month_lo
  FROM layoff_staging2
  WHERE SUBSTR(date, 1, 7) IS NOT NULL
  GROUP BY month, quarter
)
SELECT *, SUM(month_lo) OVER(ORDER BY month) AS rolling_monthly_tlo
FROM cte_monthly_lo;
```

**By Funding Stage:**
```sql
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;
```

### 6. Companies with 100% Layoffs
```sql
SELECT * FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
```
> Identified startups that shut down entirely — useful for understanding which sectors had the highest failure rates.

---

## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `Data Cleaning Layoff.sql` | Complete data cleaning pipeline (staging, deduplication, standardization, NULL handling) |
| `EDA layoff project.sql` | Full exploratory analysis queries (aggregations, rankings, time series, rolling totals) |
| `World Layoff Clean Data.JPG` | Screenshot of cleaned dataset in MySQL Workbench |
| `World Layoff Messy Data.JPG` | Screenshot of raw/messy data before cleaning |
| `World Layoff Top Laid Off Across The Years.JPG` | Query results: Top 5 companies per year using DENSE_RANK() |
| `World Layoff Total Laid Off By Country.JPG` | Query results: Layoffs aggregated by country |
| `World Layoff Total Laid Off By Industry.JPG` | Query results: Layoffs aggregated and ranked by industry |

---

## 🎯 Skills Demonstrated

- ✅ **Data Cleaning:** Built a complete SQL pipeline with staging tables
- ✅ **Deduplication:** Used `ROW_NUMBER()` window function with multi-column partitioning
- ✅ **Data Standardization:** Fixed inconsistent text values, date formats, and data types
- ✅ **NULL Handling:** Applied self-join strategy to impute missing categorical data
- ✅ **Aggregation:** `SUM`, `COUNT`, `GROUP BY`, `ORDER BY` for multi-dimensional analysis
- ✅ **Window Functions:** `ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()` for ranking and rolling totals
- ✅ **CTEs:** Built multi-layer CTEs for complex analytical queries
- ✅ **Time Intelligence:** `YEAR()`, `QUARTER()`, `SUBSTR()` for date-based analysis
- ✅ **Business Storytelling:** Transformed raw layoff data into actionable industry insights

---

## 🚀 How to Run

1. Open **MySQL Workbench**
2. Create a new schema (e.g., `projects`)
3. Import the raw layoffs dataset into table `layoffs`
4. Run `Data Cleaning Layoff.sql` sequentially to clean the data
5. Run `EDA layoff project.sql` to reproduce all analysis results

---

*Created as part of a Data Analyst Portfolio.*

