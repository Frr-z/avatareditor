local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Promise = require(ReplicatedStorage.Promise)
local Signal = require(ReplicatedStorage.Signal)

--[=[
    @class AvatarEditor
    A module to handle avatar-related functionalities.
]=]
local AvatarEditor = {}
AvatarEditor.__index = AvatarEditor

local Cached = {}
local CacheSignal = Signal.new()
local CacheLimit = 200 
local CachedCount = 0

local LoadedInventories = {}

CacheSignal:Connect(function(Url, Response)
	if Cached[Url] == nil and CachedCount <= CacheLimit then
		CachedCount += 1
		Cached[Url] = {
			data = Response,
			Index = CachedCount
		}
	else
		for Url, Data in pairs(Cached) do
			if Data.Index == 1 then
				Cached[Url] = nil
			end
		end
		CachedCount -= 1
	end
end)

--[=[
    Retrieves cached data for a given URL.
    @method GetCached
    @within AvatarEditor
    @param Url string -- The URL to check in the cache.
    @return table? -- The cached data or nil if not found.
]=]
function AvatarEditor:GetCached(Url)
	return Cached[Url]
end

--[=[
    Retrieves a humanoid description from a user ID.
    @method GetHumanoidDescriptionFromUserId
    @within AvatarEditor
    @param Id number -- The user ID.
    @return Promise<HumanoidDescription?>
]=]
function AvatarEditor:GetHumanoidDescriptionFromUserId(Id)
	return Promise.new(function(Resolve, Reject)
		local Description
		local Success, Error = pcall(function()
			Description = Players:GetHumanoidDescriptionFromUserId(Id)
		end)
		if not Success then
			return Reject(Error)
		end
		return Resolve(Description)
	end):catch(warn)
end

--[=[
    Retrieves a humanoid description from a username.
    @method GetHumanoidDescriptionFromUsername
    @within AvatarEditor
    @param PlayerName string -- The username.
    @return Promise<HumanoidDescription?>
]=]
function AvatarEditor:GetHumanoidDescriptionFromUsername(PlayerName)
	return Promise.new(function(Resolve, Reject)
		local Description
		local Success, Error = pcall(function()
			Description = Players:GetHumanoidDescriptionFromUserId(Players:GetUserIdFromNameAsync(PlayerName))
		end)
		if not Success then
			return Reject(Error)
		end
		return Resolve(Description)
	end):catch(warn)
end

--[=[
    Morphs a player into another player's avatar.
    @method MorphFromPlayerIdAsync
    @within AvatarEditor
    @param PlayerToBeMorphed Player -- The player to be morphed.
    @param PlayerToMorphId number -- The ID of the player to morph into.
    @return Promise<void>
]=]
function AvatarEditor:MorphFromPlayerIdAsync(PlayerToBeMorphed, PlayerToMorphId)
	return self:GetHumanoidDescriptionFromUserId(PlayerToMorphId):andThen(function(HumanoidDescription)
		local Character = PlayerToBeMorphed.Character or PlayerToBeMorphed.CharacterAdded:Wait()
		local Humanoid = Character:FindFirstChild("Humanoid")
		local Success, Error = pcall(function()
			Humanoid:ApplyDescription(HumanoidDescription)
		end)
		if not Success then
			return Promise.reject(Error)
		end
		return Promise.resolve()
	end):catch(warn)
end

