-- =====================================================================
-- Vehicle Rental Management System - 10 Functional Features
-- DBMS: PostgreSQL 15+
-- =====================================================================
-- This file demonstrates all 10 required functional features, covering
-- DDL (CREATE/ALTER/DROP), DML (INSERT/SELECT/UPDATE/DELETE), and
-- DCL (GRANT/REVOKE) commands.
--
-- Run AFTER 01_schema.sql and 02_sample_data.sql
-- =====================================================================


-- =====================================================================
-- FEATURE 1 : Register a New Customer  (DML - INSERT)
-- ---------------------------------------------------------------------
-- Adds a new customer record to the system.
-- =====================================================================
INSERT INTO Customer (Name, CNIC, Phone, Email, Address)
VALUES ('Imran Sheikh', '35202-1112223-9', '0300-1112223', 'imran.sheikh@gmail.com', 'Wapda Town, Lahore');

-- Verify
SELECT * FROM Customer WHERE CNIC = '35202-1112223-9';


-- =====================================================================
-- FEATURE 2 : Add a New Vehicle to Inventory  (DML - INSERT)
-- ---------------------------------------------------------------------
-- Adds a new rentable vehicle to the fleet.
-- =====================================================================
INSERT INTO Vehicle (Make, Model, Year, LicensePlate, RentalRate, Status)
VALUES ('Toyota', 'Yaris', 2024, 'LEX-2024', 4800.00, 'Available');

-- Verify
SELECT * FROM Vehicle WHERE LicensePlate = 'LEX-2024';


-- =====================================================================
-- FEATURE 3 : Create a New Booking  (DML - INSERT)
-- ---------------------------------------------------------------------
-- Creates a rental booking linking a customer to a vehicle.
-- =====================================================================
INSERT INTO Booking (CustomerID, VehicleID, StartDate, EndDate, Status, TotalAmount)
VALUES (3, 5, '2026-06-01', '2026-06-04', 'Active', 18000.00);

-- Verify
SELECT * FROM Booking WHERE CustomerID = 3 AND VehicleID = 5;


-- =====================================================================
-- FEATURE 4 : Search / Filter Available Vehicles  (DML - SELECT + WHERE)
-- ---------------------------------------------------------------------
-- Finds all vehicles currently available for rent, optionally within
-- a price range.
-- =====================================================================
SELECT VehicleID, Make, Model, Year, RentalRate
FROM Vehicle
WHERE Status = 'Available'
  AND RentalRate BETWEEN 3000 AND 8000
ORDER BY RentalRate ASC;


-- =====================================================================
-- FEATURE 5 : View Customer Rental History  (DML - SELECT + JOIN)
-- ---------------------------------------------------------------------
-- Shows the full booking history of a specific customer.
-- =====================================================================
SELECT
    c.Name           AS Customer,
    b.BookingID,
    (v.Make || ' ' || v.Model) AS Vehicle,
    b.StartDate,
    b.EndDate,
    b.TotalAmount,
    b.Status
FROM Booking b
INNER JOIN Customer c ON b.CustomerID = c.CustomerID
INNER JOIN Vehicle  v ON b.VehicleID  = v.VehicleID
WHERE c.CustomerID = 1
ORDER BY b.StartDate DESC;


-- =====================================================================
-- FEATURE 6 : Record a Payment  (DML - INSERT)
-- ---------------------------------------------------------------------
-- Records a payment made against a booking.
-- =====================================================================
INSERT INTO Payment (BookingID, Amount, PaymentDate, Method)
VALUES (6, 7000.00, '2026-05-09', 'Cash');

-- Verify
SELECT * FROM Payment WHERE BookingID = 6;


-- =====================================================================
-- FEATURE 7 : Update Vehicle Status  (DML - UPDATE)
-- ---------------------------------------------------------------------
-- Marks a vehicle as 'Rented' when it is booked, or back to
-- 'Available' / 'Maintenance' as needed.
-- =====================================================================
UPDATE Vehicle
SET Status = 'Rented'
WHERE VehicleID = 5;

