local _, Addon = ...;

local function setTargetMark(markID)
    if IsControlKeyDown() == false then
        SetRaidTargetIcon("target", markID)
    end
end

function Addon.SetLinearMode()

    QuickLeadingFrame.TopBorder:SetWidth(248);

    local clearWMarksFrame = QuickLeadingFrame.ClearWMarksFrame;
    clearWMarksFrame:SetWidth(55);
    clearWMarksFrame.Button:SetText("Clear WM");
    clearWMarksFrame:ClearAllPoints()
    clearWMarksFrame:SetPoint("TOPLEFT", QuickLeadingFrame.MarksFrame, "TOPRIGHT", 1, 0)

    local rcFrame = QuickLeadingFrame.ReadyCheckFrame;
    rcFrame:SetWidth(43);
    rcFrame.Button:SetText("RCheck");

    local cancelFrame = QuickLeadingFrame.CancelFrame;
    cancelFrame:SetWidth(39);
    cancelFrame.Button:SetText("Cancel");
    cancelFrame:ClearAllPoints();
    cancelFrame:SetPoint("TOPLEFT", clearWMarksFrame, "BOTTOMLEFT", 0, -1)

end

function Addon.SetCompactMode()

    QuickLeadingFrame.TopBorder:SetWidth(148);

    local clearWMarksFrame = QuickLeadingFrame.ClearWMarksFrame;
    clearWMarksFrame:SetWidth(33);
    clearWMarksFrame.Button:SetText("CWM");
    clearWMarksFrame:ClearAllPoints()
    clearWMarksFrame:SetPoint("TOPLEFT", QuickLeadingFrame.MarksFrame, "BOTTOMLEFT", 0, -1)

    local rcFrame = QuickLeadingFrame.ReadyCheckFrame;
    rcFrame:SetWidth(19);
    rcFrame.Button:SetText("RC");

    local cancelFrame = QuickLeadingFrame.CancelFrame;
    cancelFrame:SetWidth(32);
    cancelFrame.Button:SetText("Canc.");
    cancelFrame:ClearAllPoints();
    cancelFrame:SetPoint("LEFT", rcFrame, "RIGHT", 1, 0)

end

function Addon.InitUI()

    QuickLeadingFrame.TopBorder:RegisterForDrag("LeftButton")
    QuickLeadingFrame.TopBorder:SetScript("OnDragStart", function() QuickLeadingFrame:StartMoving(); end);
    QuickLeadingFrame.TopBorder:SetScript("OnDragStop", function()
        QuickLeadingFrame:StopMovingOrSizing()
        QuickLeadingUIPoint, QuickLeadingUIRelativeTo, QuickLeadingUIRelativPoint, QuickLeadingUIXOffset, QuickLeadingUIYOffset = QuickLeadingFrame:GetPoint(0);
    end)
    QuickLeadingFrame:SetScript("OnShow", function()

        if QuickLeadingUIPoint == nil then
            QuickLeadingUIPoint = "CENTER"
            QuickLeadingUIRelativeTo = nil
            QuickLeadingUIRelativPoint = "CENTER"
            QuickLeadingUIXOffset = 0
            QuickLeadingUIYOffset = 0
        end
        QuickLeadingFrame:ClearAllPoints()
        QuickLeadingFrame:SetPoint(QuickLeadingUIPoint, QuickLeadingUIRelativeTo, QuickLeadingUIRelativPoint, QuickLeadingUIXOffset, QuickLeadingUIYOffset)

    end)

    -- set hookscripts
    local marksFrame = QuickLeadingFrame.MarksFrame;
    marksFrame.Star:HookScript("OnClick", function() setTargetMark(1) end);
    marksFrame.Circle:HookScript("OnClick", function() setTargetMark(2) end);
    marksFrame.Diamond:HookScript("OnClick", function() setTargetMark(3) end);
    marksFrame.Triangle:HookScript("OnClick", function() setTargetMark(4) end);
    marksFrame.Moon:HookScript("OnClick", function() setTargetMark(5) end);
    marksFrame.Square:HookScript("OnClick", function() setTargetMark(6) end);
    marksFrame.Cross:HookScript("OnClick", function() setTargetMark(7) end);
    marksFrame.Skull:HookScript("OnClick", function() setTargetMark(8) end);

    QuickLeadingCancelFrame.Button:HookScript("OnClick", function()
        Addon.PullTimer(0);
    end);
    QuickLeadingPull1Frame.Button:HookScript("OnClick", function()
        Addon.PullTimer(QuickLeadingPull1Seconds);
    end);
    QuickLeadingPull2Frame.Button:HookScript("OnClick", function()
        Addon.PullTimer(QuickLeadingPull2Seconds);
    end);
    QuickLeadingPull3Frame.Button:HookScript("OnClick", function()
        Addon.PullTimer(QuickLeadingPull3Seconds);
    end);

end