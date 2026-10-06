##Overall Customer Churn
SELECT 
	COUNT(*) AS Total_Customers,
	SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers;

## Churn by Contract Type
USE customer_churn_analysis;

SELECT Contract_Type,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
	ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY Contract_Type
ORDER BY Churn_Rate DESC;

##Churn by Tenure
SELECT

    CASE
        WHEN Tenure_Months <= 6 THEN '0-6 Months'
        WHEN Tenure_Months <= 12 THEN '7-12 Months'
        WHEN Tenure_Months <= 24 THEN '13-24 Months'
        WHEN Tenure_Months <= 36 THEN '25-36 Months'
        ELSE '37+ Months'
    END AS Tenure_Group,

    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY
    CASE
        WHEN Tenure_Months <= 6 THEN '0-6 Months'
        WHEN Tenure_Months <= 12 THEN '7-12 Months'
        WHEN Tenure_Months <= 24 THEN '13-24 Months'
        WHEN Tenure_Months <= 36 THEN '25-36 Months'
        ELSE '37+ Months'
    END
ORDER BY Churn_Rate DESC;

##Churn by Plan Type
SELECT Plan_Type,
	COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY Plan_Type
ORDER BY Churn_Rate DESC;

##Churn by Payment Method
SELECT Payment_Method,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY Payment_Method
ORDER BY Churn_Rate DESC;

##Churn by City
SELECT City,
    COUNT(*) AS Total_Customers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY City
HAVING COUNT(*) >= 500
ORDER BY Churn_Rate DESC;

##Revenue Associated With Churned Customers
SELECT
    COUNT(*) AS Churned_Customers,
    ROUND(SUM(Monthly_Charges),2) AS Churned_Monthly_Revenue
FROM customers
WHERE Churn = 'Yes';

##High-Value Churned Customers
WITH revenue_segments AS (

SELECT
        Customer_ID,
        Monthly_Charges,
        Churn,

NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers
)

SELECT
	COUNT(*) AS High_Value_Churned_Customers,
	ROUND(SUM(Monthly_Charges),2) AS High_Value_Churned_Revenue
FROM revenue_segments
WHERE Revenue_Quartile = 4 AND Churn = 'Yes';
  
##Risk-Level Analysis
SELECT

    CASE
        WHEN Risk_Score >= 7 THEN 'High'
        WHEN Risk_Score >= 4 THEN 'Medium'
        ELSE 'Low'
    END AS Risk_Level,

    COUNT(*) AS Total_Customers,
	SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY
    CASE
        WHEN Risk_Score >= 7 THEN 'High'
        WHEN Risk_Score >= 4 THEN 'Medium'
        ELSE 'Low'
    END
ORDER BY Churn_Rate DESC;

##High-Risk Active Customers
SELECT

    Customer_ID,
    City,
    Contract_Type,
    Plan_Type,
    Tenure_Months,
    Satisfaction_Score,
    Support_Calls,
    Complaints,
    Monthly_Charges,
    Risk_Score,

    CASE
        WHEN Risk_Score >= 7 THEN 'High'
        WHEN Risk_Score >= 4 THEN 'Medium'
        ELSE 'Low'
    END AS Risk_Level,

    Churn

FROM customers
WHERE Churn = 'No'AND Risk_Score >= 7
ORDER BY
    Risk_Score DESC,
    Monthly_Charges DESC
LIMIT 20;

##High-Risk + High-Revenue Customers
WITH revenue_segments AS (
SELECT *,
NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers
)

SELECT
    Customer_ID,
    City,
    Contract_Type,
    Plan_Type,
    Tenure_Months,
    Satisfaction_Score,
    Support_Calls,
    Complaints,
    Monthly_Charges,
    Risk_Score,
    Revenue_Quartile

FROM revenue_segments
WHERE Churn = 'No'
  AND Risk_Score >= 7
  AND Revenue_Quartile = 4
ORDER BY
    Risk_Score DESC,
    Monthly_Charges DESC
LIMIT 20;

##Revenue Exposure From High-Risk Customers
WITH revenue_segments AS (

SELECT *,
NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers
)

SELECT
    COUNT(*) AS High_Risk_Active_Customers,
    ROUND(SUM(Monthly_Charges), 2) AS Monthly_Revenue_Exposure
FROM revenue_segments
WHERE Churn = 'No'
  AND Risk_Score >= 7
  AND Revenue_Quartile = 4;
