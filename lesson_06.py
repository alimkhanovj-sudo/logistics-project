from openpyxl import Workbook

workbook = Workbook()

sheet = workbook.active

sheet["A1"] = "Shipment"
sheet["B1"] = "Customer"
sheet["C1"] = "Delay"
    
sheet["A2"] = "SHP-1001"
sheet["B2"] = "IKEA"
sheet["C2"] = 4 

workbook.save("shipments.xlsx") 