# Plant Co. Performance Dashboard — Power BI

> **Advanced Power BI dashboard** featuring a dynamic metric selector, star schema data model, and time intelligence analysis to track Sales, Quantity, and Gross Profit performance with Year-over-Year comparisons.

---

## 📌 Business Problem

A plant retail company operates across multiple countries and product categories (Indoor, Landscape, Outdoor). Leadership needs a single, interactive dashboard to:

- Track performance across **Sales**, **Quantity**, and **Gross Profit** dynamically
- Compare **Year-to-Date (YTD)** vs **Prior Year-to-Date (PYTD)** performance
- Identify **which countries and product types** are driving or dragging performance
- Segment accounts by **profitability** (GP% vs volume) to prioritize high-value customers
- Analyze monthly trends and variance patterns across years

---

## 🛠️ Tools & Techniques

| Tool / Feature | Purpose |
|---------------|---------|
| **Power BI Desktop** | Dashboard design and DAX development |
| **Power Query** | Data transformation and star schema loading |
| **DAX** | Time intelligence, dynamic measures, SWITCH logic |
| **Star Schema** | Optimized data model for performance and scalability |
| **Waterfall Chart** | YTD vs PYTD variance decomposition by month |
| **Treemap** | Hierarchical country performance view |
| **Scatter Plot** | Account profitability segmentation (GP% vs YTD) |
| **Stacked Bar Chart** | Monthly YTD with PYTD overlay by product type |

---

## 🏗️ Data Model — Star Schema

The dashboard is built on a **star schema** for optimal query performance:

```
                    ┌─────────────┐
                    │  D_Date     │
                    │  (Time Dim) │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────┴────┐      ┌──────┴──────┐      ┌───┴────┐
   │D_Product│      │  Fact_Sales │      │D_Accounts│
   │(Product│◄────►│  (Fact Table)│◄────►│(Customer│
   │  Dim)  │      │              │      │  Dim)   │
   └─────────┘      └──────────────┘      └─────────┘
```

| Table | Type | Key Fields |
|-------|------|------------|
| **Fact_Sales** | Fact Table | Sales_USD, COGS_USD, quantity, Price_USD, Product_id, Account_id, Date_Time |
| **D_Product** | Dimension | Product_Family, Product_Group, Product_Name, Product_Size, Product_Type (Indoor/Landscape/Outdoor) |
| **D_Accounts** | Dimension | Account, country, country_code, latitude, longitude |
| **D_Date** | Dimension | Date, Inpast flag, Month, Year |
| **Slc_values** | Parameter | Values: "Sales", "Quantity", "Gross Profit" |
| **T_Measures** | Measure Group | All DAX calculations |

> **Why Star Schema?** Separates facts from dimensions, enabling faster aggregations, simpler DAX, and easier maintenance as the dataset grows.

---

## 🎯 Dashboard Components

### 1. Dynamic Metric Selector (DAX SWITCH)

Users can toggle between **Sales**, **Quantity**, and **Gross Profit** — all KPIs, charts, and variances update instantly without switching pages.

**The DAX SWITCH Measure:**
```dax
YTD = 
VAR selected_value = SELECTEDVALUE(Slc_values[Values])
VAR result = 
    SWITCH(selected_value,
        "Sales", [YTD_Sales],
        "Quantity", [YTD_Quantity],
        "Gross Profit", [YTD_Gross_Profit],
        BLANK()
    )
RETURN 
    result
```

**Time Intelligence Foundation:**
```dax
YTD_Sales = 
TOTALYTD( 
    [Sales],
    Fact_Sales[Date_Time]
)

PYTD_Sales = 
CALCULATE(
    [Sales],
    SAMEPERIODLASTYEAR(D_Date[Date]),
    D_Date[Inpast] = TRUE
)

YTD vs PYTD = [YTD] - [PYTD]
```

> 💡 **Technical Insight:** The `D_Date[Inpast] = TRUE` filter ensures PYTD only includes dates that have already occurred in the current year, preventing future dates from inflating the comparison.

---

### 2. Executive KPI Cards

| Metric | 2023 (Sales) | 2024 (Gross Profit) |
|--------|-------------|---------------------|
| **YTD** | $13.00M | €1.40M |
| **YTD vs PYTD** | -$512.26K 🔴 | -€77.62K 🔴 |
| **PYTD** | $13.51M | €1.47M |
| **GP%** | 39.62% | 39.15% |

> **Insight:** Both Sales and Gross Profit are underperforming vs. prior year. The consistent ~39% GP% suggests margin pressure is not the issue — volume/ demand is.

---

### 3. Country Performance (Treemap)

**Sales View (2023):**
- **China:** -$760.40K (largest negative variance)
- **Sweden:** -$240.09K
- **Poland:** -$112.00K
- **Netherlands:** -$96.72K

**Gross Profit View (2024):**
- **Canada:** -€41.99K
- **Germany:** -€25.51K
- **Japan:** -€19.91K
- **Croatia:** -€16.66K

