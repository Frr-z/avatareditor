local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Promise = require(ReplicatedStorage.Promise)
local Signal = require(ReplicatedStorage.Signal)

--[=[
  @class AvatarEditor
 
  AvatarEditor Simple module to deal with some resources involving catalog and inventory and player avatar.
]=]

local AvatarEditor = {}
AvatarEditor.__index = AvatarEditor



local Cached = {}
local CacheSignal = Signal.new()
local CacheLimit = 50

local LoadedInventories = {}

CacheSignal:Connect(function(Url, Response)
	if Cached[Url] == nil and #Cached <= CacheLimit then
	   Cached[Url] =  { 
		Data = Response,
		Index = #Cached
	   }
	else 
		for Url, Data in pairs(Cached) do
			if Data.Index == 1 then
				table.remove(Cached, Url)
			end
		end
	end
end)

--[=[
	 Get cached URLs

	 @method GetCached
	 @within AvatarEditor
]=]

function AvatarEditor:GetCached(Url) 
	if Cached[Url] then 
		return Cached[Url]
	else 
		return  nil   
	end    
end

--[=[
	 Returns a HumanoidDescription which specifies everything equipped for the avatar of the user specified by the passed in Id. Also includes scales and body colors.
 
	 @method GetHumanoidDescriptionFromUserId
	 @within AvatarEditor	
	 @param Id number --The userId of the specified player.
	 @server
	 @tag Not cached 
	 @return Promise<HumanoidDescription?>
]=]


function AvatarEditor:GetHumanoidDescriptionFromUserId(Id : number)
	return Promise.new(function(Resolve, Reject)
		local Description 
		local Sucess, Error = pcall(function()
			Description = Players:GetHumanoidDescriptionFromUserId(Id)
		end)
		print(Description)

		if not Sucess then 
			return Reject(Error)
		end

		return Resolve(Description)
	end):catch(warn)
end

--[=[
	 Returns a HumanoidDescription which specifies everything equipped for the avatar of the user specified by the passed in PlayerName. Also includes scales and body colors.
 
	 @method GetHumanoidDescriptionFromUsername
	 @within AvatarEditor	
	 @param PlayerName string -- The username of the specified player.
	 @server
	 @tag Not cached 
	 @return Promise<HumanoidDescription?>
]=]


function AvatarEditor:GetHumanoidDescriptionFromUsername(PlayerName : string)
	return Promise.new(function(Resolve, Reject)
		local Description 
		local Sucess, Error = pcall(function()
			Description = Players:GetHumanoidDescriptionFromUserId(Players:GetUserIdFromNameAsync(PlayerName))
		end)

		print(Description)

		if not Sucess then 
			return Reject(Error)
		end

		return Resolve(Description)
	end):catch(warn)
end

--[=[
	 This function Morphs a player into another one based on its current avatar.
 
	 @method MorphFromPlayerIdAsync
	 @within AvatarEditor	
	 @param PlayerToBeMorphId Player -- The player that will morph into another one
	 @param PlayerToBeMorphed Player -- The player that will have its HumanoidDescription applied in the other one
	 @server
	 @tag Not cached   
]=]


function AvatarEditor:MorphFromPlayerIdAsync(PlayerToBeMorphed : Player, PlayerToMorphId : number)
	return Promise.new(function(Resolve, Reject)
		self:GetHumanoidDescriptionFromUserId(PlayerToMorphId):andThen(function(HumanoidDescription)

			local Character = PlayerToBeMorphed.Character or PlayerToBeMorphed.CharacterAdded:Wait()
			local Humanoid = Character:FindFirstChild("Humanoid")

			local Sucess, Error = pcall(function()
				Humanoid:ApplyDescription(HumanoidDescription) 
			end)

			if not Sucess then 
				return Reject(Error)
			end

			return Resolve()
		end)
	end):catch(warn)
end      

--[=[
	 This function removes ALL the player accessories just with its Player Instance.
 
	 @method RemovePlayerAccessories
	 @within AvatarEditor	
	 @param Player Player -- The Player to remove accessories  
	 @server
	 @tag Not cached   
]=]


