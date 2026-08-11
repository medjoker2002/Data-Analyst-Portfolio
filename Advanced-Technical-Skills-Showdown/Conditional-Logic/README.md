# Updated User Status

> **Source:** [DataLemur](https://datalemur.com/questions/updated-status) | **Difficulty:** Hard | **Concept:** Conditional Logic — Business-State Mapping

---

## 📝 Problem Statement

Update user status based on payment history:
- **CHURN:** User has paid $0 or has no payment record
- **RESURRECT:** User was previously marked as CHURN but has now made a payment
- **EXISTING:** User has an active payment history and was not churned

---

## 🧠 Approach

1. Aggregated total payments per user from the payments table
2. Joined payment totals with the status updates table
3. Applied business rules using nested `CASE` statements:
   - No payment → CHURN
   - Was CHURN + has payment → RESURRECT
   - Otherwise → EXISTING

---

## 💻 Solution

```sql
WITH day_payments AS (
    SELECT 
        user_id,
        SUM(paid) AS paid 
    FROM payments
    GROUP BY user_id
)
SELECT  
    s.user_id,
    CASE 
        WHEN paid = 0 OR paid IS NULL THEN "CHURN"
        WHEN s.status = "CHURN" THEN "RESURRECT"
        ELSE "EXISTING"
    END AS updated_status
FROM status_updates s
LEFT JOIN day_payments p 
    ON s.user_id = p.user_id;
```

---

## 🔑 Key Technique Explained

This demonstrates **state-machine logic in SQL**:

- The `CASE` statement evaluates conditions in order (like an `if-elseif-else` chain)
- `paid = 0 OR paid IS NULL` handles both zero-payment users and users with no payment records
- `s.status = "CHURN"` checks the *previous* state before upgrading to RESURRECT
- The `ELSE` catch-all ensures every user gets a valid status

This pattern is the backbone of **customer lifecycle management**, **subscription state tracking**, and **user segmentation pipelines**.

---

## 🎯 Why This Matters

- **Subscription billing:** Automated status updates for SaaS platforms
- **CRM systems:** Tracking customer lifecycle stages
- **Churn prediction:** Identifying at-risk users for intervention campaigns
- **Revenue reporting:** Segmenting revenue by customer state (new, existing, resurrected)

---

# Trips and Users Cancellation Rate

> **Source:** [LeetCode](https://leetcode.com/problems/trips-and-users/description/) | **Difficulty:** Hard | **Concept:** CTEs + Conditional Aggregation + Multi-Table Filtering

---

## 📝 Problem Statement

Calculate the **cancellation rate** of trips by unbanned users each day. A trip is cancelled if its status is not `'completed'`. Exclude trips where either the client or driver is banned.

---

## 🧠 Approach

1. Filtered trips to the target date range and joined with Users table twice (client + driver)
2. Excluded trips where either party was banned
3. Calculated daily totals and cancelled counts using conditional `CASE` aggregation
4. Computed cancellation rate with proper decimal handling

---

## 💻 Solution

```sql
WITH unbanned_trips AS (
    SELECT 
        t.request_at AS day,
        t.status,
        t.client_id,
        t.driver_id
    FROM Trips t
    LEFT JOIN Users c ON t.client_id = c.users_id
    LEFT JOIN Users d ON t.driver_id = d.users_id
    WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
      AND c.banned = 'No'
      AND d.banned = 'No'
),
daily_stats AS (
    SELECT 
        day,
        COUNT(*) AS total_requests,
        COUNT(CASE WHEN status != 'completed' THEN 1 END) AS canceled_requests
    FROM unbanned_trips
    GROUP BY day
    HAVING COUNT(*) > 0
)
SELECT 
    day,
    ROUND(canceled_requests * 1.0 / total_requests, 2) AS "Cancellation Rate"
FROM daily_stats
ORDER BY day;
```

---

## 🔑 Key Technique Explained

This demonstrates **multi-table integrity filtering** and **conditional aggregation**:

- **Double self-join pattern:** Joining the same `Users` table twice (aliased as `c` and `d`) to validate both client and driver independently
- **Conditional COUNT:** `COUNT(CASE WHEN status != 'completed' THEN 1 END)` counts only cancelled trips without needing a subquery
- `* 1.0` forces decimal division in MySQL (integer division would truncate to 0)
- `HAVING COUNT(*) > 0` ensures we only report days with valid (unbanned) trip data

---

## 🎯 Why This Matters

- **Ride-sharing platforms:** Uber/Lyft cancellation rate is a core operational KPI
- **Marketplace trust:** Filtering out banned users ensures metrics reflect legitimate activity
- **Service quality monitoring:** Daily cancellation tracking for SLA compliance
- **Fraud detection:** Unusual cancellation spikes from unbanned users may indicate coordinated attacks
