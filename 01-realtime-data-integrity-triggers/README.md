# Project 01: Real-Time Data Integrity & Aggregation using Triggers

## This project implements an automated real-time mechanism to maintain a simplified 'orders' summary table by aggregating data from the transactional 'order_items' table. The trigger-based design ensures that aggregated order metrics remain immediately up to date without relying on batch jobs, improving both data freshness and analytical query performance.

## Technologies Used
- **Database:** MySQL  
- **Concepts:** DDL, DML, Triggers, Aggregation, Data Integrity


## Problem & Motivation

### The Challenge
Analytical queries needed a consolidated view of orders—total price, number of items, and primary product ID, but the 'order_items' table stores highly granular, row-level data.  
Traditional batch pipelines introduced latency, and manual updates were error-prone.

### The Objective
Automatically maintain a clean, aggregated record for each order in real time as new 'order_items' records arrive.

## Solution: AFTER INSERT Trigger + REPLACE INTO

A MySQL **AFTER INSERT** trigger on 'order_items' performs live aggregation of all rows belonging to the affected 'order_id'.

Key design elements:

### 🔹 Trigger Logic
- When a new row is inserted into 'order_items', the trigger queries all items for that order ('WHERE order_id = NEW.order_id').
- It recalculates order-level metrics (item count, total price, primary product).

### 🔹 Why REPLACE INTO?
'REPLACE INTO' ensures the summary table is always up to date by:
- Inserting the row if it does not exist.
- Automatically deleting the old version and inserting the updated one if it exists.

This eliminates:
- Duplicate order summaries  
- The need to check whether the order already exists  
- Conditional logic inside the trigger

## Implementation Details

All SQL is contained in **'data_integrity_trigger.sql'**, including:

### 1. Summary Table Creation ('orders')
Defines order-level fields such as:
- 'order_id'
- 'number_of_items'
- 'total_amount'
- 'primary_product_id'
- 'created_at'

### 2. Backfill Step (Historical Load)
A one-time insert aggregates all existing records from 'order_items'.

### 3. Real-Time Trigger
Ensures the 'orders' table stays in sync for every new insert into 'order_items'.

## Results & Validation

To confirm correctness, new rows were inserted into 'order_items' and the 'orders' table was inspected before and after trigger execution:

| **Metric**                 | **Before Insert**         | **After Insert (Trigger Fired)** |
|---------------------------|---------------------------|----------------------------------|
| Total Rows in 'orders'    | 10,033                    | 12,036                           |
| Latest 'created_at'       | 2013-12-31 23:22:54        | 2014-02-28 23:40:45              |

This validated that the trigger updated the summary table in real time without requiring any manual refresh.

## Summary
This project demonstrates how MySQL triggers can maintain real-time, aggregated reporting tables without batch jobs—improving data accuracy, reducing operational complexity, and enabling faster analytics.








