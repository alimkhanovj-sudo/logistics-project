# import os
# import pandas as pd

# all_data = []

# for file in os.listdir("Reports"):
#     df = pd.read_excel("Reports/" + file)
#     all_data.append(df)
# result = pd.concat(
#     all_data,
#     ignore_index=True
# )
# result.to_excel(
#     "all_shipments.xlsx",
#     index=False
# )

# import os
# files = []
# for file in os.listdir():
#     if file.endswith(".xlsx"):
#         files.append(file)
# print(files)

import pandas as pd
df = pd.read_excel("all_shipments.xlsx") 
filter = df[df["Delay"] > 5]
print(filter)




