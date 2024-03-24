

SELECT
   name,
   payroll_year,
   average_payroll_by_year
FROM t_jakub_kucera_project_SQL_primary_final
WHERE payroll_year = 2018 OR payroll_year = 2006
GROUP BY name, payroll_year 

/*
rozdíl mezi předochozím rokem a zárvoeň odstranení kladných a NULL hodnot
*/

SELECT
   name,
   payroll_year,
   average_payroll_by_year,
   difference
FROM (
    SELECT
        name,
        payroll_year,
        average_payroll_by_year,
        average_payroll_by_year - LAG(average_payroll_by_year) OVER (PARTITION BY name ORDER BY payroll_year) AS difference
    FROM t_jakub_kucera_project_SQL_primary_final
    GROUP BY name, payroll_year
) AS subquery
WHERE difference < 0;

/*
Počet případu kdy je meziroční rozdíl záporný
*/

SELECT
    COUNT(*) AS count_negative_differences
FROM (
    SELECT
        name,
        payroll_year,
        average_payroll_by_year,
        average_payroll_by_year - LAG(average_payroll_by_year) OVER (PARTITION BY name ORDER BY payroll_year) AS difference
    FROM t_jakub_kucera_project_SQL_primary_final
    GROUP BY name, payroll_year
) AS subquery
WHERE difference < 0;

CREATE TABLE test_count AS
	SELECT
	   name,
	   payroll_year,
	   average_payroll_by_year,
	   difference
	FROM (
	    SELECT
	        name,
	        payroll_year,
	        average_payroll_by_year,
	        average_payroll_by_year - LAG(average_payroll_by_year) OVER (PARTITION BY name ORDER BY payroll_year) AS difference
	    FROM t_jakub_kucera_project_SQL_primary_final
	    GROUP BY name, payroll_year
	) AS subquery
	WHERE difference < 0;

/*
Kolikrát došlo ke snížení mezd v daném období
*/

SELECT
	name,	
	COUNT (name)
FROM test_count
GROUP BY name

SELECT
	name,
	payroll_year,
	MIN (difference)
FROM test_count