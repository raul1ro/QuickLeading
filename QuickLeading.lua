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
local function setInterfaceOptionPulls(addonCategory)

    local p1Label = addonCategory:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    p1Label:SetText("P1 seconds:")
    p1Label:SetPoint("TOPLEFT", 17, -94);
    p1Label:SetTextColor(1, 1, 1, 1);
    local p1Input = CreateFrame("EditBox", "QuickLeadingInterfaceOptionPull1SecondsInput", addonCategory, "InputBoxTemplate")
    p1Input:SetSize(30, 20);
    p1Input:SetPoint("TOPLEFT", 97, -90);
    p1Input:SetNumeric(true);
    p1Input:SetAutoFocus(false);
    p1Input:SetMultiLine(false);
    p1Input:SetMaxLetters(2);
    p1Input:SetNumber(QuickLeadingPull1Seconds);
    p1Input:SetCursorPosition(0);
    p1Input:SetScript("OnTextChanged", function(self)
        QuickLeadingPull1Seconds = tonumber(self:GetText());
    end);

    local p2Label = addonCategory:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    p2Label:SetText("P2 seconds:")
    p2Label:SetPoint("TOPLEFT", 17, -119);
    p2Label:SetTextColor(1, 1, 1, 1);
    local p2Input = CreateFrame("EditBox", "QuickLeadingInterfaceOptionPull1SecondsInput", addonCategory, "InputBoxTemplate")
    p2Input:SetSize(30, 20);
    p2Input:SetPoint("TOPLEFT", 97, -115);
    p2Input:SetNumeric(true);
    p2Input:SetAutoFocus(false);
    p2Input:SetMultiLine(false);
    p2Input:SetMaxLetters(2);
    p2Input:SetNumber(QuickLeadingPull2Seconds);
    p2Input:SetCursorPosition(0);
    p2Input:SetScript("OnTextChanged", function(self)
        QuickLeadingPull2Seconds = tonumber(self:GetText());
    end);

    local p3Label = addonCategory:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    p3Label:SetText("P3 seconds:")
    p3Label:SetPoint("TOPLEFT", 17, -144);
    p3Label:SetTextColor(1, 1, 1, 1);
    local p3Input = CreateFrame("EditBox", "QuickLeadingInterfaceOptionPull1SecondsInput", addonCategory, "InputBoxTemplate")
    p3Input:SetSize(30, 20);
    p3Input:SetPoint("TOPLEFT", 97, -140);
    p3Input:SetNumeric(true);
    p3Input:SetAutoFocus(false);
    p3Input:SetMultiLine(false);
    p3Input:SetMaxLetters(2);
    p3Input:SetNumber(QuickLeadingPull3Seconds);
    p3Input:SetCursorPosition(0);
    p3Input:SetScript("OnTextChanged", function(self)
        QuickLeadingPull3Seconds = tonumber(self:GetText());
    end);

end

local function setInterfaceOptionScale(addonCategory)

    local scaleSlider = CreateFrame("Slider", "QuickLeadingInterfaceOptionScale", addonCategory, "OptionsSliderTemplate");
    scaleSlider:SetSize(300, 15);
    scaleSlider:ClearAllPoints();
    scaleSlider:SetPoint("TOPLEFT", 230, -65);
    scaleSlider:SetMinMaxValues(100, 150);
    scaleSlider:SetObeyStepOnDrag(true);
    scaleSlider:SetValueStep(1);
    _G['QuickLeadingInterfaceOptionScaleLow']:SetText('100%');
    _G['QuickLeadingInterfaceOptionScaleHigh']:SetText('150%');
    local text = _G['QuickLeadingInterfaceOptionScaleText'];
    scaleSlider:HookScript("OnValueChanged", function(self)

        local value = self:GetValue();
        QuickLeadingScale = math.floor(value);

        text:SetText("Scale: " .. QuickLeadingScale .. "%");
        QuickLeadingFrame:SetScale(QuickLeadingScale/100);

    end)
    scaleSlider:Show();

    scaleSlider:SetValue(QuickLeadingScale);

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

        -- set current state
        if(QuickLeadingUICompact) then
            Addon.SetCompactMode()
        else
            Addon.SetLinearMode()
        end
        if(QuickLeadingUIShow) then
            QuickLeadingFrame:Show()
        end
        if(QuickLeadingPull1Seconds == nil) then
            QuickLeadingPull1Seconds = 3;
        end
        if(QuickLeadingPull2Seconds == nil) then
            QuickLeadingPull2Seconds = 7;
        end
        if(QuickLeadingPull3Seconds == nil) then
            QuickLeadingPull3Seconds = 10;
        end
        if(QuickLeadingScale == nil) then
            QuickLeadingScale = 100;
        end

        -- add the options
        setInterfaceOptionShowUI(addonCategory);
        setInterfaceOptionCompactMode(addonCategory);
        setInterfaceOptionPulls(addonCategory);
        setInterfaceOptionScale(addonCategory);

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
            return "RAID_WARNING";
        else
            return "PARTY";
        end
    elseif(GetHomePartyInfo() ~= nil) then
        return "PARTY";
    else
        return "SAY";
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