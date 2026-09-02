import pandas as pd
df = pd.read_excel("all_shipments.xlsx")
# summary = df.groupby("Customer")["Pallets"].sum()
# print(summary)

#summary = df.groupby("Customer")["Delay"].mean()
#Средняя задержка каждого клиента.
#summary = df.groupby("Customer")["Shipment"].count()
#Количество поставок каждого клиента.
#summary = df.groupby("Customer")["Pallets"].max()
#Самая большая поставка каждого клиента.
# summary = df.groupby("Customer").size()
# Посчитать количество строк клиента.

# summary = df.groupby("Customer")["Delay"].max()
# max = df.groupby("Customer")["Delay"].mean()
# print(summary)
# print(max)
# =
# df.groupby("Customer")["Delay"].agg(["mean", "max"])