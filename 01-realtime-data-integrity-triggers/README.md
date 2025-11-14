# Project 01: Real-Time Data Integrity & Aggregation using Triggers

## The objective of this project was to establish an automated, real-time mechanism to maintain a simplified Summary Table (orders) by aggregating data from a complex Transactional Table (order_items).

This technique ensures that the orders table is always current for faster analytical queries, eliminating the need for periodic batch loads, thus improving data freshness and query performance.

### Technologies Used
- Database: MySQL (Used for this implementation)

- Concepts: Data Definition Language (DDL), Data Manipulation Language (DML), Database Triggers, Data Aggregation.

### The Problem and Solution:
### The Challenge
We needed a consolidated view of each customer order, summarizing key metrics (total price, number of items, primary product ID) from the detailed, row-level order_items table. A standard batch job would introduce latency, while manual updates are error-prone.

### The Solution: AFTER INSERT TRIGGER
The solution uses a MySQL Trigger associated with the order_items table. This trigger fires immediately after any new record is inserted into order_items.

The core efficiency comes from the combined use of the trigger and the REPLACE INTO command.
- Trigger Logic: The trigger uses the new order_id (WHERE order_id = new.order_id) to aggregate the full order data from order_items.

- REPLACE INTO: This command is crucial. If an existing order_id is updated in the source table (or if we insert a new
  item for an existing order), REPLACE INTO ensures the existing row in the orders table
  The table is updated with the fresh summary data, avoiding duplicate entries and maintaining data integrity.

### Implementation: Files and Key Commands
The full implementation is contained in the data_integrity_trigger.sql file.

Key SQL Components:
1. Table Creation (orders): Defines the structure of the final, aggregated table.
2. Back-Population: An initial, one-time insert to load all existing historical data from order_items into the new orders table.
3. Automation Trigger: The central piece of logic, ensuring data consistency on every new transactional row.

### Results and Validation
The automation was validated by confirming the immediate and accurate update of the summary table after inserting new transactional data.


| **Metric**                 | **Before Insert into `order_items`** | **After Insert into `order_items` (Trigger Fired)** |
| -------------------------- | ------------------------------------ | --------------------------------------------------- |
| **Total Rows in `orders`** | 10,033 rows                          | 12,036 rows                                         |
| **Latest `created_at`**    | 2013-12-31 23:22:54                  | 2014-02-28 23:40:45                                 |






