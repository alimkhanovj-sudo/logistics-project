SELECT Customer
FROM Shipments
WHERE Customer LIKE 'I%';

SELECT Customer
FROM Shipments
WHERE Customer LIKE '%m%';

SELECT Customer
FROM Shipments
WHERE Customer LIKE 'A%'
ORDER BY Customer;

SELECT Customer
FROM Shipments
WHERE Customer LIKE 'A%'
OR Customer LIKE 'I%'
ORDER BY Customer;


