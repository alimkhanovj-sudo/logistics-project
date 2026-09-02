
--1
SELECT Customer,
       COUNT(*) AS Total_Shipments,
	   SUM(Pallets) AS Total_Pallets
FROM Shipments
GROUP BY Customer
ORDER BY Total_Shipments DESC, Total_Pallets DESC;
--2
SELECT Customer,
       AVG(Delay) AS Avarage_Delay,
	   MAX(Delay) AS Max_Delay
FROM Shipments
GROUP BY Customer
HAVING AVG(Delay) > 3 
ORDER BY Avarage_Delay DESC;
--3
SELECT c.Customer, с.Country, с.Phone, s.Shipment, s.Delay, s.Pallets
FROM Customers c
JOIN Shipments s
     ON s.Customer = c.Customer
WHERE s.Delay > 2
ORDER BY s.Delay DESC;
--4
SELECT s.Shipment, s.Delay, i.Amount, i.Status, c.Country, c.Customer
FROM Shipments s
JOIN Customers c
	ON s.Customer = c.Customer
JOIN Invoices i
    ON i.Shipment = s.Shipment
WHERE s.Delay > 3
AND i.Status = 'Paid';
--5   неоплаченные отправки
SELECT s.Customer, c.Country
FROM Shipments s
JOIN Customers c
     ON c.Customer = s.Customer
WHERE NOT EXISTS
(      
       SELECT 1
	   FROM Invoices i
	   WHERE s.Shipment = i.Shipment
	   AND i.Status = 'Paid'
	   );
--5   клиенты у которых нет ни одного оплаченного инвойса
SELECT s.Customer, c.Country
FROM Customers c
WHERE NOT EXISTS(
      SELECT 1
	  FROM Shipments s
	  JOIN Invoices i
	    ON i.Shipment = s.Shipment
	  WHERE s.Customer = c.Customer
	  AND Status = 'Paid');
--6 Вывести для каждого клиента только его самую последнюю отправку:
WITH LatestDeliveryDate AS
(
  SELECT Shipment, Customer, DeliveryDate, Delay,
  ROW_NUMBER () OVER
(
  PARTITION BY Customer
  ORDER BY DeliveryDate DESC, Shipment DESC -- (Теперь даже если даты одинаковые, SQL знает, какую запись поставить первой.)
  ) AS Row_Num
FROM Shipments
)
SELECT *
FROM LatestDeliveryDate
WHERE Row_Num = 1;

Запомни правило
Если нужно:
📈 Самое большое значение → DESC
последняя дата;
самая большая задержка;
самая высокая зарплата.
📉 Самое маленькое значение → ASC
первая дата;
минимальная задержка;
самая низкая цена.
--7 Покажи клиентов, у которых суммарное количество паллет больше среднего количества паллет среди всех клиентов.
WITH CustomerTotals AS 
(
SELECT SUM(Pallets) AS Total_Pallets, Customer
FROM Shipments
GROUP BY Customer
)
SELECT Customer, Total_Pallets
FROM CustomerTotals
WHERE Total_Pallets > 
( 
   SELECT AVG(Pallets) AS Avarage_Total
   FROM CustomerTotals
   )
ORDER BY Total_Pallets DESC;
--8 Покажи только последнюю отправку каждого клиента, но только для тех клиентов, у которых было больше 2 отправок.
WITH RankedShipments AS
(
  SELECT Shipment, Customer, DeliveryDate, Delay,
  ROW_NUMBER () OVER
(
  PARTITION BY Customer
  ORDER BY DeliveryDate DESC, Shipment DESC 
  ) AS Row_Num,
  COUNT(*) OVER 
  (
   PARTITION BY Customer
   ) AS Total_Shipments
FROM Shipments
)
SELECT Shipment, Customer, DeliveryDate, Delay, Total_Shipments
FROM RankedShipments
WHERE Total_Shipments > 2
AND Row_Num = 1
ORDER BY Total_Shipments DESC;

--9

WITH Limit_Table AS
( 
  SELECT Shipment,
	     Customer, Delay,
		 DeliveryDate,
  ROW_NUMBER() OVER
  ( 
     PARTITION BY Customer
	 ORDER BY DeliveryDate DESC, Shipment DESC 
	 ) AS Row_Num,
  COUNT(*) OVER 
  (
    PARTITION BY Customer
	) AS Total_Shipments,
  AVG(Delay) OVER
  (
   PARTITION BY Customer
   ) AS Average_Delay
FROM Shipments
)
SELECT Shipment, Customer, DeliveryDate, Delay, Total_Shipments, Average_Delay
FROM Limit_Table
WHERE Average_Delay > 3
AND Row_Num = 1
ORDER BY Average_Delay DESC;

--10

WITH Total_Table AS
( 
  SELECT *
  FROM Customers с
  JOIN Shipments s
  ON s.Customer = c.Customer
  ),
 Ranked_Table AS
 (
    SELECT *,
    ROW_NUMBER() OVER
  ( 
     PARTITION BY Customer
	 ORDER BY DeliveryDate DESC, Shipment DESC 
	 ) AS Row_Num,
  COUNT(*) OVER 
  (
    PARTITION BY Customer
	) AS Total_Shipments,
  AVG(Delay) OVER
  (
   PARTITION BY Customer
   ) AS Average_Delay
FROM Total_Table
)
SELECT Shipment, Country, Customer, DeliveryDate, Delay, Total_Shipments, Average_Delay
FROM Ranked_Table
WHERE Average_Delay > 2
AND Total_Shipments >= 2
AND Row_Num = 1
ORDER BY Average_Delay DESC, DeliveryDate DESC;
 
