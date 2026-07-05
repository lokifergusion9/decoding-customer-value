-- =====================================================================
--  Decoding Customer Value — SQL Segmentation Layer (Deliverable 2)
--  Dialect: MySQL 8.0+   (uses CTEs + window functions)
--  Source : customers_enriched.csv  (exported by customer_value_analysis.ipynb)
--
--  Loyalty is DEFINED, not declared. Primary loyalty label = loyal_b
--  (Margin-safe: full price AND satisfied). loyal_a (behavioural) is the
--  secondary engagement axis. ideal_customer = loyal_a AND loyal_b.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. SCHEMA  (column order matches customers_enriched.csv exactly)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id            INT PRIMARY KEY,
    age                    INT,
    gender                 VARCHAR(10),
    item_purchased         VARCHAR(50),
    category               VARCHAR(30),
    purchase_amount        DECIMAL(8,2),
    location               VARCHAR(40),
    size                   VARCHAR(5),
    color                  VARCHAR(30),
    season                 VARCHAR(15),
    review_rating          DECIMAL(3,2),
    subscription_status    VARCHAR(5),
    shipping_type          VARCHAR(20),
    discount_applied       VARCHAR(5),
    promo_code_used        VARCHAR(5),
    previous_purchases     INT,
    payment_method         VARCHAR(20),
    frequency_of_purchases VARCHAR(20),
    freq_rank              INT,
    high_cadence           TINYINT,
    disc                   TINYINT,            -- 1 = used a discount/promo
    sub                    TINYINT,            -- 1 = subscriber
    dependency_score       INT,               -- 0 / 60 / 100
    dependency_tier        VARCHAR(20),       -- Full-Price / Bargain-Hunter / Subscription-Promo
    value_score            DECIMAL(6,2),
    value_tier             VARCHAR(5),         -- Low / Mid / High
    satisfaction_flag      VARCHAR(10),        -- At-Risk / Neutral / Satisfied
    loyal_a                TINYINT,            -- behavioural loyalty
    loyal_b                TINYINT,            -- margin-safe loyalty (PRIMARY)
    ideal_customer         TINYINT
);

-- Load (adjust the path; needs local_infile=ON, or use Workbench's Table Data Import Wizard):
-- LOAD DATA LOCAL INFILE 'customers_enriched.csv'
-- INTO TABLE customers
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n' IGNORE 1 LINES;


-- =====================================================================
--  KEY QUESTION 1 — Who is genuinely loyal vs. a discount-only buyer?
-- =====================================================================
-- Maps every customer to a strategic segment from traceable flags.
SELECT
    CASE
        WHEN loyal_b = 1 AND loyal_a = 1 THEN 'Ideal Loyalist (full-price + repeat)'
        WHEN loyal_b = 1                 THEN 'Margin-Safe Loyalist (full-price)'
        WHEN loyal_a = 1 AND disc = 1    THEN 'Discount-Dependent Repeater'
        WHEN disc = 1                    THEN 'One-Time Bargain Hunter'
        ELSE                                  'Passive / Low-Engagement'
    END AS customer_segment,
    COUNT(*)                              AS customers,
    ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER (), 1) AS pct_of_base,
    ROUND(AVG(purchase_amount), 2)        AS avg_spend,
    ROUND(AVG(previous_purchases), 1)     AS avg_prev_purchases,
    ROUND(AVG(review_rating), 2)          AS avg_rating
FROM customers
GROUP BY customer_segment
ORDER BY customers DESC;


-- =====================================================================
--  KEY QUESTION 2 — What behavioural patterns predict high value?
-- =====================================================================
-- 2a. Value tier vs repeat behaviour, frequency and promo reliance.
SELECT
    value_tier,
    COUNT(*)                          AS customers,
    ROUND(AVG(previous_purchases),1)  AS avg_prev_purchases,
    ROUND(AVG(freq_rank),2)           AS avg_freq_rank,   -- 7=Weekly ... 1=Annually
    ROUND(AVG(disc),2)                AS promo_rate,
    ROUND(AVG(review_rating),2)       AS avg_rating
FROM customers
GROUP BY value_tier
ORDER BY FIELD(value_tier,'Low','Mid','High');

-- 2b. Which profiles show the STRONGEST repeat behaviour? (top quartile of prior purchases)
WITH ranked AS (
    SELECT *, NTILE(4) OVER (ORDER BY previous_purchases) AS prev_quartile
    FROM customers
)
SELECT
    dependency_tier,
    COUNT(*)                                          AS customers,
    ROUND(AVG(previous_purchases),1)                  AS avg_prev_purchases,
    ROUND(100*AVG(CASE WHEN prev_quartile=4 THEN 1 ELSE 0 END),1) AS pct_top_repeat_quartile
FROM ranked
GROUP BY dependency_tier
ORDER BY avg_prev_purchases DESC;


-- =====================================================================
--  KEY QUESTION 3 — Which geographies & demographics are under-leveraged?
-- =====================================================================
-- 3a. Organic-demand states: high value, LOW promo reliance, min 60 customers.
SELECT
    location,
    COUNT(*)                                   AS customers,
    ROUND(AVG(value_score),1)                  AS avg_value_score,
    ROUND(AVG(disc),2)                         AS promo_rate,
    ROUND(AVG(purchase_amount),2)              AS avg_spend,
    ROUND(AVG(value_score)*(1-AVG(disc)),1)    AS organic_score   -- value un-attributable to discounts
