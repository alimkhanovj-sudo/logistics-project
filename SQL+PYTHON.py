# import sqlite3
# import pandas as pd
# connection = sqlite3.connect("logistics_project.db")
# query = """
# SELECT ShipmentID, ShipmentNumber, CustomerID, Delay, DeliveryDate
# FROM Shipments
# WHERE Delay > 5;
# """
# df = pd.read_sql_query(query, connection)
# print(df)

# import sqlite3 
# import pandas as pd
# connection = sqlite3.connect("logistics_project.db")
# query = """
# SELECT ShipmentID, ShipmentNumber, CustomerID, Delay, DeliveryDate
# FROM Shipments;
# """
# df = pd.read_sql_query(query, connection)
# high_delay_df = df[df["Delay"] > 5]

# high_delay_df = high_delay_df.sort_values (by = "Delay",
#     ascending = True
# )
# print(high_delay_df)

# import sqlite3
# import pandas as pd
# connection = sqlite3.connect("logistics_project.db")
# query = """
# SELECT c.CustomerID, s.Delay, c.Customer, c.Country
# FROM Shipments s
# JOIN Customers c
# ON c.CustomerID = s.CustomerID;
# """
# df = pd.read_sql_query(query, connection)
# df["Average_Delay"] = df.groupby("Customer")["Delay"].transform("mean")
# df.loc[df["Average_Delay"] > 5, "Delay_Status"] = "Critical"
# df.loc[(df["Average_Delay"] > 2) & (df["Average_Delay"] <= 5), "Delay_Status"] = "Warning"
# df.loc[df["Average_Delay"] <= 2, "Delay_Status"] = "Good" 
# sorted_df = df.sort_values( 
#     by = "Average_Delay", 
#     ascending=False)
# print(sorted_df)

import sqlite3
import pandas as pd
connection = sqlite3.connect("logistics_project.db")
query = """
SELECT CustomerID, Customer, Country
FROM Customers;
"""
query1 = """
SELECT CustomerID, Delay, ShipmentID
FROM Shipments;
"""
customers_df = pd.read_sql_query(query, connection)
shipments_df = pd.read_sql_query(query1, connection)
combined_df = pd.merge(
    customers_df, shipments_df,
    on = "CustomerID"
)
combined_df["Average_Delay"] = combined_df.groupby("CustomerID")["Delay"].transform("mean")
combined_df["Total_Shipments"] = combined_df.groupby("CustomerID")["ShipmentID"].transform("count")
combined_df.loc[combined_df["Average_Delay"] > 5, "Delay_Status"] = "Critical"
combined_df.loc[(combined_df["Average_Delay"] <= 5) & (combined_df["Average_Delay"] > 2), "Delay_Status"] = "Warning"
combined_df.loc[combined_df["Average_Delay"] <= 2, "Delay_Status"] = "Good"
sorted_df = combined_df.sort_values(
    by = "Average_Delay", 
     ascending=False)
print(sorted_df) 



