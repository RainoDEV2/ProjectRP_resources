<!-- Please open this file in Visual Studio Code and press Ctrl + Shift + V, or right click it and press "Open Preview" -->

# Loaf Housing
Housing script for ESX & ProjectRP
If you for some reason want the old version, you can download it [here](https://drive.google.com/drive/u/4/folders/1Wa_9KQLNYD6J0hqI31aed6L4Knnf1_gp)

## Features
* Rentable houses / apartments
* Apartments - multiple people can purchase a room at the same apartment complex
* Multiple different interior types: Shells, IPL & MLO
* Support for both ESX & ProjectRP
* Lockpicking
* Furnish your house / apartment
* Share your keys with your friends
* Wardrobe & storage
* Support for [prp-clothing](https://github.com/qbcore-framework/prp-clothing), [default ESX outfits](https://github.com/esx-community/esx_eden_clotheshop) & [fivem-appearance](https://github.com/overextended/fivem-appearance)
* Support for [prp-weathersync](https://github.com/qbcore-framework/prp-weathersync), [cd_easytime](https://github.com/dsheedes/cd_easytime) & [my version of vSync](https://github.com/loaf-scripts/vSync)
* Extremely configurable
* 24 out of 25 files are not encrypted! Only 1 file is encrypted, and it contains functions that you don't need to edit
* Good performance 

    ![resmon; housing: 0.00ms, keysystem: 0.00ms, lib: 0.01ms](https://i.gyazo.com/28f099fe9b9e092934ce058de46db011.png)

## Requirements
* ESX or ProjectRP server
* [loaf_lib](https://github.com/loaf-scripts/loaf_lib)
* [loaf_keysystem](https://github.com/loaf-scripts/loaf_keysystem)
* (should already be on your server) [mysql-async](https://github.com/brouznouf/fivem-mysql-async) or [oxmysql](https://github.com/overextended/oxmysql/)
* (prp only) [prp-menu](https://github.com/qbcore-framework/prp-menu)
* (prp only) [prp-input](https://github.com/qbcore-framework/prp-input)

## Supported inventories
* [ox_inventory](https://github.com/overextended/ox_inventory)
* [chezza inventory](https://store.chezza.dev/package/4770357)
* [prp-inventory](https://github.com/qbcore-framework/prp-inventory)
* ModFreakz inventory

## Supported garage scripts
* [loaf_garage](https://store.loaf-scripts.com/package/4310876)
* [cd_garage](https://codesign.pro/package/4206352)

## Installation
* Run loaf_housing.sql - If you are updating from the old version, make sure to remove all tables from your database first.
* Install all requirements & follow their installation guides
* Add `ensure loaf_housing` to your server.cfg (you do not need to ensure loaf_keysystem nor loaf_lib)
* Drag "whiteshell" to your resources folder