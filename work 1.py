import sqlite3
import pandas as pd
connection = sqlite3.connect("logistics_project.db")
query = """
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
"""
df = pd.read_sql_query(query, connection)
df.to_excel(
    "report.xlsx",
    index = False
    )
print(df)
connection.close()

import sqlite3
import pandas as pd
connection = sqlite3.connect("logistics_project.db")
query = """
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
"""
df = pd.read_sql_query(query, connection)
df.loc[df["Average_Delay"] > 5, "Customer_Status"] = "Critical"
df.loc[(df["Average_Delay"] <= 5) & (df["Average_Delay"] > 2), "Customer_Status"] = "Warning" 
df.loc[df["Average_Delay"] <= 2, "Customer_Status"] = "Good"
df = df.sort_values(
    by = "Average_Delay",
    ascending = False
).index[0]
df.to_excel(
    "Customer_30_Day_Report.xlsx",
    index=False
)

