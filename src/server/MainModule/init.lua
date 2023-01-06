--!nonstrict
-- ^^ so p garantir :thumbsup:
local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Promise = require(ReplicatedStorage.Promise)


local Main = {}

--[[export type Accessory = {
    Order : number, 
	AssetId : number,
	Puffiness : number,
	AccessoryType : Enum.AccessoryType,
	IsLayered : boolean
}]]

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
    self:GetHumanoidDescriptionFromUserId(Players:GetUserIdFromNameAsync(PlayerName))
end

function Main:MorphFromPlayerIdAsync(PlayerToBeMorphed : Player, PlayerToMorphId : number)
    return Promise.new(function(Resolve, Reject)
        self:GetHumanoidDescriptionFromUserId(PlayerToMorphId):andThen(function(HumanoidDescription)
            local Character = PlayerToBeMorphed.Character or PlayerToBeMorphed.CharacterAdded:Wait()
            local Humanoid = Character:FindFirstChild("Humanoid")
            print(PlayerToBeMorphed, PlayerToMorphId, HumanoidDescription, Character, Humanoid)
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

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		Main:MorphFromPlayerIdAsync(player, 2528081463)
	end)
end)


return Main