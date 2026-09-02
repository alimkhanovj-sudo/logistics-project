# from openpyxl import Workbook

# workbook = Workbook()

# sheet = workbook.active

# sheet["A1"] = "Shipment"
# sheet["B1"] = "Customer"
# sheet["C1"] = "Delay"
    
# sheet["A2"] = "SHP-1001"
# sheet["B2"] = "Xiaomi"
# sheet["C2"] = 8

# workbook.save("shipments2.xlsx") 

# import pandas as pd
# df1 = pd.read_excel("shipments.xlsx")
# df2 = pd.read_excel("shipments2.xlsx")
# all_shipments = pd.concat(
#     [df1,df2],
#     ignore_index=True
#     )
# print(all_shipments)

import pandas as pd
df_shipments = pd.DataFrame({
    "CustomerID": [1, 2, 3],
    "Delay": [2, 7, 4]
})

df_customers = pd.DataFrame({
    "CustomerID": [1, 2, 3],
    "Customer": ["Amazon", "IKEA", "DHL"]
})
all_shipments = pd.merge(
    df_shipments, df_customers,
    on = "CustomerID"
)
print(all_shipments)