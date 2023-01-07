"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[266],{95168:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetHumanoidDescriptionFromUserId","desc":"Returns a HumanoidDescription which specifies everything equipped for the avatar of the user specified by the passed in Id. Also includes scales and body colors.\\n ","params":[{"name":"Id","desc":"The userId of the specified player.","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Promise<HumanoidDescription?>"}],"function_type":"method","realm":["Server"],"source":{"line":28,"path":"src/server/MainModule/init.lua"}},{"name":"GetHumanoidDescriptionFromUsername","desc":"Returns a HumanoidDescription which specifies everything equipped for the avatar of the user specified by the passed in PlayerName. Also includes scales and body colors.\\n ","params":[{"name":"PlayerName","desc":"The username of the specified player.","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Promise<HumanoidDescription?>"}],"function_type":"method","realm":["Server"],"source":{"line":55,"path":"src/server/MainModule/init.lua"}},{"name":"MorphFromPlayerIdAsync","desc":"This function Morphs a player into another one based on its current avatar.\\n ","params":[{"name":"PlayerToBeMorphId","desc":"The player that will morph into another one","lua_type":"Player"},{"name":"PlayerToBeMorphed","desc":"The player that will have its HumanoidDescription applied in the other one","lua_type":"Player"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":83,"path":"src/server/MainModule/init.lua"}},{"name":"RemovePlayerAccessories","desc":"This function removes ALL the player accessories just with its Player Instance.\\n ","params":[{"name":"Player","desc":"The Player to remove accessories","lua_type":"Player"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":113,"path":"src/server/MainModule/init.lua"}},{"name":"AddPlayerAccessories","desc":"This function adds a SINGLE accessory into player\'s character\\n ","params":[{"name":"Player","desc":"The player to add accessory","lua_type":"Player"},{"name":"Accessory","desc":"The accessory to add into the player\'s character","lua_type":"Accessory"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":130,"path":"src/server/MainModule/init.lua"}},{"name":"GetCharacterAppearanceInfoAsync","desc":"This function returns information about a player\'s avatar (ignoring gear) on the Roblox website in the form of a dictionary.\\n ","params":[{"name":"Id","desc":"The userId of the specified player.","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Promise<table?>"}],"function_type":"method","realm":["Server"],"source":{"line":147,"path":"src/server/MainModule/init.lua"}},{"name":"GetPlayerGears","desc":"This function returns information about a player\'s gears on the Roblox website in the form of a dictionary.\\n ","params":[{"name":"Id","desc":"The userId of the specified player.","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Promise<table?>"}],"function_type":"method","realm":["Server"],"source":{"line":173,"path":"src/server/MainModule/init.lua"}},{"name":"GetUserInventoryAsync","desc":"Returns an dictionary with information about owned items in the users inventory.\\n ","params":[{"name":"Id","desc":"The userId of the specified player.","lua_type":"number"},{"name":"Cursor","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Promise<table?>"}],"function_type":"method","realm":["Server"],"source":{"line":201,"path":"src/server/MainModule/init.lua"}},{"name":"CheckIfUserOwnsItem","desc":"Returns whether the inventory of given PlayerId contains an item, given the ID. ","params":[{"name":"Id","desc":"The userId of the specified player.","lua_type":"number"},{"name":"ItemId","desc":"The itemId of the specified item.","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Promise<boolean?>"}],"function_type":"method","realm":["Server"],"source":{"line":293,"path":"src/server/MainModule/init.lua"}},{"name":"GetItensByCategory","desc":"Loads relevant itens of each Category and/or Subcategory with/without its filters. Check https://create.roblox.com/docs/studio/catalog-api#:~:text=%7D-,Avatar%20Catalog%20API,-You%20can%20query ","params":[{"name":"Category","desc":"Check link below for more details","lua_type":"string"},{"name":"Cursos","desc":"Check link below for more details","lua_type":"string"},{"name":"SortType","desc":"Check link below for more details","lua_type":"string"},{"name":"Subcategory","desc":"Check link below for more details","lua_type":"string"},{"name":"CreatorName","desc":"Check link below for more details","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Promise<table?>"}],"function_type":"method","realm":["Server"],"source":{"line":323,"path":"src/server/MainModule/init.lua"}},{"name":"GetRolimonsLimitedsInfos","desc":"Loads all Rolimons.com limiteds with all available the informations\\t\\n ","params":[],"returns":[{"desc":"","lua_type":"Promise<table?>"}],"function_type":"method","realm":["Server"],"source":{"line":370,"path":"src/server/MainModule/init.lua"}}],"properties":[],"types":[],"name":"AvatarEditor","desc":" \\nAvatarEditor Simple module to deal with some resources involving catalog and inventory and player avatar.","source":{"line":13,"path":"src/server/MainModule/init.lua"}}')}}]);