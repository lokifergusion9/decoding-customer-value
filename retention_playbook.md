# Retention Playbook (Deliverable 4)
### Promotional Sunset Plan + Ideal Customer Profile

**Audience:** Founding team. **Basis:** `customer_value_analysis.ipynb` +
`segmentation_queries.sql`. Every claim traces to a stated combination of variables.

---

## Part A — Promotional Sunset Plan

### The evidence (why "keep discounting" is the expensive option)
Discounting buys the brand **nothing measurable**. Like-for-like:

| | Full-price customers | Discounted customers |
|---|---|---|
| Customers | 2,223 (57%) | 1,677 (43%) |
| Avg spend | **$60.13** | $59.28 |
| Avg rating | 3.76 | 3.74 |
| Avg prior purchases | 25.1 | 25.7 |

Discounted customers spend **slightly less**, rate the brand the **same**, and repeat the
**same** amount. **43% of the base ($99,411 of $233,081 revenue, ~43%) is promo-attached for no
behavioural return.** That margin is being given away, not invested.

### Who to wean — and in what order (named segments, not "reduce discounts")

**Phase 1 (Months 0–2) — Subscription-Promo customers (1,053 customers, $62,645 revenue).**
- *Why first:* they have already committed to a recurring relationship (subscription) — the
  discount is now a habit, not the reason they buy. 32% are already behaviourally sticky.
- *Action:* replace the standing % discount with a **non-price loyalty perk** (free express
  shipping, early seasonal access, a points programme). Same perceived value, protects margin.
- *Trigger to act on a customer:* subscriber with ≥ median prior purchases (≥25) — these are
  safe to transition first.
- *Trade-off / risk:* a minority of price-sensitive subscribers may lapse; cap exposure by
  piloting on the **High value_tier** sub-segment before full rollout.

**Phase 2 (Months 2–4) — Bargain-Hunters (624 customers, $36,766 revenue).**
- *Why second:* only 26% show sticky behaviour — many are one-time deal-seekers with low
  brand pull.
- *Action:* move from blanket discounts to **targeted, expiring first-purchase-only offers**;
  stop re-discounting repeat bargain-hunters. Let genuinely price-only buyers self-select out.
- *Trade-off / risk:* some volume loss is expected and **acceptable** — this volume carries no
  margin and no loyalty; the goal is to stop subsidising it.

**Never discount — protect at all costs (942 Margin-Safe + 281 Ideal Loyalists).**
- These already pay full price and are satisfied (rating 4.47). Offering them discounts would
  *train* a profitable segment to expect them — pure margin destruction. **Hold the line.**

### Margin impact (explicit, adjustable)
- Promo-attached revenue at stake: **$99,411 (~43% of revenue).**
- If discounts average ~15% off list, the sunset recovers roughly **0.15 × $99,411 ≈ $14,900**
  in margin per equivalent period, **before** any churn. Even at a pessimistic 20% churn of
  promo-attached revenue, net margin still improves because the lost revenue carried near-zero
  contribution. *(Swap in the real average discount % and contribution margin to finalise.)*

### The one metric to track
**Full-price revenue share** = full-price revenue ÷ total revenue (today: **~57%** of
customers, ~57% of revenue). The sunset is working if this share **rises** while total revenue
holds flat or grows. Secondary guardrail: **margin-safe-loyal count (loyal_b)** must not fall.

### Rollout timeline
| Month | Action | Success check |
|---|---|---|
| 0 | Pilot perk-swap on High-value subscribers | retention holds vs control |
| 0–2 | Roll Phase 1 to all subscribers | full-price share ↑, churn < 10% |
| 2–4 | Phase 2 bargain-hunter tightening | margin ↑, total revenue flat+ |
| 4+ | Reallocate saved margin → acquiring Ideal-Customer lookalikes | ideal-customer count ↑ |

---

## Part B — Ideal Customer Profile (data-backed, targetable today)

The **Ideal Loyalist** = full-price **and** satisfied **and** a frequent repeat buyer
(`loyal_a ∧ loyal_b`). **281 customers (7.2% of the base)** — small, but the blueprint for
profitable acquisition.

| Attribute | Ideal Loyalist signature |
|---|---|
| Spend | **$61.75** avg (above the $59.76 base) |
| Prior purchases | **37.4** (vs 25.4 base) — deep repeat history |
| Satisfaction | **4.47 / 5** rating |
| Discount reliance | **0%** — buys entirely at full price |
| Age | ~**44** (mature, stable spenders) |
| Gender | **52% female** — notable, since the base is 68% male → **women over-index on loyalty** |
| Cadence | **Bi-Weekly / Monthly** buyers |
| Category | **Clothing**, then **Accessories** |
| Season | even, with mild **Summer/Winter** peaks |
| Payment | **Credit Card / Cash** |

**How to acquire more (the recommendation):**
1. **Target female, 35–55, full-price shoppers** in lookalike modelling — they convert to
   loyalty at a higher rate than the male-heavy base suggests.
2. **Lead acquisition with Clothing & Accessories** (the loyalists' entry categories), then
   drive cadence to Bi-Weekly/Monthly via the non-price loyalty programme from Part A.
3. **Concentrate spend on organic-demand geographies** — Arizona, Kansas, Alaska, Tennessee,
   Michigan (high value, low discount reliance) — where brand pull already exists.
- *Trade-off:* a full-price-first acquisition strategy converts **slower** than discount-led
  acquisition, but produces customers worth far more and costs nothing in eroded margin.

---

## Watch-list: At-Risk customers
**680 customers rate the brand below 3.0** with average tenure 25 purchases — these are
*existing* relationships at risk. Prioritise a satisfaction intervention (service follow-up,
not a discount) before they churn; discounting an unhappy customer fixes nothing the data shows.
