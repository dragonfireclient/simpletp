local function tp_func(y, goal)
	return function()
		local player = minetest.localplayer
		local pos = player:get_pos()

		if pos.y < y then
			return false, "Can't teleport to " .. goal .. " from this location."
		end

		pos.y = y
		player:set_pos(pos)
		return true
	end
end

local function disconnect_wrapper(func)
	return function()
		local success, msg = func()
		if success then
			minetest.after(0, minetest.disconnect)
		end
		return success, msg
	end
end

local function menu_wrapper(func)
	return function()
		local _, msg = func()
		if msg then
			minetest.display_chat_message(msg)
		end
	end
end

local end_func = tp_func(-27000, "End")
local nether_func = tp_func(-29000, "Nether")
local spawn_func = disconnect_wrapper(tp_func(-32000, "Spawn"))

minetest.register_chatcommand("end", {
	description = "Teleport to the end (works in the overworld only). This may drop you above the void, so make sure you have Fly or Jetpack enabled.",
	func = end_func,
})

minetest.register_chatcommand("nether", {
	description = "Teleport to the nether (works in the overworld or the end). This may move you into solid blocks, so make sure you have a pickaxe ready or Noclip enabled.",
	func = nether_func,
})

minetest.register_chatcommand("spawn", {
	description = "Teleport to your spawn location. This will disconnect you, you have to reconnect afterwards.",
	func = spawn_func,
})

minetest.register_cheat("End", "Exploit", menu_wrapper(end_func))
minetest.register_cheat("Nether", "Exploit", menu_wrapper(nether_func))
minetest.register_cheat("Spawn", "Exploit", menu_wrapper(spawn_func))
