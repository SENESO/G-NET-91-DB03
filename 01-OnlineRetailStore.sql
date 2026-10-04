-- G-NET-91-DB03 | Session 03 - Database
-- Online Retail Store Management System
-- Student: Eslam Ashraf

CREATE DATABASE OnlineRetailStore;
GO
USE OnlineRetailStore;
GO

CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    MainCategoryId INT NULL,
    FOREIGN KEY (MainCategoryId) REFERENCES Categories(CategoryId)
);
GO

CREATE TABLE Suppliers (
    SupplierId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Country NVARCHAR(100) NULL,
    Email NVARCHAR(255) NULL,
    Address NVARCHAR(500) NULL,
    ContactNumber NVARCHAR(20) NULL
);
GO

CREATE TABLE Products (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity INT NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
    AddedDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CategoryId INT NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);
GO

CREATE TABLE Products_Suppliers (
    SupplierId INT NOT NULL,
    ProductId INT NOT NULL,
    PRIMARY KEY (SupplierId, ProductId),
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

CREATE TABLE StockTransactions (
    TranId INT IDENTITY(1,1) PRIMARY KEY,
    TranDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    QuantityChange INT NOT NULL,
    Type NVARCHAR(20) NOT NULL CHECK (Type IN ('IN','OUT','ADJUST')),
    Reference NVARCHAR(255) NULL,
    ProductId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

CREATE TABLE Customers (
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    ShippingAddress NVARCHAR(500) NULL,
    RegistrationDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
GO

CREATE TABLE Orders (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Status NVARCHAR(30) NOT NULL DEFAULT 'Pending'
        CHECK (Status IN ('Pending','Paid','Shipped','Delivered','Cancelled')),
    TotalAmount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (TotalAmount >= 0),
    CustomerId INT NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);
GO

CREATE TABLE OrderItems (
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    ProductId INT NOT NULL,
    OrderId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);
GO

CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Amount DECIMAL(12,2) NOT NULL CHECK (Amount > 0),
    Status NVARCHAR(30) NOT NULL DEFAULT 'Pending'
        CHECK (Status IN ('Pending','Completed','Failed','Refunded')),
    Method NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Orders_Payments (
    OrderId INT NOT NULL,
    PaymentId INT NOT NULL,
    PRIMARY KEY (OrderId, PaymentId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId)
);
GO

CREATE TABLE Shipments (
    ShipmentId INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Status NVARCHAR(30) NOT NULL DEFAULT 'Preparing'
        CHECK (Status IN ('Preparing','Shipped','InTransit','Delivered','Returned')),
    DeliveryDate DATE NULL,
    CarrierName NVARCHAR(100) NULL,
    TrackingNumber NVARCHAR(100) NULL,
    OrderId INT NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);
GO

CREATE TABLE Reviews (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Comment NVARCHAR(MAX) NULL,
    ProductId INT NOT NULL,
    CustomerId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);
GO
