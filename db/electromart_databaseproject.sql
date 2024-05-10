-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: 14. Apr, 2024 13:35 PM
-- Tjener-versjon: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `electromart_databaseproject`
--

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Address`
--

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

--
-- Dataark for tabell `Address`
--

INSERT INTO `Address` (`AddressID`, `UserID`, `Street`, `City`, `State`, `PostalCode`, `Country`, `IsDefault`, `AddressType`) VALUES
(1, 1, 'Karl Johans gate 23', 'Oslo', 'Oslo', '0162', 'Norway', 1, 'Shipping'),
(2, 2, 'Nedre Bakklandet 58', 'Trondheim', 'Trøndelag', '7014', 'Norway', 1, 'Billing');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Brand`
--

CREATE TABLE `Brand` (
  `BrandID` int(11) NOT NULL,
  `Name` varchar(75) NOT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `Brand`
--

INSERT INTO `Brand` (`BrandID`, `Name`, `Description`) VALUES
(1, 'Samsung', 'South Korean multinational electronics company known for its smartphones and consumer electronics.'),
(2, 'Apple', 'American multinational technology company known for its innovative consumer electronics.'),
(3, 'Sony', 'Japanese multinational conglomerate known for its electronics, especially in photography and gaming.'),
(4, 'HP', 'American multinational information technology company known for its laptops and printers.'),
(5, 'Canon', 'Japanese multinational corporation specialized in the manufacture of imaging and optical products, including cameras.'),
(6, 'Bosch', 'Leading global supplier of technology and services in the areas of Mobility Solutions, Industrial Technology, Consumer Goods, and Energy and Building Technology.');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Category`
--

CREATE TABLE `Category` (
  `CategoryID` int(11) NOT NULL,
  `Name` varchar(75) DEFAULT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `Category`
--

INSERT INTO `Category` (`CategoryID`, `Name`, `Description`) VALUES
(1, 'Smartphones', 'Mobile phones with advanced features and functionalities.'),
(2, 'Laptops', 'Portable personal computers suitable for mobile use.'),
(3, 'Tablets', 'Portable computing devices with touchscreen interfaces.'),
(4, 'Cameras', 'Devices for capturing photographs and videos.'),
(5, 'Home Appliances', 'Electronic devices intended for everyday home use.'),
(6, 'Accessories', 'Additional gadgets and devices that complement other electronics.');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Order`
--

CREATE TABLE `Order` (
  `OrderID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `OrderDate` date NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  `OrderStatusID` int(11) DEFAULT NULL,
  `PaymentConfirmedDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `Order`
--

INSERT INTO `Order` (`OrderID`, `UserID`, `OrderDate`, `TotalAmount`, `OrderStatusID`, `PaymentConfirmedDate`) VALUES
(1, 1, '2023-10-01', 1299.99, 1, '2023-10-01'),
(2, 2, '2023-10-02', 349.99, 2, '2023-10-02');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `OrderItem`
--

CREATE TABLE `OrderItem` (
  `OrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `OrderItem`
--

INSERT INTO `OrderItem` (`OrderID`, `ProductID`, `Quantity`, `Subtotal`) VALUES
(1, 5, 1, 1999.99),
(2, 11, 1, 349.99);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `OrderStatus`
--

CREATE TABLE `OrderStatus` (
  `OrderStatusID` int(11) NOT NULL,
  `StatusName` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `CreatedAt` datetime DEFAULT current_timestamp(),
  `UpdatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `OrderStatus`
--

INSERT INTO `OrderStatus` (`OrderStatusID`, `StatusName`, `Description`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Placed', 'Order has been placed and is awaiting processing.', '2024-04-14 13:00:03', '2024-04-14 13:00:03'),
(2, 'Shipped', 'Order has been shipped to the customer.', '2024-04-14 13:00:03', '2024-04-14 13:00:03'),
(3, 'Delivered', 'Order has been delivered.', '2024-04-14 13:00:03', '2024-04-14 13:00:03');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Payment`
--

CREATE TABLE `Payment` (
  `PaymentID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `PaymentMethod` varchar(255) NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `PaymentDate` date NOT NULL,
  `PaymentStatusID` int(11) DEFAULT NULL,
  `TransactionID` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `Payment`
--

INSERT INTO `Payment` (`PaymentID`, `OrderID`, `PaymentMethod`, `Amount`, `PaymentDate`, `PaymentStatusID`, `TransactionID`) VALUES
(1, 1, 'Credit Card', 1299.99, '2023-10-01', 1, 'TX100001'),
(2, 2, 'PayPal', 349.99, '2023-10-02', 1, 'TX100002');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `PaymentStatus`
--

CREATE TABLE `PaymentStatus` (
  `PaymentStatusID` int(11) NOT NULL,
  `StatusName` varchar(75) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `PaymentStatus`
--

INSERT INTO `PaymentStatus` (`PaymentStatusID`, `StatusName`) VALUES
(1, 'Completed'),
(2, 'Pending'),
(3, 'Refunded');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Product`
--

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

--
-- Dataark for tabell `Product`
--

INSERT INTO `Product` (`ProductID`, `Name`, `Description`, `Price`, `StockQuantity`, `BrandID`, `CategoryID`, `ImageURL`, `SKU`, `Weight`, `Dimensions`, `IsActive`) VALUES
(1, 'Samsung Galaxy S21', 'High-end smartphone with advanced photography features.', 799.99, 150, 1, 1, 'https://i5.walmartimages.com/asr/dcf28e36-4c71-49d1-931b-4649b866db89.22d7e2d5e09fe373b2541876b509ebfb.jpeg', 'SKU9001', 0.17, '151.7 x 71.2 x 7.9 mm', 1),
(2, 'iPhone 13', 'Latest model with A15 Bionic chip and advanced dual-camera system.', 899.99, 100, 2, 1, 'https://www.elkjop.no/image/dv_web_D180001002838380/361879/iphone-13-5g-smarttelefon-128gb-midnatt.jpg', 'SKU9002', 0.17, '146.7 x 71.5 x 7.65 mm', 1),
(3, 'HP Spectre x360', 'Versatile laptop with 2-in-1 design and touchscreen.', 1200.00, 75, 4, 2, 'https://www.komplett.no/img/p/800/1304121_6.jpg', 'SKU9003', 1.30, '306 x 194 x 17 mm', 1),
(4, 'MacBook Pro 14\"', 'Powerful laptop with M1 Pro chip, designed for professionals.', 1999.99, 50, 2, 2, 'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111902_mbp14-silver2.png', 'SKU9004', 1.60, '312 x 221 x 15.5 mm', 1),
(5, 'Apple iPad Pro', 'High-performance tablet with Liquid Retina display.', 1099.00, 85, 2, 3, 'https://itechstore.tn/6854-thickbox_default/ipad-pro-11-wi-fi-cellulaire-4%C3%A8me-g%C3%A9n-256go-space-grey.jpg', 'SKU9005', 0.47, '247.6 x 178.5 x 5.9 mm', 1),
(6, 'Samsung Galaxy Tab S7', 'Tablet with enhanced productivity features and S Pen.', 649.99, 90, 1, 3, 'https://m.media-amazon.com/images/I/61YY3z1XkaS._AC_UF894,1000_QL80_DpWeblab_.jpg', 'SKU9006', 0.50, '253.8 x 165.3 x 6.3 mm', 1),
(7, 'Sony Alpha A7 III', 'Full-frame mirrorless camera for enthusiasts and professionals.', 1999.99, 60, 3, 4, 'https://sony.scene7.com/is/image/sonyglobalsolutions/Primary_Image-2?$S7Product$&fmt=png-alpha', 'SKU9007', 0.65, '126.9 x 95.6 x 73.7 mm', 1),
(8, 'Canon EOS R5', 'High-resolution camera designed for professional photography.', 3899.00, 40, 5, 4, 'https://i1.adis.ws/i/canon/eos-r5_front_rf24-105mmf4lisusm_square_32c26ad194234d42b3cd9e582a21c99b', 'SKU9008', 0.74, '138 x 97.5 x 88 mm', 1),
(9, 'Bosch Series 4 Washing Machine', 'Efficient and reliable front loader washing machine.', 599.99, 70, 6, 5, 'https://media.currys.biz/i/currysprod/10236041?$l-large$&fmt=auto', 'SKU9009', 70.00, '848 x 598 x 550 mm', 1),
(10, 'Samsung Family Hub Refrigerator', 'Smart refrigerator with touchscreen and Wi-Fi connectivity.', 3199.99, 30, 1, 5, 'https://img.us.news.samsung.com/us/wp-content/uploads/2018/01/14112220/180108_FH_AKG-Speaker_Full-Shot_w_homescreen_rgb_04.jpg', 'SKU9010', 120.00, '1825 x 908 x 733 mm', 1),
(11, 'Sony WH-1000XM4 Headphones', 'Industry-leading noise cancellation headphones.', 349.99, 100, 3, 6, 'https://www.sony.no/image/5d02da5df552836db894cead8a68f5f3?fmt=pjpeg&wid=330&bgcolor=FFFFFF&bgc=FFFFFF', 'SKU9011', 0.25, 'N/A', 1),
(12, 'Apple AirTag', 'Easy way to keep track of your stuff.', 29.00, 200, 2, 6, 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/airtag-double-select-202104_FMT_WHH?wid=2000&hei=2000&fmt=jpeg&qlt=90&.v=1617761672000', 'SKU9012', 0.01, '31.9 mm diameter x 8 mm', 1);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `ShippingDetail`
--

CREATE TABLE `ShippingDetail` (
  `ShippingID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `RecipientName` varchar(255) DEFAULT NULL,
  `AddressID` int(11) DEFAULT NULL,
  `ShippingMethod` varchar(100) DEFAULT NULL,
  `ShippingCost` decimal(10,2) DEFAULT NULL,
  `ExpectedDeliveryDate` date DEFAULT NULL,
  `TrackingNumber` varchar(255) DEFAULT NULL,
  `IsDelivered` tinyint(1) NOT NULL DEFAULT 0,
  `DeliveryDate` date DEFAULT NULL,
  `BaseCost` decimal(10,2) DEFAULT NULL,
  `WeightSurcharge` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `ShippingDetail`
--

INSERT INTO `ShippingDetail` (`ShippingID`, `OrderID`, `RecipientName`, `AddressID`, `ShippingMethod`, `ShippingCost`, `ExpectedDeliveryDate`, `TrackingNumber`, `IsDelivered`, `DeliveryDate`, `BaseCost`, `WeightSurcharge`) VALUES
(1, 1, 'Alice Blue', 1, 'FedEx', 10.00, '2023-10-05', 'TRACK1001', 0, NULL, 10.00, 2.00),
(2, 2, 'Bob Smith', 2, 'UPS', 5.00, '2023-10-04', 'TRACK1002', 1, '2023-10-04', 5.00, 0.50);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Taxes`
--

CREATE TABLE `Taxes` (
  `TaxID` int(11) NOT NULL,
  `Description` text DEFAULT NULL,
  `TaxPercent` decimal(5,2) DEFAULT NULL,
  `ApplicableToCategoryID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `Taxes`
--

INSERT INTO `Taxes` (`TaxID`, `Description`, `TaxPercent`, `ApplicableToCategoryID`) VALUES
(1, 'Standard Electronics Tax', 15.00, 1),
(2, 'Luxury Electronics Tax', 20.00, 2),
(3, 'Reduced Tax for Tablets', 5.00, 3),
(4, 'Camera Tax', 18.00, 4),
(5, 'Home Appliance Tax', 10.00, 5),
(6, 'Accessory Tax', 12.00, 6);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `User`
--

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

--
-- Dataark for tabell `User`
--

INSERT INTO `User` (`UserID`, `Username`, `Password`, `Email`, `FirstName`, `LastName`, `ProfilePicURL`, `DateOfBirth`, `LastLogin`) VALUES
(1, 'aliceblue', 'hashed_password_123', 'alice.blue@example.com', 'Alice', 'Blue', 'https://example.com/aliceblue.png', '1990-06-01', '2024-04-14 10:58:22'),
(2, 'bobsmith', 'hashed_password_456', 'bob.smith@example.com', 'Bob', 'Smith', 'https://example.com/bobsmith.png', '1985-08-15', '2024-04-14 10:58:22');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `Wishlist`
--

CREATE TABLE `Wishlist` (
  `WishlistID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `AddedDate` date DEFAULT NULL,
  `Name` varchar(75) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dataark for tabell `Wishlist`
--

INSERT INTO `Wishlist` (`WishlistID`, `UserID`, `ProductID`, `AddedDate`, `Name`) VALUES
(1, 1, 1, '2023-10-05', 'Holiday Gifts'),
(1, 1, 2, '2023-10-05', 'Holiday Gifts'),
(2, 2, 3, '2023-10-05', 'Birthday Wishlist');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Address`
--
ALTER TABLE `Address`
  ADD PRIMARY KEY (`AddressID`),
  ADD KEY `fk_user_address` (`UserID`);

--
-- Indexes for table `Brand`
--
ALTER TABLE `Brand`
  ADD PRIMARY KEY (`BrandID`);

--
-- Indexes for table `Category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indexes for table `Order`
--
ALTER TABLE `Order`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `fk_order_user` (`UserID`),
  ADD KEY `fk_order_orderstatus` (`OrderStatusID`);

--
-- Indexes for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD PRIMARY KEY (`OrderID`,`ProductID`),
  ADD KEY `fk_orderitem_product` (`ProductID`);

--
-- Indexes for table `OrderStatus`
--
ALTER TABLE `OrderStatus`
  ADD PRIMARY KEY (`OrderStatusID`);

--
-- Indexes for table `Payment`
--
ALTER TABLE `Payment`
  ADD PRIMARY KEY (`PaymentID`),
  ADD KEY `fk_payment_order` (`OrderID`),
  ADD KEY `fk_payment_status` (`PaymentStatusID`);

--
-- Indexes for table `PaymentStatus`
--
ALTER TABLE `PaymentStatus`
  ADD PRIMARY KEY (`PaymentStatusID`);

--
-- Indexes for table `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`ProductID`),
  ADD UNIQUE KEY `SKU` (`SKU`),
  ADD KEY `BrandID` (`BrandID`),
  ADD KEY `CategoryID` (`CategoryID`);

--
-- Indexes for table `ShippingDetail`
--
ALTER TABLE `ShippingDetail`
  ADD PRIMARY KEY (`ShippingID`),
  ADD KEY `fk_shipping_order` (`OrderID`),
  ADD KEY `fk_shipping_address` (`AddressID`);

--
-- Indexes for table `Taxes`
--
ALTER TABLE `Taxes`
  ADD PRIMARY KEY (`TaxID`),
  ADD KEY `ApplicableToCategoryID` (`ApplicableToCategoryID`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `Wishlist`
--
ALTER TABLE `Wishlist`
  ADD PRIMARY KEY (`WishlistID`,`UserID`,`ProductID`),
  ADD KEY `fk_wishlist_user` (`UserID`),
  ADD KEY `fk_wishlist_product` (`ProductID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Address`
--
ALTER TABLE `Address`
  MODIFY `AddressID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Brand`
--
ALTER TABLE `Brand`
  MODIFY `BrandID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Category`
--
ALTER TABLE `Category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Order`
--
ALTER TABLE `Order`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `OrderStatus`
--
ALTER TABLE `OrderStatus`
  MODIFY `OrderStatusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Payment`
--
ALTER TABLE `Payment`
  MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `PaymentStatus`
--
ALTER TABLE `PaymentStatus`
  MODIFY `PaymentStatusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Product`
--
ALTER TABLE `Product`
  MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `ShippingDetail`
--
ALTER TABLE `ShippingDetail`
  MODIFY `ShippingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Taxes`
--
ALTER TABLE `Taxes`
  MODIFY `TaxID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Wishlist`
--
ALTER TABLE `Wishlist`
  MODIFY `WishlistID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Begrensninger for dumpede tabeller
--

--
-- Begrensninger for tabell `Address`
--
ALTER TABLE `Address`
  ADD CONSTRAINT `fk_user_address` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

--
-- Begrensninger for tabell `Order`
--
ALTER TABLE `Order`
  ADD CONSTRAINT `fk_order_orderstatus` FOREIGN KEY (`OrderStatusID`) REFERENCES `OrderStatus` (`OrderStatusID`),
  ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

--
-- Begrensninger for tabell `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`OrderID`) REFERENCES `Order` (`OrderID`),
  ADD CONSTRAINT `fk_orderitem_product` FOREIGN KEY (`ProductID`) REFERENCES `Product` (`ProductID`);

--
-- Begrensninger for tabell `Payment`
--
ALTER TABLE `Payment`
  ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`OrderID`) REFERENCES `Order` (`OrderID`),
  ADD CONSTRAINT `fk_payment_status` FOREIGN KEY (`PaymentStatusID`) REFERENCES `PaymentStatus` (`PaymentStatusID`);

--
-- Begrensninger for tabell `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`BrandID`) REFERENCES `Brand` (`BrandID`),
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Category` (`CategoryID`);

--
-- Begrensninger for tabell `ShippingDetail`
--
ALTER TABLE `ShippingDetail`
  ADD CONSTRAINT `fk_shipping_address` FOREIGN KEY (`AddressID`) REFERENCES `Address` (`AddressID`),
  ADD CONSTRAINT `fk_shipping_order` FOREIGN KEY (`OrderID`) REFERENCES `Order` (`OrderID`);

--
-- Begrensninger for tabell `Taxes`
--
ALTER TABLE `Taxes`
  ADD CONSTRAINT `taxes_ibfk_1` FOREIGN KEY (`ApplicableToCategoryID`) REFERENCES `Category` (`CategoryID`);

--
-- Begrensninger for tabell `Wishlist`
--
ALTER TABLE `Wishlist`
  ADD CONSTRAINT `fk_wishlist_product` FOREIGN KEY (`ProductID`) REFERENCES `Product` (`ProductID`),
  ADD CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
