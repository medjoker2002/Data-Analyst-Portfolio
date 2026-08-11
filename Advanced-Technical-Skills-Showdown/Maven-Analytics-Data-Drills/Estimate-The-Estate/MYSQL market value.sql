use data_drill;

WITH avg_price_per_sqft AS (

    SELECT
        zip_code,
        building_class,
        AVG(sale_price / square_feet) AS avg_price_per_sqft
    FROM manhattan_property_sales
    WHERE sale_price != 0
      AND square_feet > 0
    GROUP BY zip_code, building_class
),
mrkt_vls AS
(
	SELECT
		p.address,
		p.zip_code,
		p.building_class,
		p.square_feet,
		p.sale_price,
		CASE
			WHEN p.sale_price = 0 THEN
				ROUND(
					p.square_feet * aps.avg_price_per_sqft,
					0
				)
			ELSE
				p.sale_price
		END AS market_value
	FROM manhattan_property_sales AS p
	LEFT JOIN avg_price_per_sqft AS aps
		   ON p.zip_code = aps.zip_code
		  AND p.building_class = aps.building_class
)
SELECT count(*) values_over_15m
FROM mrkt_vls
WHERE market_value > 15000000