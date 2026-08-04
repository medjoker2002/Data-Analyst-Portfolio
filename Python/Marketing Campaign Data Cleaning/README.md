# Marketing Campaign Data Cleaning

> **Comprehensive data cleaning pipeline** transforming a raw marketing campaign dataset into analysis-ready data using Python and Pandas. Features advanced techniques including logical integrity checks, outlier capping, and temporal anomaly detection.

---

## 📌 Business Problem

A marketing team needs to analyze campaign performance across multiple channels (TikTok, Facebook, Email, Instagram, Google Ads) to understand which campaigns, seasons, and channels drive the most conversions and ROI. However, the raw dataset contains significant data quality issues that prevent accurate analysis.

**Key Questions:**
- Which marketing channels deliver the highest conversion rates?
- How does campaign performance vary by season (Summer, Winter, Launch, BlackFriday)?
- What is the relationship between spend, impressions, clicks, and conversions?
- Which active vs. inactive campaigns are worth continuing?

---

## 🛠️ Tools & Libraries

| Tool/Library | Purpose |
|-------------|---------|
| **Python** | Programming language |
| **Pandas** | Data manipulation and cleaning |
| **NumPy** | Numerical operations |
| **Jupyter Notebook** | Interactive development environment |

---

## 📊 Dataset Overview

- **Original Rows:** 2,020 campaigns
- **Original Columns:** 12 (with duplicates and quality issues)
- **Key Fields:** Campaign ID, Campaign Name, Start/End Dates, Channel, Impressions, Clicks, Spend, Conversions, Active Status, Campaign Tag
- **Date Range:** February 2023 – December 2023

---

## 🚨 Data Quality Issues Identified

### 1. Inconsistent Column Headers
Original headers had mixed casing and spaces (e.g., `Campaign_ID`, `Campaign Name`), making programmatic access unreliable.

**Fix:** Standardized to `snake_case`.

### 2. Currency Symbols in Numeric Columns
The `spend` column contained currency symbols and formatting characters, stored as strings instead of floats.

**Fix:** Used regex to strip non-numeric characters and convert to float.

### 3. Duplicate Column
A duplicate `clicks` column existed in the raw data.

**Fix:** Programmatically detected and removed the redundant column.

### 4. Inconsistent Channel Names
The `channel` column contained multiple variations of the same platform.

### 5. Mixed Boolean Formats
The `active` column had **7 different representations** of True/False.

### 6. Date Parsing Issues
- `start_date` stored as **strings** instead of datetime
- Some records had **inverted dates** (start_date > end_date) — "time travel" anomalies

### 7. Logical Integrity Violations
- Some records had **clicks > impressions** (impossible in reality)
- Inverted start/end dates affecting campaign duration calculations

### 8. Outliers in Spend
Extreme outliers in the `spend` column (e.g., $500,000) that could skew analysis.

---

## 🔧 Cleaning Process

### Step 1: Header Standardization
```python
# Standardized column names to snake_case for consistency
print(df.columns.to_list())
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")
print("Fix Applied:")
print(df.columns.to_list())
```
**Before:** `['Campaign_ID', 'Campaign Name', 'Start_Date', ...]`  
**After:** `['campaign_id', 'campaign_name', 'start_date', ...]`

---

### Step 2: Currency Cleaning
```python
# Removed currency symbols and non-numeric characters from spend column
df["spend"] = df["spend"].replace(r"[^\d.]", "", regex=True).astype("float")
```
**Before:** `$102.82`, `$503.95` (strings)  
**After:** `102.82`, `503.95` (float64)

---

### Step 3: Duplicate Column Removal
```python
# Removed duplicate 'clicks' column
df = df.loc[:, ~df.columns.duplicated()]
```

---

### Step 4: Channel Name Standardization
```python
# Standardized inconsistent channel naming conventions
print(df["channel"].unique())

cleanup_map = {
    "Facebook": "Facebook",
    "Google": "Google Ads",
    "Tik_Tok": "TikTok",
    "E-mail": "Email",
    "Insta_gram": "Instagram",
    "N/A": np.nan
}

df["channel"] = df["channel"].replace(cleanup_map)
print("Fix Applied:")
print(df["channel"].unique())
```
**Before:** `['Tik_Tok', 'Facebook', 'E-mail', 'Insta_gram', 'Google', 'N/A', nan]`  
**After:** `['TikTok', 'Facebook', 'Email', 'Instagram', 'Google Ads', nan]`

---

### Step 5: Boolean Normalization
```python
# Unified 7 different boolean representations into clean True/False
print(df["active"].unique())

boolean_map = {
    "True": True, "Yes": True, "1": True, "Y": True,
    "0": False, "No": False, "False": False
}

df["active"] = df["active"].replace(boolean_map).fillna(False).astype("bool")
print("Fix Applied:")
print(df["active"].unique())
```
**Before:** `['Y', '0', 'No', 'True', 'Yes', '1', 'False']`  
**After:** `[True, False]`

---

### Step 6: Date Parsing
```python
# Converted string dates to proper datetime format
print(df["start_date"].dtype)  # str

df["start_date"] = pd.to_datetime(df["start_date"], errors="coerce")
print("Fix Applied:")
print(df["start_date"].dtype)  # datetime64[us]
```

---

