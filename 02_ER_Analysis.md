# Task 2 — Entities, Attributes, and Relationships

## 1. Entities

The system is modeled around **5 strong entities**:

| # | Entity | Purpose |
|---|--------|---------|
| 1 | **CUSTOMER** | Stores personal/contact details of every customer who rents a vehicle |
| 2 | **VEHICLE** | Represents every vehicle in the rental inventory |
| 3 | **BOOKING** | The central transaction — links a customer to a vehicle for a specific date range |
| 4 | **PAYMENT** | Records money paid against a booking (supports multiple installments) |
| 5 | **RETURN** | Records the closure of a booking when the vehicle is returned |

---

## 2. Attributes

### 2.1 CUSTOMER

| Attribute | Type | Description |
|-----------|------|-------------|
| **CustomerID** (PK) | INT | Unique system-generated identifier |
| Name | VARCHAR(100) | Customer's full name |
| CNIC | VARCHAR(15) | National identity number (UNIQUE) |
| Phone | VARCHAR(15) | Contact number |
| Email | VARCHAR(100) | Email address |
| Address | VARCHAR(255) | Residential or business address |

### 2.2 VEHICLE

| Attribute | Type | Description |
|-----------|------|-------------|
| **VehicleID** (PK) | INT | Unique vehicle identifier |
| Make | VARCHAR(50) | Manufacturer (Toyota, Honda, Suzuki, etc.) |
| Model | VARCHAR(50) | Model name (Corolla, Civic, etc.) |
| Year | INT | Manufacturing year |
| LicensePlate | VARCHAR(20) | Government-issued plate (UNIQUE) |
| RentalRate | DECIMAL(10,2) | Rental price per day |
| Status | VARCHAR(20) | Available / Rented / Maintenance |

### 2.3 BOOKING

| Attribute | Type | Description |
|-----------|------|-------------|
| **BookingID** (PK) | INT | Unique booking identifier |
| CustomerID (FK) | INT | Reference to CUSTOMER |
| VehicleID (FK) | INT | Reference to VEHICLE |
| StartDate | DATE | Rental start date |
| EndDate | DATE | Planned end date |
| Status | VARCHAR(20) | Active / Completed / Cancelled |
| *TotalDays* | INT | **Derived** — computed at query-time as `EndDate − StartDate` (not stored in schema) |
| TotalAmount | DECIMAL(10,2) | Total rental cost for the booking |

### 2.4 PAYMENT

| Attribute | Type | Description |
|-----------|------|-------------|
| **PaymentID** (PK) | INT | Unique payment identifier |
| BookingID (FK) | INT | Reference to BOOKING |
| Amount | DECIMAL(10,2) | Payment amount |
| PaymentDate | DATE | Date of payment |
| Method | VARCHAR(20) | Cash / Card / Bank Transfer / Online |

### 2.5 RETURN

| Attribute | Type | Description |
|-----------|------|-------------|
| **ReturnID** (PK) | INT | Unique return identifier |
| BookingID (FK) | INT | Reference to BOOKING (UNIQUE — 1:1) |
| ReturnDate | DATE | Actual return date |
| Condition | VARCHAR(50) | Excellent / Good / Damaged |
| LateFee | DECIMAL(10,2) | Fee applied if returned after EndDate |

> **Note on derived attributes:** `TotalDays` is the only fully derived attribute — it is computed at query time as `EndDate − StartDate` and is NOT stored as a column in the database. It appears as a dashed oval in the ERD. The other dashed ovals shown in the diagrams (`TotalAmount`, vehicle `Status`) are physically stored in the schema for convenience and indexing, but their values are logically derivable from other attributes.

---

## 3. Relationships

| # | Relationship | Between | Cardinality | Participation | Business Meaning |
|---|--------------|---------|-------------|---------------|------------------|
| 1 | **Makes** | Customer ↔ Booking | 1 : N | Customer: Partial, Booking: Total | One customer can make many bookings; every booking belongs to exactly one customer |
| 2 | **For** | Booking ↔ Vehicle | N : 1 | Booking: Total, Vehicle: Partial | A vehicle can have many bookings over time; each booking is for exactly one vehicle |
| 3 | **Has Payment** | Booking ↔ Payment | 1 : N | Booking: Partial, Payment: Total | A booking can have multiple installment payments; each payment belongs to one booking |
| 4 | **Ends With** | Booking ↔ Return | 1 : 1 | Booking: Partial, Return: Total | Each booking ends with exactly one return record (or zero if still active) |