--[=[
    Removes all accessories from a player's character.
    @method RemovePlayerAccessories
    @within AvatarEditor
    @param Player Player -- The player whose accessories will be removed.
]=]
function AvatarEditor:RemovePlayerAccessories(Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid:RemoveAccessories()
end

--[=[
    Removes all accessories from a model.
    @method RemoveModelAccessories
    @within AvatarEditor
    @param Model Instance -- The model whose accessories will be removed.
]=]
function AvatarEditor:RemoveModelAccessories(Model)
	local Humanoid = Model:FindFirstChild("Humanoid")
	Humanoid:RemoveAccessories()
end

--[=[
    Adds an accessory to a player's character.
    @method AddPlayerAccessory
    @within AvatarEditor
    @param Player Player -- The player to add the accessory to.
    @param Accessory Accessory -- The accessory to add.
]=]
function AvatarEditor:AddPlayerAccessory(Player, Accessory)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid:AddAccessory(Accessory)
end

--[=[
    Adds an accessory to a model.
    @method AddModelAccessory
    @within AvatarEditor
    @param Model Instance -- The model to add the accessory to.
    @param Accessory Accessory -- The accessory to add.
]=]
function AvatarEditor:AddModelAccessory(Model, Accessory)
	local Humanoid = Model:FindFirstChild("Humanoid")
	Humanoid:AddAccessory(Accessory)
end

--[=[
    Retrieves character appearance information asynchronously.
    @method GetCharacterAppearanceInfoAsync
    @within AvatarEditor
    @param Id number -- The user ID.
    @return Promise<table?>
]=]
function AvatarEditor:GetCharacterAppearanceInfoAsync(Id)
	return Promise.new(function(Resolve, Reject)
		local Result
		local Success, Error = pcall(function()
			Result = Players:GetCharacterAppearanceInfoAsync(Id)
		end)
		if not Success then
			return Reject(Error or "Error retrieving character appearance info")
		end
		return Resolve(Result)
	end):catch(warn)
end

--[=[
    Retrieves player gears asynchronously.
    @method GetPlayerGears
    @within AvatarEditor
    @param Id number -- The user ID.
    @return Promise<table?>
]=]
function AvatarEditor:GetPlayerGears(Id)
	local Url = ("users/%s/inventory?assetTypes=Gear&limit=100&sortOrder=Asc"):format(Id)
	return Promise.new(function(Resolve, Reject)
		if self:GetCached(Url) then
			return Resolve(self:GetCached(Url))
		else
			local Response
			local Success, Error = pcall(function()
				Response = HttpService:JSONDecode(HttpService:GetAsync("https://inventory.roproxy.com/v2/" .. Url))
			end)
			if not Success then
				return Reject(Error)
			end
			CacheSignal:Fire(Url, Response.data)
			return Resolve(Response)
		end
	end):catch(warn)
end

--[=[
    Retrieves user inventory asynchronously.
    @method GetUserInventoryAsync
    @within AvatarEditor
    @param Id number -- The user ID.
    @param Cursor string? -- The cursor for pagination.
    @return Promise<table?>
]=]
function AvatarEditor:GetUserInventoryAsync(Id, Cursor)
    local function fetchInventory(cursor, accumulatedInventory)
        if cursor then
            cursor = "&cursor=" .. cursor
        else
            cursor = ""
        end
        local Url = ("users/%s/inventory?assetTypes=Gear%%2C,Hat%%2C,TShirt%%2C,Shirt%%2C,Pants%%2C,Head%%2C,Face%%2C,Animation%%2C,Torso%%2C,RightArm%%2C,LeftArm%%2C,LeftLeg%%2C,RightLeg%%2C,Package%%2C,HairAccessory%%2C,FaceAccessory%%2C,NeckAccessory%%2C,ShoulderAccessory%%2C,FrontAccessory%%2C,BackAccessory%%2C,WaistAccessory%%2C,ClimbAnimation%%2C,DeathAnimation%%2C,FallAnimation%%2C,IdleAnimation%%2C,JumpAnimation%%2C,RunAnimation%%2C,SwimAnimation%%2C,WalkAnimation%%2C,PoseAnimation%%2C,TShirtAccessory%%2C,ShirtAccessory%%2C,PantsAccessory%%2C,JacketAccessory%%2C,SweaterAccessory%%2C,ShortsAccessory%%2C,LeftShoeAccessory%%2C,RightShoeAccessory%%2C,DressSkirtAccessory%%2C,EyebrowAccessory%%2C,EyelashAccessory%%2C,MoodAnimation%%2C,DynamicHead%s&limit=100&sortOrder=Asc"):format(Id, cursor)
        return Promise.new(function(Resolve, Reject)
            if self:GetCached(Url) then
                return Resolve(self:GetCached(Url))
            else
                if not LoadedInventories[Id] then
                    LoadedInventories[Id] = {}
                end
                local Response
                local Success, Error = pcall(function()
                    Response = HttpService:RequestAsync({
                        Url = "https://inventory.roproxy.com/v2/" .. Url,
                        Method = "GET"
                    })
                end)
                if not Success then
                    return Reject(Error)
                elseif Response.StatusCode == 429 then
                    local RetryAfter = tonumber(Response.Headers["Retry-After"]) or 60
                    task.wait(RetryAfter)
                    return fetchInventory(cursor, accumulatedInventory):andThen(Resolve):catch(Reject)
                elseif Response.StatusCode ~= 200 then
                    return Reject("HTTP Error: " .. Response.StatusCode)
                else
                    local Data = HttpService:JSONDecode(Response.Body)
                    for _, Item in ipairs(Data.data) do
                        if not LoadedInventories[Id][Item.assetType] then
                            LoadedInventories[Id][Item.assetType] = {}
                        end
                        table.insert(LoadedInventories[Id][Item.assetType], Item)
                    end
                    if Data.nextPageCursor then
                        fetchInventory(Data.nextPageCursor, LoadedInventories[Id]):andThen(Resolve):catch(Reject)
                    else
                        CacheSignal:Fire(Url, LoadedInventories[Id])
                        return Resolve(LoadedInventories[Id])
                    end
                end
            end
        end):catch(warn)
    end

    return fetchInventory(Cursor, {})
end

--[=[
    Checks if a user owns a specific item.
    @method CheckIfUserOwnsItem
    @within AvatarEditor
    @param Id number -- The user ID.
    @param ItemId number -- The item ID.
    @return Promise<boolean?>
]=]
function AvatarEditor:CheckIfUserOwnsItem(Id, ItemId)
	local Url = ("users/%s/items/Asset/%s/is-owned"):format(Id, ItemId)
	return Promise.new(function(Resolve, Reject)
		if self:GetCached(Url) then
			return Resolve(self:GetCached(Url))
		else
			local Response
			local Success, Error = pcall(function()
				Response = HttpService:JSONDecode(HttpService:GetAsync("https://inventory.roproxy.com/v1/" .. Url))
			end)
			if not Success then
				return Reject(Error)
			end
			if typeof(Response) == "boolean" and Response ~= nil then
				CacheSignal:Fire(Url, Response)
				return Resolve(Response)
			else
				return Reject("Invalid response format")
			end
		end
	end):catch(warn)
end

--[=[
    Retrieves items by category.
    @method GetItemsByCategory
    @within AvatarEditor
    @param Category string -- The category of items.
    @param Subcategory string? -- The subcategory of items.
    @param SalesTypeFilter string? -- The sales type filter.
    @param Cursor string? -- The cursor for pagination.
    @param SortType string? -- The sort type.
    @param CreatorName string? -- The creator name.
    @return Promise<table?>
]=]
function AvatarEditor:GetItemsByCategory(Category, Subcategory, SalesTypeFilter, Cursor, SortType, CreatorName)
    local function fetchItems(cursor, accumulatedItems)
        if cursor then
            cursor = "&cursor=" .. cursor
        else
            cursor = ""
        end
        local Url = ("search/items/details?Category=%s&Subcategory=%s&SalesTypeFilter=%s&Cursor=%s&SortType=%s&CreatorName=%s&Limit=30"):format(
            Category or "", Subcategory or "", SalesTypeFilter or "", cursor, SortType or "", CreatorName or "")
        return Promise.new(function(Resolve, Reject)
            if self:GetCached(Url) then
                return Resolve(self:GetCached(Url))
            else
                local Response
                local Success, Error = pcall(function()
                    Response = HttpService:RequestAsync({
                        Url = "https://catalog.roproxy.com/v1/" .. Url,
                        Method = "GET"
                    })
                end)
                if not Success then
                    return Reject(Error)
                elseif Response.StatusCode == 429 then
                    local RetryAfter = tonumber(Response.Headers["Retry-After"]) or 60
                    task.wait(RetryAfter)
                    return fetchItems(cursor, accumulatedItems):andThen(Resolve):catch(Reject)
                elseif Response.StatusCode ~= 200 then
                    return Reject("HTTP Error: " .. Response.StatusCode)
                else
                    local Data = HttpService:JSONDecode(Response.Body)
                    for _, Item in ipairs(Data.data) do
                        table.insert(accumulatedItems, Item)
                    end
                    if Data.nextPageCursor then
                        fetchItems(Data.nextPageCursor, accumulatedItems):andThen(Resolve):catch(Reject)
                    else
                        CacheSignal:Fire(Url, accumulatedItems)
                        return Resolve({
                            data = accumulatedItems,
                            nextPageCursor = Data.nextPageCursor,
                            previousPageCursor = Data.previousPageCursor
                        })
                    end
                end
            end
        end):catch(warn)
    end

    return fetchItems(Cursor, {})
end

--[=[
    Retrieves Rolimons limiteds information.
    @method GetRolimonsLimitedsInfos
    @within AvatarEditor
    @return Promise<table?>
]=]
function AvatarEditor:GetRolimonsLimitedsInfos()
	local Url = "itemapi/itemdetails"
	return Promise.new(function(Resolve, Reject)
		if self:GetCached(Url) then
			return Resolve(self:GetCached(Url))
		else
			local Response
			local Success, Error = pcall(function()
				Response = HttpService:JSONDecode(HttpService:GetAsync("https://www.rolimons.com/" .. Url))
			end)
			if not Success then
				return Reject(Error)
			end
			local Data = {}
			for Id, ItemInformation in pairs(Response.items) do
				if not Data[ItemInformation[1]] then
					for Index, Information in pairs(ItemInformation) do
						if ItemInformation[Information] == -1 then
							ItemInformation[Information] = "False or not valued"
						elseif ItemInformation[Information] == 1 or ItemInformation[Information] == 2 then
							ItemInformation[Information] = "true"
						end
					end
					Data[ItemInformation[1]] = {
						Item_Name = ItemInformation[1],
						Acronym = ItemInformation[2],
						Rap = ItemInformation[3],
						Value = ItemInformation[4],
						Default_Value = ItemInformation[5],
						Demand = ItemInformation[6],
						Trend = ItemInformation[7],
						Projected = ItemInformation[8],
						Hyped = ItemInformation[9],
						Rare = ItemInformation[10],
						Item_Id = Id
					}
				end
			end
			CacheSignal:Fire(Url, Response.items)
			return Resolve(Data)
		end
	end):catch(warn)
end

--[=[
    Retrieves the current outfit of a player.
    @method GetCurrentOutfit
    @within AvatarEditor
    @param Player Player -- The player whose current outfit will be retrieved.
    @return Promise<HumanoidDescription?>
]=]
function AvatarEditor:GetCurrentOutfit(Player)
	return Promise.new(function(Resolve, Reject)
		local Character = Player.Character or Player.CharacterAdded:Wait()
		local Humanoid = Character:FindFirstChild("Humanoid")
		if not Humanoid then
			return Reject("Humanoid not found")
		end
		local Description = Humanoid:GetAppliedDescription()
		return Resolve(Description)
	end):catch(warn)
end

--[=[
    Saves the current outfit of a player.
    @method SaveCurrentOutfit
    @within AvatarEditor
    @param Player Player -- The player whose current outfit will be saved.
    @param OutfitName string -- The name of the outfit.
    @return Promise<void>
]=]
function AvatarEditor:SaveCurrentOutfit(Player, OutfitName)
	return Promise.new(function(Resolve, Reject)
		local Character = Player.Character or Player.CharacterAdded:Wait()
		local Humanoid = Character:FindFirstChild("Humanoid")
		if not Humanoid then
			return Reject("Humanoid not found")
		end
		local Description = Humanoid:GetAppliedDescription()
		local Success, Error = pcall(function()
			AvatarEditorService:PromptSaveAvatar(Description, OutfitName)
		end)
		if not Success then
			return Reject(Error)
		end
		return Resolve()
	end):catch(warn)
end

--[=[
    Loads a saved outfit for a player.
    @method LoadSavedOutfit
    @within AvatarEditor
    @param Player Player -- The player whose saved outfit will be loaded.
    @param OutfitId number -- The ID of the saved outfit.
    @return Promise<void>
]=]
function AvatarEditor:LoadSavedOutfit(Player, OutfitId)
	return Promise.new(function(Resolve, Reject)
		local Success, Error = pcall(function()
			AvatarEditorService:PromptSetAvatar(OutfitId)
		end)
		if not Success then
			return Reject(Error)
		end
		return Resolve()
	end):catch(warn)
end

return AvatarEditor