
--"Из всех строк оставь только те, где клиент не нашёлся."  Найди отправки без клиента.
SELECT *
FROM Shipments s
LEFT JOIN Customers c
ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

--"Хочу понять, кто приносит компании больше всего денег."

WITH A_Table AS(
SELECT COUNT(*) AS Total_Shipment, SUM(Pallets) AS Total_Pallets, CustomerID
FROM Shipments
GROUP BY CustomerID
),
B_Table AS (
SELECT SUM(Amount) AS Paid_Amount
FROM Shipments s
JOIN Invoices i
        ON i.ShipmentID = s.ShipmentID
WHERE Status = 'Paid'
GROUP BY CustomerID
)
SELECT 	 c.CustomerName AS Customer,
    c.Country,
    a.Total_Shipments,
    a.Total_Pallets,
    COALESCE(b.Paid_Amount, 0) AS Paid_Amount
FROM A_Table a
JOIN Customers c
    ON c.CustomerID = a.CustomerID
LEFT JOIN B_Table b
    ON b.CustomerID = a.CustomerID
ORDER BY Paid_Amount DESC
);

--«Покажи клиентов, у которых средняя задержка больше 3 дней, при этом у них есть хотя бы 2 отправки.»

SELECT AVG(s.Delay) AS Average_Delay, COUNT(s.Shipment) AS Total_Shipments, c.Country, c.Customer
FROM Shipments s
JOIN Customers c
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID,
         c.Customer,
         c.Country
HAVING Total_Shipments >= 2
AND Average_Delay > 3
ORDER BY Average_Delay DESC, Total_Shipments DESC;

--«Покажи последнюю отправку каждого клиента и сравни её задержку со средней задержкой этого клиента.»

WITH Ranked_Table AS (
SELECT Delay AS Last_Delay, ShipmentNumber AS Last_Shipment, DeliveryDate AS Last_DeliveryDate, CustomerID
SELECT AVG(Delay) OVER (
PARTITION BY CustomerID ) AS Average_Delay
ROW_NUMBER() OVER (
PARTITION BY CustomerID 
ORDER BY Last_DeliveryDate DESC, Last_Shipment DESC ) AS Row_Num
FROM Shipments )
SELECT Last_Delay, Last_Shipment, Last_DeliveryDate, c.Customer, c.Country, Average_Delay
FROM Customers c
JOIN Ranked_Table rt
ON c.CustomerID = rt.CustomerID
WHERE Row_Num = 1;

--Показать каждого клиента и определить, насколько у него проблемные доставки.

SELECT c.Customer,
c.Country,
COUNT(s.ShipmentNumber) AS Total_Shipments,
AVG(s.Delay) AS Average_Delay,
CASE 
   WHEN AVG(s.Delay) <= 2
   THEN 'Good'
   WHEN AVG(s.Delay) > 2 AND AVG(s.Delay) <= 5
   THEN 'Warning'
   ELSE 'Critical'
END AS Status
FROM Shipments s
JOIN Customers c
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.Customer, c.Country;

--«Покажи только клиентов, у которых минимум 2 отправки и средняя задержка больше 2 дней. Также классифицируй их по уровню проблемы.»

SELECT c.Customer,
c.Country,
COUNT(s.ShipmentNumber) AS Total_Shipments,
AVG(s.Delay) AS Average_Delay,
CASE 
   WHEN AVG(s.Delay) <= 3
   THEN 'Warning'
   ELSE 'Critical'
END AS Delay_Status
FROM Shipments s
JOIN Customers c
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.Customer, c.Country
HAVING Total_Shipments >= 2
AND Average_Delay > 2;

--

SELECT c.Customer, c.Country, COUNT(i.InvoiceID) AS Total_Invoices, SUM(
         CASE
		    WHEN i.Status = 'Paid'
			THEN 1
			ELSE 0
		END) AS Paid_Invoices,
		SUM (
		 CASE
		    WHEN i.Status = 'Pending'
			THEN 1
			ELSE 0
		END) AS Pending_Invoices,  
		SUM (
		 CASE 
		    WHEN i.Status = 'Paid'
			THEN i.Amount
			ELSE 0
			END ) AS Paid_Amount,
		SUM (
		 CASE 
		    WHEN i.Status = 'Paid'
			THEN 1
			ELSE 0
			END ) * 100.0 / COUNT(i.InvoiceID) AS Paid_Percentage	
FROM Shipments s
JOIN Customers c
ON c.CustomerID = s.CustomerID
JOIN Invoices i
ON i.ShipmentID = s.ShipmentID
GROUP BY c.CustomerID,
    c.Customer,
    c.Country;
	
