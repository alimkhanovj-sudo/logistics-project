import pandas as pd
df = pd.read_excel("all_shipments.xlsx")
# df["Status"] = "Normal"
# df.loc[
#     df["Delay"] >= 3,
#     "Status"
# ] = "Warining"
# df.loc[
#     df["Delay"] >= 5,
#     "Status"
# ] = "Critical"
# df.to_excel(
#     "shipments_with_status.xlsx",
#     index=False
# )
#--
# filtered = df.loc[df["delay"] > 5]
# print(filtered)
# --
# df.loc[df["delay"] > 5, "Delay_Status"] = "Critical" 
# df.loc[df["delay"] <= 5, "Delay_Status"] = "Normal" 
# print(df)


# one = df.iloc[0]
# two = df.iloc[1]
# print(one)
# print(two)
--
df.iloc[0, 1]
df.iloc[0:2, 0:2]
print(df.iloc[0:2, 0:2])
строки 0 до 2, не включая 2
↓
0 и 1
столбцы 0 до 2, не включая 2
↓
0 и 1


