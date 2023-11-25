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
    marksFrame.Star:HookScript("OnClick", function() setTargetMark(1) end)
    marksFrame.Circle:HookScript("OnClick", function() setTargetMark(2) end)
    marksFrame.Diamond:HookScript("OnClick", function() setTargetMark(3) end)
    marksFrame.Triangle:HookScript("OnClick", function() setTargetMark(4) end)
    marksFrame.Moon:HookScript("OnClick", function() setTargetMark(5) end)
    marksFrame.Square:HookScript("OnClick", function() setTargetMark(6) end)
    marksFrame.Cross:HookScript("OnClick", function() setTargetMark(7) end)
    marksFrame.Skull:HookScript("OnClick", function() setTargetMark(8) end)

    QuickLeadingPull5s.Pull5sButton:HookScript("OnClick", function() Addon.PullTimer(5, false) end)
    QuickLeadingPull10s.Pull10sButton:HookScript("OnClick", function() Addon.PullTimer(10, false) end)
    QuickLeadingStopPull.StopPullButton:HookScript("OnClick", function() Addon.PullTimer(0, true) end)

end

function Addon.DetectGroupChat()
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

local timer;
local function countdown(seconds, groupType)

    -- start the timer
    timer = C_Timer.NewTimer(1, function()

        if(seconds == 0) then
            SendChatMessage("Pull!", groupType);
            return;
        else
            SendChatMessage(seconds, groupType);
        end

        if(timer ~= nil) then
            countdown(seconds - 1, groupType);
        end

    end, 1)

end

function Addon.PullTimer(seconds, isCancel)

    local groupType = Addon.DetectGroupChat();

    --if is cancel and return
    if(isCancel) then
        SendChatMessage("Pull timer cancelled!", groupType);
        timer:Cancel();
        timer = nil;
        return;
    end

    -- Pull in message
    SendChatMessage("Pull in " .. seconds .. " seconds!", groupType);

    -- start timer
    if(timer ~= nil) then
        timer:Cancel();
        timer = nil;
    end
    countdown(seconds - 1, groupType)

end