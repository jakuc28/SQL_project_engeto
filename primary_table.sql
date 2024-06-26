CREATE TABLE t_jk_average_year_payroll_by_category AS
	SELECT
		cpib.name,
		ROUND(AVG(cp. value),0) AS average_payroll_by_year,
		cp. payroll_year 
	FROM czechia_payroll cp 	
	JOIN czechia_payroll_industry_branch cpib 
		ON cp.industry_branch_code = cpib.code 
	WHERE value_type_code = 5958 AND calculation_code = 100
	GROUP BY cp. payroll_year, cpib.name
	ORDER BY cpib.name, payroll_year 

CREATE TABLE t_jk_average_year_price_by_category_avg_value AS
	SELECT
		cprc. name, 
		cprc. price_value,
		cprc.price_unit,
		ROUND(AVG(cpr. value),0) AS average_price_by_year,
		YEAR (cpr. date_from) AS year_date_from
	FROM czechia_price cpr 
	LEFT JOIN czechia_price_category cprc 
		ON cpr.category_code = cprc.code
	GROUP BY YEAR (cpr. date_from), cprc.name 
	ORDER BY name, year_date_from
	
/*
kontrola tabulky cen
*/
	
ALTER TABLE t_jk_average_year_price_by_category_avg_value RENAME COLUMN name TO product_name;
	
/*	
tvorba první požadované tabulky
*/

CREATE TABLE t_jakub_kucera_project_SQL_primary_final AS
	SELECT* 
	FROM t_jk_average_year_price_by_category_avg_value price
	JOIN t_jk_average_year_payroll_by_category pay
		ON pay.payroll_year = price.year_date_from
	ORDER BY product_name, pay.name, payroll_year