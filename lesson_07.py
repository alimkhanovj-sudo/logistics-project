from openpyxl import load_workbook

workbook = load_workbook("shipments.xlsx")

sheet = workbook.active

print(f"Shipment: {sheet["A2"].value}")
print(f"Customer: {sheet["B2"].value}")
print(f"Delay: {sheet["C2"].value}")