--

WITH Invoice_Table AS (
SELECT s.CustomerID, COUNT(i.InvoiceID) AS Total_Invoices, SUM(
     CASE
	  WHEN i.Status = 'Paid'
	  THEN 1
	  ELSE 0
END ) AS Paid_Invoices,
SUM(
     CASE
	  WHEN i.Status = 'Pending'
	  THEN 1
	  ELSE 0
END ) AS Pending_Invoices,
SUM(
     CASE
	  WHEN i.Status = 'Paid'
	  THEN i.Amount
	  ELSE 0
END ) AS Paid_Amount
FROM Invoices i
JOIN Shipments s
    ON i.ShipmentID = s.ShipmentID
GROUP BY
    c.CustomerID
)
SELECT c.CustomerID, c.Country, it.Total_Invoices,
		it.Paid_Invoices,
		it.Pending_Invoices,
		it.Paid_Amount,
		 it.Paid_Invoices * 100.0 / it.Total_Invoices AS Paid_Percentage
FROM Invoice_Table it
JOIN Customers c
    ON c.CustomerID = it.CustomerID;

--«Покажи всех клиентов, даже если у них вообще нет инвойсов. Для клиентов без инвойсов покажи 0.»

WITH Invoices_Table AS(
SELECT COUNT(i.InvoiceID) AS Total_Invoices, CustomerID,
SUM(
     CASE
	  WHEN i.Status = 'Paid'
	  THEN i.Amount
	  ELSE 0
END ) AS Paid_Amount
FROM Invoices i
JOIN Shipments s
ON i.ShipmentID = s.ShipmentID
GROUP BY CustomerID
)
SELECT  COALESCE(it.Total_Invoices, 0) AS Total_Invoices,
COALESCE(it.Paid_Amount, 0) AS Paid_Amount, c.Country, c.CustomerID,
CASE 
    WHEN COALESCE(it.Total_Invoices, 0) = 0
	THEN 'No Invoices'
	WHEN COALESCE(it.Paid_Amount, 0) > 5000
	THEN 'High Value'
	ELSE 'Regular'
END AS Customer_Status
FROM Customers c
LEFT JOIN Invoices_Table it
ON c.CustomerID = it.CustomerID;

--найти клиентов, у которых есть отправки, но нет оплаченных инвойсов.
   
WITH Shipment_Stats AS (
SELECT COUNT(ShipmentID) AS Total_Shipments, CustomerID
FROM Shipments
GROUP BY CustomerID
),
Invoices_Table AS (
SELECT CustomerID,
   SUM ( CASE 
      WHEN i.Status = 'Paid'
	  THEN i.Amount
	  ELSE 0
END ) AS Paid_Amount
FROM Invoices i
JOIN Shipments s
ON i.ShipmentID = s.ShipmentID
GROUP BY CustomerID
)
SELECT c.Customer,
c.Country,
ss.Total_Shipments,
COALESCE(it.Paid_Amount, 0) AS Paid_Amount,
 CASE 
     WHEN COALESCE(it.Paid_Amount, 0) = 0
	 THEN 'No Payment'
	 ELSE 'Paid'
 END AS Customer_Status
FROM Shipment_Stats ss
JOIN Customers c
ON c.CustomerID = ss.CustomerID
LEFT JOIN Invoices_Table it
ON it.CustomerID = ss.CustomerID
WHERE ss.Total_Shipments >= 1
AND COALESCE(it.Paid_Amount, 0) = 0;

--Найти клиентов, у которых есть хотя бы одна отправка с задержкой больше 5 дней, 
но нет ни одной отправки с задержкой больше 10 дней.

SELECT c.Customer, c.Country
FROM Customers c
WHERE EXISTS
  (
    SELECT 1
	FROM Shipments s
	WHERE s.Customer = c.Customer
	AND s.Delay > 5
 )
 AND NOT EXISTS 
   (
    SELECT 1
	FROM Shipments s
	JOIN Invoices i
	ON i.ShipmentID = s.ShipmentID
	WHERE s.CustomerID = c.CustomerID
	AND i.Status = 'Paid'
	);
	
--Найди все отправки, у которых задержка выше средней задержки этого же клиента.

SELECT s.ShipmentNumber,
s.CustomerID,
s.Delay,
(
  SELECT AVG(s2.Delay)
  FROM Shipments s2
  WHERE s2.CustomerID =  s.CustomerID
  ) AS Average_Delay
