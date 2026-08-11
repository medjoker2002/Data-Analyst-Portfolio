# Advanced Technical Skills Showcase

> A curated collection of **hard-level SQL and analytics problems** solved across DataLemur, HackerRank, LeetCode, and Maven Analytics. Organized by concept.

---

## 📊 Overview

| Platform | Difficulty | Problems | Key Techniques |
|----------|------------|----------|--------------|
| **DataLemur** | Hard | 8 | Recursive CTEs, Window Functions, Self-Joins, Conditional Logic |
| **HackerRank** | Hard | 1 | Streak Filtering, Daily Ranking |
| **LeetCode** | Hard | 2 | Multi-Table Filtering, Gap & Islands |
| **Maven Analytics** | Hard | Multi-Tool | Cross-tool proficiency on identical business problems |

---

## 🗂️ By Concept

### Window Functions
| Problem | Source | File | Key Technique |
|---------|--------|------|---------------|
| Consecutive Filing Years | DataLemur | [`consecutive-filing-years.sql`](Window-Functions/consecutive-filing-years.sql) | `ROW_NUMBER()` streak detection with gap analysis |
| Google Median Search Frequency | DataLemur | [`google-median.sql`](Window-Functions/google-median.sql) | Running totals + median from frequency table |
| Server Utilization | DataLemur | [`server-utilization.sql`](Window-Functions/server-utilization.sql) | `LAG()` for time-delta between start/stop events |
| Human Traffic of Stadium | LeetCode | [`human-traffic-stadium.sql`](Window-Functions/human-traffic-stadium.sql) | Gap & islands for consecutive high-attendance days |
| 15 Days of Learning SQL | HackerRank | [`15-days-learning.sql`](Window-Functions/15-days-learning.sql) | Multi-level window functions (streak + daily rank) |

### Recursive CTEs
| Problem | Source | File | Key Technique |
|---------|--------|------|---------------|
| Pizza Topping Combinations | DataLemur | [`pizza-topping-cost.sql`](Recursive-CTEs/pizza-topping-cost.sql) | Combinatorial generation (3-topping pizzas) |
| Repeated Payments Detection | DataLemur | [`repeated-payments.sql`](Recursive-CTEs/repeated-payments.sql) | Sequential duplicate detection with time window |

### Self-Joins & Retention
| Problem | Source | File | Key Technique |
|---------|--------|------|---------------|
| Active User Retention | DataLemur | [`active-users-retention.sql`](Self-Joins/active-users-retention.sql) | Self-join on `month + 1` for MoM retention |
| Reactivated Users | DataLemur | [`reactivated-users.sql`](Self-Joins/reactivated-users.sql) | Gap detection to identify returning inactive users |

### Multi-Table Filtering & Aggregation
| Problem | Source | File | Key Technique |
|---------|--------|------|---------------|
| Trips Cancellation Rate | LeetCode | [`trips-cancellation-rate.sql`](Conditional-Logic/trips-cancellation-rate.sql) | Double self-join + conditional aggregation |
| Updated User Status | DataLemur | [`updated-status.sql`](Conditional-Logic/updated-status.sql) | `CASE` statements with payment aggregation |

### Cross-Tool Proficiency (Maven Analytics)

- Check README file inside the Maven-Analytics-Data-Drills folder for the full list of drills with a short description of each one.

> 🏆 **Maven Analytics drills are solved in all 4 tools**.

---

## 🎯 Skills Demonstrated

- ✅ **Window Functions:** `ROW_NUMBER()`, `LAG()`, `DENSE_RANK()`, `SUM() OVER()`, `COUNT() OVER()`
- ✅ **Recursive CTEs:** Tree traversal, combinatorial generation, sequential pattern detection
- ✅ **Self-Joins:** Time-series gap analysis, retention cohorts, reactivation tracking
- ✅ **Time Intelligence:** `TIMESTAMPDIFF()`, date arithmetic, period-over-period analysis
- ✅ **Conditional Aggregation:** `CASE` + `COUNT/SUM` for business-state mapping
- ✅ **Median/Percentile Calculation:** Frequency-distribution approach without native functions
- ✅ **Gap & Islands Pattern:** Streak detection using `ROW_NUMBER()` offset technique
- ✅ **Multi-Table Integrity:** Double joins, referential validation, composite filtering
- ✅ **Cross-Tool Execution:** Same business problem solved with SQL, Excel, Power BI, and Python

---

## 🚀 How to Use

Each `.sql` file contains the solution query. Each folder's `README.md` contains:
1. **Problem statement** — what we're solving and why
2. **Approach** — step-by-step reasoning
3. **Solution** — the full query with comments
4. **Key technique explained** — the core concept in plain English
5. **Business value** — why this matters in real analytics work

**Problem URLs are included** for authenticity and verification.

---

*Part of a Data Analyst Portfolio.*
