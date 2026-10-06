CREATE DATABASE customer_churn_analysis;

USE customer_churn_analysis;

-- Create the Customer Table 
CREATE TABLE customers (
    Customer_ID VARCHAR(20),
    Age INT,
    Gender VARCHAR(20),
    City VARCHAR(50),
    Tenure_Months INT,
    Contract_Type VARCHAR(30),
    Plan_Type VARCHAR(30),
    Monthly_Charges DECIMAL(10,2),
    Total_Charges DECIMAL(12,2),
    Payment_Method VARCHAR(50),
    Internet_Service VARCHAR(20),
    Support_Calls INT,
    Complaints INT,
    Satisfaction_Score INT,
    Discount_Percent DECIMAL(5,2),
    Referral VARCHAR(10),
    Churn VARCHAR(10),
    Risk_Score INT,
    Risk_Level VARCHAR(20)
);

SELECT * FROM customers LIMIT 10;

-- 1 TOTAL CUSTOMER
SELECT COUNT(*) AS total_customers FROM customers;

-- 2 Churned Customers
SELECT COUNT(*) AS churned_customers
FROM customers
WHERE Churn = 'Yes';

-- 3 Overall Churn Rate
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_rate
FROM customers;

-- 4 Churn By Contract
SELECT
    Contract_Type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_rate
FROM customers
GROUP BY Contract_Type
ORDER BY churn_rate DESC;

-- 5 Churn by Plan
SELECT
    Plan_Type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_rate
FROM customers
GROUP BY Plan_Type
ORDER BY churn_rate DESC;

-- 6 Churn by City
SELECT
    City,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_rate
FROM customers
GROUP BY City
ORDER BY churn_rate DESC;

-- 7 Churn by Payment Method
SELECT
    Payment_Method,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_rate
FROM customers
GROUP BY Payment_Method
ORDER BY churn_rate DESC;

 -- 8 Revenue Associated with Churned Customers
SELECT
    ROUND(SUM(Monthly_Charges), 2) AS churned_monthly_revenue
FROM customers
WHERE Churn = 'Yes';

-- 9 Revenue by Contract Type
SELECT
    Contract_Type,
    COUNT(*) AS total_customers,
    ROUND(SUM(Monthly_Charges), 2) AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN Monthly_Charges ELSE 0 END),2) AS churned_monthly_revenue
FROM customers
GROUP BY Contract_Type
ORDER BY churned_monthly_revenue DESC;

-- 10 High-Value Churned Customers
SELECT
    Monthly_Charges
FROM customers
ORDER BY Monthly_Charges;

WITH ranked_customers AS (
    SELECT
        Customer_ID,
        Monthly_Charges,
        Churn,
        NTILE(4) OVER (ORDER BY Monthly_Charges) AS revenue_quartile
    FROM customers
)
SELECT
    COUNT(*) AS high_value_churned_customers,
    ROUND(SUM(Monthly_Charges), 2) AS high_value_churned_revenue
FROM ranked_customers
WHERE revenue_quartile = 4
AND Churn = 'Yes';
  

## CUSTOMER TENURE SEGMENTATION
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

## HAVING: Find High-Churn Cities
SELECT
    City,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM customers
GROUP BY City
HAVING COUNT(*) >= 500 AND
   SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) > 21.92
ORDER BY Churn_Rate DESC;

## CTE: CHURN BY CONTRACT
WITH contract_analysis AS (
    SELECT
        Contract_Type,
        COUNT(*) AS Total_Customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers
    FROM customers
    GROUP BY Contract_Type
)

SELECT
    Contract_Type,
    Total_Customers,
    Churned_Customers,
    ROUND(
        Churned_Customers * 100.0 / Total_Customers,2) AS Churn_Rate
FROM contract_analysis
ORDER BY Churn_Rate DESC;

## ABOVE-AVERAGE REVENUE CUSTOMERS
SELECT
    Customer_ID,
    Contract_Type,
    Plan_Type,
    Monthly_Charges,
    Churn
FROM customers
WHERE Monthly_Charges >
(SELECT AVG(Monthly_Charges)
FROM customers)
ORDER BY Monthly_Charges DESC;
SELECT AVG(Monthly_Charges)
FROM customers

