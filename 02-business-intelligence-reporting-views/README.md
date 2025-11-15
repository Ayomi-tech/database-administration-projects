# Project 02: Business Intelligence Reporting Views

## View: 'monthly_sessions_view' - Core Marketing Traffic Snapshot

### Overview: 
This view provides the Marketing team with secure, pre-aggregated monthly website session data, grouped by traffic source and campaign. It ensures fast, reliable access to essential KPIs without requiring users to write SQL.


### Key Benefits
- **Security & Data Integrity:** Marketing receives read-only access to aggregated metrics, reducing risk to the underlying 'website_sessions' table.  
- **Efficiency:** Eliminates the need to write complex aggregation logic; the data is ready for direct use in BI tools.  
- **Actionable Insights:** Supports trend analysis and campaign performance monitoring across time.

### When to Use This View
- Building monthly traffic or campaign performance dashboards.  
- Comparing paid search sources (e.g., gsearch vs. bsearch).  
- Measuring month-over-month or year-over-year session trends.  
- Supplying standardized, controlled metrics to non-technical stakeholders.

### Technical Definition
This view summarizes data from the 'website_sessions' table, grouped by:
- calendar year  
- calendar month  
- utm source  
- utm campaign  

### Data Dictionary

| Field               | Description                                                         |
|---------------------|---------------------------------------------------------------------|
| 'year'              | The calendar year of the session.                                   |
| 'month'             | The calendar month of the session.                                  |
| 'utm_source'        | The traffic source (e.g., gsearch, bsearch).                        |
| 'utm_campaign'      | The specific marketing campaign that generated the traffic.         |
| 'number_of_sessions'| Count of unique website sessions for that month/source/campaign.    |




