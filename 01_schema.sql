-- =====================================================================
-- Vehicle Rental Management System - Schema
-- DBMS: PostgreSQL 15+
-- =====================================================================
-- Run order: 01_schema.sql -> 02_sample_data.sql -> 03_joins.sql
-- Tool: pgAdmin 4  (Query Tool)
-- =====================================================================

-- Create the database (run this part from postgres default DB or psql)
-- DROP DATABASE IF EXISTS vehiclerentaldb;
-- CREATE DATABASE vehiclerentaldb;
-- \c vehiclerentaldb

-- Drop in reverse dependency order if re-running
DROP TABLE IF EXISTS "Return"  CASCADE;
DROP TABLE IF EXISTS Payment    CASCADE;
DROP TABLE IF EXISTS Booking    CASCADE;
DROP TABLE IF EXISTS Vehicle    CASCADE;
DROP TABLE IF EXISTS Customer   CASCADE;

-- ---------------------------------------------------------------------
-- 1. CUSTOMER
-- ---------------------------------------------------------------------
CREATE TABLE Customer (
    CustomerID   SERIAL          PRIMARY KEY,
    Name         VARCHAR(100)    NOT NULL,
    CNIC         VARCHAR(15)     NOT NULL UNIQUE,
    Phone        VARCHAR(15),
    Email        VARCHAR(100),
    Address      VARCHAR(255)
);

-- ---------------------------------------------------------------------
-- 2. VEHICLE
-- ---------------------------------------------------------------------
CREATE TABLE Vehicle (
    VehicleID     SERIAL          PRIMARY KEY,
    Make          VARCHAR(50)     NOT NULL,
    Model         VARCHAR(50)     NOT NULL,
    Year          INT             CHECK (Year BETWEEN 1980 AND 2030),
    LicensePlate  VARCHAR(20)     NOT NULL UNIQUE,
    RentalRate    NUMERIC(10,2)   NOT NULL CHECK (RentalRate > 0),
    Status        VARCHAR(20)     DEFAULT 'Available'
                  CHECK (Status IN ('Available','Rented','Maintenance'))
);

-- ---------------------------------------------------------------------
-- 3. BOOKING
-- ---------------------------------------------------------------------
CREATE TABLE Booking (
    BookingID     SERIAL          PRIMARY KEY,
    CustomerID    INT             NOT NULL,
    VehicleID     INT             NOT NULL,
    StartDate     DATE            NOT NULL,
    EndDate       DATE            NOT NULL,
    Status        VARCHAR(20)     DEFAULT 'Active'
                  CHECK (Status IN ('Active','Completed','Cancelled')),
    TotalAmount   NUMERIC(10,2),
    CONSTRAINT fk_booking_customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    CONSTRAINT fk_booking_vehicle  FOREIGN KEY (VehicleID)
        REFERENCES Vehicle(VehicleID)  ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (EndDate >= StartDate)
);

-- ---------------------------------------------------------------------
-- 4. PAYMENT
-- ---------------------------------------------------------------------
CREATE TABLE Payment (
    PaymentID     SERIAL          PRIMARY KEY,
    BookingID     INT             NOT NULL,
    Amount        NUMERIC(10,2)   NOT NULL CHECK (Amount > 0),
    PaymentDate   DATE            NOT NULL,
    Method        VARCHAR(20)     CHECK (Method IN ('Cash','Card','Bank Transfer','Online')),
    CONSTRAINT fk_payment_booking FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 5. RETURN  ("Return" is a PostgreSQL reserved word -> use double quotes)
-- ---------------------------------------------------------------------
CREATE TABLE "Return" (
    ReturnID      SERIAL          PRIMARY KEY,
    BookingID     INT             NOT NULL UNIQUE, -- enforces 1:1
    ReturnDate    DATE            NOT NULL,
    "Condition"   VARCHAR(50)     CHECK ("Condition" IN ('Excellent','Good','Damaged')),
    LateFee       NUMERIC(10,2)   DEFAULT 0 CHECK (LateFee >= 0),
    CONSTRAINT fk_return_booking FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Confirm schema
-- ---------------------------------------------------------------------
SELECT table_name
FROM   information_schema.tables
WHERE  table_schema = 'public'
ORDER  BY table_name;
