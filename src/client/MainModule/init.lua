
local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Promise)


function Main:GetItemDetailsAsync(Item : number, ItemType :  AvatarItemType)
    return Promise.new(function(Resolve, Reject)
        local Details
        local Sucess, Error = pcall(function()
             Details = AvatarEditorService:GetItemDetails(Item, Type)
        end)
        if not Sucess then 
            return Reject(Error or "Can't get item details")
        end
        if type(Details) ~= "table" then 
            return Reject(Error or "Detail type isn't a table")
        end
        return Resolve(Details)
    end):catch(warn)
end  


function Main:GetUserInventoryAsync(AssetTypes)
    return Promise.new(function(Resolve, Reject)
        local InventoryPage 
        local Sucess, Error = pcall(function()
            InventoryPage = AvatarEditorService:GetInventory(AssetTypes)
        end)

        if not Sucess or type(InventoryPage) ~= "InventoryPages" then 
            return Reject(Error or "Err")
        end

        return Resolve(InventoryPage)
    end):catch(warn)
end    


function Main:GetOutfitsAsync(OutfitSource, OutfitType)
return Promise.new(function(Resolve, Reject)
    local Outfit 

    local Sucess, Error = pcall(function()
        Outfit = AvatarEditorService:GetOutfits(OutfitSource or 1, OutfitType or 1)
    end)

    if not Sucess or type(Outfit) ~= "OutfitPages" then 
      return Reject(Error or "error while loading outfit")
    end

    return Resolve(Outfit)
end):catch(warn)
end

function Main:GetBatchItemDetailsAsync(IDs : table, ItemType : AvatarItemType) 
    return Promise.new(function(Resolve, Reject)
        local Array
        local Sucess, Error = pcall(function()
            Array = AvatarEditorService:GetBatchItemDetails()
        end)

        if not Sucess or type(Array) ~= "table" then 
            Reject(Error or "Error while getting batch")
        end     

        return Resolve(Array)
    end):catch(warn)
end

function Main:CreateOutfit(HumanoidDescription, RigType)
    AvatarEditorService:PromptCreateOutfit(HumanoidDescription, RigType)    
end



return Main
