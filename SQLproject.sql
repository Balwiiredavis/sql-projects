SELECT * FROM [Marketing Raw Data]

SELECT * FROM [Revenue Raw Data]

SELECT * FROM [Targets Raw Data]

SELECT * FROM [ipi_Calendar_lookup(1)]

SELECT * FROM ipi_account_lookup




----- what is the total revenue of the company in 2021-------

---SELECT * FROM [Revenue Raw Data]


---SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21'


SELECT sum(Revenue) AS Total_revenue_2021 FROM [Revenue Raw Data]
WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')



-----what is the total revenue of the company in 2020 -------

---SELECT * FROM [Revenue Raw Data]

--SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy17'

SELECT sum(Revenue) AS Total_revenue_2020 FROM [Revenue Raw Data]
WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy20')


------what is the total revenue performance by year ------



SELECT a.Total_revenue_2021 ,b.Total_revenue_2020,a.Total_revenue_2021 - b.Total_revenue_2020 AS Dollar_Dif_YoY,a.Total_revenue_2021 / b.Total_revenue_2020 - 1 AS perc_Dif_YoY
FROM


	(
	SELECT sum(Revenue) AS Total_revenue_2021 FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
	---GROUP BY Month_ID

	)a,


	(
	SELECT sum(Revenue) AS Total_revenue_2020 FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID - 12 FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21'))
	----GROUP BY Month_ID

	)b

----SELECT DISTINCT Month_ID - 12 FROM [Revenue Raw Data]
----WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')



----- WHAT IS THE MONTH OVER MONTH PERFORMANCE BETWEEN THE LAST TWO MONTHS ------



SELECT Total_revenue1 ,Total_revenue2,Total_revenue1 - Total_revenue2 AS Dollar_Dif_YoY,Total_revenue1 / Total_revenue2 - 1 AS perc_Dif_YoY
FROM
	(
	SELECT SUM(Revenue) AS Total_revenue1 FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT MAX (Month_ID) FROM [ipi_Calendar_lookup(1)])
	)a,

	(
	SELECT SUM(Revenue) AS Total_revenue2 FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT MAX (Month_ID) - 1 FROM [ipi_Calendar_lookup(1)])
	)b



-------- what is the total revenue VS Target performance for 2021-------



----SELECT * FROM [Revenue Raw Data]


----SELECT * FROM [Targets Raw Data]


----SELECT * FROM [ipi_Calendar_lookup(1)]


SELECT Total_revenue_2021 ,Target_performance_21,Total_revenue_2021 - Target_performance_21 AS Dollar_Dif_YoY,Total_revenue_2021 / Target_performance_21 AS perc_Dif_YoY
FROM
	(
	SELECT sum(Revenue) AS Total_revenue_2021 FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
	)a,

	(
	SELECT SUM(Target) AS Target_performance_21 FROM [Targets Raw Data]
	WHERE Month_ID IN ((SELECT DISTINCT Month_ID FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')))
	)b




------what is the total revenue VS Target performance per month--------


SELECT a.Month_ID, Total_revenue ,Target_performance,Total_revenue - Target_performance AS Dollar_Dif_YoY,Total_revenue / Target_performance AS perc_Dif_YoY
FROM
	(
	SELECT Month_ID,
	SUM(Revenue) AS Total_revenue FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
	GROUP BY Month_ID
	)a

    LEFT JOIN

	(
	SELECT Month_ID, 
	SUM(Target) AS Target_performance FROM [Targets Raw Data]
	WHERE Month_ID IN ((SELECT DISTINCT Month_ID FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')))
	GROUP BY Month_ID
	)b
	ON a.Month_ID = b.Month_ID




-----what is the best performing product by revenue in 2021-------------



-----SELECT * FROM [Revenue Raw Data]


SELECT Product_Category,SUM(Revenue) AS revenue2021 FROM [Revenue Raw Data]
WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
GROUP BY Product_Category





-------What is the product performance Vs Target for the month-----


SELECT a.Product_Category,a.Month_ID, revenue ,Target,revenue - Target AS Dollar_Dif_YoY,revenue / Target AS perc_Dif_YoY
FROM
    (
	SELECT Product_Category,Month_ID,SUM(Revenue) AS revenue FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT MAX (Month_ID)  FROM [Revenue Raw Data] )
	GROUP BY Product_Category , Month_ID
	)a
	LEFT JOIN
	(
	SELECT Product_Category,Month_ID, 
		SUM(Target) AS Target FROM [Targets Raw Data]
		WHERE Month_ID IN (SELECT MAX (Month_ID)  FROM [Revenue Raw Data] )
		GROUP BY Product_Category , Month_ID

	)b
	ON a.Product_Category = b.Product_Category AND a.Month_ID = b.Month_ID






-----best performing account by revenue in 2021------


---SELECT * FROM [Revenue Raw Data]

SELECT Account_No FROM [Revenue Raw Data]
WHERE Revenue IN (SELECT MAX (Revenue)  FROM [Revenue Raw Data])


SELECT Account_No,New_Account_Name,MAXREVENUE
FROM
	(
	SELECT Account_No,SUM(Revenue) AS MAXREVENUE FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
	GROUP BY Account_No
	---ORDER BY MAXREVENUE DESC
	)a
	LEFT JOIN
	(
	SELECT * FROM ipi_account_lookup) b
	ON A.Account_No = B.New_Account_No



----OPPORTUNITY WITH HIGHEST POTENTIAL 

SELECT TOP 5 * FROM [ipi_Opportunities_Data(1)]
WHERE Est_Completion_Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
ORDER BY Est_Completion_Month_ID DESC





-----Account with most revenue by marketing expenditure

SELECT ISNULL (a.Account_No, b.Account_No) AS Account_No,ttrevenue, ttmarketing, ISNULL (ttrevenue,0)/ NULLIF (ISNULL (ttmarketing,0),0) AS revenue_per_expenditure
FROM

	(SELECT Account_No,SUM(Revenue) AS ttrevenue FROM [Revenue Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
	GROUP BY Account_No)a


	FULL JOIN

	(
	SELECT Account_No,SUM(Marketing_Spend) AS ttmarketing FROM [Marketing Raw Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID  FROM [ipi_Calendar_lookup(1)] where Fiscal_Year = 'fy21')
	GROUP BY Account_No) b
	ON a.Account_No = b.Account_No
	ORDER BY  ISNULL (ttrevenue,0)/ NULLIF (ISNULL (ttmarketing,0),0) DESC


