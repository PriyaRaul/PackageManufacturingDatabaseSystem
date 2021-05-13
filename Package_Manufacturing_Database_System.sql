CREATE DATABASE PackageManufacturingDatabaseSystem
use PackageManufacturingDatabaseSystem

Create Table dbo.Customer
(
	CustomerID INT Not Null Primary Key identity(200,1),
	CompanyName Varchar Not null,
	ContactNumber Int Not null,
	EmailID Varchar Not Null ,
	Country Varchar Not Null ,
	State Varchar Not Null,
	City Varchar Not Null,
	Address1 Varchar Not Null,
	Address2 Varchar,
	ZipCode Int Not Null
);


Alter table dbo.Customer add constraint checkForEmail check (EmailID like '%_@__%.__%')
ALTER TABLE dbo.Customer ADD CONSTRAINT uniqueEmail UNIQUE(EmailID);

ALTER TABLE dbo.Customer ALTER COLUMN CompanyName VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN EmailID VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN Country VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN State VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN City VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN Address1 VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN Address2 VARCHAR (50)

ALTER TABLE Customer ALTER COLUMN Address1 VARCHAR (50) NULL
ALTER TABLE Customer ALTER COLUMN Address2 VARCHAR (50) NULL

Create Table dbo.Subscriptions
(
	SubscriptionID Int PRIMARY KEY IDENTITY(501,1),
	CustomerID Int Not Null References dbo.Customer(CustomerID),
	ProductID Int Not Null References dbo.Products(ProductID),		
	Quantity Int Not Null,
	RepeatOrderIn_Months Int Not Null,
	ExpiryDate date
)

--- To have unique subscriptions for product 1 customer can subscribe for many products
ALTER TABLE Subscriptions  ADD CONSTRAINT uniqueSubscriptions UNIQUE(CustomerID,productID);

Create Table CustomerCredentials
(
	CustomerID Int References dbo.Customer(CustomerID) unique,
	EmailID Varchar(50) ,	
	PasswordValue VARBINARY(250) 
)


CREATE TABLE dbo.Products
	(
	ProductID int NOT NULL PRIMARY KEY,
	MaterialID int NOT NULL
		REFERENCES dbo.RawMaterials(MaterialID),
	Size_Length int NOT NULL,
	Size_Height int NOT NULL,
	Size_Width int NOT NULL,
	Image_url varchar(100) NOT NULL,
	);

CREATE TABLE dbo.Refunds
	(
	RefundID int NOT NULL PRIMARY KEY,
	ReturnID int NOT NULL
		REFERENCES dbo.[Returns](ReturnID),
	ModeOfRefund varchar(20) NOT NULL,
	Status varchar(10) NOT NULL	
	);

CREATE TABLE dbo.ProcessType
	(
	ProcessID int NOT NULL PRIMARY KEY,
	ProcessName varchar(10) NOT NULL
	);

CREATE TABLE dbo.SalesOpportunities
	(
	SaleID int NOT NULL PRIMARY KEY,
	CustomerID int NOT NULL
			REFERENCES dbo.Customer(CustomerID),
	Requirement_Specifications varchar(100)
	);

CREATE TABLE dbo.PaymentDetails
	(
	CustomerID int NOT NULL
			REFERENCES dbo.Customer(CustomerID),
	OrderID int NOT NULL
			REFERENCES dbo.Orders(OrderID),
	ModeOfPayment varchar(20) NOT NULL,
	Amount int NOT NULL,
	Note varchar,
	CONSTRAINT PKOrderPayment PRIMARY KEY CLUSTERED(CustomerID,OrderID)
	);

CREATE TABLE dbo.Orders(
	OrderID int IDENTITY NOT NULL PRIMARY KEY,
	CustomerID int NOT NULL
	REFERENCES dbo.Customer(CustomerID),
	[Status] varchar(50) NOT NULL,
	OrderDate Date NOT NULL
);

CREATE TABLE dbo.OrderProducts(
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	Quantity int NOT NULL
	CONSTRAINT PKOrderItem PRIMARY KEY CLUSTERED(OrderID, ProductID)
 );

 CREATE TABLE dbo.Reprocess(
	ReprocessID int IDENTITY NOT NULL PRIMARY KEY,
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	[Status] varchar(50) NOT NULL
 );


 CREATE TABLE dbo.Returns(
	ReturnID  int IDENTITY NOT NULL PRIMARY KEY,
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	Reason varchar(max) NOT NULL
 );

