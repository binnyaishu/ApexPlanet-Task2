# ApexPlanet-Task2
# ApexPlanet Data Analytics Internship — Task 2: Exploratory Data Analysis & Business Intelligence

Explored a 1,000-row sales dataset to uncover patterns and trends, wrote SQL queries against a 
normalized database to answer real business questions, and built a dashboard mock-up proposing 
KPIs for ongoing tracking — as part of my Data Analytics internship at ApexPlanet.

## 📁 Files

- `EDA_report.md` — full write-up: descriptive stats, univariate/multivariate analysis, 
  correlation findings, SQL insights, and proposed KPIs
- `sql_business_questions.sql` — 7 business questions answered via SQL (filtering, aggregation, joins)
- `sql_query_results.md` — the same queries with their actual output tables
- `apexplanet_sales.db` — SQLite database (3 normalized tables: `orders`, `customers`, `products`)
- `dashboard_mockup.pptx` — static dashboard mock-up proposing key metrics to track
- `charts/` — all supporting visualizations (histograms, bar charts, heatmap, scatter plots, pair plot)

## 🔍 What this covers

1. **Descriptive Statistics & Univariate Analysis** — summary stats and distributions for all 
   numerical and categorical fields
2. **SQL for Business Questions** — top products by revenue, monthly trend, highest AOV city, 
   category revenue share, top customers, AOV by age/gender, best quarter
3. **Multivariate Analysis & Correlation** — correlation heatmap, scatter plots, pair plot, 
   city × category breakdown
4. **Dashboard Mock-up** — proposed KPIs: Total Revenue, Total Orders, Avg Order Value, Unique 
   Customers, Monthly Trend, Revenue by Category, AOV by City, Top Products

## 📊 Key Insights

- **Electronics drives ~36% of total revenue** — the single largest category, led by Laptop and Mobile
- **Customer age has virtually no correlation with spend** (all correlations ≈ 0) — demographic 
  targeting by age isn't well supported by this data
- **Bengaluru has the highest average order value** (₹153,882), despite not being the 
  highest-volume city
- **Q4 2025 was the strongest quarter** by both order count and revenue

## 🛠️ Tools used
Python, Pandas, Matplotlib, Seaborn, SQLite, pptxgenjs

---
