# 🛒 E-Commerce & SaaS Revenue Analytics Platform

An interactive Power BI report that looks at how a software business makes its money: which plans and deals drive revenue, how loyal customers are, and where money is being lost through refunds and promo codes.

**Tools used:** Power BI, DAX, Power Query, Deneb (Vega-Lite), HTML Content, SVG

**Live report:** [View the interactive dashboard](https://app.powerbi.com/view?r=eyJrIjoiYjZhZmRiMzItMGM4My00ZDU2LWFmYjUtY2U1YTU3MjA2N2Q2IiwidCI6Ijc4NGU5YWE4LWI4ZjQtNGFhOS1iMTgzLTE5ODExNjE5YjllZSJ9)

## 💭 Why I built this

A revenue total on its own says very little. I wanted to understand what sits behind the number and answer the questions a sales, finance or customer success team would actually ask:

* Which plans, deal sizes and products bring in most of the revenue?
* Are customers sticking around, and are we still winning new ones?
* Which valuable customers have gone quiet and are worth winning back?
* How much revenue is lost to refunds and discounts that could have been avoided?

## ⌗ The Data

* **Type:** E-commerce transactions for a software (SaaS) business
* **Period covered:** April 2024 to October 2025
* **Size:** 48,000 transactions, 4,000 customers and 101 software products

## 🔍 Key Insights

* **Annual plans drive the business:** They make up 49% of orders but 88% of revenue, and each annual order is worth about 10 times a monthly one.
* **Big deals matter most:** Orders of 10 or more seats are 29% of volume but 70% of revenue.
* **Revenue is concentrated:** Just 38 of the 101 products generate 80% of revenue.
* **Retention is strong, but growth has stalled:** About 85% of customers keep buying each quarter, yet new customer acquisition almost stopped in 2025.
* **There's a clear win back list:** 492 high value customers have gone quiet, and together they hold $5.9M of lifetime revenue.
* **Over half of refunds are preventable:** 56% of refunded revenue came from billing errors and duplicate orders.
* **Promo codes are leaking:** Welcome codes were reused on around 5,000 repeat orders ($319K in discounts), and 89% of Black Friday codes were redeemed outside November and December.

## 🛠️ How I built it

* **DAX** for RFM segmentation, cohort retention, like for like year over year comparisons and Pareto analysis
* **Deneb (Vega-Lite)** for custom visuals, including a Pareto chart, cohort heatmap, dumbbell chart and refund hotspot matrix
* **HTML Content visuals** for KPI tiles with sparklines and insight cards that update with the filters
* **SVG measures** to place data bars and bullet charts inside tables
* **A custom theme**, background and typography used consistently across every page

## 💡 Lesson learned

Checking the data model before building any visuals paid off. The audit caught a discount measure that added up to $61.9B instead of $1.26M, discount rates above 100%, and tax being counted twice in gross revenue. Fixing these first meant every chart afterwards could be trusted.

## 📊 How the dashboard is organised

### Page 1: Executive Summary

This page gives a quick view of how the business is doing overall. It shows the headline numbers for revenue, orders and customers, how they are trending over time, and how each one compares with the same period last year. It's the starting point for the rest of the report.

<img width="997" alt="Executive Summary" src="https://github.com/user-attachments/assets/02f26e52-c837-4fcf-8b5c-f463b446f7dd" />

### Page 2: Customer Loyalty

This page groups customers by how recently they bought, how often they buy and how much they spend (RFM). It makes it easy to see who the most valuable customers are, who is at risk, and which high value customers have gone quiet and should be contacted first.

<img width="997" alt="Customer Loyalty" src="https://github.com/user-attachments/assets/1e2f5265-a6fa-4720-87e7-5267044ad67c" />

### Page 3: Revenue Drivers

This page breaks revenue down by plan type, deal size and product. The Pareto chart shows how a small group of products brings in most of the revenue, and the comparisons make it clear why annual plans and larger seat deals matter so much.

<img width="997" alt="Revenue Drivers" src="https://github.com/user-attachments/assets/4e695669-b5b0-4de7-b25e-0e8737fee643" />

### Page 4: Customer Health & Retention

This page follows groups of customers from their first purchase to see how many keep coming back each quarter. The cohort heatmap shows that retention stays strong over time, while also revealing how few new customers joined in 2025.

<img width="996" alt="Customer Health and Retention" src="https://github.com/user-attachments/assets/e61096c9-bb60-4fe1-a1c2-bab0979b609a" />

### Page 5: Refunds & Promotions

This page looks at where money is leaking out of the business. It shows the main reasons for refunds and which products they come from, then checks how promo codes are actually being used, including welcome codes used by repeat customers and seasonal codes redeemed out of season.

<img width="996" alt="Refunds and Promotions" src="https://github.com/user-attachments/assets/2ed11578-4417-4bbd-879d-ff84966280e9" />
