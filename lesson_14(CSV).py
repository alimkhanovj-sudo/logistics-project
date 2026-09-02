import os
import pandas as pd

all_reports = []

files = os.listdir("Reports")
for file in files:
    df = pd.read_csv(
        os.path.join("Reports", file)
    )
    all_reports.append(df)
result = pd.concat(
    all_reports,
    ignore_index=True
    )
result.to_csv(
    "all_reports.csv",
    index=False
)
