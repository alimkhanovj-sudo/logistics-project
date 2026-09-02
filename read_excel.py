# import os
# import pandas as pd
# all_data = []
# for data in os.listdir("Shipments"):
#     if data.endswith(".xlsx"):
#         df = pd.read_excel("Shipments/" + data)
#         all_data.append(df)
# all_shipments = pd.concat(
#     all_data, 
#     ignore_index=True
# )
# clean_shipments_df = all_shipments.drop_duplicates(
#     subset="ShipmentNumber",
#     ignore_index=True
# ) #уберает пропуски
# missing_values = clean_shipments_df.isna().sum()  #считает стоки с пропусками
# print(missing_values)
# clean_shipments_df[clean_shipments_df["Delay"].isna()] #.isna()→ ГДЕ пропуски? df[df["Delay"].isna()] → какие именно строки имеют пропуск в Delay?
# clean_df = clean_shipments_df.dropna(
#     subset = ["ShipmentNumber","CustomerID"]
# ) #удаляет строки
# final_df = clean_df.copy() #создает копию таблицы
# final_df["Delay"] = final_df["Delay"].fillna(0) #заменяет все NULL на 0
# clean_df["Delay"] = pd.to_numeric(clean_df["Delay"]) #Возьми столбец Delay, преобразуй его в числовой тип и запиши обратно в Delay.
# clean_df["DeliveryDate"] = pd.to_datetime(clean_df["DeliveryDate"]) #Нам нужно сделать так, чтобы pandas воспринимал этот столбец именно как дату, а не как обычный текст.
# recent_shipments = clean_df[
#     clean_df["DeliveryDate"] > pd.Timestamp("2026-03-01")
# ] #все отправки, доставленные после 1 марта 2026 года.
# recent_average_delay = recent_shipments.groupby("CustomerID")["Delay"].mean()
# worst_customer = recent_average_delay.sort_values(  
#     ascending=False
# ).index[0]

# customer_summary = recent_shipments.groupby("CustomerID")["Delay"].agg(
#     ["mean", "max", "count"]
# )

# customer_summary = customer_summary.rename(columns={
#     "mean": "Average_Delay",
#     "max": "Max_Delay",
#     "count": "Total_Shipments"
# }) #менять название колонок
# final_customer_report = pd.merge(
#     clean_df, customer_summary,
#     on = "CustomerID"
# )
# final_customer_report.loc[final_customer_report["Average_Delay"] > 5, "Customer_Status"] = "Critical"
# final_customer_report.loc[(final_customer_report["Average_Delay"] <= 5) & (final_customer_report["Average_Delay"] > 2), "Customer_Status"] = "Warning"
# final_customer_report.loc[final_customer_report["Average_Delay"] <= 2, "Customer_Status"] = "Good"

# final_customer_report = final_customer_report.sort_values(
#     by = "Average_Delay",
#     ascending = False
# )
# final_customer_report.to_excel(
#     "Supply_Chain_Customer_Report.xlsx",
#     index=False
# ) 

# import pandas as pd
# import os
# all_data = []
# for file in os.listdir("all_shipments"):
#     if file.endswith(".xlsx"):
#         df = pd.read_excel("all_shipments/" + file)
#         all_data.append(df)
# all_shipments = pd.concat(
#     all_data,
#     ignore_index = True
# )
# all_shipments = all_shipments.drop_duplicates(
#     subset = "ShipmentNumber",
#     ignore_index = True
# )
# all_shipments.to_excel(
#     "All_Shipments_Clean.xlsx",
#         index=False
# )
# all = len(all_shipments) #=
# #= all = all_shipments.shape[0]
# missing_values = all_shipments.isna().sum()
# invalid_delays = all_shipments.loc[
#     all_shipments["Delay"] < 0
# ] 
# print(len(invalid_delays))
# all_shipments.loc[
#     all_shipments["Delay"] < 0, "Delay"
# ] = 0
# customer_kpi = all_shipments.groupby("CustomerID")["Delay"].agg(
#     ["max", "mean", "count"]
# )
# customer_kpi = customer_kpi.rename(columns={
#    "mean": "Average_Delay",
#    "max": "Max_Delay",
#    "count": "Total_Shipments"
# })
# customer_kpi = customer_kpi.sort_values(
#     by = "Average_Delay",
#     ascending = False
# )
# customer_report = pd.merge(
#     customer_kpi, customers_df,
#     on = "CustomerID"
# )
# customer_report.loc[customer_report["Average_Delay"] > 5, "Customer_Status"] = "Critical"
# customer_report.loc[(customer_report["Average_Delay"] <= 5) & (customer_report["Average_Delay"] > 2), "Customer_Status"] = "Warning"
# customer_report.loc[customer_report["Average_Delay"] <= 2, "Customer_Status"] = "Good"

