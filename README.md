# Decoding Customer Value — A SQL-Driven Retention Strategy

**D2C Fashion Brand · 3,900 Customers · Python + SQL + Power BI**

A full customer intelligence project built from raw transactional data — with no loyalty score, no churn label, and no timestamps provided. Every metric, segment, and recommendation in this project is engineered and traced back to specific variables, not assumed.

📊 **[View the Founder Dashboard (PDF)](dashboard/founder_dashboard.pdf)** · 📄 **[Read the Executive Summary](playbook/executive_summary.md)**

> **The strategic question:** Is the business building a loyal customer base, or renting revenue with discounts — and what should it do under either scenario?
>
> **The answer:** The brand has a thin but real loyal core (7%), is giving away margin on 43% of customers for zero measurable return, and can grow profitably by sunsetting promotions and acquiring more of its proven Ideal Customer.

---

## 📌 Problem Statement

Using only transactional and behavioral data, can the brand identify what its most valuable customers look like, measure how much of its current revenue depends on promotions, and build a data-backed retention strategy that reduces discount dependency without hurting sales?

**Key questions addressed:**
1. Who are the genuinely loyal customers vs. those who only buy on discount?
2. What behavioral patterns predict high customer value?
3. Which geographies and demographics are commercially under-leveraged?
4. How should the brand restructure its promotional strategy?
5. What does the ideal customer profile look like — and how can the brand acquire more of them?

---

## 🗂️ Project Structure

```
├── Problem_Statements.pdf              # Original case brief (Consulting & Analytics Club, IIT Guwahati)
├── data/
│   ├── Dataset.csv                     # Raw source data
│   └── customers_enriched.csv          # Cleaned + feature-engineered output (feeds SQL + Power BI)
├── notebooks/
│   └── customer_value_analysis.ipynb   # Python: cleaning + feature engineering
├── sql/
│   └── segmentation_queries.sql        # SQL: segmentation logic (MySQL 8.0+)
├── dashboard/
│   ├── founder_dashboard.pbix          # Power BI source file (fully interactive)
│   ├── founder_dashboard.pdf           # Static export — quickest way to view the dashboard
│   ├── founder_dashboard.html          # Interactive export — viewable in any browser
│   └── PowerBI_build_guide.md          # Data model, every DAX measure, and panel-by-panel build logic
├── playbook/
│   ├── retention_playbook.md           # Promo sunset plan + Ideal Customer Profile
│   └── executive_summary.md            # 1-page summary of findings & recommendations
└── README.md
```

---

## 🧠 Methodology

### 1. Data Preparation & Feature Engineering (Python)
Since the raw dataset had no loyalty, churn, or value labels, several features were engineered from behavioral signals:
- **`dependency_score` / `dependency_tier`** — how reliant a customer is on discounts/subscriptions (Full-Price / Bargain-Hunter / Subscription-Promo)
- **`value_score` / `value_tier`** — composite of spend + purchase history (Low / Mid / High)
- **`satisfaction_flag`** — At-Risk / Neutral / Satisfied, from review rating
- **`loyal_a`** (behavioral loyalty) and **`loyal_b`** (margin-safe loyalty: full-price *and* satisfied) — two **competing loyalty definitions**, tested against each other
- **`ideal_customer`** = `loyal_a AND loyal_b`

`loyal_b` was adopted as the primary loyalty label because it's the only definition that answers the founders' real question: *is this customer loyal, or just present?*

### 2. Customer Segmentation (SQL)
`sql/segmentation_queries.sql` builds a structured query layer (CTEs + window functions) answering all five key business questions — segment discovery, value-tier behavior, geographic/demographic gaps, promo effectiveness, and the Ideal Customer profile.

### 3. Founder Dashboard (Power BI)
A 4-panel dashboard designed for a non-technical founding team:
1. **Customer Pyramid** — value distribution across segments
2. **Promo Dependency vs. Retention** — who actually needs discounts to buy
3. **Geographic Opportunity Map** — organic demand vs. discount-driven demand
4. **Category Funnel** — entry-point vs. retention categories

The dashboard was built in Power BI Desktop (`dashboard/founder_dashboard.pbix`). `founder_dashboard.pdf` and `.html` are ready-to-view exports for anyone without Power BI installed. `PowerBI_build_guide.md` documents the full data model and every DAX measure used, for anyone who wants to see the reasoning behind each panel.

### 4. Retention Playbook (Business Recommendations)
`playbook/retention_playbook.md` translates the analysis into two concrete, actionable outputs:
- **Promotional Sunset Plan** — named segments, trigger behavior, rollout timeline, and the metric to track (not just "reduce discounts")
- **Ideal Customer Profile** — specific enough for a marketing team to act on today

---

## 🔑 Headline Findings

| Metric | Value |
|---|---|
| Total customers | 3,900 |
| Buy at full price | 57% |
| Margin-safe loyal (`loyal_b`) | ~24% (≈942) |
| Ideal Loyalists (`loyal_a ∧ loyal_b`) | ~7% (281) |
| Promo-reliant base | 43% |
| Spend lift from discounting | **≈ $0** |
| Top organic-demand states | Arizona, Kansas, Alaska, Tennessee, Michigan |

Full write-up in [`playbook/executive_summary.md`](playbook/executive_summary.md).

---

## 🛠️ Tech Stack
- **Python** (pandas) — data cleaning & feature engineering
- **SQL** (MySQL 8.0+) — segmentation & business-question queries
- **Power BI** — interactive founder-facing dashboard
- **Markdown / PDF** — playbook & executive summary

---

## 🚀 How to Reproduce
1. Open `notebooks/customer_value_analysis.ipynb` and run it on `data/Dataset.csv` to regenerate `customers_enriched.csv`.
2. Load `data/customers_enriched.csv` into MySQL using the schema at the top of `sql/segmentation_queries.sql`, then run the queries.
3. Open `dashboard/founder_dashboard.pbix` in Power BI Desktop to explore the live dashboard, or check `PowerBI_build_guide.md` to see how it was built from scratch (data model + all DAX measures).
4. Compare your output against `dashboard/founder_dashboard.pdf` / `.html`.

---

## 👤 Author
*(Lokesh kumar / https://www.linkedin.com/in/lokesh-kumar-1768262b9/ )*

Project brief by Consulting & Analytics Club, IIT Guwahati.# decoding-customer-value
