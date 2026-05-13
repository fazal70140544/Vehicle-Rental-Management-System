-- =====================================================================
-- Vehicle Rental Management System - Task 6: Joins (PostgreSQL)
-- =====================================================================
-- Requirement: Perform joins on two of the tables and check output.
-- We demonstrate multiple JOIN types on different table pairs to
-- showcase a full understanding of joins.
-- =====================================================================

-- =====================================================================
-- QUERY 1 : INNER JOIN  (Customer JOIN Booking)
-- ---------------------------------------------------------------------
-- Purpose: List every booking with the customer who made it.
-- INNER JOIN returns only the rows that have a match in BOTH tables.
-- Customer 8 (Ayesha) has no bookings and therefore will NOT appear.
-- =====================================================================
SELECT
    c.CustomerID,
    c.Name           AS CustomerName,
    c.Phone,
    b.BookingID,
    b.StartDate,
    b.EndDate,
    b.Status         AS BookingStatus,
    b.TotalAmount
FROM Customer c
INNER JOIN Booking b
       ON c.CustomerID = b.CustomerID
ORDER BY b.StartDate;

-- Expected result: 8 rows (all bookings paired with their customer).
-- Ayesha Iqbal does NOT appear because she has no booking.


-- =====================================================================
-- QUERY 2 : LEFT JOIN  (Customer LEFT JOIN Booking)
-- ---------------------------------------------------------------------
-- Purpose: List ALL customers, including those who have never booked.
-- LEFT JOIN keeps every row from the LEFT table (Customer) even if
-- there is no match in the right table (Booking) -> those rows show
-- NULL in the Booking columns.
-- =====================================================================
SELECT
    c.CustomerID,
    c.Name           AS CustomerName,
    b.BookingID,
    b.StartDate,
    b.EndDate,
    b.TotalAmount
FROM Customer c
LEFT JOIN Booking b
       ON c.CustomerID = b.CustomerID
ORDER BY c.CustomerID, b.StartDate;

-- Expected result: 9 rows (8 bookings + 1 NULL row for Ayesha Iqbal).


-- =====================================================================
-- QUERY 3 : INNER JOIN  (Booking JOIN Vehicle)
-- ---------------------------------------------------------------------
-- Purpose: Show every booking together with the vehicle's details
-- (make, model, license plate, daily rate).
-- =====================================================================
SELECT
    b.BookingID,
    v.Make,
    v.Model,
    v.LicensePlate,
    v.RentalRate,
    b.StartDate,
    b.EndDate,
    (b.EndDate - b.StartDate)        AS TotalDays,
    b.TotalAmount
FROM Booking b
INNER JOIN Vehicle v
       ON b.VehicleID = v.VehicleID
ORDER BY b.BookingID;


-- =====================================================================
-- QUERY 4 : LEFT JOIN  (Booking LEFT JOIN Payment)
-- ---------------------------------------------------------------------
-- Purpose: For every booking, show the payments made against it.
-- Bookings without any payment yet (Booking #6) appear with NULLs.
-- =====================================================================
SELECT
    b.BookingID,
    b.TotalAmount,
    p.PaymentID,
    p.Amount         AS PaidAmount,
    p.PaymentDate,
    p.Method
FROM Booking b
LEFT JOIN Payment p
       ON b.BookingID = p.BookingID
ORDER BY b.BookingID, p.PaymentDate;


-- =====================================================================
-- QUERY 5 : 3-TABLE JOIN  (Customer + Booking + Vehicle)
-- ---------------------------------------------------------------------
-- Purpose: Generate a complete rental report -- who rented what,
-- when, for how much. This is the kind of join used to power a
-- "Recent Rentals" dashboard.
-- =====================================================================
SELECT
    c.Name                              AS CustomerName,
    (v.Make || ' ' || v.Model)          AS Vehicle,
    v.LicensePlate,
    b.StartDate,
    b.EndDate,
    b.TotalAmount,
    b.Status
FROM Booking b
INNER JOIN Customer c ON b.CustomerID = c.CustomerID
INNER JOIN Vehicle  v ON b.VehicleID  = v.VehicleID
ORDER BY b.StartDate DESC;


-- =====================================================================
-- QUERY 6 : JOIN with AGGREGATE  (Customer JOIN Booking + GROUP BY)
-- ---------------------------------------------------------------------
-- Purpose: Show total spend per customer (revenue report by customer).
-- =====================================================================
SELECT
    c.CustomerID,
    c.Name,
    COUNT(b.BookingID)               AS TotalBookings,
    COALESCE(SUM(b.TotalAmount), 0)  AS TotalSpent
FROM Customer c
LEFT JOIN Booking b
       ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY TotalSpent DESC;


-- =====================================================================
-- QUERY 7 : 4-TABLE JOIN  (full booking lifecycle)
-- ---------------------------------------------------------------------
-- Purpose: Show only completed bookings together with their return
-- record, customer, and vehicle -- a "Closed Rentals" view.
-- =====================================================================
SELECT
    b.BookingID,
    c.Name                              AS Customer,
    (v.Make || ' ' || v.Model)          AS Vehicle,
    b.StartDate,
    b.EndDate,
    r.ReturnDate,
    r."Condition",
    r.LateFee
FROM Booking b
INNER JOIN Customer  c ON b.CustomerID = c.CustomerID
INNER JOIN Vehicle   v ON b.VehicleID  = v.VehicleID
INNER JOIN "Return"  r ON b.BookingID  = r.BookingID
ORDER BY r.ReturnDate;
