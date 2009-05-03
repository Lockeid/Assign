Assign = LibStub("AceAddon-3.0"):NewAddon("Assign")

local defaults = {
	["skull"] = "Main Focus",
	["cross"] = "Second Focus",
	["star"] = "Sap",
	["circle"] = "Hibernate",
	["diamond"] = "Seduce",
	["triangle"] = "Shackle undead",
	["moon"] = "First sheep",
	["square"] = "Freezing Trap",
		
}

local channels = {
	["Default channel"] = 3,	
	["Default channel Name"] = "Party"
}



function Assign:OnInitialize()
	AssignDB = AssignDB or {}
	AssignDB.icons = setmetatable(AssignDB.icons or {}, {__index = defaults})
	AssignDB.channel = setmetatable(AssignDB.channel or {}, {__index = channels})

	--LoadDefaults()
	SlashCmdList["Assign"] = function()				
					InterfaceOptionsFrame_OpenToCategory("Assign")  	
					end
	SLASH_Assign1 = "/assign"
	
	end

function Assign:SendAssignments(channel, to)
	--if icon == "all" or (not icon) then
		for icon, message in pairs(defaults) do
			message = AssignDB.icons[icon]
			if (not channel) then
				SendChatMessage(("{"..icon.."} "..string.upper(string.sub(icon,1,1))..string.sub(icon,2)..": "..message),AssignDB.channel["Default channel Name"])
			elseif string.lower(channel) ~= "whisper" then
				SendChatMessage(("{"..icon.."} "..string.upper(string.sub(icon,1,1))..string.sub(icon,2)..": "..message),string.upper(channel))
			else
				SendChatMessage(("{"..icon.."} "..string.upper(string.sub(icon,1,1))..string.sub(icon,2)..": "..message),string.upper(channel), nil, to)
			end
		end
	--end			

end

local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local AssignLDB = LDB:NewDataObject('Assign', {
type = 'data source',
icon = 'Interface\\Icons\\INV_Misc_EngGizmos_31',
OnClick = function(self, button)
	GameTooltip:Hide()
	if button ~= "RightButton" then
		InterfaceOptionsFrame_OpenToCategory("Assign")
	else
		Assign:SendAssignments(AssignDB.channel["Default channel Name"])		
	end
end
})

AssignLDB.OnEnter = function(self)
 	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
	GameTooltip:ClearLines()
	
	GameTooltip:AddLine("Assign")
	GameTooltip:AddDoubleLine("Left Click","Open the config panel",201/255,118/255,0,0,201/255,180/255)
	GameTooltip:AddDoubleLine("Right Click","Send the assignments to the default channel",201/255,118/255,0,0,201/255,180/255)
	GameTooltip:Show()
end


