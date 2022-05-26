Config = {}

Config.MenuItems = {
    [1] = {
        id = 'citizen',
        title = 'Citizen',
        icon = 'user',
        items = {
            {
                id = 'givenum',
                title = 'Give Contact Details',
                icon = 'address-book',
                type = 'client',
                event = 'prp-phone:client:GiveContactDetails',
                shouldClose = true
            }, {
                id = 'getintrunk',
                title = 'Get In Trunk',
                icon = 'car',
                type = 'client',
                event = 'prp-trunk:client:GetIn',
                shouldClose = true
            }, {
                id = 'cornerselling',
                title = 'Corner Selling',
                icon = 'cannabis',
                type = 'client',
                event = 'prp-drugs:client:cornerselling',
                shouldClose = true
            }, {
                id = 'togglehotdogsell',
                title = 'Hotdog Selling',
                icon = 'hotdog',
                type = 'client',
                event = 'prp-hotdogjob:client:ToggleSell',
                shouldClose = true
            }
        }
    },
    [2] = {
        id = 'interactions',
        title = 'Interaction',
        icon = 'exclamation-triangle',
        items = {
            {
                id = 'handcuff',
                title = 'Cuff',
                icon = 'user-lock',
                type = 'client',
                event = 'police:client:CuffPlayerSoft',
                shouldClose = true
            }, {
                id = 'playerinvehicle',
                title = 'Put In Vehicle',
                icon = 'car-side',
                type = 'client',
                event = 'police:client:PutPlayerInVehicle',
                shouldClose = true
            }, {
                id = 'playeroutvehicle',
                title = 'Take Out Of Vehicle',
                icon = 'car-side',
                type = 'client',
                event = 'police:client:SetPlayerOutVehicle',
                shouldClose = true
            }, {
                id = 'stealplayer',
                title = 'Rob',
                icon = 'mask',
                type = 'client',
                event = 'police:client:RobPlayer',
                shouldClose = true
            }, {
                id = 'carry',
                title = 'Carry',
                icon = 'user-friends',
                type = 'client',
                event = 'CarryPeople:carryTarget',
                shouldClose = true
            }, {
                id = 'escort2',
                title = 'Escort',
                icon = 'user-friends',
                type = 'client',
                event = 'police:client:EscortPlayer',
                shouldClose = true
            }, {
                id = 'escort554',
                title = 'Hostage',
                icon = 'child',
                type = 'client',
                event = 'A5:Client:TakeHostage',
                shouldClose = true
            }, {
                id = 'stealshoe',
                title = 'Steal Shoes',
                icon = 'shoe-prints',
                type = 'client',
                event = 'prp-stealshoes:client:TheftShoe',
                shouldClose = true
            }
        }
    },
    [3] = {
        id = 'vehiclemenu',
        title = 'Vehicle',
        icon = 'car',
        type = 'client',
        event = 'prp-carmenu:openUI',
        shouldClose = true
    },
    [4] = {
        id = 'general',
        title = 'General',
        icon = 'list-alt',
        items = {
            {
                id = 'house',
                title = 'House Interaction',
                icon = 'home',
                items = {
                    {
                        id = 'givehousekey',
                        title = 'Give House Keys',
                        icon = 'key',
                        type = 'client',
                        event = 'prp-houses:client:giveHouseKey',
                        shouldClose = true,
                        items = {}
                    }, {
                        id = 'removehousekey',
                        title = 'Remove House Keys',
                        icon = 'key',
                        type = 'client',
                        event = 'prp-houses:client:removeHouseKey',
                        shouldClose = true,
                        items = {}
                    }, {
                        id = 'togglelock',
                        title = 'Toggle Doorlock',
                        icon = 'door-closed',
                        type = 'client',
                        event = 'prp-houses:client:toggleDoorlock',
                        shouldClose = true
                    }, {
                        id = 'decoratehouse',
                        title = 'Decorate House',
                        icon = 'boxes',
                        type = 'client',
                        event = 'prp-houses:client:decorate',
                        shouldClose = true
                    }, {
                        id = 'houseLocations',
                        title = 'Interaction Locations',
                        icon = 'home',
                        items = {
                            {
                                id = 'setstash',
                                title = 'Set Stash',
                                icon = 'box-open',
                                type = 'client',
                                event = 'prp-houses:client:setLocation',
                                shouldClose = true
                            }, {
                                id = 'setoutift',
                                title = 'Set Wardrobe',
                                icon = 'tshirt',
                                type = 'client',
                                event = 'prp-houses:client:setLocation',
                                shouldClose = true
                            }, {
                                id = 'setlogout',
                                title = 'Set Logout',
                                icon = 'door-open',
                                type = 'client',
                                event = 'prp-houses:client:setLocation',
                                shouldClose = true
                            }
                        }
                    }
                }
            }, {
                id = 'walking-style2',
                title = 'Walking Styles',
                icon = 'walking',
                items = {
                    {
                        id = 'walk1',
                        title = 'Arrogant',
                        icon = 'meh-rolling-eyes',
                        type = 'client',
                        event = 'prp-walkstyles:arrogant',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk2',
                        title = 'Casual',
                        icon = 'meh-blank',
                        type = 'client',
                        event = 'prp-walkstyles:casual',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk3',
                        title = 'Casual 2',
                        icon = 'meh-blank',
                        type = 'client',
                        event = 'prp-walkstyles:casual2',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk4',
                        title = 'Casual 3',
                        icon = 'meh-blank',
                        type = 'client',
                        event = 'prp-walkstyles:casual3',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk5',
                        title = 'Casual 4',
                        icon = 'meh-blank',
                        type = 'client',
                        event = 'prp-walkstyles:casual4',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk6',
                        title = 'Casual 5',
                        icon = 'meh-blank',
                        type = 'client',
                        event = 'prp-walkstyles:casual5',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk7',
                        title = 'Casual 6',
                        icon = 'meh-blank',
                        type = 'client',
                        event = 'prp-walkstyles:casual6',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walk8',
                        title = 'Confident',
                        icon = 'grin-wink',
                        type = 'client',
                        event = 'prp-walkstyles:confident',
                        shouldClose = true,
                        items = {}
                    },
                    {
                        id = 'walking-style3',
                        title = 'More...',
                        icon = 'ellipsis-h',
                        items = {
                            {
                                id = 'walk9',
                                title = 'Business',
                                icon = 'briefcase',
                                type = 'client',
                                event = 'prp-walkstyles:business',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk10',
                                title = 'Business 2',
                                icon = 'briefcase',
                                type = 'client',
                                event = 'prp-walkstyles:business2',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk11',
                                title = 'Business 3',
                                icon = 'briefcase',
                                type = 'client',
                                event = 'prp-walkstyles:business3',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk12',
                                title = 'Femme',
                                icon = 'female',
                                type = 'client',
                                event = 'prp-walkstyles:femme',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk13',
                                title = 'Flee',
                                icon = 'ghost',
                                type = 'client',
                                event = 'prp-walkstyles:flee',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk14',
                                title = 'Gangster',
                                icon = 'dollar-sign',
                                type = 'client',
                                event = 'prp-walkstyles:gangster',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk15',
                                title = 'Gangster 2',
                                icon = 'dollar-sign',
                                type = 'client',
                                event = 'prp-walkstyles:gangster2',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walk16',
                                title = 'Gangster 3',
                                icon = 'dollar-sign',
                                type = 'client',
                                event = 'prp-walkstyles:gangster3',
                                shouldClose = true,
                                items = {}
                            },
                            {
                                id = 'walking-style4',
                                title = 'More...',
                                icon = 'ellipsis-h',
                                items = {
                                    {
                                        id = 'walk17',
                                        title = 'Gangster 4',
                                        icon = 'dollar-sign',
                                        type = 'client',
                                        event = 'prp-walkstyles:gangster4',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk18',
                                        title = 'Gangster 5',
                                        icon = 'dollar-sign',
                                        type = 'client',
                                        event = 'prp-walkstyles:gangster5',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk19',
                                        title = 'Heels',
                                        icon = 'female',
                                        type = 'client',
                                        event = 'prp-walkstyles:heels',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk20',
                                        title = 'Heels 2',
                                        icon = 'female',
                                        type = 'client',
                                        event = 'prp-walkstyles:heels2',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk21',
                                        title = 'Hiking',
                                        icon = 'hiking',
                                        type = 'client',
                                        event = 'prp-walkstyles:hiking',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk22',
                                        title = 'Quick',
                                        icon = 'running',
                                        type = 'client',
                                        event = 'prp-walkstyles:quick',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk23',
                                        title = 'Wide',
                                        icon = 'arrows-alt-h',
                                        type = 'client',
                                        event = 'prp-walkstyles:wide',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walk24',
                                        title = 'Scared',
                                        icon = 'grimace',
                                        type = 'client',
                                        event = 'prp-walkstyles:scared',
                                        shouldClose = true,
                                        items = {}
                                    },
                                    {
                                        id = 'walking-style6',
                                        title = 'More...',
                                        icon = 'ellipsis-h',
                                        items = {
                                            {
                                                id = 'walk25',
                                                title = 'Brave',
                                                icon = 'wolf-pack-battalion',
                                                type = 'client',
                                                event = 'prp-walkstyles:brave',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk26',
                                                title = 'Tipsy',
                                                icon = 'beer',
                                                type = 'client',
                                                event = 'prp-walkstyles:tipsy',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk27',
                                                title = 'Injured',
                                                icon = 'crutch',
                                                type = 'client',
                                                event = 'prp-walkstyles:injured',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk28',
                                                title = 'Tough',
                                                icon = 'dumbbell',
                                                type = 'client',
                                                event = 'prp-walkstyles:tough',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk29',
                                                title = 'Sassy',
                                                icon = 'kiss',
                                                type = 'client',
                                                event = 'prp-walkstyles:sassy',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk30',
                                                title = 'Sad',
                                                icon = 'frown',
                                                type = 'client',
                                                event = 'prp-walkstyles:sad',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk31',
                                                title = 'Posh',
                                                icon = 'crown',
                                                type = 'client',
                                                event = 'prp-walkstyles:posh',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walk32',
                                                title = 'Alien',
                                                icon = 'reddit-alien',
                                                type = 'client',
                                                event = 'prp-walkstyles:alien',
                                                shouldClose = true,
                                                items = {}
                                            },
                                            {
                                                id = 'walking-style8',
                                                title = 'More...',
                                                icon = 'ellipsis-h',
                                                items = {
                                                    {
                                                        id = 'walk33',
                                                        title = 'Non Chalant',
                                                        icon = 'meh',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:nonchalant',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk34',
                                                        title = 'Hobo',
                                                        icon = 'dumpster',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:hobo',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk35',
                                                        title = 'Money',
                                                        icon = 'money-bill-alt',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:money',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk36',
                                                        title = 'Swagger',
                                                        icon = 'blind',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:swagger',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk37',
                                                        title = 'Shady',
                                                        icon = 'user-ninja',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:shady',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk38',
                                                        title = 'Man Eater',
                                                        icon = 'grin-tongue-wink',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:maneater',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk39',
                                                        title = 'ChiChi',
                                                        icon = 'yin-yang',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:chichi',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk40',
                                                        title = 'Default',
                                                        icon = 'meh',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:default',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                    {
                                                        id = 'walk41',
                                                        title = 'Walking Styles Menu',
                                                        icon = 'walking',
                                                        type = 'client',
                                                        event = 'prp-walkstyles:openmenu',
                                                        shouldClose = true,
                                                        items = {}
                                                    },
                                                }
                                            },
                                        }
                                    },
                                }
                            },
                        }
                    }
                }
            }, {
                id = 'clothesmenu',
                title = 'Clothing',
                icon = 'tshirt',
                items = {
                    {
                        id = 'Hair',
                        title = 'Hair',
                        icon = 'user',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleClothing',
                        shouldClose = true
                    }, {
                        id = 'Ear',
                        title = 'Ear Piece',
                        icon = 'deaf',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleProps',
                        shouldClose = true
                    }, {
                        id = 'Neck',
                        title = 'Neck',
                        icon = 'user-tie',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleClothing',
                        shouldClose = true
                    }, {
                        id = 'Top',
                        title = 'Top',
                        icon = 'tshirt',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleClothing',
                        shouldClose = true
                    }, {
                        id = 'Shirt',
                        title = 'Shirt',
                        icon = 'tshirt',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleClothing',
                        shouldClose = true
                    }, {
                        id = 'Pants',
                        title = 'Pants',
                        icon = 'user',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleClothing',
                        shouldClose = true
                    }, {
                        id = 'Shoes',
                        title = 'Shoes',
                        icon = 'shoe-prints',
                        type = 'client',
                        event = 'prp-radialmenu:ToggleClothing',
                        shouldClose = true
                    }, {
                        id = 'meer',
                        title = 'Extras',
                        icon = 'plus',
                        items = {
                            {
                                id = 'Hat',
                                title = 'Hat',
                                icon = 'hat-cowboy-side',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleProps',
                                shouldClose = true
                            }, {
                                id = 'Glasses',
                                title = 'Glasses',
                                icon = 'glasses',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleProps',
                                shouldClose = true
                            }, {
                                id = 'Visor',
                                title = 'Visor',
                                icon = 'hat-cowboy-side',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleProps',
                                shouldClose = true
                            }, {
                                id = 'Mask',
                                title = 'Mask',
                                icon = 'theater-masks',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleClothing',
                                shouldClose = true
                            }, {
                                id = 'Vest',
                                title = 'Vest',
                                icon = 'vest',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleClothing',
                                shouldClose = true
                            }, {
                                id = 'Bag',
                                title = 'Bag',
                                icon = 'shopping-bag',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleClothing',
                                shouldClose = true
                            }, {
                                id = 'Bracelet',
                                title = 'Bracelet',
                                icon = 'user',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleProps',
                                shouldClose = true
                            }, {
                                id = 'Watch',
                                title = 'Watch',
                                icon = 'stopwatch',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleProps',
                                shouldClose = true
                            }, {
                                id = 'Gloves',
                                title = 'Gloves',
                                icon = 'mitten',
                                type = 'client',
                                event = 'prp-radialmenu:ToggleClothing',
                                shouldClose = true
                            }
                        }
                    }
                }
            }
        }
    },
    -- [4] = {
    --     id = 'vehicle',
    --     title = 'Vehicle',
    --     icon = 'car',
    --     items = {
    --         {
    --             id = 'vehicledoors',
    --             title = 'Vehicle Doors',
    --             icon = 'car-side',
    --             items = {
    --                 {
    --                     id = 'door0',
    --                     title = 'Drivers door',
    --                     icon = 'car-side',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:openDoor',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'door4',
    --                     title = 'Hood',
    --                     icon = 'car',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:openDoor',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'door1',
    --                     title = 'Passengers door',
    --                     icon = 'car-side',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:openDoor',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'door3',
    --                     title = 'Right rear',
    --                     icon = 'car-side',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:openDoor',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'door5',
    --                     title = 'Trunk',
    --                     icon = 'car',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:openDoor',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'door2',
    --                     title = 'Left rear',
    --                     icon = 'car-side',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:openDoor',
    --                     shouldClose = false
    --                 }
    --             }
    --         }, {
    --             id = 'vehicleextras',
    --             title = 'Vehicle Extras',
    --             icon = 'plus',
    --             items = {
    --                 {
    --                     id = 'extra1',
    --                     title = 'Extra 1',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra2',
    --                     title = 'Extra 2',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra3',
    --                     title = 'Extra 3',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra4',
    --                     title = 'Extra 4',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra5',
    --                     title = 'Extra 5',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra6',
    --                     title = 'Extra 6',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra7',
    --                     title = 'Extra 7',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra8',
    --                     title = 'Extra 8',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra9',
    --                     title = 'Extra 9',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra10',
    --                     title = 'Extra 10',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra11',
    --                     title = 'Extra 11',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra12',
    --                     title = 'Extra 12',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }, {
    --                     id = 'extra13',
    --                     title = 'Extra 13',
    --                     icon = 'box-open',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:setExtra',
    --                     shouldClose = false
    --                 }
    --             }
    --         }, {
    --             id = 'vehicleseats',
    --             title = 'Vehicle Seats',
    --             icon = 'chair',
    --             items = {
    --                 {
    --                     id = 'door0',
    --                     title = 'Driver',
    --                     icon = 'chair',
    --                     type = 'client',
    --                     event = 'prp-radialmenu:client:ChangeSeat',
    --                     shouldClose = false
    --                 }
    --             }
    --         }
    --     }
    -- },
    [5] = {
        id = 'jobinteractions',
        title = 'Work',
        icon = 'briefcase',
        items = {}
    }
}

