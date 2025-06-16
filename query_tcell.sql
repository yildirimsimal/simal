-- Query 1: Customers with unpaid bills
SELECT 
  c.FullName, 
  b.BillingMonth, 
  b.TotalAmount, 
  b.PaymentStatus
FROM Customer c
JOIN Billing b ON c.CustomerID = b.CustomerID
WHERE b.PaymentStatus = 'Unpaid';

-- Query 2: Subscriber count per plan
SELECT 
  p.PlanName, 
  COUNT(s.SubscriptionID) AS TotalSubscribers
FROM Plan p
JOIN Subscription s ON p.PlanID = s.PlanID
GROUP BY p.PlanName;

-- Query 3: Top data-using customer
SELECT 
  c.FullName, 
  SUM(u.DataUsedMB) AS TotalDataMB
FROM Customer c
JOIN CustomerUsage u ON c.CustomerID = u.CustomerID
GROUP BY c.FullName
ORDER BY TotalDataMB DESC
LIMIT 1;

-- Query 4: Details of active subscriptions
SELECT 
  s.SubscriptionID, 
  c.FullName, 
  p.PlanName, 
  s.StartDate
FROM Subscription s
JOIN Customer c ON s.CustomerID = c.CustomerID
JOIN Plan p       ON s.PlanID     = p.PlanID
WHERE s.Status = 'Active';

-- Query 5: Open support tickets with assigned technician
SELECT 
  st.TicketID, 
  c.FullName        AS Customer, 
  e.FullName        AS Technician, 
  st.IssueType, 
  st.Status
FROM Support_Ticket st
JOIN Customer c        ON st.CustomerID = c.CustomerID
JOIN Assigned_Ticket at ON st.TicketID   = at.TicketID
JOIN Employee e        ON at.EmployeeID  = e.EmployeeID
WHERE st.Status = 'Open';

-- Query 6: Average bill amount per plan
SELECT 
  p.PlanName, 
  ROUND(AVG(b.TotalAmount),2) AS AvgBill
FROM Plan p
JOIN Subscription s ON p.PlanID   = s.PlanID
JOIN Billing b      ON s.CustomerID = b.CustomerID
GROUP BY p.PlanName;

-- Query 7: Latest billing info per customer
SELECT 
  c.FullName, 
  b.BillingMonth, 
  b.TotalAmount, 
  b.DueDate
FROM Customer c
JOIN Billing b ON c.CustomerID = b.CustomerID
WHERE b.DueDate = (
  SELECT MAX(b2.DueDate)
  FROM Billing b2
  WHERE b2.CustomerID = c.CustomerID
);

-- Query 8: Network elements currently under maintenance
SELECT 
  ne.ElementID, 
  ne.Location, 
  ne.ElementType, 
  ne.Status
FROM Network_Element ne
WHERE ne.Status = 'Maintenance';


-- Query 9: Support tickets and assigned employees
SELECT st.TicketID, c.FullName, e.FullName AS EmployeeName, st.IssueType, st.Status
FROM Support_Ticket st
JOIN Customer c ON st.CustomerID = c.CustomerID
JOIN Assigned_Ticket at ON st.TicketID = at.TicketID
JOIN Employee e ON at.EmployeeID = e.EmployeeID;

-- Query 10: Average bill per plan
SELECT p.PlanName, AVG(b.TotalAmount) AS AverageBill
FROM Plan p
JOIN Subscription s ON p.PlanID = s.PlanID
JOIN Billing b ON s.CustomerID = b.CustomerID
GROUP BY p.PlanName;

-- Query 11: Latest billing info for each customer
SELECT c.FullName, b.Month, b.TotalAmount, b.DueDate
FROM Customer c
JOIN Billing b ON c.CustomerID = b.CustomerID
WHERE b.DueDate = (
  SELECT MAX(b2.DueDate) FROM Billing b2 WHERE b2.CustomerID = c.CustomerID
);