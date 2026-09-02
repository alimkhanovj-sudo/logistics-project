shipments = [
    ["SH001","Amazon",5,10],
    ["SH002","IKEA",1,35],
    ["SH003","Tesla",7,50],
    ["SH004","DHL",3,12]
]

for shipment in shipments:
    print(shipment)
shipments.sort(
    key=lambda shipment: shipment[3],
    reverse=True
    )
print(shipments[0])
print(shipments[1])
print(f"1: {shipments[0][1]} — {shipments[0][3]} pallets")
print(f"2: {shipments[1][1]} — {shipments[1][3]} pallets")