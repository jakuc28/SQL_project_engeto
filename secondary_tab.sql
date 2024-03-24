/*
tvorba druhé požadované tabulky
*/

CREATE TABLE t_jakub_kucera_project_SQL_secondary_final
	SELECT
		c.country,
		e.GDP,
		e.`year`, 
		e. gini,
		e. taxes
	FROM countries c
	LEFT JOIN economies e 
	ON c. country = e.country 
	WHERE c.country = 'Czech Republic' AND GDP IS NOT NULL 


	
/*
kontrola primární tabulky
*/
	
SELECT*
FROM t_jakub_kucera_project_SQL_primary_final