# Executive Summary — Decoding Customer Value (Deliverable 5)
### A SQL-Driven Retention Strategy · D2C Fashion Brand · 3,900 customers

**The strategic question:** *Is the business building a loyal customer base, or renting revenue
with discounts — and what should we do under either scenario?*

**The answer, in one line:** The brand has a **thin but real loyal core (7%)**, is giving away
margin on **43% of customers for zero measurable return**, and can grow profitably by **sunsetting
promotions and acquiring more of its proven Ideal Customer.**

---

### What the data shows
1. **Discounts buy nothing.** Discounted customers spend **$59.28 vs $60.13** at full price, with
   identical satisfaction (3.74 vs 3.76) and repeat rate. Yet **43% of the base ($99K, ~43% of
   revenue) is promo-attached** — margin surrendered for no behavioural lift. The result holds
   like-for-like among men alone ($59.28 vs $59.98), so it is not a gender artefact.
2. **The loyal core is thin.** Using a margin-safe definition (full-price **and** satisfied), only
   **24% of customers are genuinely loyal**, and just **7% (281) are Ideal Loyalists** (also
   frequent repeat buyers). The customer pyramid is wide at the bottom (passive + bargain-hunters)
   and narrow at the top.
3. **A note on rigour:** the dataset has no loyalty score, churn label, or timestamps, and its
   variables are statistically near-independent (the only strong link, discount ↔ subscription,
   is mechanical: every subscriber is discounted). Every segment here is therefore a
   **transparent, rule-based construct traceable to specific variables** — not an assumed label.
   We built **two competing loyalty definitions** and adopted the margin-safe one because it is
   the only definition that answers the founders' actual question. One structural quirk matters:
   **discounts and subscriptions were only ever given to men** (0 of 1,248 women), so we
   re-tested every gender-sensitive finding within men only.
4. **The Ideal Customer is identifiable — by behaviour, not demographics.** Spends above average
   ($61.75 vs $59.76), ~37 prior purchases, rates 4.5/5, always pays full price, buys weekly to
   monthly, enters via Clothing/Accessories. Demographics do not separate them: age mirrors the
   base, and women look over-represented (52% vs a 32% base) only because no woman was ever
   discounted — among full-price customers men are slightly *more* likely to be ideal (13.7% vs
   11.8%). Neither age nor gender is a targeting signal.
5. **Organic demand is under-leveraged.** Arizona, Kansas, Alaska, Tennessee and Michigan show
   high customer value with **low discount reliance** — genuine brand pull the brand hasn't
   deliberately targeted.

---

### Recommendations
| # | Action | Trade-off / risk |
|---|---|---|
| 1 | **Sunset promotions in two phases** — swap subscriber discounts for non-price perks first, then tighten bargain-hunter offers. **Never discount the loyal core.** | Some price-only volume will lapse — acceptable, as it carries no margin or loyalty. |
| 2 | **Acquire Ideal-Customer lookalikes** — build audiences from the behaviour of the 281 Ideal Loyalists (full-price, high-rating, frequent repeat, Clothing/Accessories entry), not from age or gender. | Full-price acquisition converts slower but yields far higher lifetime value. |
| 3 | **Invest in organic-demand states** before discount-driven ones. | Concentrates spend; revisit quarterly as the map shifts. |
| 4 | **Service-recover the 680 At-Risk customers** (rating < 3) — with support, not discounts. | Requires ops effort; discounting them fixes nothing. |

**Track one number:** **full-price revenue share** (today ~57%). The strategy is working if it
**rises while total revenue holds** — proof the brand is building loyalty, not buying it.

---
*Supporting analysis: `customer_value_analysis.ipynb` (features), `segmentation_queries.sql`
(segmentation), `Customer_Value_Dashboard.pbix` / `founder_dashboard.pdf` (dashboard).*
