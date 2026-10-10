# 📦 Business Performance & Supply Chain Dashboard

An interactive Power BI dashboard that tracks how a retail business is selling, who it's selling to, and how well it gets orders to customers. It brings sales, customers and supply chain into one report, so you can see not just what happened but where things are slipping.

**Tools used:** Power BI, DAX, Power Query

**Live report:** [View the interactive dashboard](https://app.powerbi.com/view?r=eyJrIjoiYWQxMDE2OTctOTkzMC00ZWFmLWIwMWItMmQ1MWJlYThiZjM2IiwidCI6Ijc4NGU5YWE4LWI4ZjQtNGFhOS1iMTgzLTE5ODExNjE5YjllZSJ9)

## 💭 Why I built this

Revenue on its own can look healthy while the business underneath is struggling. I wanted to build something a manager could open on a Monday morning and get straight answers to:

- Are we growing, and is that growth actually turning into profit?
- Which products, regions and customer groups are carrying the business?
- Do customers come back, and how often?
- Are orders getting out on time, and what happens when they don't?

## 🛠️ How I built it

- Cleaned and transformed the raw data in Power Query
- Built a semantic model and used advanced DAX for the performance metrics: period-over-period comparisons, retention, cohorts, late rate and return rate
- Designed the dashboard as a story, focusing on clarity, a natural user flow and insights someone could actually act on
- Gave the analytical logic and the UI/UX equal attention

## ⌗ The Data

- **Source:** Retail sales and order data (Superstore)
- **Period covered:** January 2014 – December 2017
- **Coverage:** 4 regions (Central, East, South, West), 3 customer groups (Consumer, Corporate, Home Office) and 3 product categories (Furniture, Office Supplies, Technology)

## 🔍 Key Insights

All figures are for 2017 compared with 2016, unless stated otherwise.

- **Growth isn't turning into profit:** Revenue grew 15.0% to $658.44K, with orders up 29.2% and customers up 8.8%. But cost of sales rose faster (17.7%), so gross profit actually fell 1.7% to $77.78K and gross margin slipped from 13.8% to 11.8%. Technology was the top category ($236K), Phones the top sub-category ($92K), and the Consumer group brought in 44.08% of revenue.
- **Orders are getting smaller:** Orders grew almost twice as fast as revenue, so the average order dropped from about $437 to $389. The business is doing more work for less money per order.
- **Returns are almost wiping out the year's profit:** The return rate rose from 7.64% to 8.71%, and the value of returned goods more than doubled (up 109%) to $75.50K. That's nearly the same as the whole year's gross profit.
- **Delivery is the weakest link:** Orders took 35.22 days on average to arrive (up from 33.28), and nearly half (46.34%) arrived late. All four regions sit between 33.78 and 36.24 days, so this is a company-wide process issue rather than one problem location.
- **Paying for faster shipping doesn't always mean faster delivery:** Orders placed on a Wednesday were the slowest in every shipping mode: 71.91 days for Standard Class, 57.23 for Second Class and 49.47 for First Class. First Class averaged 15–50 days depending on the weekday, which is hard to justify as a premium option. Only Same Day performed as expected (under 6 days).
- **Discounts are quietly eating margin:** In December 2017, the products losing money were almost all discounted ones. A discounted binding machine sold at a –150% margin, and two discounted tables also ended up below zero.
- **Customers are loyal, but don't buy often:** The business served 693 customers, with an average revenue per user of $950. The cohort analysis shows that only about 1 in 10 customers buys again in any given month after their first order, and most orders are just 2–3 units. Getting existing customers to order more often (reorder reminders, bundles) is likely a bigger win than chasing new ones.
- **The year ended on a slower note:** December revenue was down 34.2% on November, with 22.5% fewer orders and 18.2% fewer customers. The average order shrank from about $380 to $322, although margin improved slightly (12.2% to 14.2%). On the bright side, delivery times dropped sharply from September onwards, with December averaging 7.01 days.

## 📊 How the dashboard is organised

### Page 1 – Sales

The starting point. It shows revenue, gross profit, cost of sales, orders, units and customers, each compared with the previous period. You can switch the trend chart between metrics, see how regions and customer groups contribute, and flip the product chart between the best and worst performers.

<img width="1026" height="579" alt="Sales page" src="https://github.com/user-attachments/assets/265a0004-c35f-4e68-9a88-6e5a9e8f2f3a" />

### Page 2 – Supply Chain

This page looks at how well orders get delivered: average delivery days, late rate, return rate and the value of returned goods. It shows how return rate relates to delivery time for each shipping mode, and a weekday heatmap that makes it easy to spot where orders get stuck.

<img width="1028" height="580" alt="Supply Chain page" src="https://github.com/user-attachments/assets/6982f7c7-5ae8-4203-8804-8fba5309c70f" />

### Page 3 – Customer

This page focuses on who is buying and whether they come back. It covers total customers, revenue per user and retention, along with a monthly cohort analysis, customer mix by group and region, and how many items people typically buy per order.

<img width="1028" height="583" alt="Customer page" src="https://github.com/user-attachments/assets/4ec94761-103e-447d-b885-a470eb8c14b4" />

### Page 4 – Sales Detail

A product-level table showing revenue, share of revenue, gross profit, margin, return rate and discounts for each item. Loss-making products are highlighted, so it's quick to see where discounts have gone too far.

<img width="1028" height="578" alt="Sales Detail page" src="https://github.com/user-attachments/assets/9b65494a-446e-45be-9fa2-feecca62dd91" />

### Page 5 – Detail by Time

The same metrics laid out by day or month, with the change from the previous period. It's useful for tracing a spike or dip in the trend charts back to the exact day it happened.

<img width="1028" height="582" alt="Detail by Time page" src="https://github.com/user-attachments/assets/77ba2877-e432-4f55-a937-5ff4ad5437f6" />
