# Pizza Topping Combinations

> **Source:** [DataLemur](https://datalemur.com/questions/pizzas-topping-cost) | **Difficulty:** Hard | **Concept:** Recursive CTEs — Combinatorial Generation

---

## 📝 Problem Statement

Generate **all possible 3-topping pizza combinations** from a list of available toppings, along with their total ingredient cost. Toppings must be combined in alphabetical order (no duplicates, no permutations).

---

## 🧠 Approach

1. **Anchor member:** Start with each individual topping as a 1-topping "pizza"
2. **Recursive member:** Join the current combinations with available toppings that come **alphabetically after** the last topping added
3. **Termination condition:** Stop when `level = 3` (3 toppings reached)
4. **Final select:** Filter for only level-3 combinations and display total cost

---

## 💻 Solution

```sql
WITH RECURSIVE pizzas AS (
    -- Anchor: each topping as a 1-topping pizza
    SELECT 
        topping_name AS last_topping,
        topping_name AS pizza,
        ingredient_cost AS pizza_cost,
        1 AS level
    FROM pizzas_topping_cost

    UNION ALL

    -- Recursive: add next topping alphabetically
    SELECT 
        i.topping_name AS last_topping,
        CONCAT(pizza, ",", topping_name) AS pizza,
        pizza_cost + ingredient_cost AS pizza_cost,
        level + 1 AS level
    FROM pizzas p
    INNER JOIN pizzas_topping_cost i
        ON p.last_topping < i.topping_name
        AND p.level < 3
)
SELECT 
    pizza,
    pizza_cost
FROM pizzas
WHERE level = 3;
```

---

## 🔑 Key Technique Explained

Recursive CTEs are typically used for **hierarchical data** (org charts, bill of materials), but they're equally powerful for **combinatorial generation**:

- The `p.last_topping < i.topping_name` condition ensures alphabetical ordering, preventing duplicates like (Pepperoni, Mushroom) and (Mushroom, Pepperoni)
- `p.level < 3` is the recursion guard — without it, the query would run forever
- Each recursion level builds on the previous, accumulating cost and concatenating names

This is essentially generating combinations in SQL without any procedural code.

---

## 🎯 Why This Matters

- **Product configuration:** Generating valid product bundles from component options
- **Menu engineering:** Calculating costs for all possible meal combinations
- **Recommendation engines:** Finding all valid product pairings within constraints
- **SQL-only solutions:** When you can't use Python/R for combinatorial tasks

---

## 🏷️ Tags

`#recursive-cte` `#combinatorics` `#product-bundles` `#cost-analysis` `#alphabetical-ordering`


---

# Repeated Payments Detection

> **Source:** [DataLemur](https://datalemur.com/questions/repeated-payments) | **Difficulty:** Hard | **Concept:** Recursive CTEs — Duplicate Detection with Time Window

---

## 📝 Problem Statement

Detect **duplicate payments** — transactions with the same merchant, credit card, and amount that occur within **10 minutes** of each other. Only flag transactions after the first one in each sequence as duplicates.

---

## 🧠 Approach

1. Numbered transactions within each `(merchant, credit_card, amount)` group by timestamp
2. Used a **recursive CTE** to traverse the sequence and flag duplicates
3. A transaction is a duplicate if it's within 10 minutes of the previous non-duplicate transaction

---

## 💻 Solution

```sql
WITH RECURSIVE numbered AS (
    SELECT 
        transaction_id,
        merchant_id,
        credit_card_id,
        amount,
        transaction_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY merchant_id, credit_card_id, amount 
            ORDER BY transaction_timestamp ASC
        ) AS rn
    FROM transactions
),
recursive_cte AS (
    -- Anchor: first transaction in each group is never a duplicate
    SELECT 
        transaction_id, merchant_id, credit_card_id, amount,
        transaction_timestamp, rn,
        CAST('No' AS CHAR(3)) AS duplicate
    FROM numbered
    WHERE rn = 1

    UNION ALL

    -- Recursive: check next transaction against previous non-duplicate
    SELECT 
        n.transaction_id, n.merchant_id, n.credit_card_id, n.amount,
        n.transaction_timestamp, n.rn,
        CASE 
            WHEN r.duplicate = 'No' 
                 AND TIMESTAMPDIFF(MINUTE, r.transaction_timestamp, n.transaction_timestamp) < 10 
            THEN 'Yes' 
            ELSE 'No' 
        END AS duplicate
    FROM recursive_cte r
    JOIN numbered n 
        ON n.merchant_id = r.merchant_id
        AND n.credit_card_id = r.credit_card_id
        AND n.amount = r.amount
        AND n.rn = r.rn + 1
)
SELECT 
    COUNT(*) AS duplicates_count
FROM recursive_cte
WHERE duplicate = "Yes";
```

---

## 🔑 Key Technique Explained

This combines **recursive traversal** with **stateful logic**:

- The anchor sets the first transaction as non-duplicate
- Each recursive step compares the next transaction to the **last non-duplicate** (not just the previous row)
- `TIMESTAMPDIFF(MINUTE, ...) < 10` defines the duplicate window
- The `duplicate` flag propagates through the chain, ensuring only the **first** transaction in a burst is kept

This is more sophisticated than a simple `LAG()` because it handles **chains of duplicates** (e.g., 3 payments in 5 minutes).

---

## 🎯 Why This Matters

- **Fraud detection:** Identifying accidental or malicious duplicate charges
- **Payment reconciliation:** Preventing revenue leakage from double-charges
- **E-commerce:** Fixing checkout bugs that create duplicate orders
- **Financial auditing:** Ensuring transaction integrity

---

## 🏷️ Tags

`#recursive-cte` `#duplicate-detection` `#time-window` `#fraud-detection` `#payment-processing`
