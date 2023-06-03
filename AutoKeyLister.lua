local numRows = 0
local rows = {} -- Keep track of the created rows
local keystoneTable = {}
local mapName = ""
local playerKeystone = ""

local function GetDungeonAbbreviation(dungeonID)
    local abbreviation = ""

    if dungeonID == 251 then
        abbreviation = "UNDR"
    elseif dungeonID == 245 then
        abbreviation = "FH"
    elseif dungeonID == 438 then
        abbreviation = "VP"
    elseif dungeonID == 405 then
        abbreviation = "BH"
    elseif dungeonID == 406 then
        abbreviation = "HOI"
    elseif dungeonID == 403 then
        abbreviation = "ULD"
    elseif dungeonID == 206 then
        abbreviation = "NL"
    elseif dungeonID == 404 then
        abbreviation = "NELT"
    else
        abbreviation = "No Key"

    end

    return abbreviation
end

local function getDungeonListingID(dungeonAbbreviation)
    local dungeonListingId = ""

    if dungeonAbbreviation == "UNDR" then
        dungeonListingId = 507
    elseif dungeonAbbreviation == "FH" then
        dungeonListingId = 518
    elseif dungeonAbbreviation == "VP" then
        dungeonListingId = 1195
    elseif dungeonAbbreviation == "BH" then
        dungeonListingId = 1164
    elseif dungeonAbbreviation == "HOI" then
        dungeonListingId = 1168
    elseif dungeonAbbreviation == "ULD" then
        dungeonListingId = 1188
    elseif dungeonAbbreviation == "NL" then
        dungeonListingId = 462
    elseif dungeonAbbreviation == "NELT" then
        dungeonListingId = 1172
    else
        dungeonListingId = "NoKey"

    end

    return dungeonListingId
end

-- Create the main addon frame
local autoKeyListerFrame = CreateFrame("Frame", "AutoKeyListerFrame", PVEFrame,
                                       "TooltipBorderBackdropTemplate")
autoKeyListerFrame:SetSize(220, 130)
autoKeyListerFrame:SetPoint("BOTTOMLEFT", PVEFrame, "BOTTOMRIGHT", -220, -130)
autoKeyListerFrame:SetBackdropColor(DARKGRAY_COLOR:GetRGBA())

local originalSettings = {}

local function storeOriginalSettings()
    local LFGListFrameEntry = LFGListFrame.EntryCreation
    originalSettings.point = {LFGListFrameEntry:GetPoint()}
    originalSettings.labelHidden = LFGListFrameEntry.Label:IsShown()
    originalSettings.groupDropDownHidden = not LFGListEntryCreationGroupDropDown:IsShown()
    originalSettings.activityDropDownHidden = not LFGListEntryCreationActivityDropDown:IsShown()
    originalSettings.crossFactionGroupHidden = not LFGListFrameEntry.CrossFactionGroup:IsShown()
    originalSettings.privateGroupHidden = not LFGListFrameEntry.PrivateGroup:IsShown()
    originalSettings.cancelButtonHidden = not LFGListFrameEntry.CancelButton:IsShown()
    originalSettings.listGroupButtonHidden = not LFGListFrameEntry.ListGroupButton:IsShown()
    originalSettings.pvpItemLevelHidden = not LFGListFrameEntry.PvpItemLevel:IsShown()
    originalSettings.pvpRatingHidden = not LFGListFrameEntry.PVPRating:IsShown()
    originalSettings.playStyleDropDownHidden = not LFGListEntryCreationPlayStyleDropdown:IsShown()
    originalSettings.creationDescriptionHidden = not LFGListCreationDescription:IsShown()
    originalSettings.descriptionLabelHidden = not LFGListFrameEntry.DescriptionLabel:IsShown()
    originalSettings.nameLabelPoint = {LFGListFrameEntry.NameLabel:GetPoint()}
    originalSettings.namePoint = {LFGListFrameEntry.Name:GetPoint()}
    originalSettings.nameSize = {LFGListFrameEntry.Name:GetSize()}
    originalSettings.mythicPlusRatingPoint = {LFGListFrameEntry.MythicPlusRating:GetPoint()}
    originalSettings.mythicPlusRatingEditBoxPoint = {LFGListFrameEntry.MythicPlusRating.EditBox:GetPoint()}
    originalSettings.mythicPlusRatingEditBoxSize = {LFGListFrameEntry.MythicPlusRating.EditBox:GetSize()}
    originalSettings.itemLevelPoint = {LFGListFrameEntry.ItemLevel:GetPoint()}
end

