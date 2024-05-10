-- SQL CRUD Operations for each entity in the database

-- CRUD Operations for User Table
-- Select Users who logged in after January 1, 2024
SELECT * FROM `User` WHERE `LastLogin` > '2024-01-01';
-- Insert a new user into the User table
INSERT INTO `User` (`Username`, `Password`, `Email`, `FirstName`, `LastName`, `DateOfBirth`) VALUES ('newuser', 'password123', 'new.user@example.com', 'New', 'User', '1992-02-02');
-- Update the email address of the user with UserID = 1
UPDATE `User` SET `Email` = 'updated.email@example.com' WHERE `UserID` = 1;
-- Delete the user with UserID = 2
DELETE FROM `User` WHERE `UserID` = 2;

-- CRUD Operations for Address Table
-- Select all addresses in Norway
SELECT * FROM `Address` WHERE `Country` = 'Norway';
-- Insert a new shipping address for the user with ID 3
INSERT INTO `Address` (`UserID`, `Street`, `City`, `State`, `PostalCode`, `Country`, `IsDefault`, `AddressType`) VALUES (3, 'Bogstadveien 30', 'Oslo', 'Oslo', '0355', 'Norway', 1, 'Shipping');
-- Change the default status of the address for UserID 1
UPDATE `Address` SET `IsDefault` = 0 WHERE `AddressID` = 1 AND `UserID` = 1;
-- Delete the address with AddressID = 3
DELETE FROM `Address` WHERE `AddressID` = 3;

-- CRUD Operations for Product Table
-- Select all products associated with BrandID 2 (Apple)
SELECT * FROM `Product` WHERE `BrandID` = 2;
-- Insert a new product, Google Nest Hub
INSERT INTO `Product` (`Name`, `Description`, `Price`, `StockQuantity`, `BrandID`, `CategoryID`, `SKU`, `IsActive`) VALUES ('Google Nest Hub', 'Smart display with Google Assistant.', 89.99, 200, 1, 1, 'SKU9015', 1);
-- Update the price of the product with ProductID = 10
UPDATE `Product` SET `Price` = 99.99 WHERE `ProductID` = 10;
-- Delete the product with ProductID = 5
DELETE FROM `Product` WHERE `ProductID` = 5;

-- CRUD Operations for Brand Table
-- Select all brands with IDs from 1 to 3
SELECT * FROM `Brand` WHERE `BrandID` BETWEEN 1 AND 3;
-- Insert a new brand, Asus
INSERT INTO `Brand` (`Name`, `Description`) VALUES ('Asus', 'Taiwanese multinational computer and phone hardware and electronics company.');
-- Update the description for the brand with BrandID = 7
UPDATE `Brand` SET `Description` = 'Updated brand description here' WHERE `BrandID` = 7;
-- Delete the brand with BrandID = 6
DELETE FROM `Brand` WHERE `BrandID` = 6;

-- CRUD Operations for Category Table
-- Select all categories in the database
SELECT * FROM `Category`;
-- Insert a new category for printers
INSERT INTO `Category` (`Name`, `Description`) VALUES ('Printers', 'Devices that produce a hard copy by transferring ink onto paper.');
-- Update the description of the category with CategoryID = 4
UPDATE `Category` SET `Description` = 'Updated category description' WHERE `CategoryID` = 4;
-- Delete the category with CategoryID = 3
DELETE FROM `Category` WHERE `CategoryID` = 3;

-- CRUD Operations for Order Table
-- Select orders where the total amount is greater than $1000
SELECT * FROM `Order` WHERE `TotalAmount` > 1000;
-- Insert a new order with details including userID, order date, total amount, and status ID
INSERT INTO `Order` (`UserID`, `OrderDate`, `TotalAmount`, `OrderStatusID`) VALUES (2, '2024-04-25', 1200.50, 3);
-- Change the order status of the order with OrderID = 1 to 'Shipped'
UPDATE `Order` SET `OrderStatusID` = 2 WHERE `OrderID` = 1;
-- Delete the order with OrderID = 3
DELETE FROM `Order` WHERE `OrderID` = 3;

-- CRUD Operations for OrderItem Table
-- Select all items associated with OrderID 1
SELECT * FROM `OrderItem` WHERE `OrderID` = 1;
-- Insert two units of product ID 7 to order ID 1 with a subtotal
INSERT INTO `OrderItem` (`OrderID`, `ProductID`, `Quantity`, `Subtotal`) VALUES (1, 7, 2, 3999.98);
-- Update the quantity and subtotal for product ID 7 in order ID 1
UPDATE `OrderItem` SET `Quantity` = 3, `Subtotal` = 5999.97 WHERE `OrderID` = 1 AND `ProductID` = 7;
-- Delete the order item entry for product ID 11 from order ID 2
DELETE FROM `OrderItem` WHERE `OrderID` = 2 AND `ProductID` = 11;