## RANK CUSTOMERS BY REVENUE
SELECT
    Customer_ID,
    Contract_Type,
    Plan_Type,
    Monthly_Charges,
    RANK() OVER (
ORDER BY Monthly_Charges DESC) AS Revenue_Rank
FROM customers
ORDER BY Revenue_Rank
LIMIT 20;

SELECT
    Customer_ID,
    Contract_Type,
    Plan_Type,
    Monthly_Charges,
    RANK() OVER (
ORDER BY Monthly_Charges DESC) AS Revenue_Rank
FROM customers
ORDER BY Revenue_Rank
LIMIT 20;

## CREATE THE RISK SCORE DIRECTLY IN SQL
SELECT
    Customer_ID,
    Contract_Type,
    Tenure_Months,
    Satisfaction_Score,
    Support_Calls,
    Complaints,
    Monthly_Charges,

    (CASE WHEN Contract_Type = 'Monthly' THEN 2 ELSE 0 END
	+CASE WHEN Tenure_Months <= 6 THEN 2 ELSE 0 END
	+CASE WHEN Satisfaction_Score <= 2 THEN 2 ELSE 0 END
	+CASE WHEN Support_Calls >= 4 THEN 2 ELSE 0 END
	+CASE WHEN Complaints >= 2 THEN 1 ELSE 0 END
	+CASE WHEN Monthly_Charges > (SELECT AVG(Monthly_Charges) FROM customers)THEN 1 ELSE 0
	END) AS Risk_Score
FROM customers;

##ADD RISK LEVEL
WITH customer_risk AS (
    SELECT
        Customer_ID,
        Contract_Type,
        Tenure_Months,
        Satisfaction_Score,
        Support_Calls,
        Complaints,
        Monthly_Charges,
        Churn,
        (CASE WHEN Contract_Type = 'Monthly' THEN 2 ELSE 0 END
		    +CASE WHEN Tenure_Months <= 6 THEN 2 ELSE 0 END
            +CASE WHEN Satisfaction_Score <= 2 THEN 2 ELSE 0 END
            +CASE WHEN Support_Calls >= 4 THEN 2 ELSE 0 END
            +CASE WHEN Complaints >= 2 THEN 1 ELSE 0 END
            +CASE WHEN Monthly_Charges > (SELECT AVG(Monthly_Charges) FROM customers)THEN 1 ELSE 0 END) AS Risk_Score
    FROM customers)

SELECT
    Customer_ID,
    Risk_Score,
CASE
	WHEN Risk_Score >= 7 THEN 'High'
	WHEN Risk_Score >= 4 THEN 'Medium'
	ELSE 'Low'
END AS Risk_Level, Churn
FROM customer_risk
ORDER BY Risk_Score DESC;

## VALIDATE THE RISK MODEL
WITH customer_risk AS (
SELECT
	Customer_ID,
	Churn,
	(
	CASE WHEN Contract_Type = 'Monthly' THEN 2 ELSE 0 END
	+CASE WHEN Tenure_Months <= 6 THEN 2 ELSE 0 END
	+CASE WHEN Satisfaction_Score <= 2 THEN 2 ELSE 0 END
	+CASE WHEN Support_Calls >= 4 THEN 2 ELSE 0 END
	+CASE WHEN Complaints >= 2 THEN 1 ELSE 0 END
	+CASE WHEN Monthly_Charges > (SELECT AVG(Monthly_Charges) FROM customers)THEN 1 ELSE 0 END) AS Risk_Score
FROM customers), risk_segments AS 
(
SELECT*,CASE
            WHEN Risk_Score >= 7 THEN 'High'
            WHEN Risk_Score >= 4 THEN 'Medium'
            ELSE 'Low'
        END AS Risk_Level
FROM customer_risk
)

SELECT Risk_Level, COUNT(*) AS Total_Customers,
		SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
		ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS Churn_Rate
FROM risk_segments
GROUP BY Risk_Level
ORDER BY Churn_Rate DESC;