---

## 4. Summary

- **5 core entities** in the basic ERD, expanded with **5 specialized subclasses** (2 under Customer, 3 under Vehicle) in the EERD
- **4 relationships** — Makes, For, Has Payment, Ends With
- **5 primary keys** (one per entity)
- **4 foreign keys** — `Booking.CustomerID`, `Booking.VehicleID`, `Payment.BookingID`, `Return.BookingID`
- **1 truly derived attribute** — `TotalDays`

---

## 5. EER Extensions (Specialization)

The basic ERD is extended into an EERD with two **disjoint, total** specializations — one on `CUSTOMER` and one on `VEHICLE`. Each subclass **inherits all attributes** from its superclass and adds its own subclass-specific attributes.

### 5.1 CUSTOMER Specialization (Disjoint, Total)

The `CUSTOMER` superclass is specialized into two mutually exclusive subclasses:

#### 5.1.1 INDIVIDUAL CUSTOMER
Represents a private individual renting a vehicle for personal use.

| Attribute | Type | Description |
|-----------|------|-------------|
| *(inherits all attributes of CUSTOMER)* | — | CustomerID, Name, CNIC, Phone, Email, Address |
| DOB | DATE | Date of birth (for age verification) |
| Gender | VARCHAR(10) | Male / Female / Other |

#### 5.1.2 CORPORATE CUSTOMER
Represents a company or organization renting vehicles for business use.

| Attribute | Type | Description |
|-----------|------|-------------|
| *(inherits all attributes of CUSTOMER)* | — | CustomerID, Name, CNIC, Phone, Email, Address |
| CompanyName | VARCHAR(100) | Registered name of the company |
| TaxID | VARCHAR(20) | Company tax identification number (NTN) |
| ContactPerson | VARCHAR(100) | Authorized representative of the company |

---

### 5.2 VEHICLE Specialization (Disjoint, Total)

The `VEHICLE` superclass is specialized into three mutually exclusive subclasses:

#### 5.2.1 CAR
Standard passenger car rentals.

| Attribute | Type | Description |
|-----------|------|-------------|
| *(inherits all attributes of VEHICLE)* | — | VehicleID, Make, Model, Year, LicensePlate, RentalRate, Status |
| SeatingCapacity | INT | Number of passenger seats |
| Transmission | VARCHAR(20) | Manual / Automatic |
| FuelType | VARCHAR(20) | Petrol / Diesel / Hybrid / Electric |

#### 5.2.2 BIKE
Motorcycle / two-wheeler rentals.

| Attribute | Type | Description |
|-----------|------|-------------|
| *(inherits all attributes of VEHICLE)* | — | VehicleID, Make, Model, Year, LicensePlate, RentalRate, Status |
| EngineCC | INT | Engine displacement in cubic centimeters |
| BikeType | VARCHAR(30) | Sport / Cruiser / Standard / Scooter |

#### 5.2.3 TRUCK
Commercial cargo and load-bearing vehicle rentals.

| Attribute | Type | Description |
|-----------|------|-------------|
| *(inherits all attributes of VEHICLE)* | — | VehicleID, Make, Model, Year, LicensePlate, RentalRate, Status |
| LoadCapacity | DECIMAL(10,2) | Maximum load weight (in tons) |
| NumAxles | INT | Number of axles |

---

### 5.3 EER Notation Used

| Symbol | Meaning |
|--------|---------|
| **d** (circle with letter d) | **Disjoint specialization** — every superclass instance belongs to **at most one** subclass (subclasses are mutually exclusive) |
| **Double line** between superclass and `d` circle | **Total participation** — every superclass instance MUST belong to one of the subclasses |
| **U** on subclass edges | **Subset / IS-A relationship** — the subclass is a subset of the superclass and inherits all of its attributes |
