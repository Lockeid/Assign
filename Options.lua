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



--[[local function LoadDefaults()

	for k,v in next, defaults do
		if(type(AssignDB[k]) == 'nil') then
			AssignDB[k] = v
		end
	end
 
end]]

function Assign:OnEnable()
	--AssignDB = AssignDB or {}
	--AssignDB.icons = setmetatable(AssignDB.icons or {}, {__index = defaults})
	--AssignDB.channel = setmetatable(AssignDB.channel or {}, {__index = channels})

	Assign:LoadConfigFirstPage()
	Assign:LoadConfigOutputPage()
	local about = LibStub("tekKonfig-AboutPanel").new("Assign", "Assign")
end


-- First page to set messages
function Assign:LoadConfigFirstPage()
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	frame.name = "Assign"
	frame.parent = nil 
	frame.addonname = "Assign"
	frame:Hide()
	frame:SetScript("OnShow", Assign.MessagesOnShow)
	InterfaceOptions_AddCategory(frame)
end


function Assign:LoadConfigOutputPage()
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	frame.name = "Output"
	frame.parent = "Assign" 
	--frame.addonname = "Assign"
	frame:Hide()
	frame:SetScript("OnShow", Assign.OutputOnShow)
	InterfaceOptions_AddCategory(frame)
end
	

-- Stuff for the first page
local editbox = CreateFrame('EditBox', nil, UIParent)
editbox:Hide()
editbox:SetAutoFocus(true)
editbox:SetHeight(32)
editbox:SetFontObject('GameFontHighlightSmall')
Assign.editbox = editbox

local left = editbox:CreateTexture(nil, "BACKGROUND")
left:SetWidth(8) left:SetHeight(20)
left:SetPoint("LEFT", -5, 0)
left:SetTexture("Interface\\Common\\Common-Input-Border")
left:SetTexCoord(0, 0.0625, 0, 0.625)

local right = editbox:CreateTexture(nil, "BACKGROUND")
right:SetWidth(8) right:SetHeight(20)
right:SetPoint("RIGHT", 0, 0)
right:SetTexture("Interface\\Common\\Common-Input-Border")
right:SetTexCoord(0.9375, 1, 0, 0.625)

local center = editbox:CreateTexture(nil, "BACKGROUND")
center:SetHeight(20)
center:SetPoint("RIGHT", right, "LEFT", 0, 0)
center:SetPoint("LEFT", left, "RIGHT", 0, 0)
center:SetTexture("Interface\\Common\\Common-Input-Border")
center:SetTexCoord(0.0625, 0.9375, 0, 0.625)


editbox:SetScript("OnTextChanged", function(self)
	self:GetParent():SetText(self:GetText())
end)

editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
editbox:SetScript("OnEnterPressed", function (self)
	editbox:ClearFocus()
	AssignDB.icons[self:GetParent().icon] = self:GetText()
	getglobal("Assign_Config."..self:GetParent().icon):SetText("|cff9999ff"..AssignDB.icons[self:GetParent().icon])
end)

editbox:SetScript("OnEditFocusLost",function(self)
	editbox:Hide()
	getglobal("Assign_Config."..self:GetParent().icon):SetText("|cff9999ff"..AssignDB.icons[self:GetParent().icon])
end)
editbox:SetScript("OnEditFocusGained", editbox.HighlightText)


function Assign.OpenEditboxMessages(self)
	editbox:SetText(AssignDB.icons[self.icon])
	getglobal("Assign_Config."..self.icon):SetText("")
	editbox:SetParent(self)
	editbox:SetPoint("LEFT", self)
	editbox:SetPoint("RIGHT", self)
	editbox:Show()
end


local ri = {"Skull", "Cross", "Star", "Circle", "Diamond", "Triangle", "Moon", "Square"}

local chan = {"Raid","Raid Warning","Party","Say"}

local function HideTooltip() GameTooltip:Hide() end

