CREATE DATABASE HotelReservationSystem;
GO
USE HotelReservationSystem;
GO

CREATE TABLE Hotels (
    HotelId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Address NVARCHAR(500) NULL,
    City NVARCHAR(100) NOT NULL,
    StarRating INT NULL CHECK (StarRating BETWEEN 1 AND 5),
    ContactNumber NVARCHAR(20) NULL,
    ManageId INT NULL UNIQUE
);
GO

CREATE TABLE Staff (
    StaffId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Position NVARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NULL CHECK (Salary >= 0),
    HotelId INT NOT NULL,
    FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId)
);
GO

ALTER TABLE Hotels
ADD FOREIGN KEY (ManageId) REFERENCES Staff(StaffId);
GO

CREATE TABLE Rooms (
    RoomNumber INT PRIMARY KEY,
    RoomType NVARCHAR(50) NOT NULL
        CHECK (RoomType IN ('Single','Double','Suite','Deluxe','Family')),
    Capacity INT NOT NULL CHECK (Capacity > 0),
    DailyRate DECIMAL(10,2) NOT NULL CHECK (DailyRate >= 0),
    Availability BIT NOT NULL DEFAULT 1,
    HotelId INT NOT NULL,
    FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId)
);
GO

CREATE TABLE Amenities (
    RoomNumber INT NOT NULL,
    Amenity NVARCHAR(100) NOT NULL,
    PRIMARY KEY (RoomNumber, Amenity),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);
GO

CREATE TABLE Services (
    ServiceId INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(150) NOT NULL,
    Charge DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (Charge >= 0),
    RequestDate DATE NULL,
    StaffId INT NULL,
    FOREIGN KEY (StaffId) REFERENCES Staff(StaffId)
);
GO

CREATE TABLE Guests (
    GuestId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Nationality NVARCHAR(100) NULL,
    PassportNumber NVARCHAR(50) NULL UNIQUE,
    DateOfBirth DATE NULL
);
GO

CREATE TABLE Guest_Contact_Details (
    GuestId INT NOT NULL,
    Detail NVARCHAR(255) NOT NULL,
    PRIMARY KEY (GuestId, Detail),
    FOREIGN KEY (GuestId) REFERENCES Guests(GuestId)
);
GO

CREATE TABLE Reservations (
    ReservationId INT IDENTITY(1,1) PRIMARY KEY,
    BookingDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    ReservationStatus NVARCHAR(30) NOT NULL DEFAULT 'Confirmed'
        CHECK (ReservationStatus IN ('Pending','Confirmed','CheckedIn','CheckedOut','Cancelled')),
    TotalPrice DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (TotalPrice >= 0),
    NumberOfAdults INT NOT NULL DEFAULT 1 CHECK (NumberOfAdults > 0),
    NumberOfChildren INT NOT NULL DEFAULT 0 CHECK (NumberOfChildren >= 0),
    CHECK (CheckOutDate > CheckInDate)
);
GO

CREATE TABLE Reservations_Rooms (
    ReservationId INT NOT NULL,
    RoomNumber INT NOT NULL,
    PRIMARY KEY (ReservationId, RoomNumber),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);
GO

CREATE TABLE Reservations_Guest (
    ReservationId INT NOT NULL,
    GuestId INT NOT NULL,
    PRIMARY KEY (ReservationId, GuestId),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
    FOREIGN KEY (GuestId) REFERENCES Guests(GuestId)
);
GO

CREATE TABLE ReservationService (
    ServiceId INT NOT NULL,
    ReservationId INT NOT NULL,
    PRIMARY KEY (ServiceId, ReservationId),
    FOREIGN KEY (ServiceId) REFERENCES Services(ServiceId),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId)
);
GO

CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    Method NVARCHAR(50) NOT NULL,
    Date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Amount DECIMAL(12,2) NOT NULL CHECK (Amount > 0),
    ConfirmationNumber NVARCHAR(100) NULL UNIQUE
);
GO

CREATE TABLE Reservations_Payment (
    ReservationId INT NOT NULL,
    PaymentId INT NOT NULL,
    PRIMARY KEY (ReservationId, PaymentId),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId)
);
GO
