# Power BI — Founder Dashboard Build Guide (Deliverable 3)

A step-by-step guide to assemble the **4-panel founder dashboard** in Power BI Desktop from
`customers_enriched.csv`. Because I can't generate a native `.pbix`, this gives you the exact
data model, **all DAX measures**, and the build steps for each panel — ~20 minutes to assemble.

---

## 1 · Load the data
1. **Power BI Desktop → Home → Get Data → Text/CSV →** `customers_enriched.csv` → **Load**.
2. The file is one row per customer (3,900 rows) with the engineered features already built in
   Python, so **no Power Query transforms are required**. Optionally rename the table to
   `Customers`.

### Data model (single flat fact table — a star schema is optional here)
The dataset is one grain (the customer), so a single table is correct and simplest. If you want
a textbook star schema, split out small dimensions and connect on the keys:

```
Customers (fact)        DimDependency (dependency_tier, dependency_score)
  ── dependency_tier ───┘
  ── value_tier ────────┐ DimValue (value_tier ordering)
  ── location ──────────┘ DimGeo (location → state, for the map)
```
For a founder demo, **the single flat table is recommended** — fewer moving parts.

### Sort columns (so tiers order correctly, not alphabetically)
Create a numeric helper in Power Query or use these existing columns as **Sort By Column**:
- `value_tier` → sort by `value_score`
- `dependency_tier` → sort by `dependency_score`
- `satisfaction_flag` → create order col (At-Risk=1, Neutral=2, Satisfied=3)

---

## 2 · DAX measures (create a `_Measures` table, then add all of these)

```DAX
Total Customers   = COUNTROWS ( Customers )

Avg Spend         = AVERAGE ( Customers[purchase_amount] )

Avg Prev Purchases = AVERAGE ( Customers[previous_purchases] )    -- retention proxy

Promo Rate        = AVERAGE ( Customers[disc] )                   -- share on discount (0-1)

Pct Margin-Safe Loyal =
    DIVIDE ( CALCULATE ( COUNTROWS ( Customers ), Customers[loyal_b] = 1 ), [Total Customers] )

Pct Ideal Customer =
    DIVIDE ( CALCULATE ( COUNTROWS ( Customers ), Customers[ideal_customer] = 1 ), [Total Customers] )

Revenue           = SUM ( Customers[purchase_amount] )

Organic Score =                                                  -- value NOT attributable to discounts
    AVERAGE ( Customers[value_score] ) * ( 1 - [Promo Rate] )

Retention Index =                                                -- 0-100, scaled avg repeat
    DIVIDE ( [Avg Prev Purchases], 50 ) * 100

-- Strategic segment (also available as a calculated column, below)
Customer Segment =
VAR a = SELECTEDVALUE ( Customers[loyal_a] )
VAR b = SELECTEDVALUE ( Customers[loyal_b] )
VAR d = SELECTEDVALUE ( Customers[disc] )
RETURN
    SWITCH ( TRUE(),
        b = 1 && a = 1, "Ideal Loyalist",
        b = 1,          "Margin-Safe Loyalist",
        a = 1 && d = 1, "Discount-Dependent Repeater",
        d = 1,          "One-Time Bargain Hunter",
        "Passive / Low-Engagement" )
```

### Recommended calculated column (for grouping in visuals)
Add this **column** (not measure) to `Customers` so you can put segments on an axis:
```DAX
Segment =
SWITCH ( TRUE(),
    Customers[loyal_b] = 1 && Customers[loyal_a] = 1, "1 Ideal Loyalist",
    Customers[loyal_b] = 1,                           "2 Margin-Safe Loyalist",
    Customers[loyal_a] = 1 && Customers[disc] = 1,    "3 Discount-Dependent Repeater",
    Customers[disc] = 1,                              "4 One-Time Bargain Hunter",
    "5 Passive / Low-Engagement" )
```
(The leading numbers force the pyramid order; hide them with a display rename if you like.)

---

## 3 · The four panels

### Panel 1 — Customer Pyramid (value distribution across the base)
- **Visual:** Stacked **Bar chart** (acts as a horizontal pyramid).
- **Y-axis (Axis):** `Segment`  •  **X-axis (Values):** `Total Customers`.
- **Data labels:** on; add `Pct of Base` (= `[Total Customers]` with "Show value as % of grand total").
- **Read:** widest at the bottom (Passive ~1,281, One-Time Bargain ~1,176) narrowing to the
  **Ideal Loyalist tip (~281, 7%)** — the visual proof of how thin the genuinely-loyal layer is.

### Panel 2 — Promo Dependency vs Retention (who needs discounts to buy)
- **Visual:** **Scatter chart**.
- **X-axis:** `Promo Rate`  •  **Y-axis:** `Avg Prev Purchases` (retention)  •
  **Legend / Details:** `Segment`  •  **Size:** `Total Customers`.
- Add a constant line at the overall `Promo Rate` (~0.43) and at avg retention to make 4 quadrants.
- **Read:** the **top-left quadrant** (low promo, high retention) = Ideal/Margin-Safe loyalists;
  **right side** = discount-attached customers. Shows discounts don't move customers up.

### Panel 3 — Geographic Opportunity Map (organic demand)
- **Visual:** **Filled Map** (or Azure Map). Set `location` → Data category **State/Province**,
  Map = USA.
- **Location:** `location`  •  **Bubble size / Color saturation:** `Organic Score`.
- Add a **Top-10 table** beside it: `location`, `Total Customers`, `Avg Spend`, `Promo Rate`,
  `Organic Score` (sorted desc).
- **Read:** **Arizona, Kansas, Alaska, Tennessee, Michigan** light up — high value, low discount
  reliance = under-leveraged organic demand to target.

### Panel 4 — Category Funnel (entry-point vs retention categories)
- **Visual:** **Clustered column** (or Funnel visual).
- **Axis:** `category`  •  **Values:** `Avg Prev Purchases` (retention) and, as a second series,
  `% Low-Tenure` (create measure below).
```DAX
Pct Low Tenure =
VAR avgPrev = CALCULATE ( AVERAGE ( Customers[previous_purchases] ), ALL ( Customers ) )
RETURN DIVIDE (
    CALCULATE ( COUNTROWS ( Customers ), Customers[previous_purchases] < avgPrev ),
    [Total Customers] )
```
- **Read:** categories with **high `% Low-Tenure`** are **entry points** (first-purchase
  magnets); categories with **high `Avg Prev Purchases`** are **retention** categories.

---

## 4 · Slicers & layout
- Add **slicers**: `gender`, age band (create `Age Band` column), `season`, `value_tier`.
- **KPI cards** across the top: `Total Customers`, `Pct Margin-Safe Loyal`, `Promo Rate`,
  `Pct Ideal Customer`.
- Theme: keep it clean for a non-technical founder — one accent colour, large card numbers,
  short titles ("How loyal is our base?", "Do discounts buy retention?", "Where is organic
  demand?", "Which categories retain?").

---

## 5 · Headline numbers your dashboard should reproduce
| Metric | Value |
|---|---|
| Customers | 3,900 |
| Buy at full price | 57% |
| Margin-safe loyal (loyal_b) | ~24% (≈942) |
| Ideal Loyalists (loyal_a ∧ loyal_b) | ~7% (281) |
| Promo-reliant base | 43% |
| Spend lift from discounting | **≈ $0 (none)** |
| Top organic states | Arizona, Kansas, Alaska, Tennessee, Michigan |

These tie back exactly to `customer_value_analysis.ipynb` and `segmentation_queries.sql`.