local function resetDungeonSettings()
    local LFGListFrameEntry = LFGListFrame.EntryCreation
    LFGListFrameEntry:SetPoint(unpack(originalSettings.point))
    LFGListFrameEntry.Label:SetShown(originalSettings.labelHidden)
    LFGListEntryCreationGroupDropDown:SetShown(not originalSettings.groupDropDownHidden)
    LFGListEntryCreationActivityDropDown:SetShown(not originalSettings.activityDropDownHidden)
    LFGListFrameEntry.CrossFactionGroup:SetShown(not originalSettings.crossFactionGroupHidden)
    LFGListFrameEntry.PrivateGroup:SetShown(not originalSettings.privateGroupHidden)
    LFGListFrameEntry.CancelButton:SetShown(not originalSettings.cancelButtonHidden)
    LFGListFrameEntry.ListGroupButton:SetShown(not originalSettings.listGroupButtonHidden)
    LFGListFrameEntry.PvpItemLevel:SetShown(not originalSettings.pvpItemLevelHidden)
    LFGListFrameEntry.PVPRating:SetShown(not originalSettings.pvpRatingHidden)
    LFGListEntryCreationPlayStyleDropdown:SetShown(not originalSettings.playStyleDropDownHidden)
    LFGListCreationDescription:SetShown(not originalSettings.creationDescriptionHidden)
    LFGListFrameEntry.DescriptionLabel:SetShown(not originalSettings.descriptionLabelHidden)
    LFGListFrameEntry.NameLabel:SetPoint(unpack(originalSettings.nameLabelPoint))
    LFGListFrameEntry.Name:SetPoint(unpack(originalSettings.namePoint))
    LFGListFrameEntry.Name:SetSize(unpack(originalSettings.nameSize))
    LFGListFrameEntry.MythicPlusRating:SetPoint(unpack(originalSettings.mythicPlusRatingPoint))
    LFGListFrameEntry.MythicPlusRating.EditBox:SetPoint(unpack(originalSettings.mythicPlusRatingEditBoxPoint))
    LFGListFrameEntry.MythicPlusRating.EditBox:SetSize(unpack(originalSettings.mythicPlusRatingEditBoxSize))
    LFGListFrameEntry.ItemLevel:SetPoint(unpack(originalSettings.itemLevelPoint))
    LFGListFrameEntry:Show()
end
local function createDungeonSettings()
    local LFGListFrameEntry = LFGListFrame.EntryCreation
    LFGListFrameEntry:SetPoint("TOPLEFT", autoKeyListerFrame, "TOPRIGHT", 220,
                               -150)
    LFGListFrameEntry.Label:Hide()
    LFGListEntryCreationGroupDropDown:Hide()
    LFGListEntryCreationActivityDropDown:Hide()
    LFGListFrameEntry.CrossFactionGroup:Hide()
    LFGListFrameEntry.PrivateGroup:Hide()
    LFGListFrameEntry.CancelButton:Hide()
    LFGListFrameEntry.ListGroupButton:Hide()
    LFGListFrameEntry.PvpItemLevel:Hide()
    LFGListFrameEntry.PVPRating:Hide()
    LFGListEntryCreationPlayStyleDropdown:Hide()
    LFGListCreationDescription:Hide()
    LFGListFrameEntry.DescriptionLabel:Hide()
    LFGListFrameEntry.NameLabel:SetPoint("TOPLEFT", autoKeyListerFrame,
                                         "TOPRIGHT", 20, -2)
    LFGListFrameEntry.Name:SetPoint("TOPLEFT", autoKeyListerFrame, "TOPRIGHT",
                                    20, -20)
    -- LFGListFrameEntry.Name:SetPlaceholderText("A manuel written Title is needed to start the key")
    LFGListFrameEntry.Name:SetSize(285, 25)
    LFGListFrameEntry.MythicPlusRating:SetPoint("TOPLEFT", autoKeyListerFrame,
                                                "TOPRIGHT", 15, -50)

    LFGListFrameEntry.MythicPlusRating.EditBox:SetPoint("TOPLEFT",
                                                        autoKeyListerFrame,
                                                        "TOPRIGHT", 170, -50)
    LFGListFrameEntry.MythicPlusRating.EditBox:SetSize(-50, 0)

    LFGListFrameEntry.ItemLevel:SetPoint("TOPLEFT", autoKeyListerFrame,
                                         "TOPRIGHT", 15, -75)
    LFGListFrameEntry:Show()

end

