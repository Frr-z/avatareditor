--!strict
-- ^^ so p garantir :thumbsup:
local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Promise = require(ReplicatedStorage.Promise)


local Main = {}

local Loaded = {}

function Main:GetHumanoidDescriptionFromUserId(Id : number)
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

function Main:GetHumanoidDescriptionFromUsername(PlayerName : string)
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

function Main:MorphFromPlayerIdAsync(PlayerToBeMorphed : Player, PlayerToMorphId : number)
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

function Main:RemovePlayerAccessories(Player : Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid:RemoveAccessories()
end

function Main:AddPlayerAccessories(Player : Player, Accessory : Accessory)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid:AddAccessory(Accessory)
end

function Main:GetCharacterAppearanceInfoAsync(Id : number)
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

function Main:GetPlayerGears(PlayerId : number)
	return Promise.new(function(Resolve, Reject)
		local Url = "https://inventory.roproxy.com/v2/users/%s/inventory?assetTypes=Gear&limit=100&sortOrder=Asc"
		local Response
		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync(Url:format(PlayerId)))
		end)

		if not Sucess then
			return Reject(Error)
		end

		return Resolve(Response)
	end):catch(warn)
end

function Main:GetUserInventoryAsync(PlayerId : number, Cursor : string)
	return Promise.new(function(Resolve, Reject)

		if Loaded[PlayerId] == nil then 
			Loaded[PlayerId] = {
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
		if Cursor ~= "" then 
			Cursor = "&cursor="..Cursor
		end

		local Response

		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync("https://inventory.roproxy.com/v2/users/"..tostring(PlayerId).."/inventory?assetTypes=Gear%2C,Hat%2C,TShirt%2C,Shirt%2C,Pants%2C,Head%2C,Face%2C,Animation%2C,Torso%2C,RightArm%2C,LeftArm%2C,LeftLeg%2C,RightLeg%2C,Package%2C,HairAccessory%2C,FaceAccessory%2C,NeckAccessory%2C,ShoulderAccessory%2C,FrontAccessory%2C,BackAccessory%2C,WaistAccessory%2C,ClimbAnimation%2C,DeathAnimation%2C,FallAnimation%2C,IdleAnimation%2C,JumpAnimation%2C,RunAnimation%2C,SwimAnimation%2C,WalkAnimation%2C,PoseAnimation%2C,TShirtAccessory%2C,ShirtAccessory%2C,PantsAccessory%2C,JacketAccessory%2C,SweaterAccessory%2C,ShortsAccessory%2C,LeftShoeAccessory%2C,RightShoeAccessory%2C,DressSkirtAccessory%2C,EyebrowAccessory%2C,EyelashAccessory%2C,MoodAnimation%2C,DynamicHead"..Cursor.."&limit=100&sortOrder=Asc"))
		end)


		if not Sucess then 
			return Reject(Error)
		elseif Sucess and Response then
			for _, Item in ipairs(Response.data) do 
				if Loaded[PlayerId][Item.assetType] ~= nil then
					table.insert(Loaded[PlayerId][Item.assetType], Item)
				end
			end
		end

		return Resolve({
			["data"] = Loaded[PlayerId],
			["nextPageCursor"] = Response.nextPageCursor,
			["previousPageCursor"] = Response.previousPageCursor
		})

	end):catch(warn)
end    

function Main:CheckIfUserOwnsItem(PlayerId : number, ItemId : number) : boolean
	return Promise.new(function(Resolve, Reject)
		local Url = "https://inventory.roproxy.com/v1/users/"..tostring(PlayerId).."/items/Asset/"..tostring(ItemId).."/is-owned"
		local Response 
		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync(Url))
		end)

		if not Sucess then
			return Reject(Error)
		end    

		return Resolve(Response)
	end):catch(warn)
end    

function Main:GetItensByCategory(Category : string, Cursor : string, SortType : string, Subcategory : string, CreatorName: string)
	return Promise.new(function(Resolve, Reject)
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
		local Response
		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync(Url, true))
		end)

		if not Sucess then
			return Reject(Error)
		elseif Sucess and Response then    
			return Resolve({
				["data"] = Response.data,
				["nextPageCursor"] = Response.nextPageCursor,
				["previousPageCursor"] = Response.previousPageCursor
			})
		end


	end):catch(warn)
end

function Main:GetRolimonsLimitedsInfos()
	return Promise.new(function(Resolve, Reject)
		local Response 
		local Sucess, Error = pcall(function()
			Response = HttpService:JSONDecode(HttpService:GetAsync("https://www.rolimons.com/itemapi/itemdetails"))
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
		return Resolve(Data)
	end):catch(warn)
end

return Main