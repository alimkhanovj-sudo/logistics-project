shipment = {
    "number": "SHP-1001",
    "route": "Berlin → Warsaw",
    "delay": 4,
    "pallets": 26,
    "Customer": "Lui",
    "Driver": "Leo",
    "vehicle": "Iveco"
}

delay = shipment["delay"]

if delay == 0:
         status = "no dalay"
elif delay <= 2:
           status = "small delay"
else:
           status = "critical delay"

shipment["status"] = status

print(shipment)
print(f"Vehicle: {shipment['vehicle']}")

