




-------------------------------------------------------------------------------------------------------------------
---------------------------------------- LEFT/FULL/CROSS join Statements in SQL------------------------------------
-------------------------------------------------------------------------------------------------------------------

SELECT * FROM proj1_Opportunities
SELECT * FROM [proj1-accounts]



----left join



SELECT a.*, b.New_Account_Name, b.Industry
FROM
	(
	SELECT New_Account_No, Opportunity_ID, New_Opportunity_Name, Est_Completion_Month_ID, Product_Category, Opportunity_Stage, Est_Opportunity_Value FROM proj1_Opportunities
	) a 

	LEFT JOIN
	(
	SELECT New_Account_No, New_Account_Name, Industry FROM [proj1-accounts]
	) b 
	ON a.New_Account_No = b.New_Account_No




	-- Exm 2: FULL JOIN




SELECT ISNULL(a.New_Account_No, b.New_Account_No) AS New_Account_No,
ISNULL(a.Opportunity_ID, 'No opportunities') AS Opportunity_ID,
a.New_Opportunity_Name, a.Est_Completion_Month_ID, a.Product_Category, a.Opportunity_Stage, a.Est_Opportunity_Value ,
b.New_Account_Name, b.Industry
FROM
	(
	SELECT New_Account_No, Opportunity_ID, New_Opportunity_Name, Est_Completion_Month_ID, Product_Category, Opportunity_Stage, Est_Opportunity_Value FROM proj1_Opportunities
	) a 

	FULL JOIN
	(
	SELECT New_Account_No, New_Account_Name, Industry FROM [proj1-accounts]
	) b 
	ON a.New_Account_No = b.New_Account_No





-- Exm 3: CROSS JOIN


SELECT * FROM proj1_Opportunities


SELECT a.*, b.*
FROM
	(
	SELECT Product_Category, SUM(Est_Opportunity_Value) AS BASELINE FROM  proj1_Opportunities
	WHERE Est_Completion_Month_ID = (SELECT MAX(Est_Completion_Month_ID)-2 FROM proj1_Opportunities)
	GROUP BY Product_Category
	) a

	CROSS JOIN
	(
	SELECT DISTINCT Fiscal_Month FROM proj1_Calendar_lookup WHERE Fiscal_Year = 'FY19' AND [Date] > (SELECT GETDATE()+30)
	) b







-------------------------------------------------------------------------------------------------------------------
---------------------------------------- UNION ALL Statements in SQL-----------------------------------------------
-------------------------------------------------------------------------------------------------------------------