CREATE TABLE dbo.Reviews(
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	Rating int NOT NULL,
	Review varchar(max) NOT NULL
	CONSTRAINT PKOrderProduct PRIMARY KEY CLUSTERED(OrderID, ProductID)
 );

CREATE TABLE dbo.Process(
    ProcessID  int NOT NULL
	REFERENCES dbo.ProcessType(ProcessID),
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	MaterialUsage int NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date
	CONSTRAINT PKProductProcess PRIMARY KEY CLUSTERED(ProcessID,OrderID, ProductID)
 );

ALTER TABLE Products
ADD Price Money;

ALTER TABLE Orders
ADD TotalAmount Money;

alter table ProcessType alter column ProcessName varchar(20)
alter table Process alter column StartDate datetime
alter table Process alter column EndDate datetime
alter table Products alter column Image_url varchar(max)

use PackageManufacturingDatabaseSystem;

--Insert data in Customer
insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('Dominos',1234567890,'dominos@gmail.com','USA','washington','Bothell','20806 Bothell','Everett Hwy Suite 106',98121)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('walMart',2456754321,'pizzhut@gmail.com','USA','washington','Bellevue','986 Aloha','Downtown',98606)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('PizzHut',2345678910,'pizzhut@gmail.com','USA','washington','Bellevue','15210 SE 37th st','',98007)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('H&M',2345678911,'HM@gmail.com','USA','washington','Seattle','2604 NE','University village st',98101)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('Uhaul',2345678912,'uhaul@gmail.com','USA','washington','Redmond','18024','Redmond way',98008)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('GapCloths',2345678913,'Gap@gmail.com','USA','washington','Bellevue','4625 27th Ave','NE st #23',98007)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('TommyHilfigerPerfume',2345678914,'tho@gmail.com','USA','washington','Tacoma','macys','Tacoma mall',98008)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('SeattleProfessionalMovers',2345678915,'spm@gmail.com','USA','washington','Seattle','NW 61st St','',98101)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('PeopleMovers',2345678916,'peoplemovers@gmail.com','USA','washington','Renton','N 103rd ST','',98055)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('IKEA',2345678917,'ikea@gmail.com','USA','washington','Redmond','601 SW','41st ST',98008)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('DollarTree',2345678918,'dollartree@gmail.com','USA','washington','Seattle','','',98101)

update dbo.Customer set EmailId='dominos@gmail.com',city='Bothell',
Address1='20806 Bothell', Address2='Everett Hwy Suite 106' 
where customerId=200

insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(204,801,100,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(200,800,2,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(201,801,50,2)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(202,803,200,1)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(203,804,100,2)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(204,802,150,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(205,802,75,3)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(206,808,60,3)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(206,809,25,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(207,810,100,1)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(208,803,250,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(208,803,250,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(209,805,250,6)

--Insert Data in Products
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(800, 2000, 4, 10, 8, 'https://www.packagingsupplies.com/collections/corrugated-mailers/products/3-x-3-x-1-white-corrugated-mailers', 5.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(801, 2000, 4, 10, 8, 'https://www.packagingsupplies.com/collections/corrugated-boxes/products/3-x-3-x-3-corrugated-boxes', 10.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(802, 2000, 4, 10, 8, 'https://www.packagingsupplies.com/collections/white-corrugated-boxes/products/4-x-4-x-4-white-corrugated-boxes', 15.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(803, 2001, 4, 4, 8, 'https://www.packagingsupplies.com/collections/foam-lined-mailers', 2.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(804, 2000, 14, 4, 8, 'https://www.packagingsupplies.com/collections/insulated-shipping-kits/products/10-1-2-x-8-1-4-x-9-1-4-insulated-shipping-kit', 12.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(805, 2002, 6, 4, 1, 'https://www.packagingsupplies.com/collections/insulated-foam-containers/products/8-x-6-x-9-insulated-foam-containers', 2.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(806, 2003, 10, 12, 2, 'https://www.packagingsupplies.com/collections/insulated-box-liners/products/12-x-12-x-12-insulated-box-liners', 12.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(807, 2001, 6, 2, 2, 'https://www.packagingsupplies.com/collections/cold-packs/products/8-x-8-x-1-1-2-32-oz-ice-brix-cold-packs', 10.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(808, 2002, 7, 10, 2, 'https://www.packagingsupplies.com/collections/cool-shield-bubble-mailers/products/6-1-2-x-10-1-2-cool-shield-bubble-mailers', 8.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(809, 2003, 6, 14, 1, 'https://www.packagingsupplies.com/collections/insulated-mailers/products/12-x-14-cool-stuff-insulated-mailers', 2.0000);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(810, 2001, 5, 12, 3, 'https://www.packagingsupplies.com/collections/retention-packaging/products/12-x-10-x-5-korrvu-r-suspension-packaging', 12.0000);


-- Insert into CustomerCredentials
INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('dominos@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'dominos')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('wm@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'walmart')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('pizzhut@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'pizzhut')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('HM@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'H&M')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('uhaul@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'uhaul')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('Gap@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'gap')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('tho@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'tommyHilfiger')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('spm@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'SeattleProfMovers')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('peoplemovers@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'peopleMovers')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('ikea@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'ikea')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('pizzhut@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'pizzhut')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue)
VALUES('dollartree@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'DollarTree')));


SET IDENTITY_INSERT dbo.Orders ON;
SET IDENTITY_INSERT dbo.Customer ON;

INSERT INTO Customer (CompanyName,ContactNumber ,EmailID,Country,State,Address1,Address2,ZipCode)
VALUES ('Dominos','1234567890','abc@def.com','USA','Washington','Add1','Add2',98121);

INSERT INTO dbo.Orders (OrderID ,CustomerID ,Status ,OrderDate, TotalAmount)
VALUES (300,200,'Processing','04-04-2006',0);

--Insert in RawMaterials
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2000,'Cardboard',24);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2001,'Plastic sheet',104);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2002,'Laminate',85);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2003,'Paperboard',150);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2004,'Tape',500);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2005,'Cutters',60);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2006,'Fevicol',600);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2007,'Paper',7000);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2008,'Ink-Red',450);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2009,'Ink-Green',260);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2009,'Ink-Blue',345);

--Insert in OrderProducts
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,800,2);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (301,802,4);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (302,800,18);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,803,20);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (304,804,18);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (305,805,120);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (307,802,87);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (308,806,109);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (308,801,70);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (309,803,45);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,801,45);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,802,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (301,803,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (304,800,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (304,802,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (303,806,2);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (306,806,2);

--Insert in Process type
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1000, 'Printing');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1001, 'Lamination');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1002, 'Bag making');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1003, 'Box making');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1004, 'Quality check');

--Insert in Refunds
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(600, 1700, 'Gift card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(601, 1701, 'Credit in card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(602, 1702, 'Gift card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(603, 1703, 'Gift card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(604, 1704, 'Credit in card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(605, 1705, 'Gift card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(606, 1706, 'Credit in card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(607, 1707, 'Gift card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(608, 1708, 'Credit in card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(609, 1709, 'Gift card', 'Refunded');

--Insert in process
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1000, 300, 800, 12, '2006-11-11 13:23:44', '2006-11-11 14:56:00');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1000, 301, 801, 10, '2006-11-11 15:00:00', '2006-11-11 16:39:39');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 305, 805, 10, '2006-11-11 15:20:30', '2006-11-11 15:22:59');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 302, 802, 5, '2006-11-11 15:20:30', '2006-11-11 15:22:07');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 302, 800, 2, '2006-11-12 12:26:30', '2006-11-12 13:12:34');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 304, 802, 6, '2006-11-12 15:27:30', '2006-11-12 16:22:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 300, 800, 0, '2006-11-12 15:27:30', '2006-11-12 16:22:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 301, 801, 0, '2006-11-12 15:30:30', '2006-11-12 15:35:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 305, 805, 0, '2006-11-12 15:40:30', '2006-11-12 15:45:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 302, 802, 0, '2006-11-12 15:50:30', '2006-11-12 15:55:09');

INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3000, 78, 'preparing for delivery', '12000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3000, 50, 'preparing for delivery', '22000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3002, 50, 'preparing for delivery', '22000');