-- CRUD Operations for OrderStatus Table
-- Select details for the order status with ID 1 (typically "Placed")
SELECT * FROM `OrderStatus` WHERE `OrderStatusID` = 1;
-- Insert a new order status called "Processing" with a description
INSERT INTO `OrderStatus` (`StatusName`, `Description`) VALUES ('Processing', 'Order is being processed.');
-- Update the description for the order status with ID 2
UPDATE `OrderStatus` SET `Description` = 'Order has been shipped and is en route to the customer.' WHERE `OrderStatusID` = 2;
-- Delete the order status with ID 3
DELETE FROM `OrderStatus` WHERE `OrderStatusID` = 3;

-- CRUD Operations for Payment Table
-- Select all payments made using a Credit Card
SELECT * FROM `Payment` WHERE `PaymentMethod` = 'Credit Card';
-- Insert a new payment record for order ID 2 using a Debit Card
INSERT INTO `Payment` (`OrderID`, `PaymentMethod`, `Amount`, `PaymentDate`, `PaymentStatusID`, `TransactionID`) VALUES (2, 'Debit Card', 120.50, '2024-04-15', 1, 'TX200003');
-- Update the payment amount for the payment with PaymentID = 1
UPDATE `Payment` SET `Amount` = 130.75 WHERE `PaymentID` = 1;
-- Delete the payment record with PaymentID = 2
DELETE FROM `Payment` WHERE `PaymentID` = 2;

-- CRUD Operations for PaymentStatus Table
-- Select details for the payment status with ID 1 (typically "Completed")
SELECT * FROM `PaymentStatus` WHERE `PaymentStatusID` = 1;
-- Insert a new payment status "Awaiting Confirmation"
INSERT INTO `PaymentStatus` (`StatusName`) VALUES ('Awaiting Confirmation');
-- Change the status name of payment status ID 3 to "Failed"
UPDATE `PaymentStatus` SET `StatusName` = 'Failed' WHERE `PaymentStatusID` = 3;
-- Delete the payment status with ID 2
DELETE FROM `PaymentStatus` WHERE `PaymentStatusID` = 2;

-- CRUD Operations for ShippingDetail Table
-- Retrieve shipping details for order ID 1
SELECT * FROM `ShippingDetail` WHERE `OrderID` = 1;
-- Add new shipping details for order ID 2
INSERT INTO `ShippingDetail` (`OrderID`, `RecipientName`, `AddressID`, `ShippingMethod`, `ShippingCost`, `ExpectedDeliveryDate`, `TrackingNumber`) VALUES (2, 'Bob Brown', 2, 'DHL', 15.00, '2024-05-05', 'TRACK2002');
-- Update the shipping record to mark it as delivered on April 25, 2024
UPDATE `ShippingDetail` SET `IsDelivered` = 1, `DeliveryDate` = '2024-04-25' WHERE `ShippingID` = 1;
-- Delete the shipping detail record with ShippingID = 2
DELETE FROM `ShippingDetail` WHERE `ShippingID` = 2;

-- CRUD Operations for Taxes Table
-- Retrieve all tax entries where the tax percent is greater than 10%
SELECT * FROM `Taxes` WHERE `TaxPercent` > 10.00;
-- Add a new tax entry called "Environmental Tax" with a tax percentage of 8%
INSERT INTO `Taxes` (`Description`, `TaxPercent`, `ApplicableToCategoryID`) VALUES ('Environmental Tax', 8.00, 3);
-- Update the tax percentage to 19% for the tax entry with TaxID = 4
UPDATE `Taxes` SET `TaxPercent` = 19.00 WHERE `TaxID` = 4;
-- Delete the tax entry with TaxID = 3
DELETE FROM `Taxes` WHERE `TaxID` = 3;

-- CRUD Operations for Wishlist Table
-- Retrieve all wishlist entries for userID 1
SELECT * FROM `Wishlist` WHERE `UserID` = 1;
-- Add a new wishlist entry for userID 2
INSERT INTO `Wishlist` (`UserID`, `ProductID`, `AddedDate`, `Name`) VALUES (2, 8, '2024-04-20', 'Tech Favorites');
-- Update the name of the wishlist for userID 1 and wishlist ID 1
UPDATE `Wishlist` SET `Name` = 'Updated Wishlist' WHERE `WishlistID` = 1 AND `UserID` = 1;
-- Delete the wishlist entry for userID 2 with wishlist ID 2
DELETE FROM `Wishlist` WHERE `WishlistID` = 2 AND `UserID` = 2;

