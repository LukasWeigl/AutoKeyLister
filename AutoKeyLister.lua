local keystoneTable = {} -- Define the keystoneTable outside the function to make it accessible

local function ClearTableData()
    numRows = 0
    for i = 1, #keystoneTable do
        keystoneTable[i] = nil
    end
end

-- Create the main addon frame
local autoKeyListerFrame = CreateFrame("Frame", "AutoKeyListerFrame", PVEFrame,
                                       "TooltipBorderBackdropTemplate")
autoKeyListerFrame:SetSize(220, 100)
autoKeyListerFrame:SetPoint("BOTTOMLEFT", PVEFrame, "BOTTOMRIGHT", -220, -100)
autoKeyListerFrame:SetBackdropColor(DARKGRAY_COLOR:GetRGBA())

local tableFrame = CreateFrame("Frame", nil, autoKeyListerFrame)
tableFrame:SetSize(200, 80)
tableFrame:SetPoint("CENTER", autoKeyListerFrame, "CENTER")

local numRows = 0

local function AddRowToTable(rowData)
    local row = CreateFrame("Frame", nil, tableFrame)
    row:SetSize(200, 20)
    row:SetPoint("TOP", 0, -numRows * 20)

    for i, data in ipairs(rowData) do
        local cell = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        cell:SetPoint("LEFT", (i - 1) * 50, 0)
        cell:SetText(data)
    end

    numRows = numRows + 1
end

local function importKeys()
    local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
    local keystoneData

    if (IsInGroup()) then
        --local hola = openRaidLib.RequestKeystoneDataFromParty()
    end

    keystoneData = openRaidLib.GetAllKeystonesInfo()

    if keystoneData then
        ClearTableData()

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
            ClearTableData() -- Clear the keystoneTable data when the frame is hidden
        end)
    end
end)
