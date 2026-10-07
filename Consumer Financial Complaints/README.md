# 💳 Consumer Financial Complaints Analytics

An interactive Power BI dashboard that looks at consumer financial complaints: what people complain about, which companies they complain about, and how well those complaints get resolved.

**Tools used:** Power BI, DAX, Power Query

**Live report:** [View the interactive dashboard](https://app.powerbi.com/view?r=eyJrIjoiOGJjOTZkZWUtN2ZlZC00N2FhLWI4MjEtZWY4YjVmNmExYzNhIiwidCI6Ijc4NGU5YWE4LWI4ZjQtNGFhOS1iMTgzLTE5ODExNjE5YjllZSJ9)

## 💭 Why I built this

Complaint data is one of the clearest signals of where a financial product is failing its customers. I wanted to go past "how many complaints are there" and answer the questions a regulator or a product team would actually ask:

- Is the problem getting better or worse?
- Which products and issues are driving it?
- Which companies stand out, for good or bad reasons?
- Once a complaint is lodged, does it actually get resolved, and does the way it was submitted make a difference?

## ⌗ The Data

- **Source:** Consumer Financial Protection Bureau (CFPB) Consumer Complaint Database
- **Period covered:** May 2017 – August 2023
- **Size:** 62,516 complaints and 1,081 companies

## 🔍 Key Insights

- **Compliance has slipped:** Complaints rose from about 8.2K to 9K, while the share answered on time fell from 96.8% to 77.9%. Fewer complaints also ended in monetary relief, down from 23.9% to 17.9%.
- **Banking products dominate:** *Checking or savings accounts* (4.1K) and *credit cards* (2.4K) lead complaint volume. *Managing an account* is the single biggest issue (2.1K).
- **The most common complaints aren't always the most harmful:** Credit cards (23.5%) and checking/savings accounts (21.8%) also have the highest monetary relief rates. Credit reporting complaints (2.3%), by contrast, rarely lead to any relief.
- **Web is the bottleneck:** Around 87% of complaints come in through the web. Postal mail is actually answered on time more often, but because web carries most of the workload, faster web processing would do the most for overall performance.
- **Company size isn't the explanation:** Large, medium and small companies all respond on time at similar rates. Once complaints are measured against market share, the highest-risk companies turn out not to be the biggest ones.

## 📊 How the dashboard is organised

### Page 1 – Executive Overview: volume, trend and compliance

This page gives a quick sense of how the complaint system is performing overall. It covers how many complaints are coming in, how that changes over time, and how reliably companies respond, with each headline figure compared against the previous year. It's the starting point for the rest of the report.


<img width="1216" alt="Executive Overview" src="https://github.com/user-attachments/assets/97ae5063-0a40-42ef-ac54-e78a210f74e8" />

### Page 2 – Root Cause Deep Dive

This page breaks complaints down by product (mortgages, credit reporting, debt collection and so on) and then by the specific issues within each product. The aim is to show where a fix would make the most difference.


<img width="1216" alt="Root Cause Deep Dive" src="https://github.com/user-attachments/assets/d5de7e62-bf1d-4ba7-9f66-494e4c37a176" />

### Page 3 – Company Accountability & Benchmarking

This page shifts the focus to the companies themselves. Complaint volume is weighed against each company's market share, so smaller firms aren't unfairly hidden behind the big names, and that is paired with how reliably each company responds on time. The result makes it easier to see which companies consistently fall behind their peers and where regulatory attention might be best directed.


<img width="1216" alt="Accountability and Benchmarking" src="https://github.com/user-attachments/assets/850b981e-bebc-45a4-98ef-fe9fd80df5e8" />

### Page 4 – Resolution Channels & Outcomes

This page follows complaints through to the end. It looks at how quickly companies respond and how complaints are ultimately resolved, then compares both across the different ways consumers submit them. It also considers whether companies that respond publicly treat complaints any differently. Together, these show where the resolution process works well and where it slows down.


<img width="1216" alt="Resolution and Outcomes" src="https://github.com/user-attachments/assets/a931caa7-f992-49b1-8593-8f8fc7ec3b2e" />

### Page 5 – Report (Tabular)

This page gives direct access to the underlying complaint records. You can choose which fields to display, filter by date, and export the results for further analysis. It's designed for anyone who wants to dig into individual complaints beyond what the visual pages show.


<img width="1216" alt="Report Tabular" src="https://github.com/user-attachments/assets/c71d53ee-9e4a-4bf5-8711-fb45c3cc2945" />

