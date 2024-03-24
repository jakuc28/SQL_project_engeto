/*
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Rok ve kteríém by byl nárůst cen o 10 % větší než byl nárůst mezd ve sledovaném období neexistuje.

Největší rozdíl mezi násrustem cen potravin a cen mezd byl v roce mezi roky 2012 a 2013 kdy došlo k poklesu mezd o 2% a nárůstu cen potravin o 6 %.
*/

	
SELECT
description,
payroll_year,
CONCAT(difference_payroll,'%') AS difference_payroll_prc,
CONCAT(difference_price,'%') AS difference_price_prc,
CONCAT(difference_price - difference_payroll ,'%') AS diff_payroll_price
FROM (SELECT
	description,
	payroll_year,
	round(((avg_avg_payroll - LAG(avg_avg_payroll) OVER 
			(PARTITION BY description ORDER BY payroll_year))/LAG(avg_avg_payroll)
			OVER (PARTITION BY description ORDER BY payroll_year))*100,0) AS difference_payroll,
	round(((avg_avg_price - LAG(avg_avg_price) OVER 
			(PARTITION BY description ORDER BY avg_avg_price))/LAG(avg_avg_price)
			OVER (PARTITION BY description ORDER BY payroll_year))*100,0) AS difference_price
	FROM (SELECT
		'Průměrná cena potravin a výše mzdy' AS description,	
		payroll_year,
		ROUND(avg(average_payroll_by_year),0) AS avg_avg_payroll,
		ROUND(avg(average_price_by_year),0) AS avg_avg_price
		FROM t_jakub_kucera_project_sql_primary_final
		GROUP BY payroll_year
	) AS subqery_a
) AS subqery_b