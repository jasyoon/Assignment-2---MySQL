create table Customers
(
    CustomerID   int auto_increment
        primary key,
    CustomerName varchar(255) not null,
    ContactName  varchar(255) null,
    Address      varchar(255) null,
    City         varchar(100) null,
    PostalCode   varchar(20)  null,
    Country      varchar(100) null
);

create table Orders
(
    OrderID        int auto_increment
        primary key,
    CustomerID     int          null,
    OrderDate      date         null,
    ShipDate       date         null,
    ShipAddress    varchar(255) null,
    ShipCity       varchar(100) null,
    ShipPostalCode varchar(20)  null,
    ShipCountry    varchar(100) null,
    constraint Orders_ibfk_1
        foreign key (CustomerID) references Customers (CustomerID)
);

create index CustomerID
    on Orders (CustomerID);

create table Suppliers
(
    SupplierID   int auto_increment
        primary key,
    SupplierName varchar(255) not null,
    ContactName  varchar(255) null,
    Address      varchar(255) null,
    City         varchar(100) null,
    PostalCode   varchar(20)  null,
    Country      varchar(100) null,
    Phone        varchar(20)  null
);

create table Products
(
    ProductID    int auto_increment
        primary key,
    ProductName  varchar(255)   not null,
    SupplierID   int            null,
    Category     varchar(100)   null,
    UnitPrice    decimal(10, 2) null,
    UnitsInStock int            null,
    constraint Products_ibfk_1
        foreign key (SupplierID) references Suppliers (SupplierID)
);

create table OrderDetails
(
    OrderDetailID int auto_increment
        primary key,
    OrderID       int            null,
    ProductID     int            null,
    Quantity      int            null,
    UnitPrice     decimal(10, 2) null,
    constraint OrderDetails_ibfk_1
        foreign key (OrderID) references Orders (OrderID),
    constraint OrderDetails_ibfk_2
        foreign key (ProductID) references Products (ProductID)
);

create index OrderID
    on OrderDetails (OrderID);

create index ProductID
    on OrderDetails (ProductID);

create index SupplierID
    on Products (SupplierID);

create
    definer = root@`%` procedure AddNewOrder(IN p_CustomerID int, IN p_OrderDate date, IN p_ShipDate date,
                                             IN p_ShipAddress varchar(255), IN p_ShipCity varchar(100),
                                             IN p_ShipPostalCode varchar(20), IN p_ShipCountry varchar(100),
                                             IN p_ProductID int, IN p_Quantity int, IN p_UnitPrice decimal(10, 2))
BEGIN
    INSERT INTO Orders (CustomerID, OrderDate, ShipDate, ShipAddress, ShipCity, ShipPostalCode, ShipCountry)
    VALUES (p_CustomerID, p_OrderDate, p_ShipDate, p_ShipAddress, p_ShipCity, p_ShipPostalCode, p_ShipCountry);

    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES (p_ProductID, p_Quantity, p_UnitPrice);

    CALL UpdateStockQuantity(p_ProductID, p_Quantity);
END;

create
    definer = root@`%` procedure UpdateStockQuantity(IN p_ProductID int, IN p_Quantity int)
BEGIN
    UPDATE Products

    SET UnitsInStock = UnitsInStock + p_Quantity
    WHERE ProductID = p_ProductID;
END;


