# prp-payments
ProjectRP based payment system

If you think I did a good job here, consider donating as it keeps by lights on and my cat fat:
https://ko-fi.com/jixelpatterns
--------------

If you use a different phone/invoice system let me know and I will add support for it as best I can!

Enchanced QB-Input payment system from my other scripts now free on its own

![General](https://i.imgur.com/37d2mE3.jpeg) ![General](https://i.imgur.com/AIdXzxX.jpeg)
![General](https://i.imgur.com/RYADcI2.jpeg) ![General](https://i.imgur.com/ICbQyeQ.jpeg)
# Installation

To make use of this payment system you need trigger the event

```prp-payments:client:Charge```

for example with prp-target
```
exports['prp-target']:AddBoxZone("Receipt", vector3(1589.14, 6458.26, 26.01), 0.6, 0.6, { name="Receipt", heading = 335.0, debugPoly=debugPoly, minZ = 26.01, maxZ = 26.81, }, 
{ options = { { event = "prp-payments:client:Charge", icon = "fas fa-credit-card", label = "Charge Customer", job = "popsdiner" } }, distance = 2.0	})
```
It currently requires you to be on duty to charge someone

--------------

To make use of the ticket reward system for workers you need to add the ticket item to your shared items lua:
```
["payticket"] 					 = {["name"] = "payticket", 				["label"] = "Receipt", 	     			["weight"] = 150, 		["type"] = "item", 		["image"] = "ticket.png", 				["unique"] = false,   	["useable"] = false,    ["shouldClose"] = false,    ["combinable"] = nil,   ["description"] = "Cash these in at the bank!"},	
```

Add the ticket image to your inventory script

[qb] > prp-inventory > html > images

--------------
To get tickets from phone invoices you NEED to add it to the event when a payment is accepted:

Go to [qb] > prp-phone > client > main.lua
- Around line 645 there should be the PayInvoice NUICallBack
- Directly under this line:

```TriggerServerEvent('prp-phone:server:BillingEmail', data, true)```

- Add this line:

```TriggerServerEvent('prp-payments:Tickets:Give', data)```

--------------

The latest banking systems are very simple to use and add,
simply look in the atms.lua and change the config options at the top

Choose wether to use atm's, choose wether to use banking locations
Choose wether to add bank blips (if you want to disable prp-banking)
Choose wether to add ATM blips (if you like $ signs)


--------------

New Commission system added

This brings more config options to find tune the script

Choose wether people get commission from every sale
Choose if EVERY worker gets Commission that is on duty
Choose if Commission is limited by MinAmountForTicket
Choose if the worker charging the customer gets double commission
