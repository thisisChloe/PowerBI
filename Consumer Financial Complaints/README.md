# 💳 Consumer Financial Complaints Analytics

An interactive, five-page Power BI dashboard that analyses ~9,000 consumer complaints about financial products and services. Rather than just reporting complaint counts, it is built as a **regulatory intelligence tool** that moves from *what is happening* → *why* → *who is responsible* → *how well it gets resolved*.

**Tools used:** Power BI, DAX, Power Query

---

## 📂 Project Files

| File | Description |
|---|---|
| [CFCA.pbix](CFCA.pbix) | Power BI report file |
| [CFCA-Dataset.xlsx](CFCA-Dataset.xlsx) | Source dataset |

---

## 🎯 Business Questions

1. How many complaints are coming in, and is the system getting better or worse over time?
2. Which financial products and issues are driving the most complaints?
3. Which companies are under-performing once their size is taken into account?
4. How quickly and how fairly are complaints resolved, and does the submission channel make a difference?

---

## 🧭 Dashboard Structure

| Page | Focus | Key visuals |
|---|---|---|
| **1. Executive Overview** | Volume, trend and compliance health | KPI cards with year-on-year comparison, monthly trend, submission channel split, geographic map |
| **2. Root Cause Deep Dive** | Product and issue drivers | Top 10 products, top 10 issues, monetary relief % by product, relief vs. response time |
| **3. Accountability & Benchmarking** | Company performance | Risk quadrant (complaints per market share vs. timeliness), top offenders with compliance status, performance by company size, top 10 high-risk companies |
| **4. Resolution & Outcomes** | Resolution speed and fairness by channel | Outcome distribution by channel, timeliness by channel, response-time distribution, public response impact |
| **5. Report (Tabular)** | Self-service drill-down | Table where users choose which columns to display and export |

A date slicer and side navigation panel are shared across all pages.

---

## 📐 Key Metrics (DAX)

- **Total Complaints** with a vs-last-year comparison
- **Timely Response Rate %**: share of complaints answered on time
- **Avg. Days to Respond**
- **Monetary Relief %**: share of complaints closed with financial compensation, used as a signal of substantiated harm
- **Complaints per Market Share (CPM, normalised)**: adjusts complaint volume for company size, so large firms aren't flagged just for being large

---

## 🔍 Key Insights

- **Compliance has slipped.** The timely response rate fell to **77.9%** from 96.8% the previous year, and monetary relief dropped from 23.9% to **17.9%**. Volume rose to ~9K complaints, from about 8.2K.
- **Banking products dominate.** *Checking or savings accounts* (4.1K) and *credit cards* (2.4K) lead complaint volume. *Managing an account* is the single biggest issue (2.1K).
- **Volume ≠ harm.** Credit cards (23.5%) and checking/savings accounts (21.8%) also have the highest monetary relief rates. Credit reporting complaints rarely end in relief (2.3%).
- **Web is the bottleneck.** About 87% of complaints arrive via the web. Postal mail is answered most reliably (85.5% timely), while referral channels are the most likely to end in monetary relief (~24–25%). Because web carries most of the workload, improving web-based processing would have the biggest effect on overall performance.
- **Company size isn't the excuse.** Large, medium and small companies all respond on time ~77–78% of the time. Normalising by market share (CPM) shows that the high-risk companies are not simply the biggest ones.

---

## 📸 Dashboard Preview

### Page 1 – Executive Overview
<img width="1216" alt="Executive Overview" src="https://github.com/user-attachments/assets/97ae5063-0a40-42ef-ac54-e78a210f74e8" />

### Page 2 – Root Cause Deep Dive
<img width="1216" alt="Root Cause Deep Dive" src="https://github.com/user-attachments/assets/d5de7e62-bf1d-4ba7-9f66-494e4c37a176" />

### Page 3 – Company Accountability & Benchmarking
<img width="1216" alt="Accountability and Benchmarking" src="https://github.com/user-attachments/assets/850b981e-bebc-45a4-98ef-fe9fd80df5e8" />

### Page 4 – Resolution Channels & Outcomes
<img width="1216" alt="Resolution and Outcomes" src="https://github.com/user-attachments/assets/a931caa7-f992-49b1-8593-8f8fc7ec3b2e" />

### Page 5 – Report (Tabular)
<img width="1216" alt="Report Tabular" src="https://github.com/user-attachments/assets/c71d53ee-9e4a-4bf5-8711-fb45c3cc2945" />

---

## 👩🏻‍💻 Author

**Chloe Truong**: LinkedIn @thisischloetruong · hello.chloetruong@gmail.com
