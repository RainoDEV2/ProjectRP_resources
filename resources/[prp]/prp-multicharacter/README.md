# prp-multicharacter
Multi Character Feature for QB-Core Framework :people_holding_hands:

Added support for setting default number of characters per player per Rockstar license

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
- [prp-core](https://github.com/qbcore-framework/prp-core)
- [prp-spawn](https://github.com/qbcore-framework/prp-spawn) - Spawn selector
- [prp-apartments](https://github.com/qbcore-framework/prp-apartments) - For giving the player a apartment after creating a character.
- [prp-clothing](https://github.com/qbcore-framework/prp-clothing) - For the character creation and saving outfits.
- [prp-weathersync](https://github.com/qbcore-framework/prp-weathersync) - For adjusting the weather while player is creating a character.

## Screenshots
![Character Selection](https://i.imgur.com/EUB5X6Y.png)
![Character Registration](https://i.imgur.com/RKxiyed.png)

## Features
- Ability to create up to 5 characters and delete any character.
- Ability to see character information during selection.

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Add the following code to your server.cfg/resouces.cfg
```
ensure prp-core
ensure prp-multicharacter
ensure prp-spawn
ensure prp-apartments
ensure prp-clothing
ensure prp-weathersync
```
