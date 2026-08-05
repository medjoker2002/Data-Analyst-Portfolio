# 15 Days of Learning SQL

> **Source:** [HackerRank](https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem) | **Difficulty:** Hard | **Concept:** Window Functions + Streak Filtering

---

## 📝 Problem Statement

Find the hacker who made the **maximum number of submissions each day** during a 15-day learning streak. Only consider hackers who submitted code on **all 15 consecutive days** (March 1–15, 2016).

---

## 🧠 Approach

1. Counted submissions per hacker per day within the 15-day window
2. Used `COUNT(*) OVER(PARTITION BY hacker_id)` to identify hackers with a full 15-day streak
3. Ranked hackers by submission count per day using `ROW_NUMBER()`
4. Selected the top hacker for each day

---

## 💻 Solution

```sql
WITH subs_count AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) AS no_subs
    FROM submissions
    WHERE submission_date <= "2016-03-15"
    GROUP BY 1, 2
),
streaks AS (
    SELECT 
        submission_date,
        hacker_id,
        no_subs,
        COUNT(*) OVER(PARTITION BY hacker_id) AS streak
    FROM subs_count
),
ranked AS (
    SELECT 
        submission_date,
        hacker_id,
        no_subs,
        ROW_NUMBER() OVER(
            PARTITION BY submission_date 
            ORDER BY no_subs DESC, hacker_id
        ) AS rn
    FROM streaks
    WHERE streak = 15
)
SELECT
    submission_date,
    hacker_id,
    no_subs
FROM ranked
WHERE rn = 1;
```

---

## 🔑 Key Technique Explained

This combines **streak validation** with **per-day ranking**:

- `COUNT(*) OVER(PARTITION BY hacker_id)` counts how many distinct days each hacker submitted — filtering `streak = 15` guarantees only full-streak participants
- `ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY no_subs DESC, hacker_id)` creates a daily leaderboard, using `hacker_id` as a tiebreaker
- The two window functions operate at different granularities (hacker-level vs. day-level), demonstrating multi-level analytical thinking

---

## 🎯 Why This Matters

- **Gamification analytics:** Identifying power users in learning platforms (Duolingo, Codecademy)
- **Engagement streaks:** Finding users with consistent daily habits for retention programs
- **Leaderboards:** Daily top-performer tracking with eligibility constraints
- **Challenge campaigns:** Measuring participation in time-bound corporate training

---

## 🏷️ Tags

`#window-functions` `#row-number` `#count-over` `#streak-filtering` `#leaderboard` `#daily-ranking`


---

# Consecutive Filing Years

> **Source:** DataLemur | **Difficulty:** Hard | **Concept:** Window Functions — Gap & Islands Pattern

---

## 📝 Problem Statement

Find all users who filed taxes using TurboTax for **3 or more consecutive years**. A user is considered a loyal filer if they have an unbroken streak of annual filings.

---

## 🧠 Approach

1. Filtered for TurboTax product filings only
2. Used `ROW_NUMBER()` partitioned by `user_id` to assign a sequential number to each filing year
3. Calculated a `streak_group` by subtracting the row number from the filing year — consecutive years produce identical group values
4. Grouped by `user_id` and `streak_group` to count streak lengths
5. Filtered for users with at least one streak of 3+ consecutive years

---

## 💻 Solution

```sql
WITH filing_group AS (
    SELECT 
        user_id,
        YEAR(filing_date) - ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY filing_id) AS streak_group
    FROM filed_taxes
    WHERE product LIKE "TurboTax%"
),
filing_streaks AS (
    SELECT 
        user_id,
        streak_group,
        COUNT(*) AS streak_length
    FROM filing_group
    GROUP BY user_id, streak_group
)
SELECT
    user_id
FROM filing_streaks
WHERE streak_length > 2
GROUP BY user_id;
```

---

## 🔑 Key Technique Explained

The **gap and islands** pattern is one of the most elegant SQL techniques for detecting consecutive sequences. Here's the intuition:

| user_id | filing_year | row_num | streak_group (year - row_num) |
|---------|-------------|---------|-------------------------------|
| 1 | 2020 | 1 | 2019 |
| 1 | 2021 | 2 | 2019 |
| 1 | 2022 | 3 | 2019 |
| 1 | 2024 | 4 | 2020 | ← gap! different group |

All consecutive years share the same `streak_group`. A gap (missing 2023) breaks the pattern, producing a new group. This makes streak detection as simple as `COUNT(*) GROUP BY streak_group`.

---

## 🎯 Why This Matters

- **Retention analysis:** Identifying loyal customers vs. churned users
- **Subscription businesses:** Finding users with uninterrupted service
- **Compliance tracking:** Ensuring continuous filing/reporting behavior
- **Sales forecasting:** Loyal streak users are higher-lifetime-value targets

---

## 🏷️ Tags

`#window-functions` `#row-number` `#gap-and-islands` `#streak-detection` `#user-retention`


---

# Google Median Search Frequency

> **Source:** DataLemur | **Difficulty:** Hard | **Concept:** Window Functions — Running Totals & Median Calculation

---

## 📝 Problem Statement

Calculate the **median number of searches** per user from a frequency distribution table. The table contains `searches` (number of searches) and `users` (count of users with that many searches). MySQL does not have a built-in `MEDIAN()` function.

---

## 🧠 Approach

1. Calculated a **running total** of users ordered by search count (ascending)
2. Calculated the **total user count** across all search frequencies
3. Identified the row(s) where the running total crosses the 50% threshold (`total / 2`)
4. Averaged the search counts of the boundary row(s) to compute the median

---

## 💻 Solution

