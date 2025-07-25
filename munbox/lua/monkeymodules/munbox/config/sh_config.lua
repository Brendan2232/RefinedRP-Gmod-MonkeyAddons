MUnbox = MUnbox or {}
MUnbox.Config = MUnbox.Config or {}

MUnbox.Config.InventorySpace = 75 // How many rows of inventory space they have. 

MUnbox.Config.Messages = {
    
    ["crate_purchase_success"] = "Sucessfully purchased '%s'.", 
    ["crate_purchase_fail"] = "Failed to purchase crate.", 

    ["crate_unbox_fail"] = "Failed to unbox crate.",
    
    ["query_confirm_delete"] = "Are you sure you'd like to delete this item?", 
    ["query_cant_revert"] = "Note: This action can't be reverted.", 

    ["cant_afford"] = "You can't afford to purchase this item.", 

    ["inventory_success"] = "Item was successfully inserted!", 
    ["inventory_no_space"] = "No inventory space.", 
    ["inventory_fail"] = "Failed to insert item into your inventory.", 
    
    ["item_delete_fail"] = "Failed to delete item", 
    ["item_delete_success"] = "Successfully deleted item!", 

    ["item_equip_fail"] = "Failed to equip item.", 
    ["item_equip_dupe"] = "Can't equip the same item twice!", 

    ["item_equip_equiped"] = "Item is already equiped!", 
    ["item_unequip_fail"] = "Failed to unequip item.", 

    ["item_unequip_success"] = "Successfully unequiped item!", 
    ["item_equip_success"] = "Successfully equiped item!", 

    ["market_sell_success"] = "Successfully sold item!", 
    ["market_sell_fail"] = "Failed to sell item.", 

    ["market_purchase_success"] = "Successfully purchased item!", 
    ["market_purchase_fail"] = "Failed to purchase item.", 
    
}

MUnbox.Config.Logs = {

    ["unbox_crate"] = "%s | %s Unboxed %s crate.", 
    ["purchase_crate"] = "%s | %s Purchased Crate %s, with the price of %s.", 

    ["item_added"] = "%s | %s Got item %s added to their inventory.", 
    ["item_deleted"] = "%s | %s Deleted item %s from their inventory.", 
        
    ["item_equip"] = "%s | %s Equiped item %s.", 
    ["item_unequip"] = "%s | %s UnEquiped item %s.", 

}

MUnbox.Icons = {

    {
        ["iconID"] = "m_unbox_search", 
        ["iconLink"] = "https://i.imgur.com/Qnd6wgr.png", 
        ["iconParamaters"] = "noclamp smooth", 
    }, 

    {
        ["iconID"] = "m_unbox_store", 
        ["iconLink"] = "https://i.imgur.com/jRax90s.png", 
        ["iconParamaters"] = "noclamp smooth", 
    }, 
    
    {
        ["iconID"] = "m_unbox_wallet", 
        ["iconLink"] = "https://i.imgur.com/84jBVjV.png", 
        ["iconParamaters"] = "noclamp smooth", 
    }, 
    
    {
        ["iconID"] = "m_unbox_crate_2", 
        ["iconLink"] = "https://i.imgur.com/PfxBulD.png", 
        ["iconParamaters"] = "noclamp smooth", 
    }, 
    { 
        ["iconID"] = "m_scoreboard_arrow", 
        ["iconLink"] = "https://i.imgur.com/oWDUc6J.png", 
        ["iconParamaters"] = "noclamp smooth", 
    }, 

}

MUnbox.Tabs = {

    {
        ["Name"] = "Store", 
        ["Icon"] = "m_unbox_store", 
        ["VGUIPanel"] = "MonkeyUnbox:StorePanel",
        ["StartsActive"] = true, 
    },

    {
        ["Name"] = "Inventory", 
        ["Icon"] = "m_unbox_wallet", 
        ["VGUIPanel"] = "MonkeyUnbox:InventoryPanel",
        ["StartsActive"] = false, 
    },

}


