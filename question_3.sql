

SELECT
product_name,
year_date_from,
CONCAT(MIN (difference),'%') AS min_dif
	FROM (SELECT
		product_name, 
		average_price_by_year,
		year_date_from,
		round(((average_price_by_year - LAG(average_price_by_year) OVER 
		(PARTITION BY product_name ORDER BY year_date_from))/LAG(average_price_by_year)
		OVER (PARTITION BY product_name ORDER BY year_date_from))*100,0) AS difference
	FROM t_jakub_kucera_project_sql_primary_final tjkpspf
	GROUP BY product_name, year_date_from 
	ORDER BY product_name
	) AS subqery
WHERE difference IS NOT NULL
GROUP BY product_name, year_date_from
ORDER BY MIN (difference)

/*
Největší procentuální pokles cen
*/


SELECT 
product_name,
CONCAT(difference,'%')
	FROM (SELECT
		product_name, 
		average_price_by_year,
		year_date_from,
		round(((average_price_by_year - LAG(average_price_by_year) OVER 
		(PARTITION BY product_name ORDER BY year_date_from))/LAG(average_price_by_year)
		OVER (PARTITION BY product_name ORDER BY year_date_from))*100,0) AS difference
	FROM t_jakub_kucera_project_sql_primary_final
	WHERE 
		year_date_from IN (2006, 2018)
	GROUP BY product_name, year_date_from
	) AS subqery
WHERE difference IS NOT NULL
ORDER BY difference

/*
Pokles nárůst cen mezi roky 2006 a 2018