> 💡 **Insight:** China dominates the negative variance in Sales, while Canada and Germany lead the Gross Profit decline. Different countries drive different metric underperformance — the dynamic selector reveals this instantly.

---

### 4. Monthly Variance Waterfall Chart

Decomposes **YTD vs PYTD** month by month:

**Sales (2023):**
- Strong start in January, but consistent declines from March onward
- Largest single-month drop: **-$350K** in November
- Only December shows a slight recovery (+$20K)

**Quantity (2023):**
- Positive momentum in Q1 (March: +13K units)
- Steep declines in Q2-Q3 (July: -7K, August: -8K)
- Partial recovery in Q4

> 💡 **Insight:** The waterfall reveals **when** the underperformance started (Q2) and which months contributed most to the gap — critical for root-cause analysis.

---

### 5. Monthly Trend by Product Type (Stacked Bar)

**Sales View (2023):**
| Month | Indoor | Landscape | Outdoor | PYTD |
|-------|--------|-----------|---------|------|
| Jan | ~0.4M | ~0.4M | ~0.4M | 1.2M |
| Nov | ~0.3M | ~0.3M | ~0.3M | 1.4M |

**Quantity View (2023):**
- Steady performance across all product types
- Outdoor category shows strongest absolute volume
- PYTD line tracks consistently above YTD bars

> 💡 **Insight:** All three product categories (Indoor, Landscape, Outdoor) contribute relatively evenly. No single category is collapsing — the issue is broad-based demand softness.

---

### 6. Account Profitability Segmentation (Scatter Plot)

Plots **GP% (Y-axis)** vs **YTD Volume (X-axis)** for each account:

- **High GP% + High Volume** (top-right): Ideal accounts — prioritize retention and expansion
- **High GP% + Low Volume** (top-left): Niche profitable accounts — consider upselling
- **Low GP% + High Volume** (bottom-right): Volume drains — negotiate better terms or reduce focus
- **Low GP% + Low Volume** (bottom-left): Consider deprioritizing

> 💡 **Insight:** The scatter plot with interactive sliders lets users dynamically filter accounts by GP% and YTD thresholds, enabling precise sales targeting.

---

## 🔍 Key Business Insights

1. **Broad-Based Underperformance:** YTD vs PYTD is negative across all three metrics (Sales, Quantity, Gross Profit), indicating a company-wide demand issue rather than a category-specific problem.

2. **Geographic Concentration of Risk:** China and Sweden drive the largest sales variances; Canada and Germany drive profit declines. Regional strategies should differ.

3. **Q2-Q3 Weakness:** The waterfall chart shows consistent monthly underperformance starting in April-May, suggesting a seasonal or macroeconomic factor rather than a one-time event.

4. **Margin Stability:** GP% holds steady at ~39% across years, meaning the company is not discounting heavily to drive volume. The problem is top-line demand, not pricing.

5. **Account Segmentation Opportunity:** The scatter plot reveals a wide dispersion in account profitability — sales teams should focus on high-GP%, high-volume accounts while reassessing low-GP relationships.

---

## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `Plant Co. Data Dashboard Sales.JPG` | Dashboard view — Sales metric selected (2023) |
| `Plant Co. Data Dashboard Profit 2014.JPG` | Dashboard view — Gross Profit metric selected (2024) |
| `Plant Co. Data Dashboard Quantity 2023.JPG` | Dashboard view — Quantity metric selected (2023) |
| `Plant Co. Data Model.JPG` | Star schema relationship diagram |
| `Plant Co. Data.JPG` | Fact_Sales table sample data |
| `Plant Co Dashboard.pbix` | Power BI Desktop file |

---

## 🎯 Skills Demonstrated

- ✅ **Star Schema Design:** Built a proper dimensional model with fact and dimension tables
- ✅ **DAX SWITCH Parameterization:** Dynamic metric selector enabling single-dashboard multi-metric analysis
- ✅ **Time Intelligence:** `TOTALYTD`, `SAMEPERIODLASTYEAR`, `CALCULATE` for period-over-period analysis
- ✅ **Advanced DAX:** Variables (`VAR`/`RETURN`), conditional logic, and context transition
- ✅ **Variance Analysis:** Waterfall charts for month-by-month YTD vs PYTD decomposition
- ✅ **Hierarchical Visualization:** Treemaps for multi-country performance comparison
- ✅ **Segmentation Analysis:** Scatter plots with interactive sliders for account profiling
- ✅ **Business Storytelling:** Dashboard designed for executive decision-making with clear insight hierarchy

---

## 🚀 How to Use

1. Download the `.pbix` file
2. Open in **Power BI Desktop**
3. Use the **metric selector** (top-left) to switch between Sales, Quantity, and Gross Profit
4. Use the **year slicer** to compare 2023 vs 2024
5. Interact with the **scatter plot sliders** to filter accounts by GP% and volume thresholds
6. Hover over waterfall bars to see month-level variance details

> **Note:** If you don't have Power BI Desktop, view the screenshots above to see all three metric views and the underlying data model.

---

*Created as part of a Data Analyst Portfolio.*
