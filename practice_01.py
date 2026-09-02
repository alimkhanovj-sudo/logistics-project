shipments = [
    {
        "number": "SHP-1001",
        "customer": "IKEA",
        "route": "Berlin → Warsaw",
        "delay": 0,
        "pallets": 28
    },
    {
        "number": "SHP-1002",
        "customer": "Amazon",
        "route": "Prague → Berlin",
        "delay": 5,
        "pallets": 2
    },
    {
        "number": "SHP-1003",
        "customer": "Lidl",
        "route": "Paris → Warsaw",
        "delay": 2,
        "pallets": 52
    },
    {
        "number": "SHP-1004",
        "customer": "Zara",
        "route": "Madrid → Paris",
        "delay": 8,
        "pallets": 7
    }
]

total_pallets = 0

for shipment in shipments:

    total_pallets += shipment["pallets"]

    # if delay == 0:
    #     critical += 1
    #     print(f"Shipment: {shipment['number']}")
    #     print(f"Route: {shipment['route']}")
    #     print(f"Delay: {shipment['delay']}")
    #     print(f"Customer: {shipment['customer']}")
    #     print(f"Status: no delay")   
    #     print()

print(f"Total number of pallets: {total_pallets}")
    
    
    # else:
    #     print(f"Shipment: {shipment['number']}")
    #     print(f"Route: {shipment['route']}")
    #     print(f"Delay: {shipment['delay']}")
    #     print(f"Customer: {shipment['customer']}")
    #     print(f"Status: no delay")   
    #     print()
    
    