## HIGH-RISK + HIGH-REVENUE CUSTOMERS
WITH revenue_segments AS (
SELECT
        Customer_ID,
        Monthly_Charges,
        Contract_Type,
        Tenure_Months,
        Satisfaction_Score,
        Support_Calls,
        Complaints,
        Churn,

NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers
),customer_risk AS 
(
SELECT *,(
		CASE WHEN Contract_Type = 'Monthly' THEN 2 ELSE 0 END
		+CASE WHEN Tenure_Months <= 6 THEN 2 ELSE 0 END
		+CASE WHEN Satisfaction_Score <= 2 THEN 2 ELSE 0 END
		+CASE WHEN Support_Calls >= 4 THEN 2 ELSE 0 END
		+CASE WHEN Complaints >= 2 THEN 1 ELSE 0 END
		+CASE WHEN Revenue_Quartile = 4 THEN 1 ELSE 0 END
        ) AS Risk_Score FROM revenue_segments
)

SELECT
    Customer_ID,
    Contract_Type,
    Tenure_Months,
    Satisfaction_Score,
    Support_Calls,
    Complaints,
    Monthly_Charges,
    Risk_Score,
    Churn

FROM customer_risk
WHERE Risk_Score >= 7
  AND Revenue_Quartile = 4
  AND Churn = 'No'
ORDER BY Monthly_Charges DESC;

## TOP 20 RETENTION TARGETS
SELECT
    Customer_ID,
    Contract_Type,
    Plan_Type,
    Tenure_Months,
    Satisfaction_Score,
    Support_Calls,
    Complaints,
    Monthly_Charges,
    Risk_Score
FROM customers
WHERE Risk_Score >= 7
  AND Churn = 'No'
ORDER BY
    Risk_Score DESC,
    Monthly_Charges DESC
LIMIT 20;

customer_risk AS (

SELECT *,
	(CASE WHEN Contract_Type = 'Monthly' THEN 2 ELSE 0 END
            +
            CASE WHEN Tenure_Months <= 6 THEN 2 ELSE 0 END
            +
            CASE WHEN Satisfaction_Score <= 2 THEN 2 ELSE 0 END
            +
            CASE WHEN Support_Calls >= 4 THEN 2 ELSE 0 END
            +
            CASE WHEN Complaints >= 2 THEN 1 ELSE 0 END
            +
            CASE WHEN Revenue_Quartile = 4 THEN 1 ELSE 0 END
	) AS Risk_Score
FROM revenue_segments
)

SELECT
    Customer_ID,
    Contract_Type,
    Plan_Type,
    Tenure_Months,
    Satisfaction_Score,
    Support_Calls,
    Complaints,
    Monthly_Charges,
    Risk_Score

FROM customer_risk
WHERE Risk_Score >= 7
  AND Revenue_Quartile = 4
  AND Churn = 'No'
ORDER BY
    Risk_Score DESC,
    Monthly_Charges DESC
LIMIT 20;
WITH revenue_segments AS (

SELECT
        Customer_ID,
        Contract_Type,
        Plan_Type,
        Tenure_Months,
        Satisfaction_Score,
        Support_Calls,
        Complaints,
        Monthly_Charges,
        Risk_Score,
        Churn,
NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers
)

SELECT
    Customer_ID,
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
WHERE Risk_Score >= 7
  AND Revenue_Quartile = 4
  AND Churn = 'No'
ORDER BY
    Risk_Score DESC,
    Monthly_Charges DESC
LIMIT 20;
WITH revenue_segments AS (
SELECT *,NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers
)

SELECT
    COUNT(*) AS High_Risk_Active_Customers,
    ROUND(SUM(Monthly_Charges), 2) AS Monthly_Revenue_Exposure
FROM revenue_segments
WHERE Risk_Score >= 7
  AND Revenue_Quartile = 4
  AND Churn = 'No';
  
  ##REVENUE EXPOSURE OF HIGH-RISK ACTIVE CUSTOMERS
  WITH revenue_segments AS (
SELECT *, NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers)
SELECT
    COUNT(*) AS High_Risk_Active_Customers,
    ROUND( SUM(Monthly_Charges),2) AS Monthly_Revenue_Exposure
FROM revenue_segments
WHERE Risk_Score >= 7
  AND Revenue_Quartile = 4
  AND Churn = 'No';
  
##MANAGEMENT-READY QUERY
WITH revenue_segments AS (
SELECT *,NTILE(4) OVER (
ORDER BY Monthly_Charges) AS Revenue_Quartile
FROM customers)
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
    END AS Risk_Level,Churn
    
FROM revenue_segments
WHERE Churn = 'No'
ORDER BY
    Risk_Score DESC,
    Monthly_Charges DESC;
    
    