function AvatarEditor:RemovePlayerAccessories(Player : Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid:RemoveAccessories()
end

--[=[
	 This function adds a SINGLE accessory into player's character
 
	 @method AddPlayerAccessories
	 @within AvatarEditor	
	 @param Player Player -- The player to add accessory
	 @param Accessory Accessory -- The accessory to add into the player's character 
	 @server
	 @tag Not cached
]=]


function AvatarEditor:AddPlayerAccessories(Player : Player, Accessory : Accessory)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid:AddAccessory(Accessory)
end

--[=[
	 This function returns information about a player's avatar (ignoring gear) on the Roblox website in the form of a dictionary.
 
	 @method GetCharacterAppearanceInfoAsync
	 @within AvatarEditor	
	 @param Id number --The userId of the specified player.
	 @server
	 @tag Not cached
	 @return Promise<table?>
]=]


function AvatarEditor:GetCharacterAppearanceInfoAsync(Id : number)
	return Promise.new(function(Resolve, Reject)
		local Result 
		local Sucess, Error = pcall(function()
			Result = Players:GetCharacterAppearanceInfoAsync(Id)
		end)

		if not Sucess then
			return Reject(Error or "Err")
		end

		return Resolve(Result)
	end):catch(warn)
end

--[=[
	 This function returns information about a player's gears on the Roblox website in the form of a dictionary.
 
	 @method GetPlayerGears
	 @within AvatarEditor	
	 @param Id number --The userId of the specified player.
	 @server
	 @tag Cached
	 @return Promise<table?>
]=]


function AvatarEditor:GetPlayerGears(Id : number)
	local Url = "https://inventory.roproxy.com/v2/users/%s/inventory?assetTypes=Gear&limit=100&sortOrder=Asc"

		return Promise.new(function(Resolve, Reject)
		if AvatarEditor:GetCached(Url) then
			   return Resolve(AvatarEditor:GetCached(Url))
			else

			local Response
			local Sucess, Error = pcall(function()
				Response = HttpService:JSONDecode(HttpService:GetAsync(Url:format(Id)))
			end)
	
			if not Sucess then
				return Reject(Error)
			end
			 
			CacheSignal:Fire(Url, Response.data)
			return Resolve(Response)
		  end
		end):catch(warn)
end

--[=[
	 Returns an dictionary with information about owned items in the users inventory.
 
	 @method GetUserInventoryAsync
	 @within AvatarEditor	
	 @param Id number --The userId of the specified player.
	 @param Cursor string 
	 @server
	 @tag Cached
	 @return Promise<table?>
]=]


function AvatarEditor:GetUserInventoryAsync(Id : number, Cursor : string)
	if Cursor ~= "" then 
		Cursor = "&cursor="..Cursor
	end
	
	local Url = "https://inventory.roproxy.com/v2/users/"..tostring(Id).."/inventory?assetTypes=Gear%2C,Hat%2C,TShirt%2C,Shirt%2C,Pants%2C,Head%2C,Face%2C,Animation%2C,Torso%2C,RightArm%2C,LeftArm%2C,LeftLeg%2C,RightLeg%2C,Package%2C,HairAccessory%2C,FaceAccessory%2C,NeckAccessory%2C,ShoulderAccessory%2C,FrontAccessory%2C,BackAccessory%2C,WaistAccessory%2C,ClimbAnimation%2C,DeathAnimation%2C,FallAnimation%2C,IdleAnimation%2C,JumpAnimation%2C,RunAnimation%2C,SwimAnimation%2C,WalkAnimation%2C,PoseAnimation%2C,TShirtAccessory%2C,ShirtAccessory%2C,PantsAccessory%2C,JacketAccessory%2C,SweaterAccessory%2C,ShortsAccessory%2C,LeftShoeAccessory%2C,RightShoeAccessory%2C,DressSkirtAccessory%2C,EyebrowAccessory%2C,EyelashAccessory%2C,MoodAnimation%2C,DynamicHead"..Cursor.."&limit=100&sortOrder=Asc"
	return Promise.new(function(Resolve, Reject)
		if AvatarEditor:GetCached(Url) then
			return Resolve(AvatarEditor:GetCached(Url))
		 else

		if LoadedInventories[Id] == nil then 
			LoadedInventories[Id] = {
				["Gear"] = {},
				["Hat"] = {},
				["TShirt"] = {},
				["Shirt"] = {},
				["Pants"] = {},
				["Head"] = {},
				["Face"] = {},
				["Animation"] = {},
				["Torso"] = {},
				["RightArm"] = {},
				["LeftArm"] = {},
				["LeftLeg"] = {},
				["RightLeg"] = {},
				["Package"] = {},
				["HairAccessory"] = {},
				["FaceAccessory"] = {},
				["NeckAccessory"] = {},
				["ShoulderAccessory"] = {},
				["FrontAccessory"] = {},
				["BackAccessory"] = {},
				["WaistAccessory"] = {},
				["ClimbAnimation"] = {},
				["DeathAnimation"] = {},
				["FallAnimation"] = {},
				["IdleAnimation"] = {},
				["JumpAnimation"] = {},
				["RunAnimation"] = {},
				["SwimAnimation"] = {},
				["WalkAnimation"] = {},
				["PoseAnimation"] = {},
				["TShirtAccessory"] = {},
				["ShirtAccessory"] = {},
				["PantsAccessory"] = {},
				["JacketAccessory"] = {},
				["SweaterAccessory"] = {},
				["ShortsAccessory"] = {},
				["LeftShoeAccessory"] = {},
				["RightShoeAccessory"] = {},
				["DressSkirtAccessory"] = {},
				["EyebrowAccessory"] = {},
				["EyelashAccessory"] = {},
				["MoodAnimation"] = {},
				["DynamicHead"] = {}
			}
		end


		local Response

		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync(Url))
		end)


		if not Sucess then 
			return Reject(Error)
		elseif Sucess and Response then
			for _, Item in ipairs(Response.data) do 
				if LoadedInventories[Id][Item.assetType] ~= nil then
					table.insert(LoadedInventories[Id][Item.assetType], Item)
				end
			end
		end

			CacheSignal:Fire(Url, Response.data)
		return Resolve({
			["data"] = LoadedInventories[Id],
			["nextPageCursor"] = Response.nextPageCursor,
			["previousPageCursor"] = Response.previousPageCursor
		})
	end
	end):catch(warn)