FROM customers
GROUP BY location
HAVING customers >= 60
ORDER BY organic_score DESC
LIMIT 10;

-- 3b. Demographic gaps: value & loyalty by age band x gender.
SELECT
    CASE WHEN age < 30 THEN '18-29'
         WHEN age < 45 THEN '30-44'
         WHEN age < 60 THEN '45-59'
         ELSE '60+' END                        AS age_band,
    gender,
    COUNT(*)                                   AS customers,
    ROUND(AVG(value_score),1)                  AS avg_value,
    ROUND(100*AVG(loyal_b),1)                  AS pct_margin_safe_loyal,
    ROUND(AVG(disc),2)                         AS promo_rate
FROM customers
GROUP BY age_band, gender
ORDER BY avg_value DESC;


-- =====================================================================
--  KEY QUESTION 4 — How should the promo strategy be restructured?
-- =====================================================================
-- 4a. The core evidence: does discounting buy ANY lift? (compare like-for-like)
SELECT
    discount_applied,
    COUNT(*)                          AS customers,
    ROUND(AVG(purchase_amount),2)     AS avg_spend,
    ROUND(AVG(previous_purchases),1)  AS avg_prev_purchases,
    ROUND(AVG(review_rating),2)       AS avg_rating
FROM customers
GROUP BY discount_applied;

-- 4b. Promo-sunset targeting: rank dependency tiers by value at stake & margin upside.
--     High-value Subscription-Promo customers = safest to wean (they already commit).
SELECT
    dependency_tier,
    value_tier,
    COUNT(*)                              AS customers,
    ROUND(AVG(purchase_amount),2)         AS avg_spend,
    ROUND(SUM(purchase_amount),0)         AS revenue_at_stake,
    ROUND(100*AVG(loyal_a),1)             AS pct_behaviourally_sticky
FROM customers
WHERE disc = 1                            -- only promo-attached customers
GROUP BY dependency_tier, value_tier
ORDER BY revenue_at_stake DESC;


-- =====================================================================
--  KEY QUESTION 5 — What does the ideal customer look like?
-- =====================================================================
-- 5a. Headline profile of the ideal customer (full-price + satisfied + repeat).
SELECT
    COUNT(*)                                          AS ideal_customers,
    ROUND(100*COUNT(*)/(SELECT COUNT(*) FROM customers),1) AS pct_of_base,
    ROUND(AVG(age),1)                                 AS avg_age,
    ROUND(AVG(purchase_amount),2)                     AS avg_spend,
    ROUND(AVG(previous_purchases),1)                  AS avg_prev_purchases,
    ROUND(AVG(review_rating),2)                       AS avg_rating
FROM customers
WHERE ideal_customer = 1;

-- 5b. Ideal customer's signature: top category, season, payment, gender mix.
SELECT 'category' AS attribute, category AS value, COUNT(*) AS n
    FROM customers WHERE ideal_customer=1 GROUP BY category
UNION ALL SELECT 'season', season, COUNT(*) FROM customers WHERE ideal_customer=1 GROUP BY season
UNION ALL SELECT 'payment', payment_method, COUNT(*) FROM customers WHERE ideal_customer=1 GROUP BY payment_method
UNION ALL SELECT 'gender', gender, COUNT(*) FROM customers WHERE ideal_customer=1 GROUP BY gender
ORDER BY attribute, n DESC;


-- =====================================================================
--  SCOPE QUERY A — Seasons & categories: low-tenure vs high-tenure customers
--  (entry-point vs retention categories)
-- =====================================================================
WITH tenure AS (
    SELECT *,
        CASE WHEN previous_purchases >= (SELECT AVG(previous_purchases) FROM customers)
             THEN 'High-Tenure' ELSE 'Low-Tenure' END AS tenure_group
    FROM customers
)
SELECT category, season, tenure_group,
       COUNT(*) AS customers,
       ROUND(AVG(previous_purchases),1) AS avg_prev_purchases
FROM tenure
GROUP BY category, season, tenure_group
ORDER BY category, season, tenure_group;

-- Category-level entry vs retention proxy: share of low-tenure customers per category.
SELECT
    category,
    COUNT(*)                                                            AS customers,
    ROUND(AVG(previous_purchases),1)                                   AS avg_prev_purchases,
    ROUND(100*AVG(CASE WHEN previous_purchases <
        (SELECT AVG(previous_purchases) FROM customers) THEN 1 ELSE 0 END),1) AS pct_low_tenure
FROM customers
GROUP BY category
ORDER BY pct_low_tenure DESC;


-- =====================================================================
--  SCOPE QUERY B — High-value vs low-value: which profiles repeat most?
-- =====================================================================
SELECT
    value_tier,
    dependency_tier,
    satisfaction_flag,
    COUNT(*)                          AS customers,
    ROUND(AVG(previous_purchases),1)  AS avg_prev_purchases
FROM customers
GROUP BY value_tier, dependency_tier, satisfaction_flag
HAVING customers >= 20
ORDER BY avg_prev_purchases DESC
LIMIT 15;
