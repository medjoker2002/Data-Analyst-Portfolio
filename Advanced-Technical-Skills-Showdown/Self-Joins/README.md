# Active User Retention

> **Source:** [DataLemur](https://datalemur.com/questions/user-retention) | **Difficulty:** Hard | **Concept:** Self-Joins — Month-over-Month Retention

---

## 📝 Problem Statement

Calculate the number of **active users retained month-over-month**. An active user is defined as someone who performed a sign-in, like, or comment in a given month. Retention means the user was also active in the previous month.

---

## 🧠 Approach

1. Identified active users per month (users with `sign-in`, `like`, or `comment` events)
2. Self-joined the monthly active user set on `current_month = previous_month + 1`
3. Counted users from the previous month who appear in the current month (retained users)

---

## 💻 Solution

```sql
WITH act_users AS (
    SELECT 
        MONTH(event_date) AS month,
        user_id
    FROM lemur.users_retention
    WHERE event_type IN ("sign-in", "like", "comment")
    GROUP BY MONTH(event_date), user_id
)
SELECT
    c.month,
    COUNT(p.user_id) AS active_users
FROM act_users c 
LEFT JOIN act_users p
    ON c.user_id = p.user_id
    AND c.month = p.month + 1
GROUP BY month;
```

---

## 🔑 Key Technique Explained

This is the classic **cohort retention** pattern using a self-join:

- `c` = current month active users
- `p` = previous month active users
- `LEFT JOIN` + `c.month = p.month + 1` matches users who were active in **both** months
- `COUNT(p.user_id)` only counts users who existed in the previous month (retained)

The `LEFT JOIN` ensures we see all current-month users, while the count of non-NULL `p.user_id` values gives us retention. This is the foundation of **cohort analysis** used by every SaaS and subscription business.

---

## 🎯 Why This Matters

- **SaaS metrics:** Monthly Active User (MAU) retention is a core KPI
- **Product analytics:** Identifying which features drive stickiness
- **Marketing ROI:** Measuring whether acquired users stay engaged
- **Churn prediction:** Declining retention is an early warning signal

---

## 🏷️ Tags

`#self-join` `#retention` `#cohort-analysis` `#mau` `#month-over-month`


---

# Reactivated Users

> **Source:** [DataLemur](https://datalemur.com/questions/reactivated-users) | **Difficulty:** Hard | **Concept:** Self-Joins — Gap Detection

---

## 📝 Problem Statement

Identify **reactivated users** each month — users who were inactive in the previous month but logged in again in the current month. Month 1 counts all users as reactivated (baseline).

---

## 🧠 Approach

1. Identified unique login months per user
2. Used a `LEFT JOIN` to check if the user was active in the previous month (`month - 1`)
3. Users with `NULL` in the previous month are reactivated
4. Counted reactivated users per month

---

## 💻 Solution

```sql
WITH monthly_active AS (
    SELECT 
        user_id,
        MONTH(login_date) AS mth
    FROM user_logins
    GROUP BY user_id, MONTH(login_date)
),
reactivated AS (
    SELECT 
        m.mth,
        m.user_id,
        CASE
            WHEN m.mth = 1 THEN 1
            ELSE prev1.user_id 
        END AS prv1
    FROM monthly_active m
    LEFT JOIN monthly_active prev1 
        ON m.user_id = prev1.user_id 
        AND m.mth = prev1.mth + 1
)
SELECT 
    mth,
    COUNT(CASE WHEN prv1 IS NULL THEN 1 END) AS reactivated_count
FROM reactivated
GROUP BY mth
ORDER BY mth;
```

---

## 🔑 Key Technique Explained

This is the **inverse of retention analysis** — instead of finding who stayed, we find who **returned after leaving**:

- `prev1.user_id IS NULL` means the user was **NOT** active in the previous month
- The `CASE` statement handles Month 1 (all users are baseline reactivated)
- `COUNT(CASE WHEN prv1 IS NULL THEN 1 END)` counts only returning users

Reactivation analysis is crucial for understanding **win-back campaign effectiveness** and **seasonal user behavior**.

---

## 🎯 Why This Matters

- **Win-back campaigns:** Measure if lapsed users return after email/promo campaigns
- **Seasonal products:** Identify users who return during peak seasons
- **Product relaunches:** Track if dormant users come back after feature updates
- **Revenue recovery:** Reactivated users often have higher conversion than cold leads

---

## 🏷️ Tags

`#self-join` `#reactivation` `#gap-detection` `#user-engagement` `#win-back`
