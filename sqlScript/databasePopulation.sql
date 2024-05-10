-- Populate the User table
INSERT INTO `User` (`UserID`, `Username`, `Password`, `Email`, `FirstName`, `LastName`, `ProfilePicURL`, `DateOfBirth`, `LastLogin`) VALUES
(1, 'aliceblue', 'hashed_password_123', 'alice.blue@example.com', 'Alice', 'Blue', 'https://example.com/aliceblue.png', '1990-06-01', '2024-04-14 10:58:22'),
(2, 'bobsmith', 'hashed_password_456', 'bob.smith@example.com', 'Bob', 'Smith', 'https://example.com/bobsmith.png', '1985-08-15', '2024-04-14 10:58:22');

-- Populate the Address table
INSERT INTO `Address` (`AddressID`, `UserID`, `Street`, `City`, `State`, `PostalCode`, `Country`, `IsDefault`, `AddressType`) VALUES
(1, 1, 'Karl Johans gate 23', 'Oslo', 'Oslo', '0162', 'Norway', 1, 'Shipping'),
(2, 2, 'Nedre Bakklandet 58', 'Trondheim', 'Trøndelag', '7014', 'Norway', 1, 'Billing');

-- Populate the Product table
INSERT INTO `Product` (`ProductID`, `Name`, `Description`, `Price`, `StockQuantity`, `BrandID`, `CategoryID`, `ImageURL`, `SKU`, `Weight`, `Dimensions`, `IsActive`) VALUES
(1, 'Samsung Galaxy S21', 'High-end smartphone with advanced photography features.', 799.99, 150, 1, 1, 'https://example.com/galaxys21.png', 'SKU9001', 0.17, '151.7 x 71.2 x 7.9 mm', 1),
(2, 'iPhone 13', 'Latest model with A15 Bionic chip and advanced dual-camera system.', 899.99, 100, 2, 1, 'https://example.com/iphone13.png', 'SKU9002', 0.17, '146.7 x 71.5 x 7.65 mm', 1);

-- Populate the Brand table
INSERT INTO `Brand` (`BrandID`, `Name`, `Description`) VALUES
(1, 'Samsung', 'South Korean multinational electronics company known for its smartphones and consumer electronics.'),
(2, 'Apple', 'American multinational technology company known for its innovative consumer electronics.');

-- Populate the Category table
INSERT INTO `Category` (`CategoryID`, `Name`, `Description`) VALUES
(1, 'Smartphones', 'Mobile phones with advanced features and functionalities.'),
(2, 'Laptops', 'Portable personal computers suitable for mobile use.');

-- Populate the Order table
INSERT INTO `Order` (`OrderID`, `UserID`, `OrderDate`, `TotalAmount`, `OrderStatusID`, `PaymentConfirmedDate`) VALUES
(1, 1, '2023-10-01', 1299.99, 1, '2023-10-01'),
(2, 2, '2023-10-02', 349.99, 2, '2023-10-02');

-- Populate the OrderItem table
INSERT INTO `OrderItem` (`OrderID`, `ProductID`, `Quantity`, `Subtotal`) VALUES
(1, 1, 1, 1299.99),
(2, 2, 1, 899.99);

-- Populate the OrderStatus table
INSERT INTO `OrderStatus` (`OrderStatusID`, `StatusName`, `Description`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Placed', 'Order has been placed and is awaiting processing.', '2024-04-14 13:00:03', '2024-04-14 13:00:03'),
(2, 'Shipped', 'Order has been shipped to the customer.', '2024-04-14 13:00:03', '2024-04-14 13:00:03'),
(3, 'Delivered', 'Order has been delivered.', '2024-04-14 13:00:03', '2024-04-14 13:00:03');

-- Populate the Payment table
INSERT INTO `Payment` (`PaymentID`, `OrderID`, `PaymentMethod`, `Amount`, `PaymentDate`, `PaymentStatusID`, `TransactionID`) VALUES
(1, 1, 'Credit Card', 1299.99, '2023-10-01', 1, 'TX100001'),
(2, 2, 'PayPal', 349.99, '2023-10-02', 1, 'TX100002');

-- Populate the PaymentStatus table
INSERT INTO `PaymentStatus` (`PaymentStatusID`, `StatusName`) VALUES
(1, 'Completed'),
(2, 'Pending'),
(3, 'Refunded');

-- Populate the ShippingDetail table
INSERT INTO `ShippingDetail` (`ShippingID`, `OrderID`, `RecipientName`, `AddressID`, `ShippingMethod`, `ShippingCost`, `ExpectedDeliveryDate`, `TrackingNumber`, `IsDelivered`, `DeliveryDate`, `BaseCost`, `WeightSurcharge`) VALUES
(1, 1, 'Alice Blue', 1, 'FedEx', 10.00, '2023-10-05', 'TRACK1001', 0, NULL, 10.00, 2.00),
(2, 2, 'Bob Smith', 2, 'UPS', 5.00, '2023-10-04', 'TRACK1002', 1, '2023-10-04', 5.00, 0.50);

-- Populate the Taxes table
INSERT INTO `Taxes` (`TaxID`, `Description`, `TaxPercent`, `ApplicableToCategoryID`) VALUES
(1, 'Standard Electronics Tax', 15.00, 1),
(2, 'Luxury Electronics Tax', 20.00, 2),
(3, 'Reduced Tax for Tablets', 5.00, 3),
(4, 'Camera Tax', 18.00, 4),
(5, 'Home Appliance Tax', 10.00, 5),
(6, 'Accessory Tax', 12.00, 6);

-- Populate the Wishlist table
INSERT INTO `Wishlist` (`WishlistID`, `UserID`, `ProductID`, `AddedDate`, `Name`) VALUES
(1, 1, 1, '2023-10-05', 'Holiday Gifts'),
(1, 1, 2, '2023-10-05', 'Holiday Gifts'),
(2, 2, 3, '2023-10-05', 'Birthday Wishlist');
