# Pizza Sales Dashboard — Excel Analytics

> **Interactive Excel Dashboard** analyzing pizza sales performance across time, categories, sizes, and individual products to uncover ordering patterns and revenue drivers.
>
> 🔍 *SQL validation layer included to verify Excel calculations against large datasets.*

---

## 📌 Business Problem

A pizza restaurant chain wants to understand its sales performance to optimize operations, inventory, and marketing. Key questions:

- What are the peak days and hours for orders?
- Which pizza categories and sizes generate the most revenue?
- What are the best-selling and worst-selling pizzas?
- How does customer ordering behavior vary by time of day?
- What is the average order value and how many pizzas do customers order per transaction?

---

## 🛠️ Tools & Techniques

| Tool / Feature | Purpose |
|---------------|---------|
| **Microsoft Excel** | Data modeling, analysis, and dashboard design |
| **Power Pivot / Data Model** | Structured data table for efficient aggregation |
| **Pivot Tables** | Hourly trends, size distribution, top/bottom sellers |
| **Pivot Charts** | Visual representations of pivot table data |
| **Slicers** | Interactive date filtering (month-level) |
| **SQL** | Cross-validation of Excel calculations on large datasets |
| **Conditional Formatting** | Visual highlights in data tables |
| **Custom Dashboard Layout** | Professional UI with themed colors and insight callouts |

---

## 📊 Dataset Overview

- **Source:** Pizza sales transactional data
- **Rows:** Individual pizza orders
- **Date Range:** January 2015 – September 2015
- **Key Fields:**
  - `order_id` — Unique order identifier
  - `pizza_name_id` — Product code
  - `quantity` — Pizzas per line item
  - `order_date` — Date of order
  - `Day` — Day of week
  - `order_time` — Timestamp of order
  - `unit_price` / `total_price` — Pricing
  - `pizza_size` — S, M, L, XL, XXL
  - `pizza_category` — Classic, Veggie, Supreme, Chicken
  - `pizza_ingredients` — Full ingredient list
  - `pizza_name` — Product name

---

## 🎯 Dashboard Components

### 1. Executive KPI Cards
At-a-glance business metrics:

| Metric | Value (All Periods) | Value (Filtered)* |
|--------|---------------------|-------------------|
| **Total Revenue** | $817,860.05 | $273,246.40 |
| **Total Pizzas Sold** | 49,574 | 16,557 |
| **Total Orders** | 21,350 | 16,232 |
| **Avg Order Value** | $38.31 | $16.83 |
| **Avg Pizzas Per Order** | 2.32 | 1.02 |

> *Filtered view shows a subset of months (e.g., June–September 2015), demonstrating slicer interactivity.

### 2. Daily & Hourly Trend Analysis

**Daily Trend for Sales (Bar Chart)**
- Friday leads with **3,538** pizzas sold
- Saturday follows with **3,158**
- Sunday is the lowest at **2,624**
- Weekdays (Mon–Thu) are relatively consistent (~2,800–3,000)

**Hourly Trend for Sales (Line Chart)**
- Peak hours: **12 PM (2,520)** and **1 PM (2,455)** — lunch rush
- Secondary peak: **5–7 PM (1,920–2,399)** — dinner rush
- Lowest activity: **9–10 AM** and **after 10 PM**

> 💡 **Insight:** Orders are highest on weekend days (Friday & Saturday evenings). Maximum orders come from 12–1 PM and 5–8 PM.

### 3. Sales by Category

**% Sales by Category (Donut Chart)**
| Category | Share |
|----------|-------|
| Classic | ~26% |
| Supreme | ~25% |
| Veggie | ~25% |
| Chicken | ~24% |

**Total Pizzas Sold by Category (Bar Chart)**
| Category | Pizzas Sold |
|----------|-------------|
| Classic | 14,888 |
| Supreme | 11,987 |
| Veggie | 11,649 |
| Chicken | 11,050 |

> 💡 **Insight:** Classic category is the highest in total sales, though all four categories are fairly balanced.

### 4. Sales by Size

**% Sales by Size (Pie Chart)**
| Size | Share |
|------|-------|
| L (Large) | 45.89% |
| M (Medium) | 30.49% |
| S (Small) | 21.77% |
| XL | 1.72% |
| XXL | 0.12% |

