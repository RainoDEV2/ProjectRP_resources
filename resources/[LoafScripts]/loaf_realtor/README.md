<!-- Please open this file in Visual Studio Code and press Ctrl + Shift + V, or right click it and press "Open Preview" -->

# Loaf Realtor
Real estate agent job for loaf_housing
If you for some reason want the old version, you can download it [here](https://drive.google.com/drive/folders/1L8ktUMG4rzrJnfUpdWqKSS7ATvDfJuuw?usp=sharing)

## Requirements
* [loaf_billing](https://github.com/loaf-scripts/loaf_billing)
* [loaf_lib](https://github.com/loaf-scripts/loaf_lib)
* [loaf_housing](https://store.loaf-scripts.com/package/4310850)

## PRP-Core installation
* Run realtor.sql
* Go to prp-core/shared/jobs.lua and add the following: 
    ```lua
    ['rea'] = {
        label = "Real estate agent",
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Trainee',
                payment = 75
            },
            ['1'] = {
                name = 'Agent',
                payment = 100
            },
            ['2'] = {
                name = 'Manager',
                payment = 150
            },
            ['3'] = {
                name = 'Boss',
                payment = 200,
                isboss = true
            },
        },
    },
    ```
* (only if you use prp-bossmenu instead of prp-management) Go to prp-bossmenu/config.lua and add the following:
    ```lua
    ['rea'] = vector3(8000.0, 0.0, -1000.0),
    ```
* (only if you use prp-bossmenu instead of prp-management) Go to prp-bossmenu/accounts.json and add the following:
    ```json
    "rea":0
    ```
* Go to loaf_housing shared/config.lua and set `enabled` to true inside the `Realtor` table, line 70 by default.

## ESX Installation
* Run realtor.sql
* Run esx.sql
* Go to loaf_housing shared/config.lua and set `enabled` to true inside the `Realtor` table, line 70 by default.