-- Verify
SELECT VehicleID, Make, Model, Status FROM Vehicle WHERE VehicleID = 5;


-- =====================================================================
-- FEATURE 8 : Process a Vehicle Return + Late Fee  (DML - INSERT + UPDATE)
-- ---------------------------------------------------------------------
-- Logs a vehicle return, applies a late fee, and frees up the vehicle.
-- =====================================================================
INSERT INTO "Return" (BookingID, ReturnDate, "Condition", LateFee)
VALUES (2, '2026-04-16', 'Good', 15000.00);

-- Mark the booking completed and free the vehicle
UPDATE Booking SET Status = 'Completed' WHERE BookingID = 2;
UPDATE Vehicle SET Status = 'Available'
WHERE VehicleID = (SELECT VehicleID FROM Booking WHERE BookingID = 2);

-- Verify
SELECT * FROM "Return" WHERE BookingID = 2;


-- =====================================================================
-- FEATURE 9 : Cancel / Delete a Booking  (DML - DELETE)
-- ---------------------------------------------------------------------
-- Removes a cancelled booking. ON DELETE CASCADE also removes its
-- related payments and return record automatically.
-- =====================================================================
-- First insert a dummy booking to cancel
INSERT INTO Booking (CustomerID, VehicleID, StartDate, EndDate, Status, TotalAmount)
VALUES (7, 3, '2026-07-01', '2026-07-02', 'Cancelled', 3500.00);

-- Delete the cancelled booking
DELETE FROM Booking
WHERE Status = 'Cancelled';

-- Verify (should return no cancelled bookings)
SELECT * FROM Booking WHERE Status = 'Cancelled';


-- =====================================================================
-- FEATURE 10 : Revenue Report by Vehicle  (DML - SELECT + JOIN + GROUP BY)
-- ---------------------------------------------------------------------
-- Aggregates total revenue earned per vehicle (business reporting).
-- =====================================================================
SELECT
    v.VehicleID,
    (v.Make || ' ' || v.Model) AS Vehicle,
    COUNT(b.BookingID)         AS TimesBooked,
    COALESCE(SUM(b.TotalAmount), 0) AS TotalRevenue
FROM Vehicle v
LEFT JOIN Booking b ON v.VehicleID = b.VehicleID
GROUP BY v.VehicleID, v.Make, v.Model
ORDER BY TotalRevenue DESC;


-- =====================================================================
-- ============ DDL COMMANDS (Data Definition Language) ============
-- =====================================================================

-- DDL Example 1 : ALTER TABLE - add a new column
ALTER TABLE Customer ADD COLUMN RegistrationDate DATE DEFAULT CURRENT_DATE;

-- DDL Example 2 : CREATE a view (virtual table) for active rentals
CREATE OR REPLACE VIEW ActiveRentals AS
SELECT
    b.BookingID,
    c.Name AS Customer,
    (v.Make || ' ' || v.Model) AS Vehicle,
    b.StartDate,
    b.EndDate
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Vehicle  v ON b.VehicleID  = v.VehicleID
WHERE b.Status = 'Active';

-- Use the view
SELECT * FROM ActiveRentals;

-- DDL Example 3 : CREATE INDEX to speed up searches on vehicle status
CREATE INDEX idx_vehicle_status ON Vehicle(Status);


-- =====================================================================
-- ============ DCL COMMANDS (Data Control Language) ============
-- =====================================================================
-- DCL manages permissions. We create a read-only role for a "clerk"
-- who can view data but not modify it.
-- =====================================================================

-- Create a database role (user)
CREATE ROLE rental_clerk LOGIN PASSWORD 'clerk123';

-- GRANT : give the clerk permission to read all tables
GRANT SELECT ON Customer, Vehicle, Booking, Payment, "Return" TO rental_clerk;

-- GRANT : allow the clerk to add new bookings only
GRANT INSERT ON Booking TO rental_clerk;

-- REVOKE : remove the clerk's ability to insert bookings (example of revoke)
REVOKE INSERT ON Booking FROM rental_clerk;

-- =====================================================================
-- END OF FEATURES
-- =====================================================================
