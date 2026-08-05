SELECT * FROM lemur.filed_taxes;

WITH filing_group as
(
	SELECT 
		user_id,
        year(filing_date) - ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY filing_id) streak_group
    FROM filed_taxes
    WHERE product LIKE "TurboTax%"
),
filing_streaks as
(
	SELECT 
		user_id,
        streak_group,
        count(*) streak_length
    FROM filing_group
    GROUP BY user_id, streak_group
)
	SELECT
		user_id
	FROM filing_streaks
    WHERE streak_length > 2
    GROUP BY user_id