# customer_report.to_excel(
#     "customer_report.xlsx",
#     index=False
# )
import pandas as pd
import os
def load_shipments(folder):
    all_data = []
    for data in os.listdir(folder):
        if data.endswith(".xlsx"):
            try:
                df = pd.read_excel(folder + "/" + data)
                all_data.append(df)
            except:
                print(f"Error reading: {data}")
    shipments = pd.concat(
        all_data,
        ignore_index = True
    )
    return shipments
all_shipments = load_shipments("reports")
print(all_shipments)

def clean_shipments(df):
    df = df.drop_duplicates(
        subset = "ShipmentNumber",
        ignore_index = True
    )
    df = df.dropna(
        subset = ["CustomerID", "ShipmentNumber"]        
    )
    df.loc[
        df["Delay"] < 0,
        "Delay"
    ] = 0
    return df
clean_shipments_df = clean_shipments(all_shipments)
print(clean_shipments_df)

def analyze_shipments(df):
    customer_kpi = df.groupby("CustomerID")["Delay"].agg(
        ["max", "mean", "count"]
    )
    customer_kpi = customer_kpi.rename(columns = {
        "max": "Max_Delay",
        "count": "Total_Shipments",
        "mean": "Average_Delay"
    })
    return customer_kpi
customer_kpi = analyze_shipments(clean_shipments_df)

def create_report(customer_kpi, customers_df):
    merge_tables = pd.merge(
        customer_kpi, customers_df,
        on = "CustomerID" 
       )
    merge_tables.loc[merge_tables["Average_Delay"] > 5, "Customer_Status"] = "Critical"
    merge_tables.loc[(merge_tables["Average_Delay"] <= 5) & (merge_tables["Average_Delay"] > 2), "Customer_Status"] = "Warning"
    merge_tables.loc[merge_tables["Average_Delay"] <= 2, "Customer_Status"] = "Good"

    sorted_table = merge_tables.sort_values(
        by = "Average_Delay",
        ascending = False
    )
    return sorted_table 
customer_report = create_report(customer_kpi, customers_df)

def validate_data(df):
    required_columns = ["ShipmentNumber", "CustomerID", "Delay", "DeliveryDate"]  
    #  if all(column in df.columns for column in required_columns):
    #     print("All required columns are present")
    # else:
    #     print("Missing required columns")
    results = []

    for column in required_columns:
        results.append(column in df.columns)

    result = all(results)

    if result:
        print("All columns are present")
    else:
        print("Missing required columns")

    if df["CustomerID"].isna().sum() > 0:
        print("Missing values found")
    else:
        print("CustomerID is valid")
    if (df["Delay"] < 0).sum() > 0:
        print("Invalid delays found")
    else:
        print("Delays are valid")
validate_report = validate_data(all_shipments)

all_shipments = load_shipments("reports")
clean_shipments_df = clean_shipments(all_shipments)
customer_kpi = analyze_shipments(clean_shipments_df)
customer_report = create_report(customer_kpi, customers_df)
def save_report(df):
    customer_report.to_excel(
    "customer_report.xlsx",
    index = False
)
save_report(customer_report)
