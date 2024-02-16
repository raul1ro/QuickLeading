local _, Addon = ...;

local timer;
local function countdown(seconds, chatType)

    -- start the timer
    local delay = 1;
    if(seconds >= 15) then
        delay = 5;
    elseif(seconds > 10) then
        delay = seconds - 10;
    end
    timer = C_Timer.NewTimer(delay, function()

        if(timer == nil) then
            return;
        end

        seconds = seconds - delay
        if(seconds <= 0) then
            SendChatMessage("Pull!", chatType);
            timer = nil;
            return;
        else
            SendChatMessage(seconds, chatType);
            countdown(seconds, chatType);
        end

    end, 1)

end

function Addon.PullCancel(name, reason)

    if(timer ~= nil) then

        timer:Cancel();
        timer = nil;

        local chatType = Addon.GetChatType();
        if(name == nil) then
            if(reason == "cancel") then
                SendChatMessage("Pull timer canceled", chatType);
                SendAddonMessage("BigWigs", "P^Pull^0", Addon.GetGroupType());
                SendAddonMessage("D4", "PT^0^" .. Addon.GetInstanceId(), Addon.GetGroupType());
            end
        else
            if(reason == "cancel") then
                SendChatMessage("Pull timer canceled by " .. name, chatType);
                SendAddonMessage("BigWigs", "P^Pull^0", Addon.GetGroupType());
                SendAddonMessage("D4", "PT^0^" .. Addon.GetInstanceId(), Addon.GetGroupType());
            else
                SendChatMessage("Pull timer replaced by " .. name, chatType);
                if(UnitIsGroupAssistant(name) == false and UnitIsGroupLeader(name) == false) then
                    SendAddonMessage("BigWigs", "P^Pull^0", Addon.GetGroupType());
                    SendAddonMessage("D4", "PT^0^" .. Addon.GetInstanceId(), Addon.GetGroupType());
                end
            end
        end

    end

end
function Addon.PullTimer(seconds)

    -- get group/chat type
    local groupType = Addon.GetGroupType();
    local chatType = Addon.GetChatType();

    -- Pull cancel
    if(seconds <= 0) then

        -- send message : cancel
        if(groupType ~= nil) then
            SendAddonMessage("QL_PULL", "cancel", groupType);
        end

        Addon.PullCancel(nil, "cancel");

        return;

    end

    -- send message : replace
    -- include bigwigs and dbm
    SendAddonMessage("QL_PULL", "replace", groupType);
    SendAddonMessage("BigWigs", "P^Pull^" .. seconds, Addon.GetGroupType());
    SendAddonMessage("D4", "PT^" .. seconds .. "^" .. Addon.GetInstanceId(), Addon.GetGroupType());

    -- Pull in message
    SendChatMessage("Pull in " .. seconds .. " seconds", chatType);

    -- cancel previous timer
    Addon.PullCancel(nil, nil)

    -- start countdown
    countdown(seconds, chatType);

end