FROM Shipments s
WHERE s.Delay >
(
  SELECT AVG(s2.Delay)
  FROM Shipments s2
  WHERE s2.CustomerID = s.CustomerID
  );
 
 --Найди все отправки, задержка которых выше средней задержки по ВСЕМ отправкам, а не по конкретному клиенту.
 
SELECT s.ShipmentNumber,
s.CustomerID,
s.Delay,
 (
  SELECT AVG(s2.Delay)
  FROM Shipments s2 
  ) AS Overall_Average_Delay
 FROM Shipments s
 WHERE Delay >
 (
 SELECT AVG(s2.Delay)
 FROM Shipments s2
 );
 
 --Найди клиентов, у которых количество отправок выше общего среднего количества отправок.
 
SELECT c.Country, c.CustomerID, COUNT(s.ShipmentNumber) AS Total_Shipments,
(
SELECT AVG(Total_Shipments)
FROM 
(
SELECT COUNT(*) AS Total_Shipments
FROM Shipments 
GROUP BY CustomerID
) AS Shipment_Counts
) AS Average_Shipments_Per_Customer
FROM Shipments s
JOIN Customers c
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.Customer, c.Country
HAVING COUNT(s.ShipmentNumber) > 
(
SELECT AVG(Total_Shipments)
        FROM
        (
            SELECT COUNT(*) AS Total_Shipments
            FROM Shipments
            GROUP BY CustomerID
        ) AS Shipment_Counts
);

==2 вариант

WITH Shipment_Counts AS (
    SELECT
        CustomerID,
        COUNT(*) AS Total_Shipments
    FROM Shipments
    GROUP BY CustomerID
)

SELECT
    c.Customer,
    c.Country,
    sc.Total_Shipments,
    (
        SELECT AVG(Total_Shipments)
        FROM Shipment_Counts
    ) AS Average_Shipments_Per_Customer
FROM Shipment_Counts sc
JOIN Customers c
    ON c.CustomerID = sc.CustomerID
WHERE sc.Total_Shipments >
(
    SELECT AVG(Total_Shipments)
    FROM Shipment_Counts
);
 
-- Оконный функции

SELECT ShipmentNumber,
CustomerID, Delay,
AVG(Delay) OVER (
    PARTITION BY CustomerID
) AS Average_Delay,
Delay - AVG(Delay) OVER (
    PARTITION BY CustomerID
) AS Delay_Difference
FROM Shipments;

--

SELECT InvoiceID,
ShipmentID,
Amount, SUM(Amount) OVER () AS Total_Invoice_Amount, 
Amount * 100.0 / SUM(Amount) OVER () AS Invoice_Percentage
FROM Invoices;

-- 

SELECT InvoiceID,
ShipmentID,
Amount,
InvoiceDate,
SUM(Amount) OVER (
ORDER BY InvoiceDate, InvoiceID
) Running_Total
FROM Invoices
ORDER BY InvoiceDate, InvoiceID;

--Нужно показать каждую отправку и определить её место по задержке среди отправок этого же клиента.

SELECT ShipmentNumber,
CustomerID,
Delay,
RANK() OVER (
PARTITION BY CustomerID
ORDER BY Delay DESC )
Delay_Rank
FROM Shipments;

--разница между DENSE_RANK, RANK, ROW_NUMBER

SELECT ShipmentNumber,
CustomerID,
Delay,
RANK () OVER (
PARTITION BY CustomerID
ORDER BY Delay DESC ),
DENSE_RANK () OVER (
PARTITION BY CustomerID
ORDER BY Delay DESC ),
ROW_NUMBER () OVER (
PARTITION BY CustomerID
ORDER BY Delay DESC )
FROM Shipments;

--Показать только последнюю отправку каждого клиента.

WITH Ranked_Shipment AS
(
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay, 
ROW_NUMBER() OVER(
PARTITION BY CustomerID
ORDER BY DeliveryDate DESC ) AS Row_Num 
FROM Shipments
)
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay
FROM Ranked_Shipment
WHERE Row_Num = 1;

--Найди для каждого клиента его отправку с самой большой задержкой.

WITH Ranked_Shipment AS (
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
ROW_NUMBER() OVER (
PARTITION BY CustomerID
ORDER BY Delay DESC ) AS Row_Num
FROM Shipments
)
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay
FROM Ranked_Shipment
WHERE Row_Num <= 2;

-- LAG () Она берёт значение предыдущей строки.

SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
LAG (Delay) OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate ASC
) AS Previous_Delay,
Delay - LAG (Delay) OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate ASC) AS Delay_Difference
FROM Shipments;

-- LEAD() берёт значение следующей строки.

SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
LEAD (Delay) OVER (
PARTITION BY CustomerID 
ORDER BY DeliveryDate ASC 
) AS Next_Delay,
LEAD (Delay) OVER (
PARTITION BY CustomerID 
ORDER BY DeliveryDate ASC 
) - Delay AS Delay_Difference
FROM Shipments;

--
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
SUM(Delay) OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate ASC 
) AS Running_Total_Delay
FROM Shipments;

--первая и последняя отправка клиента

WITH Ranked_Shipment AS (
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
ROW_NUMBER () OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate DESC ) AS Row_Num_Last,
ROW_NUMBER () OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate ASC ) AS Row_Num_First
FROM Shipments
)
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
CASE 
    WHEN Row_Num_First = 1
	THEN 'FIRST'
	WHEN Row_Num_Last = 1
	THEN 'LAST'
END AS Shipment_Type
FROM Ranked_Shipment;

--найти отправки с задержкой выше средней задержки клиента

WITH Average_Delay_T AS 
(
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
AVG(Delay) OVER(
PARTITION BY CustomerID
) AS Average_Delay
FROM Shipments
)
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
Average_Delay
FROM Average_Delay_T
WHERE Delay > Average_Delay;

--определить тренд задержек клиента

SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
CASE  
    WHEN Delay > Previous_Delay
	THEN 'Increasing'
	WHEN Delay < Previous_Delay
	THEN 'Decreasing'
	WHEN Delay = Previous_Delay
	THEN 'No Change'
	WHEN Delay IS NULL
	THEN 'First_Shipment'
END AS Delay_Trend
FROM
(
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
LAG(Delay) OVER (
PARTITION BY CustomerID
ORDER BY DeliveryDate
) AS Previous_Delay
FROM Shipments ) AS Shipment_Data
ORDER BY CustomerID, DeliveryDate ASC;

--определить статус задержки относительно предыдущей отправки

SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
CASE 
  WHEN Delay_Change IS NULL
  THEN 'First_Shipment'
  WHEN Delay_Change > 0 
  THEN 'Worse'
  WHEN Delay_Change < 0 
  THEN 'Better'
  WHEN Delay_Change = 0
  THEN 'No Change'
END AS Status
FROM(
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
Delay - Previous_Delay AS Delay_Change
FROM(
SELECT CustomerID,
ShipmentNumber,
DeliveryDate,
Delay,
LAG(Delay) OVER(
PARTITION BY CustomerID
ORDER BY DeliveryDate ASC
) AS Previous_Delay
FROM Shipments 
) AS Step1
) AS Step2
ORDER BY CustomerID, DeliveryDate ASC;

--

WITH Piad_Amount AS (
SELECT Amount, InvoiceDate, Status, InvoiceID, ShipmentNumber
FROM Invoices
WHERE Status = 'Paid'
),
Max_Amount AS (
SELECT CustomerID,
Customer,
InvoiceID,
Amount,
InvoiceDate,
ROW_NUMBER () OVER (
PARTITION BY CustomerID
ORDER BY Amount DESC
) AS Row_Num
FROM Shipments s
JOIN Customers c
ON s.CustomerID = c.CustomerID
JOIN Piad_Amount pa
ON pa.ShipmentNumber = s.ShipmentNumber
)
SELECT CustomerID,
Customer,
InvoiceID,
Amount,
InvoiceDate
FROM Max_Amount
WHERE Row_Num = 1;

--

WITH Total_Shipments_Table AS (
SELECT CustomerID,
COUNT(*) AS Total_Shipments,
AVG(Delay) AS Average_Delay
FROM Shipments
GROUP BY CustomerID
),
Total_Invoices_Table AS (
SELECT CustomerID, COUNT(*) AS Total_Invoices,
SUM (
       CASE
	    WHEN Status = 'Paid'
		THEN Amount
		ELSE 0
END) AS Paid_Amount
FROM Invoices i
JOIN Shipments s
ON i.ShipmentID = s.ShipmentID
GROUP BY CustomerID
)
SELECT CustomerID, Customer,
Country, COALESCE(tst.Total_Shipments, 0) AS Total_Shipments,
COALESCE(tst.Average_Delay, 0) AS Average_Delay,
COALESCE(tit.Total_Invoices, 0) AS Total_Invoices,
COALESCE(tit.Paid_Amount, 0) AS Paid_Amount,
CASE 
  WHEN COALESCE(tit.Total_Invoices, 0) = 0
  THEN 'No Invoices'
  WHEN Paid_Amount > 5000
  THEN 'High Value'
  WHEN Average_Delay > 5
  THEN 'High Delay'
