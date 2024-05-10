-- Database creation for each entity

-- User Table Creation
CREATE TABLE `User` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Email` varchar(75) NOT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `ProfilePicURL` varchar(255) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `LastLogin` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- User Table Modifications
ALTER TABLE `User`
ADD PRIMARY KEY (`UserID`),
ADD UNIQUE KEY `Username` (`Username`),
ADD UNIQUE KEY `Email` (`Email`);
ALTER TABLE `User`
MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- Address Table Creation
CREATE TABLE `Address` (
  `AddressID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Street` varchar(255) DEFAULT NULL,
  `City` varchar(100) DEFAULT NULL,
  `State` varchar(100) DEFAULT NULL,
  `PostalCode` varchar(20) DEFAULT NULL,
  `Country` varchar(100) DEFAULT NULL,
  `IsDefault` tinyint(1) NOT NULL DEFAULT 0,
  `AddressType` enum('Shipping','Billing','Other') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Address Table Modifications
ALTER TABLE `Address`
ADD PRIMARY KEY (`AddressID`),
ADD KEY `fk_user_address` (`UserID`);
ALTER TABLE `Address`
ADD CONSTRAINT `fk_user_address` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);
ALTER TABLE `Address`
MODIFY `AddressID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- Product Table Creation
CREATE TABLE `Product` (
  `ProductID` int(11) NOT NULL,
  `Name` varchar(75) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `StockQuantity` int(11) DEFAULT NULL,
  `BrandID` int(11) DEFAULT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `ImageURL` varchar(225) DEFAULT NULL,
  `SKU` varchar(255) NOT NULL,
  `Weight` decimal(5,2) DEFAULT NULL,
  `Dimensions` varchar(225) DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Product Table Modifications
ALTER TABLE `Product`
ADD PRIMARY KEY (`ProductID`),
ADD UNIQUE KEY `SKU` (`SKU`),
ADD KEY `BrandID` (`BrandID`),
ADD KEY `CategoryID` (`CategoryID`);
ALTER TABLE `Product`
ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`BrandID`) REFERENCES `Brand` (`BrandID`),
ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Category` (`CategoryID`);
ALTER TABLE `Product`
MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

-- Brand Table Creation
CREATE TABLE `Brand` (
  `BrandID` int(11) NOT NULL,
  `Name` varchar(75) NOT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Brand Table Modifications
ALTER TABLE `Brand`
ADD PRIMARY KEY (`BrandID`);
ALTER TABLE `Brand`
MODIFY `BrandID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

