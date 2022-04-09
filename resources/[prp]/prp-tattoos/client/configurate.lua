
-- Set the clothes IDs, in this case, leave the ped semi naked
list_cloth = {
    {name = "Hats", type = "Prop", item = 0, male_id = 11, female_id = -1},       
    {name = "Glasses", type = "Prop", item = 1, male_id = 14, female_id = 5},         
    {name = "Hats", type = "Variation", item = 1, male_id = 0, female_id = 0},     
    {name = "Shirts", type = "Variation", item = 8, male_id = 15, female_id = 15},  
    {name = "Trunk", type = "Variation", item = 3, male_id = 15, female_id = 15},   
    {name = "Jackets", type = "Variation", item = 11, male_id = 15, female_id = 15},  
    {name = "Trunk", type = "Variation", item = 3, male_id = 15, female_id = 15},   
    {name = "Pants", type = "Variation", item = 4, male_id = 14, female_id = 15},   
    {name = "Shoes", type = "Variation", item = 6, male_id = 73, female_id = 5},   
    {name = "Vest", type = "Variation", item = 9, male_id = 0, female_id = 0},     
    {name = "Bag", type = "Variation", item = 5, male_id = 0, female_id = 0},     
}

-- Tattoos available at the store
tattoos_list = {
    {title = "Hair Degrade", dlc = "hair_degrade", price = 5, qty = 65, acquired = 0, has = false, current = 0}, 
    
    -- Normal
    {title = "Head", dlc = "mpbeach_overlays", price = 100, qty = 99, acquired = 0, has = false, current = 0}, 
    {title = "Torso", dlc = "mpbusiness_overlays", price = 100, qty = 516, acquired = 0, has = false, current = 0}, 
    {title = "Arms", dlc = "mpairraces_overlays", price = 100, qty = 351, acquired = 0, has = false, current = 0}, 
    {title = "Legs", dlc = "mpbiker_overlays", price = 100, qty = 160, acquired = 0, has = false, current = 0}, 
}

-- Extra settings
scale = '1.0'
pos_x = '75%'
pos_y = '25%'
AutoHideClothes = true
freetattoos = false

-- Notify lua
Texts = {
    Open_Store = "Welcome to the Tattoo Shop when you're done just walk out of the store.",                                  
    Close_Store = "Check it later!",                                                  
    Without_money = "You have no money for this purchase.",          
    Spent1 = "you paid",                                
    Spent2 = "an tattoos.", 
    Money_Symbol = "$", 
    KeyNotifyOpenStore = "~h~Busy ~INPUT_PICKUP~ for the tattoo shop",                                    
}

-- Text VUEJS (NUI)
Texts_Nui = {
    Title = "Tattoos Shop",                                                    
    Info1 = "Use your arrow keys to navigate",     
    Info2 = "To buy a tattoo,",                                   
    Info3 = "Press ENTER",                                              
    Info4 = "To delete one",                                   
    Info5 = "Press DELETE",                                             
    ButtonRemoveTattoo = "clear all",                                   
    ButtonTattooRemoved = "Tattoos have been removed",                                 
    Money_Symbol = "$",                                                            
    QtyTattoos = "Qty:",                                                         
    TattoosAcquired = "Tattooed!!!",                                        
    TattoosRemoved = "Tattoo removed !!!",                                         
    AlreadyHaveTattoo = "You already have this.",                                                   
}
