CREATE VIEW CriticalShipments AS
SELECT *
FROM Shipments
WHERE Delay >= 5;

SELECT *
FROM CriticalShipments

-- удалить
DROP VIEW DelayedShipments;


CREATE VIEW DelayedShipments AS
...
сохраняется в базе данных;
можно использовать завтра, через неделю, через месяц.
CTE
WITH DelayedShipments AS
(
    ...
)
существует только во время одного запроса;
после выполнения запроса исчезает.