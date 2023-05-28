-- Create the main addon frame
local frame = CreateFrame("Frame", "MyGroupAddonFrame", UIParent)
frame:SetSize(200, 100)
frame:SetPoint("BOTTOMLEFT", GroupFinderFrame, "BOTTOMLEFT", 0, 0)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
frame:SetBackdropColor(0, 0, 0, 1)
frame:Hide() -- Start with the frame hidden

-- Create a font string to display the group keys
local fontString = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fontString:SetPoint("CENTER")
fontString:SetText("")

-- Function to fetch and display the group keys
local function FetchGroupKeys()
    -- Fetch your group keys here
    -- Replace the code below with your own logic to get the keys
    
    -- Example keys for demonstration purposes
    local keys = {"+14", "+15", "+16", "+17", "+18"}
    
    -- Update the font string with the keys
    fontString:SetText(table.concat(keys, ", "))
end

-- Function to initiate a search with the selected key
local function InitiateSearch(selectedKey)
    -- Implement the logic to initiate a search with the selected key
    -- Replace the code below with your own search functionality
    print("Searching for key:", selectedKey)
end

-- Function to handle key button clicks
local function KeyButtonOnClick(self)
    local selectedKey = self:GetText()
    InitiateSearch(selectedKey)
end

-- Function to update the frame visibility and keys when needed
local function UpdateFrame()
    if GroupFinderFrame:IsShown() then
        frame:Show()
        FetchGroupKeys()
    else
        frame:Hide()
    end
end

-- Register events to update the frame visibility and keys
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "MyGroupAddon" then
            UpdateFrame()
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        UpdateFrame()
    end
end)

-- Create key buttons based on the fetched keys
local function CreateKeyButtons(keys)
    local numKeys = #keys
    local buttonHeight = 20

    for i = 1, numKeys do
        local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        button:SetWidth(frame:GetWidth() - 20)
        button:SetHeight(buttonHeight)
        button:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10 - (i - 1) * buttonHeight)
        button:SetText(keys[i])
        button:SetScript("OnClick", KeyButtonOnClick)
    end
end

-- Initialize the addon by creating the key buttons
CreateKeyButtons({})
