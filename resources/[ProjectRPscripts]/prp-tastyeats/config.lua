Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DEL'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

icfg = {}
icfg.DepositForVehiclePrice = 1000
icfg.CustomerComingToDoor = 5000

icfg.Levels = {
    Level1 = {
        MinPoints = 0,
        MaxPoints = 50,
        PayoutMin = 210,
        PayoutMax = 350,
        MinOrderSearch = 20000, ------|
        MaxOrderSearch = 30000, --------- in MS
    },
    Level2 = {
        MinPoints = 51,
        MaxPoints = 150,
        PayoutMin = 225,
        PayoutMax = 365,
        MinOrderSearch = 18000, ------|
        MaxOrderSearch = 28000, --------- in MS
    },
    Level3 = {
        MinPoints = 151,
        MaxPoints = 300,
        PayoutMin = 300,
        PayoutMax = 450,
        MinOrderSearch = 16000, ------|
        MaxOrderSearch = 26000, --------- in MS
    },
    Level4 = {
        MinPoints = 301,
        MaxPoints = 500,
        PayoutMin = 325,
        PayoutMax = 475,
        MinOrderSearch = 14000, ------|
        MaxOrderSearch = 24000, --------- in MS
    },
    Level5 = {
        MinPoints = 501,
        MaxPoints = 750,
        PayoutMin = 450,
        PayoutMax = 500,
        MinOrderSearch = 12000, ------|
        MaxOrderSearch = 22000, --------- in MS
    },
}