> 💡 **Insight:** Large is the highest-selling size by a significant margin. XL and XXL are niche offerings.

### 5. Best & Worst Sellers

**Top 5 Best Sellers by Orders**
| Rank | Pizza | Orders |
|------|-------|--------|
| 1 | The Classic Deluxe Pizza | 2,453 |
| 2 | The Barbecue Chicken Pizza | 2,432 |
| 3 | The Hawaiian Pizza | 2,422 |
| 4 | The Pepperoni Pizza | 2,418 |
| 5 | The Thai Chicken Pizza | 2,371 |

**Bottom 5 (Worst) Sellers by Orders**
| Rank | Pizza | Orders |
|------|-------|--------|
| 1 | The Brie Carre Pizza | 490 |
| 2 | The Mediterranean Pizza | 934 |
| 3 | The Calabrese Pizza | 937 |
| 4 | The Spinach Supreme Pizza | 950 |
| 5 | The Soppresata Pizza | 961 |

> 💡 **Insight:** Chicken pizzas dominate the top sellers. The Brie Carre Pizza is the worst performer with only 490 orders — consider removing it from the menu or running a promotion.

### 6. Interactive Slicer

A **month-level date slicer** allows users to filter the entire dashboard dynamically:
- View performance for specific months (e.g., June–September 2015)
- All KPIs, charts, and rankings update automatically
- Demonstrates self-service exploration capabilities

---

## 🔍 SQL Validation Layer

To ensure accuracy when working with large datasets, all Excel calculations were **cross-validated with SQL queries**. This dual-tool approach guarantees data integrity and demonstrates proficiency in both Excel and SQL.

**What was validated:**
- Total revenue, total orders, and total pizzas sold
- Average order value and average pizzas per order
- Hourly and daily aggregation totals
- Category and size distribution percentages
- Top 5 and bottom 5 product rankings

**Why this matters:**
- ✅ Prevents calculation errors in Excel formulas
- ✅ Proves ability to write SQL aggregation queries (`SUM`, `AVG`, `COUNT`, `GROUP BY`)
- ✅ Shows understanding of how to reconcile results across tools
- ✅ Demonstrates analytical rigor — a key trait for data analyst roles

---

## 🏗️ Workbook Structure

| Sheet | Purpose |
|-------|---------|
| `pizza_sales` | Raw transactional data table |
| `Pivot` | Pivot tables powering the dashboard charts (hourly trends, size %, top/bottom sellers) |
| `SQL KPI` | SQL query results used to validate Excel KPI calculations |
| `Dashboard` | Final interactive dashboard with charts, KPIs, slicers, and insight callouts |

---

## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `Pizza Sales Dashboard.JPG` | Full dashboard screenshot (all periods, unfiltered) |
| `Pizza Sales Dashboard Filter.JPG` | Dashboard with month slicer active (filtered subset) |
| `Pizza Sales Data.JPG` | Raw data table structure and sample rows |
| `Pizza Sales Pivot.JPG` | Pivot tables behind the dashboard visuals |
| `Pizza Sales Dashboard.xlsx` | Excel workbook file *(if sharing)* |

---

## 🎯 Skills Demonstrated

- ✅ **Data Modeling:** Structured raw data into an Excel Table for dynamic referencing
- ✅ **Pivot Table Mastery:** Built multiple pivot tables for trend, distribution, and ranking analysis
- ✅ **Dashboard Design:** Created a visually polished, themed dashboard with clear hierarchy
- ✅ **Interactivity:** Implemented slicers for dynamic filtering and self-service exploration
- ✅ **SQL Validation:** Wrote aggregation queries to independently verify Excel calculations
- ✅ **Business Storytelling:** Embedded insight callouts that translate data into actionable recommendations
- ✅ **KPI Calculation:** Computed custom metrics (Avg Order Value, Avg Pizzas Per Order)

---

## 🚀 How to Use

1. Download the `.xlsx` file
2. Open in **Microsoft Excel** (2016 or later recommended for full slicer support)
3. Navigate to the **Dashboard** sheet
4. Use the **month slicer** to filter by specific time periods
5. All charts and KPIs update dynamically

> **Note:** If you don't have Excel, you can view the static screenshots above to see the full dashboard layout, insights, and data structure.

---

*Created as part of a Data Analyst Portfolio.*