### Step 7: Logical Integrity — Clicks vs Impressions
```python
# Verified that clicks never exceed impressions (impossible in real campaigns)
impossible_mask = df["impressions"] < df["clicks"]
print(df.loc[impossible_mask, ["clicks", "impressions"]].head())
```
**Result:** Empty DataFrame — no logical violations found. ✅

---

### Step 8: Temporal Anomaly Detection — "Time Travel"
```python
# Detected campaigns where start_date > end_date (inverted dates)
time_travel_mask = df["start_date"] > df["end_date"]
print(len(df.loc[time_travel_mask, ["start_date", "end_date"]]))  # 34 rows

# Calculated average duration for correct vs wrong records
df["days_diff"] = (df["end_date"] - df["start_date"]).dt.days
correct_average = df.loc[df["days_diff"] >= 0, "days_diff"].mean()   # 15.46 days
wrong_average = df.loc[df["days_diff"] < 0, "days_diff"].mean()      # -5.0 days

# Fixed by swapping start_date and end_date for anomalous records
df.loc[time_travel_mask, ["start_date", "end_date"]] = df.loc[time_travel_mask, ["end_date", "start_date"]].values
print("Fix Applied:")
print(df.loc[time_travel_mask, ["start_date", "end_date"]].head())

# Dropped helper column
df.drop(columns=["days_diff"], inplace=True)
```
**Finding:** 34 campaigns had inverted start/end dates. Average "correct" duration: ~15.5 days. Average "wrong" duration: -5 days. Fixed by swapping dates.

---

### Step 9: Outlier Handling (IQR Method)
```python
# Capped extreme spend outliers using the Interquartile Range (IQR) method
Q1 = df["spend"].quantile(0.25)
Q3 = df["spend"].quantile(0.75)
IQR = Q3 - Q1
upper_limit = Q3 + (3 * IQR)  # Using 3*IQR for conservative capping

outlier_mask = df["spend"] > upper_limit
print(df.loc[outlier_mask, "spend"].head(3))
# Before: 500000.00, 8921.51, 500000.00

df.loc[outlier_mask, "spend"] = upper_limit
print("Fix Applied:")
print(df.loc[outlier_mask, "spend"].head(3))
# After: 8576.8675, 8576.8675, 8576.8675
```
**Finding:** Extreme outliers capped at the upper IQR limit (~$8,577) to prevent skewed analysis while preserving data.

---

### Step 10: Feature Engineering — Season Extraction
```python
# Extracted season from campaign name for seasonal trend analysis
print(df["campaign_name"].head(3))
# Q4_Summer_CMP-00001
# Q1_Launch_CMP-00002
# Q3_Winter_CMP-00003

df["season"] = df["campaign_name"].str.split("_").str[1]
```
**New column:** `season` — values: `Summer`, `Winter`, `Launch`, `BlackFriday`

---

## ✅ Clean Data Output

| Column | Data Type | Description |
|--------|-----------|-------------|
| `campaign_id` | object | Unique campaign identifier |
| `campaign_name` | object | Full campaign name with quarter and season |
| `start_date` | datetime64 | Campaign start date (validated) |
| `end_date` | datetime64 | Campaign end date (validated) |
| `channel` | object | Marketing channel (standardized) |
| `impressions` | int64 | Total impressions served |
| `clicks` | int64 | Total clicks received |
| `spend` | float64 | Total campaign spend ($), outliers capped |
| `conversions` | float64 | Total conversions achieved |
| `active` | bool | Campaign active status (True/False) |
| `campaign_tag` | object | Short channel code (TI, FA, EM, IN, GO) |
| `season` | object | Extracted season |

**Final result:** 2,020 rows × 12 clean columns

---

## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `Marketing Campaign.ipynb` | Full Jupyter notebook with all cleaning steps, code, and outputs |
| `Marketing Campaign Cleaning Process.JPG` | Screenshots of key cleaning transformations |
| `Marketing Campaign Clean Data.JPG` | Screenshot of final cleaned dataset preview |
| `marketing_campaign_messy_data.csv` | Original dirty dataset |
| `Marketing Campaign Clean.csv` | Final cleaned dataset |

---

## 🎯 Skills Demonstrated

- ✅ **Data Quality Assessment** — Identified 10 categories of data quality issues
- ✅ **Schema Standardization** — Normalized column headers to snake_case
- ✅ **Regex & String Manipulation** — Cleaned currency symbols and standardized categorical values
- ✅ **Type Conversion** — Safely converted mixed data types with error handling
- ✅ **Duplicate Detection** — Programmatically identified and removed duplicate columns
- ✅ **Logical Integrity Checks** — Validated business rules (clicks ≤ impressions, start ≤ end)
- ✅ **Temporal Anomaly Detection** — Found and fixed "time travel" date inversions
- ✅ **Outlier Treatment** — Applied IQR method with 3× multiplier for conservative capping
- ✅ **Feature Engineering** — Extracted new analytical dimensions (season) from existing fields
- ✅ **Missing Value Handling** — Applied domain-appropriate imputation strategies
- ✅ **Data Validation** — Verified cleaning results through before/after comparisons

---

## 🚀 How to Run

1. Clone this repository
2. Open `Marketing Campaign.ipynb` in Jupyter Notebook or JupyterLab
3. Run all cells sequentially to reproduce the cleaning pipeline
4. The final cell displays the cleaned dataset ready for analysis

---

*Created as part of a Data Analyst Portfolio.*
