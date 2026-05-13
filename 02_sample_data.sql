-- =====================================================================
-- Vehicle Rental Management System - Sample Data (PostgreSQL)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Customers
-- ---------------------------------------------------------------------
INSERT INTO Customer (Name, CNIC, Phone, Email, Address) VALUES
('Ahmed Raza',     '35202-1234567-1', '0300-1234567', 'ahmed.raza@gmail.com',    'DHA Phase 5, Lahore'),
('Sara Khan',      '35201-7654321-2', '0321-7654321', 'sara.khan@hotmail.com',   'Gulberg III, Lahore'),
('Bilal Hussain',  '35202-9988776-3', '0333-9988776', 'bilal.h@yahoo.com',       'Model Town, Lahore'),
('Fatima Ali',     '35201-1122334-4', '0345-1122334', 'fatima.ali@gmail.com',    'Bahria Town, Lahore'),
('Usman Tariq',    '35202-5566778-5', '0312-5566778', 'usman.t@outlook.com',     'Johar Town, Lahore'),
('Hina Sheikh',    '35201-4433221-6', '0301-4433221', 'hina.sheikh@gmail.com',   'Cantt, Lahore'),
('Zain Malik',     '35202-7788990-7', '0322-7788990', 'zain.malik@gmail.com',    'Township, Lahore'),
('Ayesha Iqbal',   '35201-3344556-8', '0334-3344556', 'ayesha.iqbal@gmail.com',  'Faisal Town, Lahore');

-- ---------------------------------------------------------------------
-- Vehicles
-- ---------------------------------------------------------------------
INSERT INTO Vehicle (Make, Model, Year, LicensePlate, RentalRate, Status) VALUES
('Toyota',  'Corolla GLi',  2022, 'LEA-2022',  5500.00, 'Available'),
('Honda',   'Civic',        2023, 'LEB-1234',  7500.00, 'Rented'),
('Suzuki',  'Cultus',       2021, 'LEC-5678',  3500.00, 'Available'),
('Toyota',  'Fortuner',     2023, 'LED-9999', 15000.00, 'Rented'),
('Honda',   'City',         2022, 'LEE-1111',  6000.00, 'Available'),
('Haval',   'H6 Facelift',  2026, 'LEF-2026', 12000.00, 'Available'),
('Suzuki',  'Alto',         2020, 'LEG-3333',  2800.00, 'Maintenance'),
('KIA',     'Sportage',     2024, 'LEH-4444', 11000.00, 'Rented');

-- ---------------------------------------------------------------------
-- Bookings
-- ---------------------------------------------------------------------
INSERT INTO Booking (CustomerID, VehicleID, StartDate, EndDate, Status, TotalAmount) VALUES
(1, 2, '2026-04-01', '2026-04-05', 'Completed', 30000.00),
(2, 4, '2026-04-10', '2026-04-15', 'Active',    75000.00),
(3, 1, '2026-04-20', '2026-04-22', 'Completed', 11000.00),
(4, 8, '2026-05-01', '2026-05-08', 'Active',    77000.00),
(1, 5, '2026-05-05', '2026-05-07', 'Completed', 12000.00),
(5, 3, '2026-05-09', '2026-05-11', 'Active',     7000.00),
(6, 6, '2026-05-10', '2026-05-12', 'Active',    24000.00),
(7, 2, '2026-03-15', '2026-03-20', 'Completed', 37500.00);
-- Customer 8 (Ayesha) intentionally has NO bookings -> demonstrates LEFT JOIN

-- ---------------------------------------------------------------------
-- Payments  (some bookings have multiple installments)
-- ---------------------------------------------------------------------
INSERT INTO Payment (BookingID, Amount, PaymentDate, Method) VALUES
(1, 30000.00, '2026-04-01', 'Cash'),
(2, 40000.00, '2026-04-10', 'Card'),
(2, 35000.00, '2026-04-13', 'Online'),
(3, 11000.00, '2026-04-20', 'Cash'),
(4, 50000.00, '2026-05-01', 'Bank Transfer'),
(4, 27000.00, '2026-05-04', 'Card'),
(5, 12000.00, '2026-05-05', 'Cash'),
(7, 24000.00, '2026-05-10', 'Online'),
(8, 37500.00, '2026-03-15', 'Card');
-- Booking 6 (Usman/Cultus) has no payment yet -> demonstrates LEFT JOIN

-- ---------------------------------------------------------------------
-- Returns  (only for completed bookings)
-- ---------------------------------------------------------------------
INSERT INTO "Return" (BookingID, ReturnDate, "Condition", LateFee) VALUES
(1, '2026-04-05', 'Good',      0),
(3, '2026-04-22', 'Excellent', 0),
(5, '2026-05-08', 'Good',      2000),   -- returned 1 day late
(8, '2026-03-21', 'Damaged',   5000);   -- returned 1 day late + damage

-- ---------------------------------------------------------------------
-- Quick sanity check
-- ---------------------------------------------------------------------
SELECT 'Customers' AS Entity, COUNT(*) AS RowCount FROM Customer
UNION ALL
SELECT 'Vehicles', COUNT(*) FROM Vehicle
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL
SELECT 'Returns',  COUNT(*) FROM "Return";
