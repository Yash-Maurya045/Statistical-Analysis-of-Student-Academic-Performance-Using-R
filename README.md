
# Statistical Analysis of Student Academic Performance Using R

This project performs an exploratory data analysis (EDA) on a student performance dataset using R. It focuses on understanding how students score in math, reading, and writing, along with how demographic factors such as gender, parental education, lunch type, and test preparation influence academic outcomes.

---

## 📌 Project Overview
The purpose of this mini-project is to analyze academic performance trends and uncover meaningful patterns using statistical methods and visualization techniques. The dataset contains 1,000 student records and three major performance indicators: **math**, **reading**, and **writing** scores.

This repository includes:
- Cleaned dataset  
- R scripts for data preprocessing and visualization  
- All generated plots (13 in total)  
- A concise discussion and conclusion based on findings  

---

## 📂 Dataset Information
**Source:** Kaggle – *Students Performance in Exams*  
**Records:** 1000 students  
**Variables:**  
- Gender  
- Race/Ethnicity  
- Parental Level of Education  
- Lunch Type  
- Test Preparation Status  
- Math Score  
- Reading Score  
- Writing Score  

---

## 🛠️ Tools & Libraries Used
The project uses R with key packages:

- `readr`  
- `dplyr`  
- `janitor`  
- `ggplot2`  
- `stringr`  
- `corrplot`  
- `forcats`  

---

## 📊 Key Features of the Analysis

### ✅ **Data Cleaning**
- Standardized column names  
- Transformed categorical variables into factors  
- Extracted and summarized missing values  

### ✅ **Statistical Summaries**
- Descriptive statistics for math, reading, and writing  
- Group-wise summaries (gender, parental education, test preparation)  

### ✅ **13 Attractive Visualizations**
1. **Histograms** (3)  
2. **Overall Boxplot** (1)  
3. **Gender-wise Boxplots** (3)  
4. **Gender-wise Density Plots** (3)  
5. **Scatter Plots with Regression Lines** (2)  
6. **Correlation Heatmap** (1)  

### ✅ **Insights**
- Reading and writing scores are strongly correlated  
- Gender differences are subtle but visible  
- Parental education shows mild performance trends  
- Overall, students who perform well in one subject tend to perform well in others  

---

## 📝 Discussion & Conclusion
The analysis highlights consistent academic patterns across the three major subjects. Literacy skills (reading & writing) show the strongest relationship, suggesting skill transfer between these areas. Though insightful, the dataset is limited by missing socio-economic, behavioural, and environmental factors that affect real academic outcomes.  
Future work may include predictive modeling, classification of performance levels, or integrating additional contextual datasets.

---

## 📁 Repository Structure

