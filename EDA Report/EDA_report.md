# Exploratory Data Analysis Report — ApexPlanet Sales Dataset

**Task 2: Exploratory Data Analysis (EDA) & Business Intelligence**
**Dataset:** `cleaned_sales_dataset.csv` (1,000 orders, output of Task 1)

---

## 1. Descriptive Statistics — Numerical Fields

| Metric | Age | Quantity | Unit Price (₹) | Total Sales (₹) |
|--------|-----|----------|-----------------|-------------------|
| Mean | 41.4 | 5.4 | 25,486.78 | 139,399.44 |
| Std Dev | 13.7 | 2.8 | 14,179.40 | 114,100.05 |
| Min | 18 | 1 | 145.78 | 437.34 |
| 25% | 30 | 3 | 13,895.72 | 47,066.63 |
| Median | 41 | 5 | 25,398.74 | 108,594.02 |
| 75% | 53 | 8 | 37,512.38 | 203,722.88 |
| Max | 65 | 10 | 49,997.53 | 493,677.50 |

**Observations:**
- Customer ages range 18–65 with a fairly even spread (mean ≈ median ≈ 41), so no strong age skew.
- Quantity is close to a uniform 1–10 spread — consistent with synthetic/generated order data rather than a natural Poisson-like purchase pattern.
- Total Sales is right-skewed (mean ₹139K > median ₹109K) — a smaller number of very high-value orders pull the average up.

![Numerical distributions](charts/01_histograms_numerical.png)

## 2. Descriptive Statistics — Categorical Fields

- **Gender:** near 50/50 split (511 Male / 489 Female) — no meaningful skew.
- **City:** fairly even across 8 cities (Patna highest at 135 orders, Pune lowest at 99), plus 13 orders with `Unknown` city (from Task 1 imputation).
- **Product:** Mobile (184) and Book (178) are the most frequently ordered products; Rice (153) the least.
- **Category:** Electronics dominates order volume (354 orders, ~35%) — expected, since it bundles two products (Mobile + Laptop).

![Categorical distributions](charts/02_barcharts_categorical.png)

## 3. Multivariate Analysis & Correlation

| | Age | Quantity | Unit Price | Total Sales |
|---|---|---|---|---|
| **Age** | 1.00 | -0.03 | -0.01 | 0.00 |
| **Quantity** | -0.03 | 1.00 | 0.02 | 0.65 |
| **Unit Price** | -0.01 | 0.02 | 1.00 | 0.69 |
| **Total Sales** | 0.00 | 0.65 | 0.69 | 1.00 |

![Correlation heatmap](charts/03_correlation_heatmap.png)

**Key findings:**
- **Age has essentially zero correlation with any spending metric** (all ≈ 0) — older customers don't spend more or less than younger ones in this dataset. This is a genuinely useful (if simple) insight: age-based targeting wouldn't be an effective lever here.
- **Total Sales correlates moderately-to-strongly with both Quantity (0.65) and Unit Price (0.69)** — expected, since `Total_Sales = Quantity × Unit_Price`. Neither factor dominates the other.
- **Quantity and Unit Price are uncorrelated (0.02)** — customers don't systematically buy more units of cheaper items or vice versa.

![Unit Price vs Total Sales by Category](charts/04_scatter_price_vs_sales.png)

The scatter confirms the linear fan pattern: for any fixed unit price, total sales scales cleanly with quantity, and there's no category clustering by price band — every category spans the full price range.

![Age vs Total Sales](charts/05_scatter_age_vs_sales.png)

No visible trend — reinforces the near-zero correlation above.

![Pair plot](charts/06_pairplot.png)

![Avg Total Sales by City & Category](charts/07_city_category_avgsales.png)

City × Category doesn't show a dramatically different pattern city to city — Electronics and Education tend to carry the highest average order values across most cities, consistent with their higher unit prices.

## 4. SQL — Business Questions

Full queries and results in `sql_business_questions.sql` and `sql_query_results.md`. Highlights:

1. **Top products by revenue:** Laptop (₹25.44M) and Mobile (₹25.34M) lead, both Electronics — closely followed by Book (₹25.03M).
2. **Monthly revenue trend:** Revenue fluctuates between ~₹9.2M–13.1M per month with no strong seasonal trend across 2025; March was the peak month.
3. **Highest average order value by city:** Bengaluru (₹153,882 avg), followed by Pune (₹146,598) — note that City is captured per-order (not a fixed customer attribute), since 46 customers in this dataset placed orders from more than one city.
4. **Revenue share by category:** Electronics leads at 36.4% of total revenue, followed by Education (18.0%), Grocery (16.0%), Furniture (15.4%), Fashion (14.2%).
5. **Top customers by spend:** Top 10 customers each spent ₹490K–870K, mostly from 2 orders — indicating a handful of very high-value transactions rather than frequent repeat buyers.
6. **Average order value by age group & gender:** No consistent pattern — the highest AOV segment is Female 18-25 (₹159,505), and the lowest is Female 26-35 (₹111,512), reinforcing that age/gender aren't reliable predictors of order value here.
7. **Best quarter:** Q4 2025 leads with ₹37.4M revenue across 259 orders, followed closely by Q2 2025.

## 5. Summary of Key Insights

1. **Electronics is the clear revenue driver** — over a third of total revenue, split across Laptop and Mobile.
2. **Order value is driven by quantity and price, not by customer demographics** — age and gender show no meaningful correlation with spend, so demographic-based pricing/targeting isn't supported by this data.
3. **Bengaluru orders have the highest average value** (₹153,882), followed by Pune — worth investigating as a potential premium-order region.
4. **Revenue is fairly stable month-to-month** with no strong seasonality, though Q4 2025 was the strongest quarter.
5. **A small set of high-value transactions** (top 10 customers, ₹490K+ each) contribute disproportionately — worth investigating whether these are bulk/wholesale orders.

## 6. Proposed KPIs for Ongoing Tracking

Based on the above, the dashboard mock-up (`dashboard_mockup.pptx`) proposes tracking:
- Total Revenue & Total Orders (headline metrics)
- Revenue by Category (share of wallet)
- Monthly Revenue Trend
- Average Order Value by City
- Top 5 Products by Revenue
