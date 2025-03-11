"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[886],{15169:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetItemDetailsAsync","desc":"Retrieves item details asynchronously.","params":[{"name":"Item","desc":"The item ID.","lua_type":"number"},{"name":"ItemType","desc":"The type of the item.","lua_type":"AvatarItemType"}],"returns":[{"desc":"","lua_type":"Promise<table>"}],"function_type":"method","source":{"line":20,"path":"src/client/MainModule/init.lua"}},{"name":"GetUserInventoryAsync","desc":"Retrieves user inventory asynchronously.","params":[{"name":"AssetTypes","desc":"The types of assets to retrieve.","lua_type":"table"}],"returns":[{"desc":"","lua_type":"Promise<InventoryPages>"}],"function_type":"method","source":{"line":43,"path":"src/client/MainModule/init.lua"}},{"name":"GetOutfitsAsync","desc":"Retrieves outfits asynchronously.","params":[{"name":"OutfitSource","desc":"The source of the outfits.","lua_type":"number"},{"name":"OutfitType","desc":"The type of the outfits.","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Promise<OutfitPages>"}],"function_type":"method","source":{"line":64,"path":"src/client/MainModule/init.lua"}},{"name":"GetBatchItemDetailsAsync","desc":"Retrieves batch item details asynchronously.","params":[{"name":"IDs","desc":"The IDs of the items.","lua_type":"table"},{"name":"ItemType","desc":"The type of the items.","lua_type":"AvatarItemType"}],"returns":[{"desc":"","lua_type":"Promise<table>"}],"function_type":"method","source":{"line":85,"path":"src/client/MainModule/init.lua"}},{"name":"CreateOutfit","desc":"Prompts the creation of an outfit.","params":[{"name":"HumanoidDescription","desc":"The humanoid description.","lua_type":"HumanoidDescription"},{"name":"RigType","desc":"The rig type.","lua_type":"Enum.HumanoidRigType"}],"returns":[],"function_type":"method","source":{"line":105,"path":"src/client/MainModule/init.lua"}}],"properties":[],"types":[],"name":"Main","desc":"A module to handle avatar-related functionalities on the client side.","source":{"line":10,"path":"src/client/MainModule/init.lua"}}')}}]);