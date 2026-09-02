import pandas as pd
df = pd.read_excel("shipments.xlsx")
criticals = df[df["Delay"] >= 5]
sort_delay = criticals.sort_values(
    by="Delay",
    ascending=False 
)
sort_delay.to_excel(
    "high_delay_pandas.xlsx",
    index=False
)