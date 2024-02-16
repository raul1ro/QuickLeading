local _, Addon = ...;

-- Bindings.xml globals
BINDING_HEADER_QUICKLEADING_UI = "User Interface"
BINDING_NAME_QUICKLEADING_TOGGLE = "Toggle Open/Close"

local function setInterfaceOptionShowUI(addonCategory)

    -- create a checkbutton for show/hide ui
    local optionShowUI = CreateFrame("CheckButton", "QuickLeadingInterfaceOptionShowUI", addonCategory, "UICheckButtonTemplate")
    optionShowUI:SetSize(20, 20)
    optionShowUI:SetPoint("TOPLEFT", 15, -45)
    local optionShowUIText = optionShowUI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionShowUIText:SetText("Show UI")
    optionShowUIText:SetTextColor(1, 1, 1, 1)
    optionShowUIText:SetPoint("LEFT", 20, 0)

    optionShowUI:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if isChecked then
            QuickLeadingUIShow = true
            QuickLeadingFrame:Show()
        else
            QuickLeadingUIShow = false
            QuickLeadingFrame:Hide()
        end
    end)
    optionShowUI:SetChecked(QuickLeadingUIShow)

end

local function setInterfaceOptionCompactMode(addonCategory)

    -- create a checkbutton for compact ui
    local optionCompactUI = CreateFrame("CheckButton", "QuickLeadingInterfaceOptionCompactUI", addonCategory, "UICheckButtonTemplate")
    optionCompactUI:SetSize(20, 20)
    optionCompactUI:SetPoint("TOPLEFT", 15, -65)
    local optionCompactUIText = optionCompactUI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionCompactUIText:SetText("Compact UI")
    optionCompactUIText:SetTextColor(1, 1, 1, 1)
    optionCompactUIText:SetPoint("LEFT", 20, 0)

    optionCompactUI:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if isChecked then
            QuickLeadingUICompact = true
            Addon.SetCompactMode()
        else
            QuickLeadingUICompact = false
            Addon.SetLinearMode()
        end
    end)
    optionCompactUI:SetChecked(QuickLeadingUICompact)

end

local addonLoadedFrame = CreateFrame("FRAME")
addonLoadedFrame:RegisterEvent("ADDON_LOADED")
addonLoadedFrame:SetScript("OnEvent", function(_, event , ...)

    if (event == "ADDON_LOADED") and (... == "QuickLeading") then

        if(QuickLeadingUIShow == nil) then QuickLeadingUIShow = true end
        if(QuickLeadingUICompact == nil) then QuickLeadingUICompact = false end

        -- init ui
        Addon.InitUI()

        -- create a category in interface>addons
        local addonCategory = CreateFrame("Frame", "QuickLeadingAddonCategory")
        addonCategory.name = "QuickLeading"
        InterfaceOptions_AddCategory(addonCategory)

        -- set title
        local title = addonCategory:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetText("QuickLeading")
        title:SetTextColor(1, 1, 1, 1)
        title:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
        title:SetPoint("TOPLEFT", 15, -15)

        -- add the options
        setInterfaceOptionShowUI(addonCategory)
        setInterfaceOptionCompactMode(addonCategory)

        -- set current state
        if(QuickLeadingUICompact) then
            Addon.SetCompactMode()
        else
            Addon.SetLinearMode()
        end
        if(QuickLeadingUIShow) then
            QuickLeadingFrame:Show()
        end

    end

end)

-- register addon message
if(RegisterAddonMessagePrefix("QL_PULL")) then

    QuickLeadingFrame:RegisterEvent("CHAT_MSG_ADDON");
    QuickLeadingFrame:SetScript("OnEvent", function(_, event , type, message, _, sender, ...)

        if event == "CHAT_MSG_ADDON" and type == "QL_PULL" then

            local playerName = UnitName("player");
            if(sender ~= playerName) then
                Addon.PullCancel(sender, message); -- call pull cancel
            end

        end

    end);
end

-- register slash command
SLASH_QLPULL1 = "/qlpull"
SlashCmdList.QLPULL = function(input)

    local seconds = tonumber(input);
    if(seconds == nil) then
        print("Invalid argument for `/qlpull`");
        return;
    end

    Addon.PullTimer(seconds);

end

function Addon.GetChatType()
    if(IsInRaid()) then
        if(UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
            return "RAID_WARNING"
        else
            return "RAID"
        end
    elseif(GetHomePartyInfo() ~= nil) then
        return "PARTY"
    else
        return "SAY"
    end
end
function Addon.GetGroupType()
    if(IsInRaid()) then
        return "RAID"
    elseif(GetHomePartyInfo() ~= nil) then
        return "PARTY"
    else
        return nil;
    end
end
function Addon.GetInstanceId()
    local _, _, _, _, _, _, _, id = GetInstanceInfo()
    return tonumber(id) or 0
end