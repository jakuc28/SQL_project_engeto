/*
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/


SELECT
description,
payroll_year,
difference_payroll_prc,
difference_price_prc,
CONCAT(difference_GDP,'%') AS difference_GDP_prc
FROM(SELECT
	description,
	GDP,
	payroll_year,
	round(((GDP - LAG(GDP) OVER 
				(PARTITION BY description ORDER BY payroll_year))/LAG(GDP)
				OVER (PARTITION BY description ORDER BY GDP))*100,0) AS difference_GDP,
	CONCAT(difference_payroll,'%') AS difference_payroll_prc,
	CONCAT(difference_price,'%') AS difference_price_prc
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
	JOIN t_jakub_kucera_project_sql_secondary_final sect
		ON sect.`year`= payroll_year
	ORDER BY payroll_year
)AS subqery_c