--11

WITH All_Tables AS (
SELECT Customer,
	Country,
	Shipment,
	DeliveryDate,
	Delay,
	Amount
FROM Shipments s
JOIN Customers c
  ON s.Customer = c.Customer
JOIN Invoices i
  ON s.Shipment = i.Shipment
)
AS Ranked_Table 
(
SELECT *
ROW_NUMBER() OVER 
(
 PARTITION BY Customer
 ORDER BY DeliveryDate DESC, Shipment DESC
) AS Row_Num
FROM All_Tables 
)
SELECT Customer,
       Country,
       Shipment,
       DeliveryDate,
       Delay,
       Amount
FROM Ranked_Table
WHERE Row_Num = 1
AND Status = 'Paid';

--12

SELECT c.Customer, c.Country, SUM(i.Amount) AS Total_Amount, COUNT(DISTINCT s.Shipment) AS Total_Shipment
FROM Shipments s
JOIN Customers c
  ON c.Customer = s.Customer
JOIN Invoices i
  ON i.Shipment = s.Shipment
WHERE i.Status = 'Paid'
GROUP BY c.Customer, c.Country
HAVING Total_Amount > 5000
ORDER BY Total_Shipment DESC;

--13

WITH Total_Table AS
( 
SELECT *
FROM Shipments s
JOIN Customers c
    ON c.Customer = s.Customer
),
Delay_Table AS
(
SELECT Customer,
		Country,
		Shipment,
		DeliveryDate,
		Delay AS Last_Delay,
AVG(Delay) OVER 
( 
  PARTITION BY Customer
) AS Average_Delay,
ROW_NUMBER() OVER
(  
  PARTITION BY Customer
  ORDER BY DeliveryDate DESC, Shipment DESC
 ) AS Row_Num  
FROM Total_Table
)
SELECT Customer,
		Country,
		Shipment,
		DeliveryDate,
		Last_Delay,
		Average_Delay
FROM Delay_Table
WHERE Row_Num = 1
AND Last_Delay > Average_Delay;

--14

WITH Shipment_Stats AS
(
  SELECT Customer
  COUNT(*) AS Total_Shipments,
  SUM(Pallet) AS Total_Pallets,
  AVG(Delay) AS Average_Delay
FROM Shipments
GROUP BY Customer
),
Latest_Shipment AS (
SELECT Customer, Shipment AS Last_Shipment, DeliveryDate AS Last_DeliveryDate, Delay AS Last_Delay,	
 ROW_NUMBER() OVER (
	 PARTITION BY Customer
	 ORDER BY Last_DeliveryDate DESC, Last_Shipment DESC
	 ) AS Row_Num,
FROM Shipments
),
Paid_Invoices AS 
( 
SELECT s.Customer, SUM(i.Amount) AS Paid_Amount
FROM Shipments s
JOIN Invoices i
ON i.Shipment = s.Shipment
WHERE Status = 'Paid'
GROUP BY Customer
)
SELECT  c.Customer,
		c.Country,
		ss.Total_Shipments,
		ss.Total_Pallets,
		ss.Average_Delay,
		ls.Last_Shipment,
		ls.Last_DeliveryDate,
		ls.Last_Delay,
		COALESCE(pi.Paid_Amount, 0) AS Paid_Amount
FROM Customers c
JOIN Shipment_Stats ss
    ON ss.Customer = c.Customer
JOIN Latest_Shipment ls
    ON ls.Customer = c.Customer
   AND ls.Row_Num = 1
LEFT JOIN Paid_Invoices pi
    ON pi.Customer = c.Customer
WHERE ss.Total_Shipments >= 2
ORDER BY Paid_Amount DESC;

--15
 
WITH Shipment_Stats AS
(
SELECT Customer,
  COUNT(*) AS Total_Shipments,
  AVG(Delay) AS Average_Delay
FROM Shipments
GROUP BY Customer
),
Latest_Shipment AS 
(
  SELECT s.Customer,
        s.Shipment AS Last_Shipment,
        s.DeliveryDate AS Last_DeliveryDate,
        s.Delay AS Last_Delay,
        i.Status AS Last_Status,
  ROW_NUMBER() OVER(
  PARTITION BY s.Customer
  ORDER BY s.DeliveryDate DESC, s.Shipment DESC ) AS Row_Num  
 FROM Shipments s
 LEFT JOIN Invoices i
 ON i.Shipment = s.Shipment 
  ),
  Paid_Table AS 
  (
  SELECT s.Customer, Status, SUM(Amount) AS Paid_Amount
  FROM Shipments s
    JOIN Invoices i
        ON i.Shipment = s.Shipment
  WHERE Status = 'Paid'
  GROUP BY Customer
  HAVING SUM(Amount) > 5000 
  )
SELECT c.Customer,
    c.Country,
    ls.Last_Shipment,
    ls.Last_DeliveryDate,
    ls.Last_Delay,
    pt.Paid_Amount,
    ss.Total_Shipments,
    ss.Average_Delay
FROM Customers c
JOIN Shipment_Stats ss
    ON ss.Customer = c.Customer
JOIN Latest_Shipment ls
    ON ls.Customer = c.Customer
   AND ls.Row_Num = 1
JOIN Paid_Table pt
    ON pt.Customer = c.Customer
WHERE ls.Last_Status <> 'Paid'
   OR ls.Last_Status IS NULL;