ELSE 'Regular'
END AS Customer_Status
FROM Customers c
LEFT JOIN Total_Shipments_Table tst
ON tst.CustomerID = c.CustomerID
LEFT JOIN Total_Invoices_Table tit
ON tit.CustomerID = c.CustomerID;

-- «Покажи клиентов, у которых средняя задержка выше средней задержки всех клиентов».

SELECT
    CustomerID,
    AVG(Delay) AS Average_Delay
FROM Shipments
GROUP BY CustomerID
HAVING AVG(Delay) >
(
    SELECT AVG(Delay)
    FROM Shipments
);

-- «Каждое утро мне нужен список клиентов, у которых за последние 30 дней было хотя бы 3 отправки 
и средняя задержка больше 5 дней. Нужны Customer, Country, количество отправок и средняя задержка. 
Результат хочу получить в Excel.»

SELECT
    c.Customer,
    c.Country,
    COUNT(s.ShipmentID) AS Total_Shipments,
    AVG(s.Delay) AS Average_Delay
FROM Shipments s
JOIN Customers c
    ON c.CustomerID = s.CustomerID
WHERE s.DeliveryDate >= date('now', '-30 days')
GROUP BY
    c.CustomerID,
    c.Customer,
    c.Country
HAVING COUNT(s.ShipmentID) >= 3
   AND AVG(s.Delay) > 5
ORDER BY Average_Delay DESC;

--

SELECT
    c.Customer,
    c.Country,
    COUNT(s.ShipmentID) AS Total_Shipments,
    AVG(s.Delay) AS Average_Delay
FROM Shipments s
JOIN Customers c
    ON c.CustomerID = s.CustomerID
WHERE date(s.DeliveryDate) = date('now', '-1 day')
GROUP BY
    c.CustomerID,
    c.Customer,
    c.Country
HAVING COUNT(s.ShipmentID) >= 2
   AND AVG(s.Delay) > 5
ORDER BY Average_Delay DESC;

--

WITH Average AS(
SELECT AVG(Delay) AS Average_Delay, c.Customer, CustomerID
FROM Shipments s
JOIN Customers c
ON c.CustomerID = s.CustomerID
GROUP BY CustomerID, Customer
HAVING AVG(Delay) > 5
),
Unpaid_Invoices AS(
SELECT Count(*) AS Invoice, CustomerID
FROM Invoices i
JOIN Shipments s
ON i.ShipmentID = s.ShipmentID
GROUP BY CustomerID, Customer
WHERE i.Status != 'Paid'
)
SELECT a.Customer, ui.Invoice, a.Average_Delay
FROM Average a
JOIN Unpaid_Invoices ui
ON a.ShipmentID = ui.ShipmentID;

--

SELECT Customer, Country, SUM(i.Amount) AS Total_Paid
FROM Invoices i 
JOIN Shipments s
ON s.ShipmentID = i.ShipmentID
JOIN Customers c
ON s.CustomerID = c.CustomerID
WHERE Status = 'Paid'
GROUP BY c.CustomerID, c.Customer, c.Country
ORDER BY SUM(i.Amount) DESC
LIMIT 5;

--

SELECT ShipmentNumber, CustomerID, InvoiceID, Amount, Status
FROM Shipments s 
JOIN Invoices i
ON s.ShipmentNumber = i.ShipmentNumber
WHERE s.DeliveryDate IS NULL;

--

SELECT CustomerID, Customer, Country
FROM Customers c
WHERE NOT EXISTS(
SELECT 1
FROM Shipments s
JOIN Invoices i
ON i.ShipmentID = s.ShipmentID
WHERE c.CusotmerID = s.CustomerID
AND Status = 'Paid'
);

--

--Каждый день нужно получать список клиентов, у которых за последние 
30 дней не было ни одной отправки с задержкой больше 5 дней. Покажи CustomerID, Customer, Country. 
Потом автоматически сохрани результат в Excel

SELECT
    c.Customer,
    c.Country,
FROM Customers c
WHERE NOT EXISTS (
SELECT 1
FROM Shipments s
WHERE s.CustomerID = s.CustomerID
AND s.DeliveryDate >= date('now', '-30 days')
AND Delay > 5 
);

--

SELECT CustomerID,
Customer,
Country
FROM Shipments s
JOIN Customers c
ON s.CustomerID = c.CustomersID 
WHERE NOT EXISTS (
SELECT 1
FROM Invoices i
WHERE i.ShipmentID = s.ShipmentID
AND Status = 'Pending')
AND EXISTS (
SELECT 1
FROM Invoices i
WHERE i.ShipmentID = s.ShipmentID
AND Status = 'Paid');