Config.JobInteractions = {
    ["ambulance"] = {
        {
            id = 'statuscheck',
            title = 'Check Health Status',
            icon = 'heartbeat',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true
        }, {
            id = 'revivep',
            title = 'Revive',
            icon = 'user-md',
            type = 'client',
            event = 'hospital:client:RevivePlayer',
            shouldClose = true
        }, {
            id = 'treatwounds',
            title = 'Heal wounds',
            icon = 'band-aid',
            type = 'client',
            event = 'hospital:client:TreatWounds',
            shouldClose = false
        }, {
            id = 'heallorazepam',
            title = 'Give Lorazepam',
            icon = 'pills',
            type = 'client',
            event = 'hospital:client:lorazepam',
            shouldClose = false
        }, {
            id = 'givepainkillers',
            title = 'Give Painkillers',
            icon = 'prescription-bottle-alt',
            type = 'client',
            event = 'hospital:client:givePainkillers',
            shouldClose = false
        }, {
            id = 'emergencybutton2',
            title = 'Emergency button',
            icon = 'bell',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true
        }, {
            id = 'putonbed',
            title = 'Put on Bed',
            icon = 'procedures',
            type = 'client',
            event = 'hospital:client:PutOnBed',
            shouldClose = true
        },
        -- {
        --     id = 'stretcheroptions',
        --     title = 'Stretcher',
        --     icon = 'procedures',
        --     items = {
        --         {
        --             id = 'spawnstretcher',
        --             title = 'Spawn Stretcher',
        --             icon = 'plus',
        --             type = 'client',
        --             event = 'prp-radialmenu:client:TakeStretcher',
        --             shouldClose = false
        --         }, {
        --             id = 'despawnstretcher',
        --             title = 'Remove Stretcher',
        --             icon = 'minus',
        --             type = 'client',
        --             event = 'prp-radialmenu:client:RemoveStretcher',
        --             shouldClose = false
        --         }
        --     }
        -- }
    },
    ["taxi"] = {
        {
            id = 'togglemeter',
            title = 'Show/Hide Meter',
            icon = 'eye-slash',
            type = 'client',
            event = 'prp-taxi:client:toggleMeter',
            shouldClose = false
        }, {
            id = 'togglemouse',
            title = 'Start/Stop Meter',
            icon = 'hourglass-start',
            type = 'client',
            event = 'prp-taxi:client:enableMeter',
            shouldClose = true
        }, {
            id = 'npc_mission',
            title = 'NPC Mission',
            icon = 'taxi',
            type = 'client',
            event = 'prp-taxi:client:DoTaxiNpc',
            shouldClose = true
        }
    },
    ["tow"] = {
        {
            id = 'togglenpc',
            title = 'Toggle NPC',
            icon = 'toggle-on',
            type = 'client',
            event = 'jobs:client:ToggleNpc',
            shouldClose = true
        }, {
            id = 'towvehicle',
            title = 'Tow vehicle',
            icon = 'truck-pickup',
            type = 'client',
            event = 'prp-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ["mechanic"] = {
        {
            id = 'towvehicle',
            title = 'Tow vehicle',
            icon = 'truck-pickup',
            type = 'client',
            event = 'prp-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ["police"] = {
        {
            id = 'emergencybutton',
            title = 'Emergency button',
            icon = 'bell',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true
        }, {
            id = 'checkvehstatus',
            title = 'Check Tune Status',
            icon = 'info-circle',
            type = 'client',
            event = 'prp-tunerchip:client:TuneStatus',
            shouldClose = true
        }, {
            id = 'resethouse',
            title = 'Reset house lock',
            icon = 'key',
            type = 'client',
            event = 'prp-houses:client:ResetHouse',
            shouldClose = true
        }, {
            id = 'takedriverlicense',
            title = 'Revoke Drivers License',
            icon = 'id-card',
            type = 'client',
            event = 'police:client:SeizeDriverLicense',
            shouldClose = true
        }, {
            id = 'policeinteraction',
            title = 'Police Actions',
            icon = 'tasks',
            items = {
                {
                    id = 'statuscheck',
                    title = 'Check Health Status',
                    icon = 'heartbeat',
                    type = 'client',
                    event = 'hospital:client:CheckStatus',
                    shouldClose = true
                }, {
                    id = 'checkstatus',
                    title = 'Check status',
                    icon = 'question',
                    type = 'client',
                    event = 'police:client:CheckStatus',
                    shouldClose = true
                }, {
                    id = 'escort',
                    title = 'Escort',
                    icon = 'user-friends',
                    type = 'client',
                    event = 'police:client:EscortPlayer',
                    shouldClose = true
                }, {
                    id = 'searchplayer',
                    title = 'Search',
                    icon = 'search',
                    type = 'client',
                    event = 'police:client:SearchPlayer',
                    shouldClose = true
                }, {
                    id = 'jailplayer',
                    title = 'Jail',
                    icon = 'user-lock',
                    type = 'client',
                    event = 'police:client:JailPlayer',
                    shouldClose = true
                }
            }
        }, {
            id = 'policeobjects',
            title = 'Objects',
            icon = 'road',
            items = {
                {
                    id = 'spawnpion',
                    title = 'Cone',
                    icon = 'exclamation-triangle',
                    type = 'client',
                    event = 'police:client:spawnCone',
                    shouldClose = false
                }, {
                    id = 'spawnhek',
                    title = 'Gate',
                    icon = 'torii-gate',
                    type = 'client',
                    event = 'police:client:spawnBarier',
                    shouldClose = false
                }, {
                    id = 'spawnschotten',
                    title = 'Speed Limit Sign',
                    icon = 'sign',
                    type = 'client',
                    event = 'police:client:spawnSchotten',
                    shouldClose = false
                }, {
                    id = 'spawntent',
                    title = 'Tent',
                    icon = 'campground',
                    type = 'client',
                    event = 'police:client:spawnTent',
                    shouldClose = false
                }, {
                    id = 'spawnverlichting',
                    title = 'Lighting',
                    icon = 'lightbulb',
                    type = 'client',
                    event = 'police:client:spawnLight',
                    shouldClose = false
                }, {
                    id = 'spikestrip',
                    title = 'Spike Strips',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'police:client:SpawnSpikeStrip',
                    shouldClose = false
                }, {
                    id = 'deleteobject',
                    title = 'Remove object',
                    icon = 'trash',
                    type = 'client',
                    event = 'police:client:deleteObject',
                    shouldClose = false
                }
            }
        }
    },
    ["hotdog"] = {
        {
            id = 'togglesell',
            title = 'Toggle sell',
            icon = 'hotdog',
            type = 'client',
            event = 'prp-hotdogjob:client:ToggleSell',
            shouldClose = true
        }
    },
    ["galaxy"] = {
        {
            id = 'galaxycharage',
            title = 'Charage Customer',
            icon = 'coins',
            type = 'client',
            event = "prp-payments:client:Charge",
            shouldClose = true,
            img = "<center><p><img src=https://static.wixstatic.com/media/9ea32b_f3565e8b4bfd4e819efd69eeea4b0c49~mv2.png/v1/fill/w_530,h_141,al_c,lg_1,q_85,enc_auto/galaxy.png width=150px></p>"
        }
    },
    ["fightclub"] = {
        {
            id = 'fightclubcharage',
            title = 'Charage Customer',
            icon = 'coins',
            type = 'client',
            event = "prp-payments:client:Charge",
            shouldClose = true,
            img = "<center><p><img src=https://cdn.discordapp.com/attachments/812831286082666537/979108299368714320/unknown.png width=150px></p>"
        }
    }
}

Config.TrunkClasses = {
    [0] = {allowed = true, x = 0.0, y = -1.5, z = 0.0}, -- Coupes  
    [1] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Sedans  
    [2] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- SUVs  
    [3] = {allowed = true, x = 0.0, y = -1.5, z = 0.0}, -- Coupes  
    [4] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Muscle  
    [5] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Sports Classics  
    [6] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Sports  
    [7] = {allowed = true, x = 0.0, y = -2.0, z = 0.0}, -- Super  
    [8] = {allowed = false, x = 0.0, y = -1.0, z = 0.25}, -- Motorcycles  
    [9] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Off-road  
    [10] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Industrial  
    [11] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Utility  
    [12] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Vans  
    [13] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Cycles  
    [14] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Boats  
    [15] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Helicopters  
    [16] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Planes  
    [17] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Service  
    [18] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Emergency  
    [19] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Military  
    [20] = {allowed = true, x = 0.0, y = -1.0, z = 0.25}, -- Commercial  
    [21] = {allowed = true, x = 0.0, y = -1.0, z = 0.25} -- Trains  
}

Config.ExtrasEnabled = true

Config.Commands = {
    ["top"] = {
        Func = function() ToggleClothing("Top") end,
        Sprite = "top",
        Desc = "Take your shirt off/on",
        Button = 1,
        Name = "Torso"
    },
    ["gloves"] = {
        Func = function() ToggleClothing("Gloves") end,
        Sprite = "gloves",
        Desc = "Take your gloves off/on",
        Button = 2,
        Name = "Gloves"
    },
    ["visor"] = {
        Func = function() ToggleProps("Visor") end,
        Sprite = "visor",
        Desc = "Toggle hat variation",
        Button = 3,
        Name = "Visor"
    },
    ["bag"] = {
        Func = function() ToggleClothing("Bag") end,
        Sprite = "bag",
        Desc = "Opens or closes your bag",
        Button = 8,
        Name = "Bag"
    },
    ["shoes"] = {
        Func = function() ToggleClothing("Shoes") end,
        Sprite = "shoes",
        Desc = "Take your shoes off/on",
        Button = 5,
        Name = "Shoes"
    },
    ["vest"] = {
        Func = function() ToggleClothing("Vest") end,
        Sprite = "vest",
        Desc = "Take your vest off/on",
        Button = 14,
        Name = "Vest"
    },
    ["hair"] = {
        Func = function() ToggleClothing("Hair") end,
        Sprite = "hair",
        Desc = "Put your hair up/down/in a bun/ponytail.",
        Button = 7,
        Name = "Hair"
    },
    ["hat"] = {
        Func = function() ToggleProps("Hat") end,
        Sprite = "hat",
        Desc = "Take your hat off/on",
        Button = 4,
        Name = "Hat"
    },
    ["glasses"] = {
        Func = function() ToggleProps("Glasses") end,
        Sprite = "glasses",
        Desc = "Take your glasses off/on",
        Button = 9,
        Name = "Glasses"
    },
    ["ear"] = {
        Func = function() ToggleProps("Ear") end,
        Sprite = "ear",
        Desc = "Take your ear accessory off/on",
        Button = 10,
        Name = "Ear"
    },
    ["neck"] = {
        Func = function() ToggleClothing("Neck") end,
        Sprite = "neck",
        Desc = "Take your neck accessory off/on",
        Button = 11,
        Name = "Neck"
    },
    ["watch"] = {
        Func = function() ToggleProps("Watch") end,
        Sprite = "watch",
        Desc = "Take your watch off/on",
        Button = 12,
        Name = "Watch",
        Rotation = 5.0
    },
    ["bracelet"] = {
        Func = function() ToggleProps("Bracelet") end,
        Sprite = "bracelet",
        Desc = "Take your bracelet off/on",
        Button = 13,
        Name = "Bracelet"
    },
    ["mask"] = {
        Func = function() ToggleClothing("Mask") end,
        Sprite = "mask",
        Desc = "Take your mask off/on",
        Button = 6,
        Name = "Mask"
    }
}

local Bags = {[40] = true, [41] = true, [44] = true, [45] = true}

Config.ExtraCommands = {
    ["pants"] = {
        Func = function() ToggleClothing("Pants", true) end,
        Sprite = "pants",
        Desc = "Take your pants off/on",
        Name = "Pants",
        OffsetX = -0.04,
        OffsetY = 0.0
    },
    ["shirt"] = {
        Func = function() ToggleClothing("Shirt", true) end,
        Sprite = "shirt",
        Desc = "Take your shirt off/on",
        Name = "shirt",
        OffsetX = 0.04,
        OffsetY = 0.0
    },
    ["reset"] = {
        Func = function()
            if not ResetClothing(true) then
                Notify('Nothing To Reset', 'error')
            end
        end,
        Sprite = "reset",
        Desc = "Revert everything back to normal",
        Name = "reset",
        OffsetX = 0.12,
        OffsetY = 0.2,
        Rotate = true
    },
    ["bagoff"] = {
        Func = function() ToggleClothing("Bagoff", true) end,
        Sprite = "bagoff",
        SpriteFunc = function()
            local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
            local BagOff = LastEquipped["Bagoff"]
            if LastEquipped["Bagoff"] then
                if Bags[BagOff.Drawable] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            end
            if Bag ~= 0 then
                if Bags[Bag] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            else
                return false
            end
        end,
        Desc = "Take your bag off/on",
        Name = "bagoff",
        OffsetX = -0.12,
        OffsetY = 0.2
    }
}
