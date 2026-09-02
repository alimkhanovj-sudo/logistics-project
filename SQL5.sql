SELECT Customer
FROM Customers c
WHERE EXISTS
(
	SELECT 1
	FROM Invoices i
	WHERE c.Customer = i.Customer
	);