```sql
WITH ranks AS (
    SELECT 
        searches,
        users,
        SUM(users) OVER(ORDER BY searches ASC) AS running_total,
        SUM(users) OVER() AS total
    FROM google_searches_median
)
SELECT 
    AVG(searches) AS median_searches
FROM ranks
WHERE total <= 2 * running_total
  AND total >= 2 * (running_total - users);
```

---

## 🔑 Key Technique Explained

When you don't have a `MEDIAN()` function, you can derive it from a **cumulative distribution**:

- Sort all values by frequency
- Track the running count of observations
- The median sits at the point where the running total crosses 50% of all observations

The `WHERE` clause captures the boundary condition:
- `total <= 2 * running_total` → the running total is at least half
- `total >= 2 * (running_total - users)` → removing this bucket drops below half

This elegantly handles both **odd** and **even** total counts by averaging boundary values.

---

## 🎯 Why This Matters

- **A/B testing:** Median is robust to outliers compared to mean
- **User behavior analysis:** Median session depth, median order value
- **Performance metrics:** Median response time (better than average for skewed distributions)
- **Any platform without native MEDIAN():** This technique works in MySQL, SQLite, and older SQL Server versions

---

## 🏷️ Tags

`#window-functions` `#running-totals` `#median` `#percentile` `#frequency-distribution`


---

# Human Traffic of Stadium

> **Source:** [LeetCode](https://leetcode.com/problems/human-traffic-of-stadium/) | **Difficulty:** Hard | **Concept:** Window Functions — Gap & Islands Pattern

---

## 📝 Problem Statement

Find all dates with **high attendance (> 99 people)** that occur in **consecutive streaks of 3 or more days**. Return the id, visit date, and attendance for those dates.

---

## 🧠 Approach

1. Filtered for high-attendance days (> 99 people)
2. Assigned row numbers to the filtered set
3. Applied the **gap and islands** pattern: `id - ROW_NUMBER()` creates consistent groups for consecutive sequences
4. Used `COUNT(*) OVER(PARTITION BY streak_grp)` to measure streak length
5. Filtered for streaks of 3+ days

---

## 💻 Solution

```sql
WITH high_attendance AS (
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY id) AS rn
    FROM stadium_traffic
    WHERE people > 99
),
streaks AS (
    SELECT 
        id, 
        visit_date, 
        people, 
        id - rn AS streak_grp
    FROM high_attendance
),
streaks_count AS (
    SELECT 
        id, 
        visit_date, 
        people, 
        streak_grp,
        COUNT(*) OVER(PARTITION BY streak_grp) AS streak_len 
    FROM streaks
)
SELECT 
    id, 
    visit_date, 
    people
FROM streaks_count
WHERE streak_len > 2;
```

---

## 🔑 Key Technique Explained

This is a **pure gap-and-islands** application:

| id | people | rn | streak_grp (id - rn) | streak_len |
|----|--------|----|----------------------|------------|
| 2  | 110    | 1  | 1                    | 3          |
| 3  | 150    | 2  | 1                    | 3          |
| 4  | 99     | —  | —                    | —          | ← filtered out (gap)
| 5  | 145    | 3  | 2                    | 2          | ← streak too short
| 6  | 1455   | 4  | 2                    | 2          |

When consecutive rows are truly consecutive in `id`, `id - rn` remains constant. Any gap breaks the group. `COUNT(*) OVER(PARTITION BY streak_grp)` then measures each island's length.

---

## 🎯 Why This Matters

- **Event detection:** Finding consecutive anomaly days in IoT sensor data
- **Traffic analysis:** Identifying sustained high-traffic periods for capacity planning
- **Healthcare monitoring:** Detecting consecutive days of abnormal vital signs
- **Retail analytics:** Finding consecutive high-sales days for staffing optimization

---

## 🏷️ Tags

`#window-functions` `#row-number` `#gap-and-islands` `#consecutive-detection` `#event-analysis` `#streak-filtering`

---

# Server Utilization

> **Source:** DataLemur | **Difficulty:** Hard | **Concept:** Window Functions — Time-Delta Calculation

---

## 📝 Problem Statement

Calculate the **total number of full days** a server was running. The log table records `start` and `stop` events with timestamps. Compute the cumulative runtime and convert to full days.

---

## 🧠 Approach

1. Used `LAG()` to pair each `stop` event with its preceding `start` event
2. Calculated the time difference in seconds between consecutive timestamps
3. Summed all session durations and converted to days (`/ 3600 / 24`)

---

## 💻 Solution

```sql
WITH lagged AS (
    SELECT 
        server_id,
        status_time,
        session_status,
        LAG(status_time) OVER (PARTITION BY server_id ORDER BY status_time) AS prev_time
    FROM server_utilization
)
SELECT 
    FLOOR(
        SUM(TIMESTAMPDIFF(SECOND, prev_time, status_time)) / (3600 * 24)
    ) AS total_full_days
FROM lagged
WHERE session_status = 'stop';
```

---

## 🔑 Key Technique Explained

This is a classic **event-pairing** pattern:

- `LAG(status_time)` retrieves the previous timestamp for each server
- By filtering `WHERE session_status = 'stop'`, we only calculate duration at the end of each session
- `TIMESTAMPDIFF(SECOND, prev_time, status_time)` gives the exact session length
- `FLOOR(... / 86400)` converts seconds to full days

This pattern applies to any **start/stop event logging**: server uptime, user sessions, machine runtime, etc.

---

## 🎯 Why This Matters

- **Infrastructure monitoring:** Tracking server uptime for SLA compliance
- **Cost optimization:** Identifying underutilized servers for shutdown
- **Session analytics:** Measuring average user session duration
- **IoT analytics:** Calculating device active time from event logs

---

## 🏷️ Tags

`#window-functions` `#lag` `#time-delta` `#session-duration` `#infrastructure-monitoring`