local function AddRowToTable(rowData)
    local row = CreateFrame("Frame", nil, autoKeyListerFrame)
    row:SetSize(200, 20)

    -- Calculate the vertical position of the row
    local yOffset = -(numRows * 20) - 5
    if numRows > 0 then
        yOffset = yOffset - (numRows * 2) -- Adjust spacing between rows
    end
    row:SetPoint("TOP", 0, yOffset)

    for i, data in ipairs(rowData) do
        local cell = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")

        if i == 1 then
            -- Print unitName in the color of their class
            local unitName = data
            local unitClass = select(2, UnitClass(unitName))
            local classColor = RAID_CLASS_COLORS[unitClass]
            if classColor then
                cell:SetTextColor(classColor.r, classColor.g, classColor.b)
            end
            cell:SetPoint("LEFT", 0, 0)

            local cutoffName = strsub(unitName, 1, 8) -- Cut off name after 8 characters
            local hyphenIndex = strfind(cutoffName, "-", 1, true) -- Find "-" character in the cutoff name
            if hyphenIndex and hyphenIndex <= 8 then
                cutoffName = strsub(cutoffName, 1, hyphenIndex - 1) -- Cut off at the hyphen
            end

            cell:SetText(cutoffName)
        else
            -- Print other data with default color
            cell:SetPoint("LEFT", 60, 0) -- Adjust the x-offset here as per your desired spacing
            cell:SetText(data)
        end
    end

    local queueButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    queueButton:SetSize(60, 20)
    queueButton:SetPoint("RIGHT", 3, 0)
    queueButton:SetText("Queue")
    queueButton:SetScript("OnClick", function()
        local user, keystone = unpack(rowData)
        local keystoneName = string.match(keystone, "(%a+)")
        local dungeonListingId = getDungeonListingID(keystoneName)
        
        if dungeonListingId == "NoKey" then
            return
        elseif (LFGListFrame.EntryCreation.Name:GetText() == "") then
            LFGListFrame.EntryCreation.Name.Instructions:SetTextColor(1, 0, 0)      
        else
            LFGListFrame.EntryCreation.Name.Instructions:SetTextColor(1, 1, 1)
            C_LFGList.CreateListing(dungeonListingId, 0, 0)
            
        end
    end)

    numRows = numRows + 1
end

local function ClearTableFrame()
    for i = 1, numRows do
        local row = rows[i]
        if row then
            row:Hide() -- Hide the row
            row:SetParent(nil) -- Remove the parent

            -- Clear the row's cells
            for j = 1, row:GetNumChildren() do
                local cell = select(j, row:GetChildren())
                cell:SetText("")
            end
        end
    end

    numRows = 0
    rows = {}
end

local function importKeys()
    local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
    local keystoneData

    if (IsInGroup()) then openRaidLib.RequestKeystoneDataFromParty() end

    keystoneData = openRaidLib.GetAllKeystonesInfo()

    if keystoneData then
        ClearTableFrame()
        for unitName, keystoneInfo in pairs(keystoneData) do
            mapName = GetDungeonAbbreviation(keystoneInfo.challengeMapID)
            playerKeystone = mapName .. " + " .. keystoneInfo.level
            local keystoneRow = {unitName, playerKeystone}

            keystoneTable[#keystoneTable + 1] = keystoneRow
            AddRowToTable(keystoneRow)
        end
    end
end


local dungeonSearchButton = LFGListFrame.CategorySelection.StartGroupButton
dungeonSearchButton:SetScript("OnClick", function()
    --resetDungeonSettings()
    LFGListFrame.EntryCreation:Show()
end)


local dungeonsFrame = CreateFrame("Frame")
dungeonsFrame:RegisterEvent("ADDON_LOADED")
dungeonsFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

dungeonsFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED" and addonName == "AutoKeyLister") or
        (event == "GROUP_ROSTER_UPDATE" and addonName == "AutoKeyLister") then
        
        local lfgFrame = PVEFrame
        local dungeonButton = LFDMicroButton
        local premadeGroupButton = GroupFinderFrameGroupButton3

        dungeonButton:SetScript("OnClick", function()
            if lfgFrame:IsShown() then
                lfgFrame:Hide()
            else
                lfgFrame:Show()
                storeOriginalSettings()
                LFGListFrame.EntryCreation.Name.Instructions:SetText("You need to put a title to queue a key!!!")
                premadeGroupButton:Click()
                createDungeonSettings()
            end
        end)

        lfgFrame:SetScript("OnShow", function()
            ClearTableFrame()
            importKeys()
            -- LFGListFrameEntry:Show()
            -- Your custom code here
            -- AccessDetailsFunction()
        end)

        lfgFrame:SetScript("OnHide", function()
            ClearTableFrame() -- Clear the keystoneTable data when the frame is hidden
        end)
    end
end)
