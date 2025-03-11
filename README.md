# Avatar Editor Utils

A collection of [promise](https://eryn.io/roblox-lua-promise/)-based methods to simplify working with Roblox Avatar Editor Service, Humanoid Descriptions, and Web APIs.

## Installation

### For Studio Users
You can find a model in my profile. Unfortunately, I can't provide the link here.

### For Rojo Users
1. Place the `AEServer` and `AEClient` folders inside your `Server` and `Client` directories.
2. Place the `Promise` and `Signal` modules inside `ReplicatedStorage`.

## Usage

The function names are self-explanatory. Ensure you perform type checking before calling the functions. Pass `nil` for any parameters you don't use.

### Example

```lua
local Main = require(ReplicatedStorage.MainModule)

Players.PlayerAdded:Connect(function(player)
    Main:GetUserInventoryAsync(player.UserId, nil):andThen(function(response)
        print("User Inventory:", response)
        return Main:GetItemsByCategory("1", nil, nil, nil, nil)
    end):andThen(function(items)
        print("Items by Category:", items)
    end):catch(function(error)
        warn("Error:", error)
    end)
end)
```

### Available Methods

#### Client Methods
- `GetItemDetailsAsync(Item, ItemType)`
- `GetUserInventoryAsync(AssetTypes)`
- `GetOutfitsAsync(OutfitSource, OutfitType)`
- `GetBatchItemDetailsAsync(IDs, ItemType)`
- `CreateOutfit(HumanoidDescription, RigType)`

#### Server Methods
- `GetHumanoidDescriptionFromUserId(Id)`
- `GetHumanoidDescriptionFromUsername(PlayerName)`
- `MorphFromPlayerIdAsync(PlayerToBeMorphed, PlayerToMorphId)`
- `RemovePlayerAccessories(Player)`
- `RemoveModelAccessories(Model)`
- `AddPlayerAccessory(Player, Accessory)`
- `AddModelAccessory(Model, Accessory)`
- `GetCharacterAppearanceInfoAsync(Id)`
- `GetPlayerGears(Id)`
- `GetUserInventoryAsync(Id, Cursor)`
- `CheckIfUserOwnsItem(Id, ItemId)`
- `GetItemsByCategory(Category, Subcategory, SalesTypeFilter, Cursor, SortType, CreatorName)`
- `GetRolimonsLimitedsInfos()`
- `GetCurrentOutfit(Player)`
- `SaveCurrentOutfit(Player, OutfitName)`
- `LoadSavedOutfit(Player, OutfitId)`

## Contributing

For major changes, please open an issue first to discuss what you would like to change. Pull requests are welcome!

Please ensure that you update tests as appropriate.

## License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).