icfg.TastyEats = {

    ["Base"] = {

        JobStart = {
            Coords = {x = -1321.16, y = -1263.96, z = 4.59},
            Blip = {
                Sprite = 268,
                Scale = 0.6,
                Color = 43,
                Label = "[~g~Tasty Eats~s~] Base",
            },
        },

        Garage = {
            Coords = {
                TakeVehicle = {x = -1319.74, y = -1259.22, z = 4.59},
                ReturnVehicle = {x = -1301.94, y = -1255.33, z = 3.92},
                SpawnPoint1 = {x = -1307.76, y = -1260.98, z = 4.09, h = 20.42},
                SpawnPoint2 = {x = -1311.90, y = -1262.60, z = 4.11, h = 20.42},
                SpawnPoint3 = {x = -1315.97, y = -1264.02, z = 4.13, h = 20.42},
            },
            Blip = {
                Sprite = 291,
                Scale = 0.6,
                Color = 43,
                Label = "[~g~Tasty Eats~s~] Garage",
            },
        },

    },

    ["Restaurant"] = {
        [1] = {x = -2193.69, y = 4290.09, z = 49.17, h = 57.08, blip, ped = "a_m_y_stwhi_01", name = "Hookies", emoji = "🍣"},
        [2] = {x = -1552.81, y = -440.03, z = 40.52, h = 230.32, blip, ped = "csb_chef", name = "Taco Bomb", emoji = "🌮"},
        [3] = {x = -180.84, y = -1429.05, z = 31.31, h = 300.56, blip, ped = "a_m_m_mexlabor_01", name = "Cluckin Bell", emoji = "🍗"},
        [4] = {x = 538.32, y = 101.37, z = 96.52, h = 155.16, blip, ped = "s_m_m_cntrybar_01", name = "Pizza This", emoji = "🍕"},
        [5] = {x = -1182.78, y = -883.73, z = 13.76, h = 304.07, blip, ped = "u_m_y_burgerdrug_01", name = "Burger Shot", emoji = "🍔"},
    },

    ["DeliveryPlace"] = {
        [1] = {x = -1116.19, y = -1506.56, z = 4.43, h = 30.45, px = -1116.86, py = -1505.65, pz = 4.40, ph = 214.56, blip},
        [2] = {x = -1108.97, y = -1527.78, z = 6.78, h = 300.06, px = -1108.27, py = -1527.12, pz = 6.78, ph = 123.39, blip},
        [3] = {x = -1086.73, y = -1530.15, z = 4.70, h = 32.76, px = -1087.17, py = -1529.45, pz = 4.70, ph = 215.11, blip},
        [4] = {x = -1085.36, y = -1557.90, z = 4.50, h = 212.20, px = -1084.76, py = -1558.70, pz = 4.50, ph = 34.42, blip},
        [5] = {x = -1077.36, y = -1553.51, z = 4.63, h = 215.84, px = -1076.90, py = -1554.09, pz = 4.63, ph = 35.09, blip},
        [6] = {x = -1058.11, y = -1540.24, z = 5.05, h = 213.64, px = -1057.71, py = -1540.72, pz = 5.05, ph = 34.13, blip},
        [7] = {x = -1048.39, y = -1580.44, z = 4.94, h = 127.24, px = -1049.06, py = -1580.99, pz = 4.98, ph = 303.18, blip},
        [8] = {x = -1026.98, y = -1574.95, z = 5.19, h = 123.26, px = -1027.69, py = -1575.52, pz = 5.27, ph = 306.73, blip},
        [9] = {x = -1161.32, y = -1101.32, z = 6.53, h = 205.85, px = -1160.80, py = -1102.01, pz = 6.53, ph = 31.50, blip},
        [10] = {x = -1159.24, y = -1100.44, z = 6.53, h = 211.01, px = -1158.82, py = -1100.92, pz = 6.53, ph = 32.53, blip},
        [11] = {x = -1564.02, y = -299.68, z = 48.23, h = 140.28, px = -1564.56, py = -300.27, pz = 48.23, ph = 320.17, blip},
        [12] = {x = -1569.04, y = -294.53, z = 48.28, h = 137.46, px = -1569.68, py = -295.28, pz = 48.28, ph = 316.86, blip},
        [13] = {x = -1574.48, y = -289.66, z = 48.28, h = 136.93, px = -1574.88, py = -290.24, pz = 48.28, ph = 318.81, blip},
        [14] = {x = -1581.89, y = -277.92, z = 48.28, h = 109.11, px = -1582.48, py = -278.22, pz = 48.28, ph = 290.26, blip},
        [15] = {x = -1583.05, y = -265.80, z = 48.28, h = 81.98, px = -1583.74, py = -265.84, pz = 48.28, ph = 266.76, blip},
        [16] = {x = -1570.58, y = 23.26, z = 59.55, h = 168.80, px = -1570.76, py = 22.31, pz = 59.55, ph = 349.09, blip},
        [17] = {x = -1629.56, y = 37.25, z = 62.94, h = 152.42, px = -1630.01, py = 36.32, pz = 62.94, ph = 336.02, blip},
        [18] = {x = -1094.17, y = 427.28, z = 75.88, h = 88.63, px = -1094.96, py = 427.29, pz = 75.88, ph = 264.34, blip},
        [19] = {x = -1051.91, y = 431.63, z = 77.06, h = 7.14, px = -1052.12, py = 432.52, pz = 77.26, ph = 190.89, blip},
        [20] = {x = -1006.92, y = 512.85, z = 79.60, h = 18.49, px = -1007.22, py = 513.63, pz = 79.77, ph = 191.97, blip},
        [21] = {x = -967.68, y = 509.85, z = 81.87, h = 326.36, px = -967.18, py = 510.65, pz = 82.07, ph = 146.14, blip},
        [22] = {x = -987.34, y = 487.67, z = 82.27, h = 188.91, px = -987.25, py = 487.04, pz = 82.46, ph = 8.31, blip},
        [23] = {x = -968.11, y = 436.64, z = 80.57, h = 66.15, px = -968.84, py = 436.90, pz = 80.77, ph = 246.24, blip},
        [24] = {x = -843.57, y = 466.65, z = 87.60, h = 272.24, px = -842.66, py = 466.76, pz = 87.60, ph = 95.99, blip},
        [25] = {x = -824.84, y = 422.47, z = 92.12, h = 185.46, px = -824.77, py = 421.99, pz = 92.12, ph = 7.25, blip},
        [26] = {x = -784.27, y = 459.10, z = 100.18, h = 34.75, px = -784.78, py = 459.78, pz = 100.39, ph = 215.96, blip},
        [27] = {x = -718.05, y = 449.12, z = 106.91, h = 203.39, px = -717.76, py = 448.64, pz = 106.91, ph = 28.51, blip},
        [28] = {x = -678.84, y = 511.49, z = 113.53, h = 17.60, px = -679.06, py = 512.14, pz = 113.53, ph = 196.86, blip},
        [29] = {x = -640.72, y = 519.82, z = 109.69, h = 9.22, px = -640.92, py = 520.64, pz = 109.88, ph = 192.44, blip},
        [30] = {x = -580.56, y = 492.40, z = 108.90, h = 187.34, px = -580.39, py = 491.48, pz = 108.90, ph = 11.22, blip},
    },

    ["RandomText"] = {
        [1] = {NPCText = "Hi, hope the Food is still warm", NPCText2 = "Thank you Very Much!", YourText = "[~g~E~s~] - Hi, of course"},
        [2] = {NPCText = "Hi, after all you are...", NPCText2 = "Thank you Very Much!", YourText = "[~g~E~s~] - Yes... Hi, enjoy your meal"},
        [3] = {NPCText = "Hi, I haven't had Food Delivered so quickly in my life", NPCText2 = "I have to Order Food from you more and more often!", YourText = "[~g~E~s~] - Hello, nice to hear it!"},
        [4] = {NPCText = "Hello, I was paying for an Online Order", NPCText2 = "Goodbye!", YourText = "[~g~E~s~] - Hi, allright"},
    },

    ["Peds"] = {
        [1] = {ped = "a_m_y_beach_03"},
        [2] = {ped = "a_m_y_breakdance_01"},
        [3] = {ped = "g_m_m_chicold_01"},
        [4] = {ped = "s_m_y_dealer_01"},
        [5] = {ped = "a_m_y_downtown_01"},
        [6] = {ped = "g_m_y_famfor_01"},
        [7] = {ped = "csb_g"},
        [8] = {ped = "ig_jimmydisanto"},
        [9] = {ped = "u_m_y_militarybum"},
        [10] = {ped = "ig_ortega"},
        [11] = {ped = "a_f_m_fatbla_01"},
    },

    ["Clothes"] = {
        Male = {
            ['tshirt_1'] = 42,  ['tshirt_2'] = 1,
            ['torso_1'] = 3,   ['torso_2'] = 4,
            ['arms'] = 1,
            ['pants_1'] = 9,   ['pants_2'] = 3,
            ['shoes_1'] = 1,   ['shoes_2'] = 1,
        },
        Female = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 4,   ['torso_2'] = 14,
            ['arms'] = 4,
            ['pants_1'] = 25,   ['pants_2'] = 1,
            ['shoes_1'] = 16,   ['shoes_2'] = 4,
        },
    },

}
