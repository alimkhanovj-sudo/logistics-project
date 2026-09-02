SELECT AVG(Pallets) AS Avarage_Pallets 
FROM Shipments; 

SELECT MIN(Delay) AS Minimal_Delay 
FROM Shipments;

SELECT MAX(Pallets) AS Maximum_Pallets
FROM Shipments; 

SELECT Customer, AVG(Delay) AS Avarage_Delay 
FROM Shipments 
GROUP BY Customer; 

SELECT Customer, AVG(Pallets) AS Avarage_Pallets, MIN(Pallets) AS Minimum_Pallets, MAX(Pallets) AS Maximum_Pallets 
FROM Shipments 
GROUP BY Customer;