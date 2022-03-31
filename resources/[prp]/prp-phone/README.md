# prp-phone
Advanced Phone for prp-Core Framework :iphone:

# License

    ProjectRP Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

## Dependencies
- [prp-core](https://github.com/ProjectRP-framework/prp-core)
- [prp-policejob](https://github.com/ProjectRP-framework/prp-policejob) - MEOS, handcuff check etc. 
- [prp-crypto](https://github.com/ProjectRP-framework/prp-crypto) - Crypto currency trading 
- [prp-lapraces](https://github.com/ProjectRP-framework/prp-lapraces) - Creating routes and racing 
- [prp-houses](https://github.com/ProjectRP-framework/prp-houses) - House and Key Management App
- [prp-garages](https://github.com/ProjectRP-framework/prp-garages) - For Garage App
- [prp-banking](https://github.com/ProjectRP-framework/prp-banking) - For Banking App
- [screenshot-basic](https://github.com/citizenfx/screenshot-basic) - For Taking Photos
- A Webhook for hosting photos (Discord or Imgur can provide this)


## Screenshots
![Home](https://imgur.com/ceEIvEk.png)
![Bank](https://imgur.com/tArcik2.png)
![Messages](https://imgur.com/C9aIinK.png)
![Phone](https://imgur.com/ic2zySK.png)
![Settings](https://imgur.com/jqC5Y8C.png)
![MEOS](https://imgur.com/VP7gPRPf.png)
![Vehicles](https://imgur.com/NUTcfwr.png)
![Email](https://imgur.com/zTD33N1.png)
![Advertisements](https://imgur.com/QtQxJLz.png)
![Houses](https://imgur.com/n6ocF7b.png)
![App Store](https://imgur.com/mpBOgfN.png)
![Lawyers](https://imgur.com/SzIRpsI.png)
![Racing](https://imgur.com/cqj1JBP.png)
![Crypto](https://imgur.com/Mvv6IZ4.png)

## Features
- Garages app to see your vehicle details
- Mails to inform the player
- Banking app to see balance and transfer money
- Racing app to create races
- App Store to download apps
- MEOS app for polices to search
- Houses app for house details and management

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Import `prp-phone.sql` in your database
- Add the following code to your server.cfg/resouces.cfg
```
ensure prp-core
ensure screenshot-basic
ensure prp-phone
ensure prp-policejob
ensure prp-crypto
ensure prp-lapraces
ensure prp-houses
ensure prp-garages
ensure prp-banking
```

## Configuration
```

Config = Config or {}

Config.RepeatTimeout = 2000 -- Timeout for unanswered call notification
Config.CallRepeats = 10 -- Repeats for unanswered call notification
Config.OpenPhone = 244 -- Key to open phone display
Config.PhoneApplications = {
    ["phone"] = { -- Needs to be unique
        app = "phone", -- App route
        color = "#04b543", -- App icon color
        icon = "fa fa-phone-alt", -- App icon
        tooltipText = "Phone", -- App name
        tooltipPos = "top",
        job = false, -- Job requirement
        blockedjobs = {}, -- Jobs cannot use this app
        slot = 1, -- App position
        Alerts = 0, -- Alert count
    },
}
```
## Setup Webhook in `server/main.lua` for photos
Set the following variable to your webhook (For example, a Discord channel or Imgur webhook)
### To use Discord:
- Right click on a channel dedicated for photos
- Click Edit Channel
- Click Integrations
- Click View Webhooks
- Click New Webhook
- Confirm channel
- Click Copy Webhook URL
- Paste into `WebHook` in `server/main.lua`
```
local WebHook = ""
```
