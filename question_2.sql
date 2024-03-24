
SELECT
	payroll_year,
	product_name,
	price_unit,
	average_price_by_year,
	ROUND(avg(average_payroll_by_year),0) AS avg_avg_payroll,
	ROUND((ROUND(AVG(average_payroll_by_year), 0)/average_price_by_year),0) AS price_to_payroll_ratio
FROM t_jakub_kucera_project_SQL_primary_final
WHERE
	product_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované') AND
	payroll_year IN(2006,2018)
GROUP BY product_name , payroll_year