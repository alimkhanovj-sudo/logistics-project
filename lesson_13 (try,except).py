
# import pandas as pd
# try: 
#     df = pd.read_excel("Reports/not_exist.xlsx")
#     print("Файл открыт.")
# except:
#     print("Файл не найден.")

import os 
import pandas as pd
all_shipments = []
for file in os.listdir("Reports"):
    print("открываю",file) 
    try:
        df = pd.read_excel("Reports/" + file)
        print(file, "успешно открыт")
        all_shipments.append(df)
    except:
        print("ошибка при открытии", file)
result = pd.concat(
    all_shipments,
    ignore_index=True
    )
result.to_excel(
    "all_shipments.xlsx",
    index=False
)
result = result.sort_values(
    by=["Delay"],
    ascending=False
)
result["Status"] = "Normal"
result.loc[
    result["Delay"] >= 3,
    "Status"
 ] = "Warning"

result.loc[
    result["Delay"] >= 5,
    "Status"
 ] = "Critical"

result.to_excel(
    "sort_shipments.xlsx",
    index=False
)




