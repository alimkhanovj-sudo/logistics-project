shipments = [
     {"number": "SH001", "delay": 2, "status": "Delivered"},
     {"number": "SH002", "delay": 7, "status": "Delayed"},
     {"number": "SH003", "delay": 4, "status": "Delivered"},
     {"number": "SH004", "delay": 9, "status": "Delayed"}
 ]
# #1
# #summary = 0
# #total_ship = 0
# #high_delay_count = 0
# #for shipment in shipments:
#    # summary += shipment["delay"]
#     #total_ship += 1
#    # delay = shipment["delay"]
#   #  if delay > 5:
#  #       high_delay_count+=1
# #average_total = summary / total_ship
# #print(f"Total delay: {summary}")   
# #print(f"Average delay: {average_total}")   
# #print(f"High delay shipments: {high_delay_count}") 

# #2
# #high_delay_shipments = []
# #for shipment in shipments:
# #    delay = shipment["delay"]
# #    if delay > 5:
# #        high_delay_shipments.append(delay)
# #print(high_delay_shipments)

# #3
# status_count = {}
# high_delay_shipments = []
# for shipment in shipments:
#     delay = shipment["delay"]
#     number = shipment["number"]
#     status = shipment["status"]
#     status_count[status] = status_count.get(status, 0) + 1
#     if delay > 5:
#         high_delay_shipments.append(number)
# print(high_delay_shipments)
# print(status_count) 

#4
# def check_delay(delay):
#     if delay > 5:
#         return "High Delay"
#     else:
#         return "Normal"

# for shipment in shipments:
#     check_delay(shipment["delay"])
#     number = shipment ["number"]
#     result = check_delay(shipment["delay"])
#     print(f'{shipment["number"]} - {result}')

# def calculate_average_delay(shipments):
#     count = 0
#     count_delay = 0
#     for shipment in shipments:
#         count_delay += shipment["delay"] 
#         count += 1
#     average_delay = count_delay/count
#     return average_delay
# average_delay = calculate_average_delay(shipments)
# print(f"Average delay: {average_delay}")

#5
# def calculate_delay_stats(shipments):
#     total_ship = 0
#     total_delay = 0
#     average_delay = 0
#     for shipment in shipments:
#         total_ship += 1
#         total_delay += shipment["delay"]
#     average_delay = total_delay / total_ship
#     return total_delay, average_delay, total_ship
# total, average, count = calculate_delay_stats(shipments)
# print(f"{total}")
# print(f"{average}")
# print(f"{count}")

#6
#delay = "7"
# try:
#     delay = int(delay)
#     if delay > 5:
#         print("High Delay")
#     else:
#         print("Normal")
# except:
#     print("Invalid delay")

#CSV file 7
# with open("shipments.txt", "w") as file:
#     file.write("SH001,2\n")
#     file.write("SH002,7\n")
#     file.write("SH003,4\n")
with open("shipments.txt", "r") as file:
    lines = file.readlines()
    for line in lines:
        number, delay = line.strip().split(",")
        print(f"Number: {number}, Delay: {delay}") 
      



    
   