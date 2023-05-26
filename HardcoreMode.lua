--SKYWALL.ORG -- HC MODE --
local currentTime = os.date("%Y-%m-%d %H:%M:%S")

local function PlayerDeath(event, killer, killed)
    if killed:HasItem(666, 1) then
        local players = GetPlayersInWorld()
        for _, player in ipairs(players) do
            if player:HasItem(666, 1) then
                player:SendBroadcastMessage("|cFFffffffPlayer |cFF00ff00" .. killed:GetName() .. "|r |cFFffffffwas killed by |cFF00ff00" .. killer:GetName() .. "|r - |cFFffffffAt lvl ".. killed:GetLevel() .."")
                player:SendAreaTriggerMessage("|cFFffffffPlayer |cFF00ff00" .. killed:GetName() .. "|r |cFFffffffwas killed by |cFF00ff00" .. killer:GetName() .. "|r - |cFFffffffAt lvl ".. killed:GetLevel() .."")
            end
        end 

        local input_HC_Dead = "INSERT INTO hc_dead_log (username, level, killer, date, result) VALUES ('" .. killed:GetName() .. "', '" .. killed:GetLevel() .. "', '" .. killer:GetName() .. "', '" .. currentTime .. "', 'DEAD')"
        AuthDBExecute(input_HC_Dead)

            killed:RemoveItem(666, 1)

        local playerGUID = killed:GetGUIDLow()
            local input_Del_Guild = "DELETE FROM guild_member WHERE guid = " .. playerGUID
            CharDBExecute(input_Del_Guild)
                killed:SaveToDB()
                    SendWorldMessage("|cFF007bf6You are not more in the HC Guild!|r")
    end
end

local function OnFirstTalk(event, player, unit)
    if player:GetLevel() == 1 then
        if player:HasItem(666) then
            player:GossipMenuAddItem(0, "Thanks!", 0, 3)
            player:GossipSendMenu(6668, unit)
        else
            player:GossipMenuAddItem(0, "I'am ready to try Hardcore Mode!", 0, 1)
            player:GossipSendMenu(6666, unit)
        end
    end
end

local function OnSelect(event, player, unit, sender, intid, code)
    if intid == 1 then
        player:GossipMenuAddItem(0, "Yes, these are my last words!", 0, 2)
        player:GossipMenuAddItem(0, "No, take me back!", 0, 3)
        player:GossipSendMenu(6667, unit)
    end
    if intid == 3 then
        player:GossipComplete()
    end
end

local function OnHardCore(event, player, unit, sender, intid, code)
    if intid == 2 then
        player:AddItem(666, 1)
        player:SetCoinage(0)
        player:SendAreaTriggerMessage("|cFFffffffWelcome to Hardcore Mode,|cFF00ff00" .. player:GetName() .. ".|r |cFFffffffStay vigilant and tread carefully!|r")
            SendWorldMessage("|cFF00ff00".. player:GetName() .. "|r |cFFffffffhas entered Hardcore Mode! Best of luck on your journey!")
            SendWorldMessage(" |cFF007bf6Welcome to the |r|cFF00ff00HARDCORE|r |cFF007bf6Guild |r|cFF00ff00".. player:GetName() .. "|r|cFF00a4f6! It may take a little time for you to appear in the guild list.|r|cFF007bf6 Keep leveling up and enjoy the adventure!|r")
        
        local playerGUID = player:GetGUIDLow()
        local input_HC_Start = "INSERT INTO hc_dead_log (username, level, killer, date, result) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', '"..playerGUID.."', '" .. currentTime .. "', 'BEGIN')"
            AuthDBExecute(input_HC_Start)
        local input_Add_Guild = [[INSERT INTO `guild_member` (`guildid`, `guid`, `rank`) VALUES ('1', ']]..playerGUID..[[', '3');]]        
            CharDBExecute(input_Add_Guild)
        player:GossipComplete()
    end  
end

RegisterCreatureGossipEvent(666, 1, OnFirstTalk)
RegisterCreatureGossipEvent(666, 2, OnSelect)
RegisterCreatureGossipEvent(666, 2, OnHardCore)
RegisterPlayerEvent(8, PlayerDeath)