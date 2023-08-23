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