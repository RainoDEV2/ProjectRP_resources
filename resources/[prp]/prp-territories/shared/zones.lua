Zones = {
    ["Config"] = {
        debug = false,
        minScore = 10
    },
    ["Territories"] = {
        [1] = {
            centre = vector3(755.02, -298.71, 59.89),
            radius = 50.0,
            winner = "tarteret",
            occupants={
                ["tarteret"] = {
                    label = "tarteret",
                    score = 60,
                },
            },
            blip = 437
        },
        [2] = {
            centre = vector3(1373.51, -1534.22, 56.22),
            radius = 50.0,
            winner = "marabunta",
            occupants={},
            blip = 437
        },
        [3] = {
            centre = vector3(1281.96, -1733.7, 52.53),
            radius = 50.0,
            winner = "aztecas",
            occupants={},
            blip = 437
        },
        [4] = {
            centre = vector3(37.38, -1880.71, 22.34),
            radius = 50.0,
            winner = "ballas",
            occupants={},
            blip = 437
        }
    },
    ["Gangs"] = {
        ["neutral"] = {
            color = 0,
            name = "",
        },
        ["lostmc"] = {
            color = 0,
            name = "The Lost MC",
        },
        ["ballas"] =  {
            color = 21,
            name = "Ballas",
        },
        ["cartel"] = {
            color = 39,
            name = "Cartel",
        },
        ["families"] = {
            color = 25,
            name = "Families",
        },
        ["triads"] = {
            color = 9,
            name = "Triads",
        },
        ["zerotolerance"] = {
            color = 6,
            name = "Zero Tolerance",
        },
        ["ssk"] = {
            color = 147,
            name = "South Side Kings",
        },
        ["the70s"] = {
            color = 0,
            name = "The 70s",
        },
    }
}
