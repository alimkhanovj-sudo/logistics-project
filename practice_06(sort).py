import pandas as pd
df = pd.read_excel("shipments.xlsx")
delay_shipments = df[df["Delay"] >= 3]
delya_shipments = delay_shipments.sort_values(
    by=["Delay", "Pallets"],
    ascending=False
)
delay_shipments.to_excel(
    "delay_and_pallets.xlsx",
    index=False
)