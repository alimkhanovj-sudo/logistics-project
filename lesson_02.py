shipment_numbers = [
    "SHP-1001",
    "SHP-1002",
    "SHP-1003",
    "SHP-1004",
    "SHP-1004",
    "SHP-1005"
]
delays = [
    0,
    1,
    4,
    2,
    8,
    0
]

delay = delays[5]

if delay == 0:
    status = "On Schedule"
elif delay <= 2:
    status = "Minor delay"
else:
    status = "Critical delay"

print(f"Shipment: {shipment_numbers[5]}")
print(f"Delay: {delay} days")
print(f"Status: {status}")

