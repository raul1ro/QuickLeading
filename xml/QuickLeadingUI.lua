local _, Addon = ...;

local function setTargetMark(markID)
    if IsControlKeyDown() == false then
        SetRaidTargetIcon("target", markID)
    end
end

function Addon.SetLinearMode()

    QuickLeadingFrame:SetSize(295, 30)

    QuickLeadingFrame.ClearWMarks:ClearAllPoints()
    QuickLeadingFrame.ClearWMarks:SetPoint("TOPLEFT", QuickLeadingFrame.MarksFrame, "TOPRIGHT", 1, 0)

end

function Addon.SetCompactMode()

    QuickLeadingFrame:SetSize(148, 55)

    QuickLeadingFrame.ClearWMarks:ClearAllPoints()
    QuickLeadingFrame.ClearWMarks:SetPoint("TOPLEFT", QuickLeadingFrame.MarksFrame, "BOTTOMLEFT", 0, -1)

end

function Addon.InitUI()

    QuickLeadingFrame:RegisterForDrag("LeftButton")
    QuickLeadingFrame:SetScript("OnDragStart", QuickLeadingFrame.StartMoving)
    QuickLeadingFrame:SetScript("OnDragStop", function()
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

    QuickLeadingPull7s.Pull7sButton:HookScript("OnClick", function()
        Addon.PullTimer(7);
    end)
    QuickLeadingPull10s.Pull10sButton:HookScript("OnClick", function()
        Addon.PullTimer(10);
    end)
    QuickLeadingStopPull.StopPullButton:HookScript("OnClick", function()
        Addon.PullTimer(0);
    end)

end