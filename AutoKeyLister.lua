-- Function to access "Details!" addon functionality
local function AccessDetailsFunction()
    -- Check if "Details!" addon is loaded
    if IsAddOnLoaded("Details") then
        -- Access specific functionality from "Details!" addon
        -- Replace "DetailsFunction" with the actual function name provided by "Details!"
        if DetailsFunction then
            -- Call the function
            DetailsFunction()
        end
    end
end

-- Dungeons & Raids Frame
local dungeonsFrame = CreateFrame("Frame")
dungeonsFrame:RegisterEvent("ADDON_LOADED")
dungeonsFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

dungeonsFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" or event == "GROUP_ROSTER_UPDATE" and addonName == "AutoKeyLister" then
        local lfgFrame = PVEFrame

        lfgFrame:SetScript("OnShow", function()
            local playerName = UnitName("player")
            importKeys(playerName)
            -- Your custom code here
        end)
    end
end)



-- Create the main addon frame
local autoKeyListerFrame = CreateFrame("Frame", "AutoKeyListerFrame", PVEFrame, "TooltipBorderBackdropTemplate")
autoKeyListerFrame:SetSize(220, 100)
autoKeyListerFrame:SetPoint("BOTTOMLEFT", PVEFrame, "BOTTOMRIGHT", -220, -100)
autoKeyListerFrame:SetBackdropColor(DARKGRAY_COLOR:GetRGBA())
--TEXT PART OF FRAME
--autoKeyListerFrame.text = autoKeyListerFrame:CreateFontString(nil,"ARTWORK")
--autoKeyListerFrame.text:SetFont("Fonts\\ARIALN.ttf", 18)
--autoKeyListerFrame.text:SetPoint("TOP", 0,-8)
--autoKeyListerFrame.text:SetText("Import Macro?")
--autoKeyListerFrame:SetText("Hello World")
-- frame:Hide() -- Start with the frame hidden


function importKeys(playerName)
    local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    local challengeMapID = C_MythicPlus.GetOwnedKeystoneMapID()

    if keystoneLevel then
        print(playerName .. "'s current mythic + keystone level is " .. keystoneLevel)
        print(playerName .. "'s current mythic + keystone id is " .. challengeMapID)
    else
        print(playerName .. " does not have a mythic + keystone.")
    end
end


function addInformationToAutoKeyListerFrame(playerName, keyName, keyLevel)
    autoKeyListerFrame.text:SetText("TODO")
end


AccessDetailsFunction()