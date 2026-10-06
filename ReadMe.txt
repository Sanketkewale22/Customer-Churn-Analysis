# Customer Churn Analysis — End-to-End Business Analytics Project

## 📌 Project Overview

Customer churn is an important business problem because losing
customers can affect recurring revenue and long-term customer value.

This project analyzes customer data to identify churn patterns,
customer segments, risk indicators, and retention opportunities.

The project follows an end-to-end Business Analytics workflow using
Excel, SQL, Python, and Power BI.

---

## 🎯 Business Problem

The objective of this project is to:

- Understand customer churn patterns
- Identify customer groups with higher observed churn
- Analyze customer behavior and experience indicators
- Identify high-risk customer segments
- Analyze revenue associated with churned customers
- Develop actionable customer retention recommendations

---

## 🛠️ Tools & Technologies

- Excel
- MySQL
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Power BI
- Jupyter Notebook

---

## 📊 Dataset

The dataset contains 10,000 customer records.

### Key Variables

- Customer_ID
- Age
- Gender
- City
- Tenure_Months
- Contract_Type
- Plan_Type
- Monthly_Charges
- Total_Charges
- Payment_Method
- Internet_Service
- Support_Calls
- Complaints
- Satisfaction_Score
- Churn
- Risk_Score
- Risk_Level

---

# 🔹 Project Workflow

## 1. Data Cleaning — Excel

The dataset was cleaned and prepared for analysis.

Activities included:

- Checking missing values
- Removing duplicate records
- Validating data types
- Checking customer IDs
- Preparing the dataset for SQL and Python analysis

---

## 2. SQL Analysis

MySQL was used to perform business-oriented analysis.

Key analysis areas included:

- Overall churn rate
- Churn by contract type
- Churn by plan type
- Churn by tenure
- Customer risk analysis
- Revenue analysis
- High-risk customer identification
- High-risk active customer analysis
- High-value customer prioritization

---

## 3. Python Exploratory Data Analysis

Python was used for exploratory data analysis using:

- Pandas
- NumPy
- Matplotlib
- Seaborn

Analysis included:

- Churn distribution
- Contract-wise churn
- Tenure-wise churn
- Plan-wise churn
- Satisfaction analysis
- Support-call analysis
- Complaint analysis
- Monthly charge analysis
- Total charge analysis
- Correlation analysis

---

## 4. Customer Segmentation

Customers were segmented using:

- Tenure
- Revenue level
- Risk level

The analysis identified customer groups that could be prioritized
for retention activities.

A particular focus was placed on active customers with high
observed churn risk and high monthly revenue contribution.

---

## 5. Power BI Dashboard

A three-page Power BI dashboard was developed.

### Executive Overview

Includes:

- Total Customers
- Churned Customers
- Churn Rate
- Monthly Revenue
- High-Risk Customers
- Churned Monthly Charges

### Customer Risk Analysis

Includes:

- Risk distribution
- Churn by risk level
- Churn by satisfaction
- Churn by support calls
- High-risk active customer table

### Retention & Revenue Strategy

Includes:

- Churned monthly charges
- High-risk active customers
- High-risk high-value customers
- Revenue analysis
- Retention priority table

---

# 📈 Key Findings

### Overall Churn

The observed customer churn rate is:

**21.92%**

### Contract Type

Monthly-contract customers show the highest observed churn among
contract types at approximately:

**31.98%**

### Customer Tenure

Customers with 0–6 months of tenure show the highest observed churn:

**56%**

### Risk Segmentation

| Risk Level | Customers | Observed Churn Rate |
|---|---:|---:|
| Low | 9,187 | 18% |
| Medium | 655 | 55% |
| High | 158 | 88% |

### High-Risk Active Customers

The analysis identified:

**19 active high-risk customers**

These customers can be prioritized for retention activities.

---

# 💡 Business Recommendations

1. Introduce a First 180-Day Customer Retention Program.

2. Encourage eligible monthly-contract customers to move toward
   longer-term contracts.

3. Create a dedicated high-risk customer retention queue.

4. Prioritize high-risk and high-value active customers.

5. Introduce a customer satisfaction recovery process.

6. Proactively follow up with customers showing repeated support
   interactions.

7. Monitor complaints and other customer-experience indicators.

---

# ⚠️ Analytical Limitation

The churn risk score is a rule-based segmentation framework based on
observed customer characteristics.

The analysis identifies associations and prioritization
opportunities but does not establish causal relationships.

The findings should therefore be used as decision-support inputs
rather than guarantees of future customer behavior.

---

# 📁 Repository Structure

```text
Customer-Churn-Analysis/
│
├── README.md
├── data/
├── excel/
├── sql/
├── python/
├── powerbi/
└── presentation/