-- Category Table Creation
CREATE TABLE `Category` (
  `CategoryID` int(11) NOT NULL,
  `Name` varchar(75) DEFAULT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Category Table Modifications
ALTER TABLE `Category`
ADD PRIMARY KEY (`CategoryID`);
ALTER TABLE `Category`
MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

-- Order Table Creation
CREATE TABLE `Order` (
  `OrderID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `OrderDate` date NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  `OrderStatusID` int(11) DEFAULT NULL,
  `PaymentConfirmedDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Order Table Modifications
ALTER TABLE `Order`
ADD PRIMARY KEY (`OrderID`),
ADD KEY `fk_order_user` (`UserID`),
ADD KEY `fk_order_orderstatus` (`OrderStatusID`);
ALTER TABLE `Order`
ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`),
ADD CONSTRAINT `fk_order_orderstatus` FOREIGN KEY (`OrderStatusID`) REFERENCES `OrderStatus` (`OrderStatusID`);
ALTER TABLE `Order`
MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- OrderItem Table Creation
CREATE TABLE `OrderItem` (
  `OrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- OrderItem Table Modifications
ALTER TABLE `OrderItem`
ADD PRIMARY KEY (`OrderID`,`ProductID`),
ADD KEY `fk_orderitem_product` (`ProductID`);
ALTER TABLE `OrderItem`
ADD CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`OrderID`) REFERENCES `Order` (`OrderID`),
ADD CONSTRAINT `fk_orderitem_product` FOREIGN KEY (`ProductID`) REFERENCES `Product` (`ProductID`);

-- OrderStatus Table Creation
CREATE TABLE `OrderStatus` (
  `OrderStatusID` int(11) NOT NULL,
  `StatusName` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `CreatedAt` datetime DEFAULT current_timestamp(),
  `UpdatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- OrderStatus Table Modifications
ALTER TABLE `OrderStatus`
ADD PRIMARY KEY (`OrderStatusID`);
ALTER TABLE `OrderStatus`
MODIFY `OrderStatusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

-- Payment Table Creation
CREATE TABLE `Payment` (
  `PaymentID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `PaymentMethod` varchar(255) NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `PaymentDate` date NOT NULL,
  `PaymentStatusID` int(11) DEFAULT NULL,
  `TransactionID` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Payment Table Modifications
ALTER TABLE `Payment`
ADD PRIMARY KEY (`PaymentID`),
ADD KEY `fk_payment_order` (`OrderID`),
ADD KEY `fk_payment_status` (`PaymentStatusID`);
ALTER TABLE `Payment`
ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`OrderID`) REFERENCES `Order` (`OrderID`),
ADD CONSTRAINT `fk_payment_status` FOREIGN KEY (`PaymentStatusID`) REFERENCES `PaymentStatus` (`PaymentStatusID`);
ALTER TABLE `Payment`
MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- PaymentStatus Table Creation
CREATE TABLE `PaymentStatus` (
  `PaymentStatusID` int(11) NOT NULL,
  `StatusName` varchar(75) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- PaymentStatus Table Modifications
ALTER TABLE `PaymentStatus`
ADD PRIMARY KEY (`PaymentStatusID`);
ALTER TABLE `PaymentStatus`
MODIFY `PaymentStatusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

-- ShippingDetail Table Creation
CREATE TABLE `ShippingDetail` (
  `ShippingID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `RecipientName` varchar(255) DEFAULT NULL,
  `AddressID` int(11) DEFAULT NULL,
  `ShippingMethod` varchar(100) DEFAULT NULL,
  `ShippingCost` decimal(10,2) NOT NULL,
  `ExpectedDeliveryDate` date DEFAULT NULL,
  `TrackingNumber` varchar(255) DEFAULT NULL,
  `IsDelivered` tinyint(1) NOT NULL DEFAULT 0,
  `DeliveryDate` date DEFAULT NULL,
  `BaseCost` decimal(10,2) DEFAULT NULL,
  `WeightSurcharge` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- ShippingDetail Table Modifications
ALTER TABLE `ShippingDetail`
ADD PRIMARY KEY (`ShippingID`),
ADD KEY `fk_shipping_order` (`OrderID`),
ADD KEY `fk_shipping_address` (`AddressID`);
ALTER TABLE `ShippingDetail`
ADD CONSTRAINT `fk_shipping_order` FOREIGN KEY (`OrderID`) REFERENCES `Order` (`OrderID`),
ADD CONSTRAINT `fk_shipping_address` FOREIGN KEY (`AddressID`) REFERENCES `Address` (`AddressID`);
ALTER TABLE `ShippingDetail`
MODIFY `ShippingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- Taxes Table Creation
CREATE TABLE `Taxes` (
  `TaxID` int(11) NOT NULL,
  `Description` text DEFAULT NULL,
  `TaxPercent` decimal(5,2) DEFAULT NULL,
  `ApplicableToCategoryID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Taxes Table Modifications
ALTER TABLE `Taxes`
ADD PRIMARY KEY (`TaxID`),
ADD KEY `ApplicableToCategoryID` (`ApplicableToCategoryID`);
ALTER TABLE `Taxes`
ADD CONSTRAINT `taxes_ibfk_1` FOREIGN KEY (`ApplicableToCategoryID`) REFERENCES `Category` (`CategoryID`);
ALTER TABLE `Taxes`
MODIFY `TaxID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

-- Wishlist Table Creation
CREATE TABLE `Wishlist` (
  `WishlistID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `AddedDate` date DEFAULT NULL,
  `Name` varchar(75) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- Wishlist Table Modifications
ALTER TABLE `Wishlist`
ADD PRIMARY KEY (`WishlistID`, `UserID`, `ProductID`),
ADD KEY `fk_wishlist_user` (`UserID`),
ADD KEY `fk_wishlist_product` (`ProductID`);
ALTER TABLE `Wishlist`
ADD CONSTRAINT `fk_wishlist_product` FOREIGN KEY (`ProductID`) REFERENCES `Product` (`ProductID`),
ADD CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);
ALTER TABLE `Wishlist`
MODIFY `WishlistID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

