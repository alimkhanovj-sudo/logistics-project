shipments = [
    "SHP-1001",
    "SHP-1002",
    "SHP-1003",
    "SHP-1004",
    "SHP-1005",
    "SHP-1006"
]

delays = [
    0,
    1,
    4,
    2,
    8,
    0
]

for index in range(len(shipments)):
    print(f"Shipment: {shipments[index]}")
    print(f"Delay: {delays[index]}")

    delay = delays[index]

    if delay == 0:
         status = "no dalay"
    elif delay <= 2:
            status = "small delay"
    else:
            status = "critical delay"

    print(f"Status: {status}")
    print()
   