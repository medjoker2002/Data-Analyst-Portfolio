# Superstore Analysis — Power BI Dashboard

> **Business Intelligence Dashboard** analyzing sales performance, profitability, and return trends for a retail superstore dataset.

---

## 📌 Business Problem

A retail superstore needs to understand its sales performance across regions, product categories, and customer segments. Key questions:

- Which product categories and sub-categories are most/least profitable?
- How are sales trending compared to the previous year?
- What is the return rate, and how does it vary by segment?
- Which states drive the most profit, and where are we losing money?
- How do different customer segments (Consumer, Corporate, Home Office) contribute to revenue?

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **Power BI Desktop** | Dashboard design, DAX measures, data modeling |
| **DAX** | Custom measures for YoY comparisons, return rates, and KPIs |
| **Power Query** | Data transformation and relationship modeling |

---

## 📊 Data Overview

- **Dataset:** Superstore Sales Data (10,194 rows)
- **Tables:** Orders, Dim_Date, Returns2, Measures
- **Key Fields:** Order Date, Ship Date, Segment, Region, State, Category, Sub-Category, Sales, Profit, Quantity
- **Date Range:** January 2020 – July 2023

---

## 🎯 Dashboard Features

### 1. Executive KPI Cards
At-a-glance metrics with **Year-over-Year (YoY)** comparisons:

| Metric | Current | Previous Year | Change |
|--------|---------|---------------|--------|
| **Total Sales** | $2.33M | $1.58M | ⬆️ +47.23% |
| **Total Profit** | $292.30K | $196.30K | ⬆️ +48.90% |
| **% Returned Products** | 5.79% | 8.75% | ⬇️ -2.96% |

### 2. Sales Trend Analysis
- **Line Chart:** Monthly sales trend vs. previous year
- Shows consistent growth trajectory from 2020 through mid-2023
- Seasonal peaks visible around year-end periods

### 3. Profitability by Category
- **Bar Chart:** Profit breakdown by sub-category
- **Technology** sub-categories (Copiers, Phones, Accessories) show the highest profits
- **Tables** under Furniture shows a significant loss (negative profit)
- **Bookcases** also underperform within Furniture

### 4. Geographic Profitability
- **Filled Map:** Profit by U.S. state
- Identifies high-performing regions vs. underperforming states
- Enables geographic targeting for resource allocation

### 5. Sales by Customer Segment
- **Donut Chart:** Revenue distribution across segments
  - Consumer: **50.32%**
  - Corporate: **30.77%**
  - Home Office: **18.92%**

### 6. Interactive Filters & Slicers
The dashboard includes dynamic filters for:
- **Customer** (drill-down capability)
- **Region** (Central, East, South, West)
- **Segment** (Consumer, Corporate, Home Office)
- **Order Date** (custom date range selection)

> **Example:** When filtering to the **Corporate** segment:
> - Sales: $0.70M | Profit: $93.26K | Return Rate: 19.41%
> - YoY Sales Growth: +54.80% | YoY Profit Growth: +43.92%

---

## 🔍 Key Insights

1. **Strong Overall Growth:** Sales and profit both grew nearly 50% year-over-year, indicating healthy business expansion.

2. **Return Rate Improved:** The return rate dropped by 2.96 percentage points (from 8.75% to 5.79%), suggesting better product quality or customer targeting.

3. **Category Disparity:** Technology drives the most profit, while Furniture—specifically **Tables** and **Bookcases**—is a drag on profitability. Consider reviewing pricing or supplier agreements for loss-making sub-categories.

4. **Consumer Segment Dominance:** Over half of all sales come from Consumer customers, but Corporate shows the highest growth rate (+54.80% YoY), making it a key expansion opportunity.

5. **Geographic Opportunities:** The profit map reveals clear regional winners and losers—reallocate marketing spend toward high-profit states and investigate underperforming regions.

---

## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `Superstore Dashboard.JPG` | Full dashboard screenshot (unfiltered view) |
| `Superstore Dashboard Filter.JPG` | Dashboard with slicers active (Corporate segment filtered) |
| `Superstore Data.JPG` | Data model and table structure in Power BI |
| `Superstore_Analysis.pbix` | Power BI Desktop file *(if sharing)* |

---

## 🚀 How to View

1. Download the `.pbix` file 
2. Open in **Power BI Desktop** (free download)
3. Interact with slicers, hover over visuals, and explore the data

> **Note:** If you don't have Power BI Desktop, you can view the static screenshots above to see the full dashboard layout and insights.

---

## 🙋 About This Project

This project demonstrates:
- ✅ **Data Modeling:** Multi-table relationships with a dedicated date dimension
- ✅ **DAX Measures:** Custom KPIs with time intelligence (YoY, PY comparisons)
- ✅ **Interactive Design:** Slicers and filters for self-service exploration
- ✅ **Business Storytelling:** Dashboard layout designed for executive decision-making

---

*Created as part of a Data Analyst Portfolio.*