local function ShowTooltipMessages(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	GameTooltip:SetText("Click and type the message you want")
end


function  Assign.MessagesOnShow(frame)
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Assign", "Settings to change the raid icons messages.")

	local anchor
	for _,field in pairs(ri) do
		local lowerfield = field:lower()
		local val = AssignDB.icons[lowerfield]
		if val then
			local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			title:SetWidth(75)
			if not anchor then title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)
			else title:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6) end
			title:SetJustifyH("RIGHT")
			title:SetText(field)

			local detail = frame:CreateFontString(("Assign_Config."..lowerfield), "ARTWORK", "GameFontHighlightSmall")
			detail:SetPoint("LEFT", title, "RIGHT", 4, 0)
			detail:SetPoint("RIGHT", -16, 0)
			detail:SetJustifyH("LEFT")
			detail.icon = lowerfield
			detail:SetText("|cff9999ff".. AssignDB.icons[lowerfield])
			
			

			
				local button = CreateFrame("Button", nil, frame)
				button:SetAllPoints(detail)
				button.icon = lowerfield
				button.val = val
				button:SetScript("OnClick", Assign.OpenEditboxMessages)				
				button:SetScript("OnEnter", ShowTooltipMessages)
				button:SetScript("OnLeave", HideTooltip)
			

			anchor = title
		end
	end
	frame:SetScript("OnShow", nil)
end

function Assign.OutputOnShow(frame)
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Assign - Output", "Settings to output the messages.")
	
	local anchor

	function Assign.UpdateChannel(dropdown,self,option)
		self.text:SetText(chan[option])
		AssignDB.channel["Default channel"] = option
		AssignDB.channel["Default channel Name"] = string.upper(chan[option])
		
	end

	function Assign:AddButton(frame, text, option)
		local info = UIDropDownMenu_CreateInfo()
		info.text = text		
		info.arg1 = frame
		info.arg2 = option
		info.func = Assign.UpdateChannel
		UIDropDownMenu_AddButton(info)
	end

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	title:SetWidth(300)
	title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)
	title:SetJustifyH("LEFT")
	title:SetText("Choose the default channel to send assignments.")	

	local function CreateDropdown(frameType)
		local dropdown, text = LibStub("tekKonfig-Dropdown").new(frame, frameType.." text")
		dropdown.text = text
		dropdown.label = frameType
		UIDropDownMenu_Initialize(dropdown, function()
			for i, _ in pairs(chan) do
				Assign:AddButton(dropdown, chan[i], i)
			end
		end)
		return dropdown
	end
	local channel = CreateDropdown("Default channel")
	channel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 4, -4)

	local LibButton = LibStub("tekKonfig-Button")


	-- Buttons to send assignments
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	title:SetWidth(300)
	title:SetPoint("TOPLEFT", channel, "BOTTOMLEFT", -4, -15)
	title:SetJustifyH("LEFT")
	title:SetText("Click the buttons to send assignments.")	

	local party = LibStub("tekKonfig-Button").new(frame)
	party:SetText("Party")
	party:SetPoint("TOPLEFT",title,"BOTTOMLEFT",4,-10)
	party:SetScript("OnClick",function() Assign:SendAssignments("PARTY") end)

	local raid = LibStub("tekKonfig-Button").new(frame)
	raid:SetText("Raid")
	raid:SetPoint("TOPLEFT",party,"BOTTOMLEFT",0,-5)
	raid:SetScript("OnClick",function() Assign:SendAssignments("RAID") end)

	local rw = LibStub("tekKonfig-Button").new(frame)
	rw:SetText("Raid Warning")
	rw:SetPoint("TOPLEFT",raid,"BOTTOMLEFT",0,-5)
	rw:SetScript("OnClick",function() Assign:SendAssignments("RAID_WARNING") end)

	local say = LibStub("tekKonfig-Button").new(frame)
	say:SetText("Say")
	say:SetPoint("TOPLEFT",rw,"BOTTOMLEFT",0,-5)
	say:SetScript("OnClick",function() Assign:SendAssignments("SAY") end)

	local function OnShow()
		channel.text:SetText(chan[AssignDB.channel["Default channel"]])
	end
	
	OnShow(frame)


	frame:SetScript("OnShow", nil)
end
