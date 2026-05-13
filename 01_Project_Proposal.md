# Task 1 — Project Proposal

## Project Title
**Vehicle Rental Management System (VRMS)**

## 1. Description
The Vehicle Rental Management System is a relational-database-driven application that automates the day-to-day operations of a vehicle rental agency. It replaces manual ledger-based processes with a structured digital system that records customer details, vehicle inventory, rental bookings, payments, and vehicle returns. The system provides a single source of truth for all rental transactions, eliminating the data redundancy and inconsistency that plagues paper-based or spreadsheet-based record-keeping.

## 2. Problem Statement
Local rental businesses currently track bookings on paper or in disconnected Excel sheets. This causes:
- **Double-booking** of the same vehicle for overlapping dates
- **Lost payment records** and disputed balances
- **No visibility** into which vehicles are available, rented, or under maintenance
- **Manual revenue reporting** which is slow and error-prone
- **No audit trail** when a vehicle is damaged on return

## 3. What We Are Going to Build
A normalized **PostgreSQL** database with five core tables (Customer, Vehicle, Booking, Payment, Return) connected by referential integrity constraints. The schema enforces business rules through primary keys, foreign keys, `UNIQUE` constraints (CNIC, License Plate), and `CHECK`/`DEFAULT` constraints (status fields, late fees). The database is designed from an ERD constructed in standard Chen notation and extended into an EERD using disjoint specialization for customer and vehicle subtypes.

## 4. Features

| # | Feature | Description |
|---|---------|-------------|
| 1 | Customer Management | Register, view, update, and delete customer records with CNIC validation |
| 2 | Vehicle Inventory | Add vehicles, update rental rates, track availability status |
| 3 | Booking Management | Create new rentals with automatic conflict detection (no overlapping dates) |
| 4 | Payment Processing | Record full or installment payments tied to a booking, multiple methods supported |
| 5 | Return Handling | Log return date, vehicle condition, and apply late fees if returned past EndDate |
| 6 | Availability Lookup | Query which vehicles are free for a given date range |
| 7 | Revenue Reports | Aggregate revenue by day, vehicle, or customer using SQL `JOIN` + `GROUP BY` |
| 8 | Customer History | Pull complete rental history for any customer through joins |

## 5. Entities (High-Level)
- **Customer** — Person or company renting a vehicle
- **Vehicle** — Rentable asset (car, bike, or truck)
- **Booking** — Rental contract linking a customer to a vehicle for a date range
- **Payment** — Money paid against a booking (supports installments)
- **Return** — Record of vehicle being returned at the end of a booking

## 6. Expected Outcome
By the end of the project, we will deliver:
- A fully normalized **PostgreSQL database** populated with realistic sample data
- A **Chen-notation ERD** and an **EERD** with specialization hierarchies
- A set of **SQL queries** demonstrating `INNER`, `LEFT`, and multi-table `JOIN` operations producing meaningful business reports
- A **GitHub repository** containing all deliverables with proper documentation
- A **submission-ready Project Phase I & II** report covering proposal, analysis, ERD/EERD, and join queries

## 7. Tools & Technologies
- **PostgreSQL 15+** — Relational database management system
- **pgAdmin 4** — Schema execution and query testing
- **draw.io / diagrams.net** — ERD/EERD modeling
- **GitHub** — Version control and submission
- **Markdown** — Documentation
