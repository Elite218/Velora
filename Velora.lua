local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ✅ Replace this with your actual whitelist URL
local whitelistURL = "https://raw.githubusercontent.com/Elite218/Velora/refs/heads/main/whitelist.json"

-- Function to safely fetch the whitelist data
local function fetchWhitelist()
	local success, result = pcall(function()
		return game:HttpGet(whitelistURL)
	end)

	if not success then
		warn("[Whitelist] ⚠️ Failed to load whitelist:", result)
		player:Kick("Whitelist check failed. Please try again later.")
		return nil
	end

	local decoded
	local ok, err = pcall(function()
		decoded = HttpService:JSONDecode(result)
	end)

	if not ok or not decoded or not decoded.whitelist then
		warn("[Whitelist] ⚠️ Invalid or corrupt whitelist file.")
		player:Kick("Whitelist file invalid. Contact the developer.")
		return nil
	end

	return decoded.whitelist
end

-- Function to check if player is whitelisted
local function isPlayerWhitelisted(whitelistData, userId)
	for _, entry in ipairs(whitelistData) do
		if entry.id == userId then
			return true, entry.name
		end
	end
	return false
end

-- Main check
local whitelistData = fetchWhitelist()
if not whitelistData then return end

local allowed, testerName = isPlayerWhitelisted(whitelistData, player.UserId)

if allowed then
	print("[Whitelist] ✅ Access granted to:", player.Name, "(" .. tostring(testerName) .. ")")

	-- ✅ Load your actual GUI here
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Elite218/Velora/refs/heads/main/VeloraUIscript.lua"))()

else
	warn("[Whitelist] ❌ Access denied for:", player.Name)
	player:Kick("You do not have access to this script.")
end
