# Vehicle Rental Management System

A database project for the **Database Systems** course at The University of Lahore, designed for **Ms. Ambreen Akmal**.

## Project Overview

This system manages a vehicle rental business — tracking customers, vehicles, bookings, payments, and returns. It supports full rental lifecycle operations from customer registration to vehicle return, including availability checks and revenue reporting.

## Repository Structure

```
Vehicle-Rental-Management-System/
├── README.md                          # This file
├── docs/
│   ├── 01_Project_Proposal.md         # Task 1: Project proposal
│   └── 02_ER_Analysis.md              # Task 2: Entities, Attributes, Relationships
├── diagrams/
│   ├── ERD.png                        # Task 3a: ERD image
│   └── EERD.jpeg                      # Task 3b: EERD image
├── sql/
│   ├── 01_schema.sql                  # CREATE TABLE statements (MySQL)
│   ├── 02_sample_data.sql             # INSERT sample data
│   └── 03_joins.sql                   # Task 6: Join queries with outputs
└── screenshots/                       # Workbench/CLI screenshots of join results
```

## Tasks Mapping

| Task | Description | File |
|------|-------------|------|
| Task 1 | Project proposal | `docs/01_Project_Proposal.md` |
| Task 2 | Entities, attributes, relationships | `docs/02_ER_Analysis.md` |
| Task 3a | Construct ERD in standard notation | `diagrams/ERD.png` |
| Task 3b | Extend to EERD with specialization | `diagrams/EERD.jpeg` |
| Task 6 | Perform joins on two tables | `sql/03_joins.sql` |

## Tech Stack

- **DBMS:** PostgreSQL 15+
- **Tool:** pgAdmin 4 (Query Tool)
- **Modeling Tool:** draw.io (diagrams.net)
- **Notation:** Chen / Elmasri-Navathe (Standard ERD), with EER specialization extensions

## How to Run (in pgAdmin)

1. Open **pgAdmin 4** and connect to your local PostgreSQL server
2. Right-click **Databases** → **Create** → **Database**, name it `vehiclerentaldb`
3. Click on `vehiclerentaldb` → open **Query Tool** (lightning-bolt icon)
4. Run the SQL files in this order:
   - Open and execute `sql/01_schema.sql`  → creates the 5 tables
   - Open and execute `sql/02_sample_data.sql`  → inserts sample rows
   - Open and execute `sql/03_joins.sql`  → runs all 7 join queries
5. Take screenshots of each query result and put them in `screenshots/`

### Alternative: Run from terminal (`psql`)
```bash
createdb vehiclerentaldb
psql -d vehiclerentaldb -f sql/01_schema.sql
psql -d vehiclerentaldb -f sql/02_sample_data.sql
psql -d vehiclerentaldb -f sql/03_joins.sql
```

## Group Members

| Name |
|------|
| Muhammad Usman Tariq |
| Fazal Shahbaz |
| Fahad Zubair |

## Course Info

- **Course:** Database Systems
- **Section:** B
- **Instructor:** Ms. Ambreen Akmal
- **Institution:** The University of Lahore