--Reprocess
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (300,800,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (301,801,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (302,802,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (303,803,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (304,804,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (305,805,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (306,806,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (307,807,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (308,808,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (309,809,'needs reprocessing');

--Returns
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1700,300,800,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1701,301,801,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1702,302,802,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1703,303,803,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1704,304,804,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1705,305,805,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1706,306,806,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1707,307,807,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1708,308,808,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1709,309,809,'Quality issues');


--Reviews
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(300,800,4,'Excellent quality');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(301,801,2,'delivery not on time');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(302,802,5,'great experience');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(303,803,2,'Quality not up to the mark');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(304,804,5,'Excellent and timely delivery');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(305,805,2,'ok materials');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(306,806,4,'satisfied');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(307,807,1,'not satisfied');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(308,808,5,'Overall good');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(309,809,2,'poor');

use PackageManufacturingDatabaseSystem;

--Trigger to compute Total amount in Orders 
CREATE TRIGGER TR_UpdateTotalAmtBasedOnQuantity
ON dbo.OrderProducts
AFTER INSERT, UPDATE , DELETE AS
BEGIN
	DECLARE @Amount table (totalprice int, orderID int)
	insert into @Amount 
	SELECT SUM(p.Price * op.Quantity),op.OrderID
	FROM PackageManufacturingDatabaseSystem.dbo.Products p 
	JOIN  OrderProducts op 
	ON op.ProductID = p.ProductID 
	GROUP BY op.OrderID 
	UPDATE Orders 
	SET TotalAmount = (select totalprice from @Amount a
					   where a.OrderID = Orders.OrderID)
END;

--Trigger to compute Total Raw Material Purchase
CREATE TRIGGER TR_UpdateTotalRawMaterialPurchase
ON dbo.RawMaterial_VendorPurchase
AFTER INSERT, UPDATE , DELETE AS
BEGIN
	DECLARE @TotalPurchase table (totalprice int, purchaseID int)
	insert into @TotalPurchase 
	SELECT SUM(rmvp.quantity*rmv.UnitPrice),rmvp.PurchaseID
	FROM PackageManufacturingDatabaseSystem.dbo.RawMaterialsVendors rmv 
	JOIN RawMaterial_VendorPurchase rmvp 
	ON rmv.MaterialVendorID = rmvp.MaterialVendorID 
	GROUP BY rmvp.PurchaseID 
	UPDATE RawMaterialPurchase 
	SET RawMaterialPurchase.TotalPrice = (select totalprice from @TotalPurchase a
	WHERE a.PurchaseID = RawMaterialPurchase.PurchaseID)
END;

--Trigger to Set Expiry date automatically

go
create trigger ExpiryDateUpdate
on dbo.Subscriptions
after insert, update,delete
as begin
	declare @expiryDate date;
	declare @startDate date=getdate();
	declare @duration int;
	declare @ProdID int;
	declare @CusID int;
	select @ProdID= Coalesce(i.ProductID,d.ProductID) from inserted i join deleted d
					on i.ProductID=d.ProductID
	select @CusID=Coalesce(i.CustomerID,d.CustomerID) from inserted i join deleted d
					on i.CustomerID=d.CustomerID
	set @expiryDate=DateAdd(yy,1,getdate())
	update dbo.Subscriptions set ExpiryDate=@expiryDate where ProductID= @ProdID and CustomerID=@CusID
end

--Trigger to insert customerID into CustomerCredentials automatically
go
create trigger CustomerIdUpdate
on dbo.CustomerCredentials
after insert,update,delete
as begin
	declare @CustId int;
	declare @CustEmailId varchar(50);
	declare @CustLoginId varchar(50);
	
	select @CustLoginId= coalesce(i.EmailId,d.EmailId) from inserted i full join deleted d
						 on i.EmailID=d.EmailID
	select @CustEmailId= c.EmailID from Customer c where @CustLoginId=c.EmailID

	select @CustId=c.CustomerID from Customer c where @CustLoginId=c.EmailID
	
	update CustomerCredentials set CustomerID=@CustId where EmailID=@CustEmailId
End

--trigger to subtract quantity on process usage
Create trigger SubtractQuantityonHand
on dbo.Process 
after insert,update,delete
as begin
declare @QtyOnHand int;
declare @Qtyused int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @Qtyused=isNull(MaterialUsage,0) from inserted i;
select @MatID=MaterialID from Products p join inserted i
				on p.ProductID =i.ProductID
update RawMaterials set QuantityOnHand=QuantityOnHand-@Qtyused where MaterialID=@MatID
end

--trigger to add quantity on deletion process usage
Create trigger SubtractQuantityonHandDeletion
on dbo.Process 
after DELETE 
as begin
declare @QtyOnHand int;
declare @Qtyused int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @Qtyused=isNull(MaterialUsage,0) from deleted d;
select @MatID=MaterialID from Products p join deleted d
				on p.ProductID =d.ProductID
update RawMaterials set QuantityOnHand=QuantityOnHand+@Qtyused where MaterialID=@MatID
END

--Trigger to calculate amount
CREATE TRIGGER CalculateAmount 
ON dbo.OrderProducts
AFTER INSERT, UPDATE, DELETE 
AS
BEGIN 
update dbo.Orders
set dbo.Orders.TotalAmount = o.Quantity*p.price
		 FROM dbo.Orders
		 join dbo.OrderProducts AS o
		 on dbo.Orders.OrderID= o.OrderID
		   JOIN dbo.Products AS p
		 ON o.ProductID = p.ProductID
END


--trigger to add quantity on delivered raw materials
Create trigger UpdateQuantityOnHand
on dbo.RawMaterial_VendorPurchase
after insert,update,delete
as begin
declare @QtyOnHand int;
declare @QtyPurchased int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @QtyPurchased=isNull(Quantity,0) from inserted i where DeliveryStatus='Delivered';
select @MatID=MaterialID from RawMaterialsVendors rmv join inserted i
				on rmv.MaterialVendorID=i.MaterialVendorID
update RawMaterials set QuantityOnHand=QuantityOnHand+@QtyPurchased where MaterialID=@MatID
end

--trigger to subtract quantity on deleted rows on delivered raw materials
Create trigger UpdateQuantityOnHandDeletion
on dbo.RawMaterial_VendorPurchase
after delete
as begin
declare @QtyOnHand int;
declare @QtyPurchased int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @QtyPurchased=isNull(Quantity,0) from deleted d where DeliveryStatus='Delivered';
select @MatID=MaterialID from RawMaterialsVendors rmv join deleted d
				on rmv.MaterialVendorID=d.MaterialVendorID
update RawMaterials set QuantityOnHand=QuantityOnHand-@QtyPurchased where MaterialID=@MatID
end




--Encryption on password

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'AHJNP';

CREATE CERTIFICATE ProjectCertificate 
WITH SUBJECT = 'PackageManufacturingDatabaseSystem project Certificate',EXPIRY_DATE = '2022-03-31';

CREATE SYMMETRIC KEY ProjectSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE ProjectCertificate;

OPEN SYMMETRIC KEY ProjectSymmetricKey
DECRYPTION BY CERTIFICATE ProjectCertificate;

select * from CustomerCredentials

--Decrypt the password
select CustomerID,EmailID, convert(varchar, DecryptByKey(PasswordValue)) as [PasswordValue] from CustomerCredentials;

--view 1 OrderDetailsPerMonth 

create view OrderDetailsPerMonth
as 
select year(orderDate) SaleYear
	,DateNAME(MONTH,orderDate) as [SaleMonth]
	,count(orderId) as NumberOfOrders
	,sum(TotalAmount) TotalSales 
from dbo.Orders 
group BY year(orderDate), DateNAME(MONTH,orderDate), MONTH(orderDate)
order by YEAR (OrderDate), MONTH(orderDate) offset 0 rows;

-- view 2 ProductStatistic 

create view ProductStatistic
as 
select p.ProductID 
	, sum(op.Quantity) 
		+ (case when sum(case when r2.ReprocessID is not null then op.Quantity end)is not null 
			then sum(case when r2.ReprocessID is not null then op.Quantity end)
			else 0 end) as NumOfProducedProducts
	,(case when sum(case when r.ReturnID is null then op.Quantity end) is not null 
		then sum(case when r.ReturnID is null then op.Quantity end)
		else 0 end) as NumOfSoldProducts
	, (case when sum(case when r.ReturnID is not null then op.Quantity end) is not null 
		then sum(case when r.ReturnID is not null then op.Quantity end)
		else 0 end) as NumOfReturnedProducts
	, (case when sum(case when r2.ReprocessID is not null then op.Quantity end) is not null 
		then sum(case when r2.ReprocessID is not null then op.Quantity end)
		else 0 end) as NumOfReproducedProducts
from Orders o 
join PackageManufacturingDatabaseSystem.dbo.OrderProducts op on o.OrderID = op.OrderID 
join PackageManufacturingDatabaseSystem.dbo.Products p on p.ProductID = op.ProductID 
left join [Returns] r on r.OrderID = op.OrderID and r.ProductID = op.ProductID
left join Reprocess r2 on r2.OrderID = op.OrderID and r2.ProductID = op.ProductID 
group by p.ProductID;