end    


--[=[
	 Returns whether the inventory of given PlayerId contains an item, given the ID. 
	 
	 @method CheckIfUserOwnsItem
	 @within AvatarEditor	
	 @param Id number --The userId of the specified player.
	 @param ItemId string   --The itemId of the specified item.
	 @server
	 @tag Cached
	 @return Promise<boolean?>
]=]

function AvatarEditor:CheckIfUserOwnsItem(Id : number, ItemId : number) : boolean
	local Url = "https://inventory.roproxy.com/v1/users/"..tostring(Id).."/items/Asset/"..tostring(ItemId).."/is-owned"
	return Promise.new(function(Resolve, Reject)
		if AvatarEditor:GetCached(Url) then
			return Resolve(AvatarEditor:GetCached(Url))
	 else

		local Response 
		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync(Url))
		end)

		if not Sucess then
			return Reject(Error)
		end    

			CacheSignal:Fire(Url, Response.data)
			return Resolve(Response)
	end
	end):catch(warn)
end    

--[=[
	 Loads relevant itens of each Category and/or Subcategory with/without its filters. Check https://create.roblox.com/docs/studio/catalog-api#:~:text=%7D-,Avatar%20Catalog%20API,-You%20can%20query 
	 
	 @method GetItemsByCategory
	 @within AvatarEditor	
	 @param Category string  -- Check link below for more details
	 @param Cursos string -- Check link below for more details
	 @param SortType string -- Check link below for more details
	 @param Subcategory string -- Check link below for more details
	 @param CreatorName string -- Check link below for more details
	 @server
	 @tag Cached
	 @return Promise<table?>
]=]

function AvatarEditor:GetItemsByCategory(Category : string, Cursor : string, SortType : string, Subcategory : string, CreatorName: string)
	if Category ~= "" then
		Category = "Category="..Category
	end
	if Cursor ~= "" then
		Cursor = "&Cursor="..Cursor
	end
	if SortType ~= "" then
		SortType = "&SortType="..SortType
	end
	if Subcategory ~= "" then
		Subcategory = "&Subcategory="..Subcategory
	end
	if CreatorName ~= "" then
		CreatorName = "&CreatorName="..CreatorName
	end
	
	local Url = "https://catalog.roproxy.com/v1/search/items/details?"..Category..Cursor..SortType..Subcategory..CreatorName.."&Limit=30"

	return Promise.new(function(Resolve, Reject)
		if AvatarEditor:GetCached(Url) then
		   return Resolve(AvatarEditor:GetCached(Url))
	 else
		local Response
		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync(Url, true))
		end)

		if not Sucess then
			return Reject(Error)
		elseif Sucess and Response then    
				CacheSignal:Fire(Url, Response.data)
				return Resolve({
				["data"] = Response.data,
				["nextPageCursor"] = Response.nextPageCursor,
				["previousPageCursor"] = Response.previousPageCursor
			})
		end

	end
	end):catch(warn)
end

--[=[
	 Loads all Rolimons.com limiteds with all available the informations	
 
	 @method GetRolimonsLimitedsInfos
	 @within AvatarEditor	
	 @server
	 @tag Cached
	 @return Promise<table?>
]=]

function AvatarEditor:GetRolimonsLimitedsInfos()
	local Url = "https://www.rolimons.com/itemapi/itemdetails"
	return Promise.new(function(Resolve, Reject)
		if AvatarEditor:GetCached(Url) then
		   return Resolve(AvatarEditor:GetCached(Url))
	 else
		local Response 
		local Sucess, Error = pcall(function()
				Response = HttpService:JSONDecode(HttpService:GetAsync(Url))
		end)

		if not Sucess then
			return Reject(Error)
		end

		local Data = {}

		for Id, ItemInformation in pairs(Response.items) do
			
			if Data[ItemInformation[1]] == nil then
				
				for Index, Information in pairs(ItemInformation) do
					if ItemInformation[Information] == -1 then 
						ItemInformation[Information] = "False or not valued"
					elseif ItemInformation[Information] == (1 or 2) then
						ItemInformation[Information] = "true"
					end
				end
								
				Data[ItemInformation[1]] = {
					["Item_Name"] = ItemInformation[1],
					["Acronym"] = ItemInformation[2],
					["Rap"] = ItemInformation[3],
					["Value"] = ItemInformation[4],
					["Default_Value"] = ItemInformation[5],
					["Demand"] = ItemInformation[6],
					["Trend"] = ItemInformation[7],
					["Projected"] = ItemInformation[8],
					["Hyped"] = ItemInformation[9],
					["Rare"] = ItemInformation[10],
					["Item_Id"] = Id
				}
			end
			end
			
			CacheSignal:Fire(Url, Response.items)
			return Resolve(Data)
	end
	end):catch(warn)
end


return AvatarEditor