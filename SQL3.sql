ALTER TABLE Shipments
ADD COLUMN Status TEXT;

UPDATE Shipments
SET Status =
CASE
    WHEN Delay > 5 THEN 'Critical'
    WHEN Delay >= 3 THEN 'Warning'
    ELSE 'Normal'
END;

SELECT Shipment, Customer, Delay,
	CASE
	WHEN Delay > 5 THEN 'Critical'
	WHEN Delay >= 3 THEN 'Warning'
	ELSE 'Normal'
END AS Status
FROM Shipments;

SELECT Shipment, Pallets,
	CASE
	WHEN Pallets > 20 THEN 'High'
	WHEN Pallets >= 10 THEN 'Medium'
	ELSE 'Low'
END AS Priority
FROM Shipments;

SELECT Shipment, Pallets, Customer, Delay,
	CASE
	WHEN Pallets > 5 THEN 'High'
	WHEN Pallets >= 3 THEN 'Medium'
	ELSE 'Low'
END AS Priority,
	CASE
	WHEN Delay > 5 THEN 'Critical'
	WHEN Delay >= 3 THEN 'Warning'
	ELSE 'Normal'
END AS Status
FROM Shipments;

SELECT Shipment, UPPER(Customer) AS Customer, Delay,
	CASE
	WHEN Delay > 5 THEN 'Critical'
	WHEN Delay >= 3 THEN 'Warning'
	ELSE 'Normal'
END AS Status 
FROM Shipments
ORDER BY Status, Delay DESC;