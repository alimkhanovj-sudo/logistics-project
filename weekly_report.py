import os
import pandas as pd
all_shipments = []
for file in os.listdir("Reports"):
    try:
        df = pd.read_excel("Reports/" + file)
        all_shipments.append(df)
    except:
        print(file)
if len(all_shipments) > 0:
    result = pd.concat(
    all_shipments,
    ignore_index=True
    )
else: 
    print("no files")
   
result["Status"] = "Normal"
result.loc[
    result["Delay"] >= 3,
    "Status"
] = "Warning"

result.loc[
    result["Delay"] >= 5,
    "Status"
] = "Critical"

result["Priority"] = "Low"
result.loc[
    result["Pallets"] >= 10,
    "Priority"
] = "Medium"

result.loc[
    result["Pallets"] >= 30,
    "Priority"
] = "High"

result = result.sort_values(
    by=["Delay", "Pallets"],
    ascending=[False, False]
)
customer_summary = (
    result.groupby("Customer")["Pallets"]
    .sum()
    .reset_index()
)
#customer_summary = result.groupby("Customer")["Pallets"].sum().reset_index()
with pd.ExcelWriter("weekly_logistics_report.xlsx") as writer:
    result.to_excel(
        writer,
        sheet_name="All Shipments",
        index=False
    )

    customer_summary.to_excel(
        writer,
        sheet_name="Customer Summary",
        index=False
    )
# writer = pd.ExcelWriter("weekly_logistics_report.xlsx")

# result.to_excel(writer)
# customer_summary.to_excel(writer)

# writer.close()

