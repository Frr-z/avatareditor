# Avatar editor utils

Some [promise](https://eryn.io/roblox-lua-promise/)-based methods to deal with Roblox Avatar Editor Service, Humanoid Descriptions and Web APIs easier

## Instalation

[RobloxModel]("https://www.roblox.com/library/12074132482/AvatarEditor") -> Read the README script

For Rojo users, just put the MainModule folders inside your Server/Client directory and the Promise inside ReplicatedStorage

## Usage 

The function names are pretty self-explanatory. Don't forget to do your type checking before calling the function (--!strict)

Make sure to put "" in the string parameters that you won't use

```lua
Players.PlayerAdded:Connect(function(player)
        Main:GetUserInventoryAsync(player.UserId, ""):andThen(function(Response)
            Main:GetItensByCategory("1", "", "", "", ""):andThenCall(foo, "args")
        end)    
end)
```

## Contributing

Consider making a issue for major changes. Pull requests are welcome!!

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
