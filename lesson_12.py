import pandas as pd
df = pd.read_excel("shipments.xlsx")
print(df["Customer"][3])
critical = df[df["Delay"] > 2]
print(critical)
critical.to_excel(
    "critical_pandas.xlsx",
    index=False
)

sorted_shipments = df.sort_values(
    by="Pallets",
    ascending=True
)
print(sorted_shipments.head(2))