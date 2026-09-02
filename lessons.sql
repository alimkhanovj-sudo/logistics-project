-- удалени
DELETE FROM Shipments
WHERE Shipment = 'SH006';

INSERT INTO shipments
(Shipment, Customer, Delay, Pallets)
VALUES
('SH006', 'Nike', 1, 22);


-- Сортировка по задержке
SELECT Shipment, Delay
FROM shipments
ORDER BY Delay DESC;

-- Количество перевозок IKEA
SELECT Customer, COUNT(*)
FROM shipments
GROUP BY Customer;
	

-- Общее количество паллет
SELECT SUM(Pallets)
FROM shipments;

--новые данные
SELECT * 
FROM shipments 
WHERE Shipment = 'SH002';
OR Customer = 'Amazon', Delay > 4;

UPDATE shipments
SET Customer = 'ZARA', Delay = 6
WHERE Shipment = 'SH002';

--только первый 3 задержки
SELECT *
FROM shipments
ORDER BY Delay DESC
LIMIT 3;