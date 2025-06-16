-- Create and select Turkcell database
CREATE DATABASE IF NOT EXISTS TurkcellDB;
USE TurkcellDB;

-- CUSTOMER
CREATE TABLE Customer (
  CustomerID   INT             PRIMARY KEY AUTO_INCREMENT,
  FullName     VARCHAR(100)    NOT NULL,
  Phone        VARCHAR(20)     NOT NULL,
  Email        VARCHAR(100)    NOT NULL,
  Address      TEXT            NULL,
  JoinDate     DATE            NOT NULL,
  CustomerType ENUM('Individual','Corporate') NOT NULL
) ENGINE=InnoDB;

-- PLAN
CREATE TABLE Plan (
  PlanID       INT             PRIMARY KEY AUTO_INCREMENT,
  PlanName     VARCHAR(100)    NOT NULL,
  PlanType     ENUM('Prepaid','Postpaid') NOT NULL,
  MonthlyCost  DECIMAL(10,2)   NOT NULL,
  DataLimitMB  INT             NOT NULL,
  CallMinutes  INT             NOT NULL,
  SMSLimit     INT             NOT NULL,
  IsActive     BOOLEAN         NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- SUBSCRIPTION
CREATE TABLE Subscription (
  SubscriptionID INT           PRIMARY KEY AUTO_INCREMENT,
  CustomerID     INT           NOT NULL,
  PlanID         INT           NOT NULL,
  StartDate      DATE          NOT NULL,
  EndDate        DATE          NULL,
  Status         ENUM('Active','Suspended','Cancelled') NOT NULL,
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (PlanID)     REFERENCES Plan(PlanID)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- CUSTOMER USAGE
CREATE TABLE CustomerUsage (
  UsageID     INT             PRIMARY KEY AUTO_INCREMENT,
  CustomerID  INT             NOT NULL,
  UsageDate   DATE            NOT NULL,
  CallMinutes INT             NOT NULL DEFAULT 0,
  SMSCount    INT             NOT NULL DEFAULT 0,
  DataUsedMB  INT             NOT NULL DEFAULT 0,
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- BILLING
CREATE TABLE Billing (
  BillID        INT           PRIMARY KEY AUTO_INCREMENT,
  CustomerID    INT           NOT NULL,
  BillingMonth  CHAR(7)       NOT NULL COMMENT 'Format YYYY-MM',
  TotalAmount   DECIMAL(10,2) NOT NULL,
  PaymentStatus ENUM('Paid','Unpaid','Overdue') NOT NULL,
  DueDate       DATE          NOT NULL,
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- PAYMENT
CREATE TABLE Payment (
  PaymentID   INT             PRIMARY KEY AUTO_INCREMENT,
  BillID      INT             NOT NULL,
  PaymentDate DATE            NOT NULL,
  AmountPaid  DECIMAL(10,2)   NOT NULL,
  Method      ENUM('Card','Transfer','Wallet') NOT NULL,
  FOREIGN KEY (BillID) REFERENCES Billing(BillID)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- NETWORK_ELEMENT
CREATE TABLE Network_Element (
  ElementID     INT           PRIMARY KEY AUTO_INCREMENT,
  Location      VARCHAR(100)  NOT NULL,
  ElementType   VARCHAR(50)   NOT NULL,
  Status        ENUM('Active','Faulty','Maintenance') NOT NULL,
  LastCheckDate DATE          NOT NULL
) ENGINE=InnoDB;

-- SUPPORT_TICKET
CREATE TABLE Support_Ticket (
  TicketID         INT           PRIMARY KEY AUTO_INCREMENT,
  CustomerID       INT           NOT NULL,
  NetworkElementID INT           NOT NULL,
  OpenDate         DATETIME      NOT NULL,
  IssueType        VARCHAR(100)  NOT NULL,
  Priority         ENUM('Low','Medium','High','Urgent') NOT NULL,
  Status           ENUM('Open','In Progress','Closed') NOT NULL,
  ResolutionNote   TEXT          NULL,
  FOREIGN KEY (CustomerID)       REFERENCES Customer(CustomerID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (NetworkElementID) REFERENCES Network_Element(ElementID)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- EMPLOYEE
CREATE TABLE Employee (
  EmployeeID INT          PRIMARY KEY AUTO_INCREMENT,
  FullName   VARCHAR(100) NOT NULL,
  Email      VARCHAR(100) NOT NULL,
  Phone      VARCHAR(20)  NOT NULL,
  Position   VARCHAR(50)  NOT NULL,
  Department VARCHAR(50)  NOT NULL,
  HireDate   DATE         NOT NULL
) ENGINE=InnoDB;

-- ASSIGNED_TICKET
CREATE TABLE Assigned_Ticket (
  AssignmentID INT           PRIMARY KEY AUTO_INCREMENT,
  TicketID     INT           NOT NULL,
  EmployeeID   INT           NOT NULL,
  AssignedDate DATETIME      NOT NULL,
  HandledStatus ENUM('Pending','In Progress','Resolved') NOT NULL,
  FOREIGN KEY (TicketID)   REFERENCES Support_Ticket(TicketID)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


-- SAMPLE DATA INSERTS (Turkcell + foreign customers)

-- Turkcell customers
INSERT INTO Customer (FullName, Phone, Email, Address, JoinDate, CustomerType) VALUES
  ('Defne Özkan',  '+90-531-114-7788', 'defne.ozkan@turkcell.com.tr',   'İzmir, Karşıyaka', '2023-03-05', 'Individual'),
  ('Barış Arda',   '+90-532-223-8899', 'baris.arda@turkcell.com.tr',    'Ankara, Çankaya',  '2023-04-20', 'Corporate'),
  ('Cansu Yıldız', '+90-533-334-9900', 'cansu.yildiz@turkcell.com.tr',  'Antalya, Lara',    '2023-06-10', 'Individual');

-- Foreign customers
INSERT INTO Customer (FullName, Phone, Email, Address, JoinDate, CustomerType) VALUES
  ('John Doe',      '+1-212-555-0199',    'john.doe@example.com',       'New York, NY, USA',   '2023-05-15', 'Individual'),
  ('Emma Thompson', '+44-20-7946-0958',   'emma.thompson@example.co.uk','London, UK',          '2023-04-28', 'Individual'),
  ('Lukas Müller',  '+49-30-1234-5678',   'lukas.mueller@example.de',   'Berlin, Germany',     '2023-06-01', 'Corporate');

-- Plans
INSERT INTO Plan (PlanName, PlanType, MonthlyCost, DataLimitMB, CallMinutes, SMSLimit, IsActive) VALUES
  ('Turkcell Ultra 20GB','Postpaid',129.90,20480,1000,2000,TRUE),
  ('Turkcell Mini 3GB',  'Prepaid', 39.90, 3072, 200, 300, TRUE),
  ('Turkcell Business',  'Postpaid',299.90,51200,5000,5000,TRUE);

-- Subscriptions
INSERT INTO Subscription (CustomerID, PlanID, StartDate, EndDate, Status) VALUES
  (1, 1, '2023-03-05', NULL, 'Active'),
  (2, 3, '2023-04-20', NULL, 'Active'),
  (3, 2, '2023-06-10', NULL, 'Active'),
  (4, 1, '2023-05-16', NULL, 'Active'),
  (5, 2, '2023-04-29', NULL, 'Active'),
  (6, 3, '2023-06-02', NULL, 'Active');

-- Customer usage
INSERT INTO CustomerUsage (CustomerID, UsageDate, CallMinutes, SMSCount, DataUsedMB) VALUES
  (1, '2023-06-12',  60,  50, 1800),
  (1, '2023-06-13',  30,  10, 1200),
  (2, '2023-06-12', 300, 200,10240),
  (4, '2023-06-12',  80,  30, 2500),
  (5, '2023-06-12',  20,  10,  800),
  (6, '2023-06-12', 400, 300,15360);

-- Billing
INSERT INTO Billing (CustomerID, BillingMonth, TotalAmount, PaymentStatus, DueDate) VALUES
  (1, '2023-06', 129.90, 'Unpaid',  '2023-07-05'),
  (2, '2023-06', 299.90, 'Paid',    '2023-07-10'),
  (4, '2023-06', 129.90, 'Unpaid',  '2023-07-10'),
  (5, '2023-06',  39.90, 'Paid',    '2023-07-05'),
  (6, '2023-06', 299.90, 'Unpaid',  '2023-07-15');

-- Payment
INSERT INTO Payment (BillID, PaymentDate, AmountPaid, Method) VALUES
  (2, '2023-07-08', 299.90, 'Card'),
  (1, '2023-07-04', 129.90, 'Wallet'),
  (5, '2023-07-04',  39.90, 'Card');

-- Network elements
INSERT INTO Network_Element (Location, ElementType, Status, LastCheckDate) VALUES
  ('İstanbul - Kadıköy', 'Base Station', 'Active',      '2023-06-10'),
  ('Bursa - Nilüfer',    'Core Router',   'Maintenance', '2023-06-11');

-- Support tickets
INSERT INTO Support_Ticket (CustomerID, NetworkElementID, OpenDate, IssueType, Priority, Status, ResolutionNote) VALUES
  (1, 1, '2023-06-12 09:30:00', 'No signal in area',        'High',    'Open',        NULL),
  (3, 2, '2023-06-13 14:45:00', 'Intermittent data dropouts','Medium',  'In Progress','Technician assigned');

-- Employees
INSERT INTO Employee (FullName, Email, Phone, Position, Department, HireDate) VALUES
  ('Gökhan Demir', 'gokhan.demir@turkcell.com.tr', '+90-555-445-6677', 'Field Technician', 'Operations', '2020-09-01'),
  ('Nehir Koca',   'nehir.koca@turkcell.com.tr',   '+90-555-556-7788', 'Support Lead',     'Support',    '2021-05-15');

-- Assigned tickets
INSERT INTO Assigned_Ticket (TicketID, EmployeeID, AssignedDate, HandledStatus) VALUES
  (1, 1, '2023-06-12 10:00:00', 'Pending'),
  (2, 2, '2023-06-13 15:00:00', 'In Progress');