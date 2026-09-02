WITH Expected AS (
    SELECT
        CustomerID,
        SUM(Expected_Amount) AS Expected_Total
    FROM Shipments
    GROUP BY CustomerID
),
Paid AS (
    SELECT
        s.CustomerID,
        SUM(i.Amount) AS Paid_Total
    FROM Invoices i
    JOIN Shipments s
        ON s.ShipmentID = i.ShipmentID
    WHERE i.Status = 'Paid'
    GROUP BY s.CustomerID
)
SELECT
    c.Customer,
    c.Country,
    e.Expected_Total,
    p.Paid_Total,
    e.Expected_Total - p.Paid_Total AS Difference
FROM Customers c
JOIN Expected e
    ON e.CustomerID = c.CustomerID
JOIN Paid p
    ON p.CustomerID = c.CustomerID
WHERE e.Expected_Total > p.Paid_Total;

-- Подзапрос в SELECT возвращает одно значение: И это значение становится дополнительным столбцом. даёт одно число:

SELECT
    Customer,
    (SELECT AVG(Delay) FROM Shipments) AS Company_Average
FROM Customers;

-- Подзапрос в FROM Сначала посчитай среднюю задержку по каждому клиенту, а потом работай с этой готовой таблицей.

SELECT *
FROM (
    SELECT
        CustomerID,
        AVG(Delay) AS Average_Delay
    FROM Shipments
    GROUP BY CustomerID
) AS Customer_Average;

-- Подзапрос в WHERE Найди клиентов, у которых средняя задержка выше средней задержки всей компании. даёт одно число:

SELECT CustomerID
FROM Shipments
GROUP BY CustomerID
HAVING AVG(Delay) > (
    SELECT AVG(Delay)
    FROM Shipments
);

-- Exercise — найти самую позднюю доставку каждого клиента

SELECT CustomerID, ShipmentNumber, DeliveryDate, Delay
FROM 
(
SELECT CustomerID,
        ShipmentNumber,
        DeliveryDate,
        Delay,ROW_NUMBER() OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate DESC
) AS Row_Num
FROM Shipments
) AS X
WHERE Row_Num = 1;

--«Найди всех клиентов, у которых вообще нет отправок. Покажи CustomerID, Customer, Country.»

SELECT CustomerID, Customer, Country
FROM Customers c
LEFT JOIN Shipments s
ON c.CustomerID = s.CustomerID
WHERE ShipmentID IS NULL;

--Покажи CustomerID, Customer и количество всех invoices каждого клиента.

SELECT CustomerID, Customer, 
COUNT(DISTINCT InvoiceID) AS Total_Invoices 
FROM Customers c
JOIN Shipments s
ON c.CustomerID = s.CustomerID
JOIN Invoices i
ON i.ShipmentID = s.ShipmentID
GROUP BY
    c.CustomerID,
    c.Customer;
	
--Покажи всех клиентов и количество invoices у каждого клиента. Даже если у клиента вообще нет ни одного invoice

SELECT CustomerID, Customer, COUNT(DISTINCT InvoiceID) AS Total_Invoices
FROM Customers c
LEFT JOIN Shipments s
ON c.CustomerID = s.CustomerID
LEFT JOIN Invoices i
ON i.ShipmentID = s.ShipmentID
GROUP BY
    c.CustomerID,
    c.Customer;

 

 