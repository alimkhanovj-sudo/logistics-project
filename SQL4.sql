SELECT Shipment, Customer, Delay
FROM Shipments
WHERE Delay >
(
	SELECT AVG(Delay)
	FROM Shipments 
);

SELECT Shipment, Customer, Delay
FROM Shipments
WHERE Customer IN
(
	SELECT Customer
	FROM Customers
	WHERE Country = 'USA'
);

--Покажет клиентов из таблицы Customers, которые существуют в таблице Shipments.
SELECT Customer
FROM Customers
WHERE Customer IN
(
    SELECT Customer
    FROM Shipments
);
	