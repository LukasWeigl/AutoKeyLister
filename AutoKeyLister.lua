local numRows = 0
local rows = {} -- Keep track of the created rows
local keystoneTable = {}



-- Create the main addon frame
local autoKeyListerFrame = CreateFrame("Frame", "AutoKeyListerFrame", PVEFrame,
                                       "TooltipBorderBackdropTemplate")
autoKeyListerFrame:SetSize(220, 100)
autoKeyListerFrame:SetPoint("BOTTOMLEFT", PVEFrame, "BOTTOMRIGHT", -220, -100)
autoKeyListerFrame:SetBackdropColor(DARKGRAY_COLOR:GetRGBA())

local function AddRowToTable(rowData)
    local row = CreateFrame("Frame", nil, autoKeyListerFrame)
    row:SetSize(190, 30)
    row:SetPoint("TOP", 0, -numRows * 20)

    for i, data in ipairs(rowData) do
        local cell = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        cell:SetPoint("LEFT", (i - 1) * 50, 0)
        cell:SetText(data)
    end

    numRows = numRows + 1

    rows[numRows] = row -- Store the row in the rows table
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

    if (IsInGroup()) then
        --local hola = openRaidLib.RequestKeystoneDataFromParty()
    end

    keystoneData = openRaidLib.GetAllKeystonesInfo()

    if keystoneData then
        ClearTableFrame()
        for unitName, keystoneInfo in pairs(keystoneData) do
            local keystoneRow = {
                unitName,
                keystoneInfo.classID,
                keystoneInfo.mapID,
                keystoneInfo.level
            }

            keystoneTable[#keystoneTable + 1] = keystoneRow
            AddRowToTable(keystoneRow)
        end
    end
end

local dungeonsFrame = CreateFrame("Frame")
dungeonsFrame:RegisterEvent("ADDON_LOADED")
dungeonsFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

dungeonsFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" or (event == "GROUP_ROSTER_UPDATE" and addonName == "AutoKeyLister") then
        local lfgFrame = PVEFrame

        lfgFrame:SetScript("OnShow", function()
            local playerName = UnitName("player")
            importKeys()
            -- Your custom code here
            -- AccessDetailsFunction()
        end)

        lfgFrame:SetScript("OnHide", function()
            ClearTableFrame() -- Clear the keystoneTable data when the frame is hidden
        end)
    end
end)
