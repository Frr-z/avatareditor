local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Promise)

--[=[
    @class Client
    A module to handle avatar-related functionalities on the client side.
]=]
local Client = {}

--[=[
    Retrieves item details asynchronously.
    @method GetItemDetailsAsync
    @within Client
    @param Item number -- The item ID.
    @param ItemType AvatarItemType -- The type of the item.
    @return Promise<table>
]=]
function Client:GetItemDetailsAsync(Item, ItemType)
    return Promise.new(function(Resolve, Reject)
        local Details
        local Success, Error = pcall(function()
            Details = AvatarEditorService:GetItemDetails(Item, ItemType)
        end)
        if not Success then
            return Reject(Error or "Can't get item details")
        end
        if type(Details) ~= "table" then
            return Reject("Detail type isn't a table")
        end
        return Resolve(Details)
    end):catch(warn)
end

--[=[
    Retrieves user inventory asynchronously.
    @method GetUserInventoryAsync
    @within Client
    @param AssetTypes table -- The types of assets to retrieve.
    @return Promise<InventoryPages>
]=]
function Client:GetUserInventoryAsync(AssetTypes)
    return Promise.new(function(Resolve, Reject)
        local InventoryPage
        local Success, Error = pcall(function()
            InventoryPage = AvatarEditorService:GetInventory(AssetTypes)
        end)
        if not Success or type(InventoryPage) ~= "InventoryPages" then
            return Reject(Error or "Error retrieving inventory")
        end
        return Resolve(InventoryPage)
    end):catch(warn)
end

--[=[
    Retrieves outfits asynchronously.
    @method GetOutfitsAsync
    @within Client
    @param OutfitSource number -- The source of the outfits.
    @param OutfitType number -- The type of the outfits.
    @return Promise<OutfitPages>
]=]
function Client:GetOutfitsAsync(OutfitSource, OutfitType)
    return Promise.new(function(Resolve, Reject)
        local Outfit
        local Success, Error = pcall(function()
            Outfit = AvatarEditorService:GetOutfits(OutfitSource or 1, OutfitType or 1)
        end)
        if not Success or type(Outfit) ~= "OutfitPages" then
            return Reject(Error or "Error while loading outfit")
        end
        return Resolve(Outfit)
    end):catch(warn)
end

--[=[
    Retrieves batch item details asynchronously.
    @method GetBatchItemDetailsAsync
    @within Client
    @param IDs table -- The IDs of the items.
    @param ItemType AvatarItemType -- The type of the items.
    @return Promise<table>
]=]
function Client:GetBatchItemDetailsAsync(IDs, ItemType)
    return Promise.new(function(Resolve, Reject)
        local Array
        local Success, Error = pcall(function()
            Array = AvatarEditorService:GetBatchItemDetails(IDs, ItemType)
        end)
        if not Success or type(Array) ~= "table" then
            return Reject(Error or "Error while getting batch")
        end
        return Resolve(Array)
    end):catch(warn)
end

--[=[
    Prompts the creation of an outfit.
    @method CreateOutfit
    @within Client
    @param HumanoidDescription HumanoidDescription -- The humanoid description.
    @param RigType Enum.HumanoidRigType -- The rig type.
]=]
function Client:CreateOutfit(HumanoidDescription, RigType)
    AvatarEditorService:PromptCreateOutfit(HumanoidDescription, RigType)
end

return Client