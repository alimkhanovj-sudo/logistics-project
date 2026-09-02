CREATE TABLE Drivers 
(
 DriverID INTEGER PRIMARY KEY,
 DriverName TEXT,
 Phone TEXT
 );
 
 INSERT INTO Drivers 
 (DriverID, DriverName, Phone)
 VALUES
 (1, 'John', 123456789),
 (2, 'Mike', NULL),
 (3, 'Alex', 987654321);
 
SELECT  DriverName,
		COALESCE (Phone, 'No Phone') AS Phone
FROM Drivers;
