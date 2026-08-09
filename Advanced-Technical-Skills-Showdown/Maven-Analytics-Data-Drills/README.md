# Maven Analytics Data Drills — Cross-Tool Solutions

> **The same business problem, solved with SQL · Excel · Power BI · Python.**  
> This folder demonstrates tool-agnostic analytical thinking — choosing the right tool for each stage of the data pipeline.

---

## 📋 Drills Completed

### 🔴 Advanced

| Drill | Business Context | Key Techniques | SQL | Excel | Power BI | Python |
|-------|-----------------|--------------|:---:|:-----:|:--------:|:------:|
| **Booking Breakdown** | Calculate hotel occupancy rate from check-in/check-out reservations | Date range expansion, occupancy logic | ✅ | ✅ | ✅ | ✅ |
| **Cart Combos** | Find which product pairs are bought together most often | Market basket analysis, self-joins, affinity scoring | ✅ | ✅ | ✅ | ✅ |
| **Streak Leaderboard** | Identify users with the longest daily active streaks | `LAG()`, date comparisons, streak logic, gap detection | ✅ | ✅ | ✅ | ✅ |
| **Org Chart Overhaul** | Build reporting hierarchies and count direct/total reports | Recursive CTEs, tree traversal, organizational data modeling | ✅ | ✅ | ✅ | ✅ |

### 🟡 Intermediate

| Drill | Business Context | Key Techniques | SQL | Excel | Power BI | Python |
|-------|-----------------|--------------|:---:|:-----:|:--------:|:------:|
| **Time Shift** | Determine the busiest hour for a global helpdesk (UTC conversion) | Timezone conversion, `DATETIME` parsing, hourly aggregation | ✅ | ✅ | ✅ | ✅ |
| **Readmission Radar** | Calculate a hospital's 30-day readmission rate | Event-pairing, rolling time windows, date arithmetic | ✅ | ✅ | ✅ | ✅ |
| **The Price is Right** | Look up product prices based on transaction date and historical price changes | Slowly Changing Dimensions (SCD), effective date ranges | ✅ | ✅ | ✅ | ✅ |
| **Splitting the Field** | Count players at each position during the 2025 MLB season | Multi-value field parsing, aggregation on delimited data | ✅ | ✅ | ✅ | ✅ |
| **Estimate the Estate** | Estimate missing property sale prices using price-per-sqft from similar properties | Imputation, `GROUP BY` neighborhood/class, conditional averages | ✅ | ✅ | ✅ | ✅ |
| **Movie Metrics** | Summarize Netflix viewing activity per user | Feature engineering, logic-based aggregation, user segmentation | ✅ | ✅ | ✅ | ✅ |
| **Spot the Sale** | Match orders to active promotions based on date ranges | Non-equi joins, interval overlap detection, promotional attribution | ✅ | ✅ | ✅ | ✅ |
| **Flatten the Stack** | Flatten nested JSON order records into a flat table | JSON parsing, row expansion, data transformation | ✅ | ✅ | ✅ | ✅ |

### 🟢 Beginner

| Drill | Business Context | Key Techniques | SQL | Excel | Power BI | Python |
|-------|-----------------|--------------|:---:|:-----:|:--------:|:------:|
| **Final Form** | Retrieve the latest response from a recurring employee satisfaction survey | Deduplication, `MAX(date)` filtering, most-recent record selection | ✅ | ✅ | ✅ | ✅ |
| **Making the Cut** | Group marathon runners into performance bands | Data binning (`CASE` / `IF`), time calculations, distribution analysis | ✅ | ✅ | ✅ | ✅ |
| **Rolling Up, Looking Back** | Analyze monthly sales and calculate MoM changes | Period-over-period comparison, trend calculation, variance analysis | ✅ | ✅ | ✅ | ✅ |
| **Turning Bullish** | Compare short-term and long-term moving averages for S&P 500 | Rolling calculations, moving averages, conditional flags | ✅ | ✅ | ✅ | ✅ |

---

## 🎯 Skills Demonstrated

- ✅ **Cross-Tool Fluency:** Same logic expressed in SQL, DAX, Excel formulas, and Pandas
- ✅ **Tool Selection:** Knowing which tool fits each stage of the analytical pipeline
- ✅ **Business Contextualization:** Every drill is grounded in a real-world scenario (healthcare, hospitality, retail, finance, sports)
- ✅ **Advanced SQL:** Recursive CTEs, window functions, non-equi joins, date range expansion
- ✅ **DAX & Data Modeling:** Time intelligence, calculated tables, measure branching
- ✅ **Python Data Engineering:** `pandas`, `numpy`, `datetime`, string parsing, JSON flattening
- ✅ **Excel Analytics:** Pivot tables, Power Query, array formulas, what-if analysis

---

## 🔗 Original Drill Links

All problems are from [Maven Analytics Data Drills](https://mavenanalytics.io/data-drills):

- [Booking Breakdown](https://mavenanalytics.io/data-drills/booking-breakdown)
- [Cart Combos](https://mavenanalytics.io/data-drills/cart-combos)
- [Streak Leaderboard](https://mavenanalytics.io/data-drills/streak-leaderboard)
- [Org Chart Overhaul](https://mavenanalytics.io/data-drills/org-chart-overhaul)
- [Time Shift](https://mavenanalytics.io/data-drills/time-shift)
- [Readmission Radar](https://mavenanalytics.io/data-drills/readmission-radar)
- [The Price is Right](https://mavenanalytics.io/data-drills/the-price-is-right)
- [Splitting the Field](https://mavenanalytics.io/data-drills/splitting-the-field)
- [Estimate the Estate](https://mavenanalytics.io/data-drills/estimate-the-estate)
- [Movie Metrics](https://mavenanalytics.io/data-drills/movie-metrics)
- [Spot the Sale](https://mavenanalytics.io/data-drills/spot-the-sale)
- [Flatten the Stack](https://mavenanalytics.io/data-drills/flatten-the-stack)
- [Final Form](https://mavenanalytics.io/data-drills/final-form)
- [Making the Cut](https://mavenanalytics.io/data-drills/making-the-cut)
- [Rolling Up, Looking Back](https://mavenanalytics.io/data-drills/rolling-up-looking-back)
- [Turning Bullish](https://mavenanalytics.io/data-drills/turning-bullish)

---

## 📁 Folder Structure

- Each solution file begins with the name of the tool used("MYSQL", "Excel", "PBI" for Power BI, "Pandas").
- While the sample data files end with ".csv".
- Most but not all folders contain the sample data files( due to their sizes) but they can be downloaded from the links above.

---

*Part of a Data Analyst Portfolio.*

