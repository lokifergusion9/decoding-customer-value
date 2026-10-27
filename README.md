# Decoding Customer Value — A SQL-Driven Retention Strategy

![Python](https://img.shields.io/badge/Python-pandas%20%7C%20seaborn-3776AB?logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-4479A1?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Customers](https://img.shields.io/badge/Customers-3%2C900-2e7d32)

**Is a D2C fashion brand building a loyal customer base — or renting revenue with discounts?**

The data came with **no loyalty score, no churn label and no timestamps**. Every segment, metric and recommendation here is engineered from explicit, traceable rules.

📊 **[Interactive Dashboard](https://lokifergusion9.github.io/decoding-customer-value/founder_dashboard.html)** · 📑 **[Dashboard PDF](founder_dashboard.pdf)** · 📄 **[Executive Summary](executive_summary.md)** · 📓 **[Notebook](customer_value_analysis.ipynb)**

[![Founder Dashboard](images/founder_dashboard.png)](https://lokifergusion9.github.io/decoding-customer-value/founder_dashboard.html)

---

## 🎯 The Answer

> The brand has a **thin but real loyal core (7%)**, gives away margin on **43% of customers for zero measurable return**, and can grow profitably by sunsetting promotions and acquiring more customers who *behave* like its Ideal Loyalists.

| Metric | Value |
|---|---|
| Full-price revenue share | **57%** |
| Margin-safe loyal customers | **24%** (942) |
| Ideal Loyalists | **7%** (281) |
| Promo-reliant customers | **43%** — $99K of $233K revenue |
| Spend lift from discounting | **≈ $0** (−$0.85 overall, −$0.70 within men only) |
| At-Risk customers (rating < 3) | 680 |
| Top organic-demand states | Arizona, Kansas, Alaska, Tennessee, Michigan |

### Customer segments

| Segment | Customers | Share | Avg spend | Avg prior purchases | Avg rating |
|---|---:|---:|---:|---:|---:|
| 🟢 Ideal Loyalist (full-price + repeat) | 281 | 7.2% | $61.75 | 37.4 | 4.47 |
| 🟢 Margin-Safe Loyalist (full-price) | 661 | 16.9% | $60.29 | 20.6 | 4.47 |
| 🟡 Discount-Dependent Repeater | 501 | 12.8% | $58.46 | 37.4 | 3.72 |
| 🟠 One-Time Bargain Hunter | 1,176 | 30.2% | $59.63 | 20.8 | 3.75 |
| ⚪ Passive / Low-Engagement | 1,281 | 32.8% | $59.69 | 24.6 | 3.23 |

---

## 🧠 Approach

**1 · Audit before engineering.** The notebook first checks what signal actually exists:
- `Discount Applied` and `Promo Code Used` are identical → merged into one promo signal.
- Every subscriber is discounted → a subscription is a recurring-discount habit, not full-price commitment.
- Apart from that mechanical link (r ≈ 0.7), **every variable pair has |r| < 0.05** → loyalty can't be *discovered*, it has to be *constructed* from transparent rules.
- **Only men were ever discounted** (0 of 1,248 women) → any "no discount" segment over-represents women, so gender-sensitive findings are re-tested within men only.

**2 · Engineer features (Python).**

| Feature | Rule |
|---|---|
| `dependency_tier` | Full-Price · Bargain-Hunter (discount) · Subscription-Promo (discount + subscription) |
| `value_score` / `value_tier` | 60% normalised previous purchases + 40% normalised spend → Low / Mid / High terciles |
| `satisfaction_flag` | At-Risk (< 3) · Neutral (3–3.99) · Satisfied (≥ 4) |
| `loyal_A` — behavioural | previous purchases ≥ median **and** buys monthly or more often |
| `loyal_B` — margin-safe ⭐ | **no discount and** rating ≥ 4 |
| `ideal_customer` | `loyal_A` **and** `loyal_B` |

Two competing loyalty definitions were tested. **`loyal_B` is the primary label** because it is the only one that isolates promo-independent customers — `loyal_A` is still ~44% discount-driven.

**3 · Segment (SQL).** [`segmentation_queries.sql`](segmentation_queries.sql) uses CTEs and window functions to answer five business questions: who is loyal, what predicts value, which states and demographics are under-leveraged, whether discounts buy any lift (overall and men-only), and what the Ideal Customer looks like.

**4 · Visualise (Power BI).** A four-panel founder dashboard: Customer Pyramid · Promo Dependency vs. Retention · Geographic Opportunity Map · Category Funnel.

---

## 💡 Recommendations

| # | Action | Trade-off |
|---|---|---|
| 1 | **Sunset promotions in two phases** — swap subscriber discounts for non-price perks, then tighten bargain-hunter offers. Never discount the loyal core. | Some price-only volume lapses — it carries no margin or loyalty. |
| 2 | **Acquire Ideal-Customer lookalikes** on behaviour (full price, high rating, frequent repeat, Clothing/Accessories entry) — not age or gender, which don't separate them from the base. | Full-price acquisition converts slower but yields higher lifetime value. |
| 3 | **Invest in organic-demand states** — high value, low discount reliance. | Concentrates spend; revisit quarterly. |
| 4 | **Service-recover the 680 At-Risk customers** with support, not discounts. | Needs ops effort. |

**North-star metric:** full-price revenue share (today 57%). The strategy works if it rises while total revenue holds.

---

## ⚠️ Limitations

- **One snapshot, no timestamps.** Retention and churn can't be measured directly; `Previous Purchases` stands in for tenure and `Frequency of Purchases` is self-reported.
- **Rule-based segments.** The 60/40 `value_score` weights and the rating ≥ 4 loyalty threshold are judgement calls, documented so they can be challenged and re-tuned.
- **No margin or cost data.** "Margin given away" is inferred from discount use; the size of each discount is unknown.
- **Observational, not causal.** "Discounts buy no lift" compares customers who did and didn't get discounts. A controlled promo holdout test is the right next step before a full sunset.
- **Likely synthetic data.** Near-zero correlations and the clean gender/discount split suggest a generated dataset, so the method transfers better than the specific numbers.

---

## 🗂️ Repository

| File | What it is |
|---|---|
| [`Dataset.csv`](Dataset.csv) | Raw data — 3,900 customers × 18 columns |
| [`customer_value_analysis.ipynb`](customer_value_analysis.ipynb) | Python — audit, cleaning, feature engineering |
| [`customers_enriched.csv`](customers_enriched.csv) | Notebook output — 30 columns, feeds SQL and Power BI |
| [`segmentation_queries.sql`](segmentation_queries.sql) | MySQL 8.0+ — schema and segmentation queries |
| [`Customer_Value_Dashboard.pbix`](Customer_Value_Dashboard.pbix) | Power BI source file |
| [`founder_dashboard.html`](founder_dashboard.html) / [`.pdf`](founder_dashboard.pdf) | Dashboard exports |
| [`executive_summary.md`](executive_summary.md) | One-page findings and recommendations |

---

## 🚀 Reproduce

```bash
git clone https://github.com/lokifergusion9/decoding-customer-value.git
cd decoding-customer-value
python -m venv venv
# Windows: .\venv\Scripts\Activate.ps1     macOS/Linux: source venv/bin/activate
pip install -r requirements.txt
jupyter notebook customer_value_analysis.ipynb
```

1. **Python** — run all notebook cells from the repo folder; it reads `Dataset.csv` and writes `customers_enriched.csv`.
2. **SQL** — create the table with the schema at the top of `segmentation_queries.sql`, load `customers_enriched.csv` (MySQL Workbench → Table Data Import Wizard → *use existing table*), then run the queries.
3. **Dashboard** — open `Customer_Value_Dashboard.pbix` in Power BI Desktop, or the [interactive version](https://lokifergusion9.github.io/decoding-customer-value/founder_dashboard.html) in a browser.

---

## 👤 Author

**Lokesh Kumar** · IIT Roorkee · [LinkedIn](https://www.linkedin.com/in/lokesh-kumar-1768262b9/)

*Case brief: Consulting & Analytics Club, IIT Guwahati.*
