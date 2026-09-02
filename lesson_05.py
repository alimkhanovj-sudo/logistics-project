shipments = [

    {
        "number": "SHP-1001",
        "route": "Berlin → Warsaw",
        "delay": 0,
        "customer": "IKEA"
    },

    {
        "number": "SHP-1002",
        "route": "Prague → Berlin",
        "delay": 3,
        "customer": "Amazon"
    },

    {
        "number": "SHP-1003",
        "route": "Paris → Warsaw",
        "delay": 1,
        "customer": "Lidl"
    }

]    

for shipment in shipments:
   
   delay = shipment["delay"]

   if delay == 0:
      status = "No delay"
   elif delay <= 2:
      status = "Small delay"
   else:
      status = "Critical delay"
  
   print(f"Shipment: {shipment['number']}")
   print(f"Route: {shipment['route']}")
   print(f"Delay: {shipment['delay']}")
   print(f"Status: {status}") 
   print(f"Customer: {shipment['customer']}")
   print()