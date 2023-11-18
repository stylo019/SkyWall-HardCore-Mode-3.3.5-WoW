-- SkyWall.org

local auraID = 43869  -- Replace with the actual ID of the aura you want to apply
local auraDuration = 6  -- Replace with the desired duration of the aura in seconds

local raceNames = {
    [1] = "Human",
    [2] = "Orc",
    [3] = "Dwarf",
    [4] = "Night Elf",
    [5] = "Undead",
    [6] = "Tauren",
    [7] = "Gnome",
    [8] = "Troll",
}

local classNames = {
    [1] = "Warrior",
    [2] = "Paladin",
    [3] = "Hunter",
    [4] = "Rogue",
    [5] = "Priest",
    [6] = "Death Knight",
    [7] = "Shaman",
    [8] = "Mage",
    [9] = "Warlock",
}

local deathQuotes = {
    "Better luck next time!",
    "Valiant effort!",
    "Fate has spoken...",
    "Adventure ends here...",
    "Next journey success!",
    "Heroes fall, legends live...",
    "Hardcore claims another...",
    "In the end, we're mortal...",
    "Journey over, memories remain...",
    "Courage in death, true end...",
    "Through time, hero's echo fades...",
    "Darkness embraces, new journey...",
    "Even in defeat, spirit shines...",
    "Battle lost, life's war continues...",
    "In fate's tapestry, thread cut...",
    "Final chapter written, story lives...",
    "From defeat, new strength born...",
    "In death, true meaning found...",
    "Echoes of deeds linger...",
    "Through mortality's veil, legacy woven...",
    "In existence's symphony, note fades...",
    "Amidst shadows, hero's light flickers...",
    "Destiny's pages turn, bittersweet tale...",
    "Journey concludes, another begins...",
    "Chapter closes, story echoes...",
    "Silence of void, legacy resonates...",
    "Cosmic dance, solo concludes...",
    "In tapestry of time, vibrant thread dims...",
    "Stars weep for hero's departure...",
    "Vast expanse, hero's tale finds rest...",
    "Beyond horizon, hero's spirit sails...",
    "Realm of echoes, your story endures...",
    "Whispers of fate, hero's name lingers...",
    "Canvas of life painted, vibrant memories...",
    "In garden of destiny, petal falls...",
    "Grand tapestry threads your legacy...",
    "Curtain falls, saga resonates...",
    "Cosmic melody, note gracefully concludes...",
    "Ebb and flow, your tale remains...",
    "Final chord played, melody endures...",
}

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%d days, %d hours, %02d min, %02d sec", days, hours, minutes, seconds)
end

local function CreateGrave(player)
    if player:GetLevel() < 15 then
        -- Tomb is not created for players below level 15
        return
    end

    local gameObjectEntry = 254605 -- Gameobject id of your grave // It is recommended to use this id 194537
    local secondsInADay = 86400 -- Duración en segundos que la tumba estará en el mundo (1 día)

    local x, y, z, o = player:GetLocation()

    local grave = player:SummonGameObject(gameObjectEntry, x, y, z, o)

    if grave then
        local graveGUID = grave:GetGUIDLow() -- Obtener el GUID de la tumba

        -- Depawn the grave
        local event = CreateLuaEvent(function()
            if grave and grave:IsInWorld() then
                grave:Despawn()
            end
        end, secondsInADay * 1000, 1)

        print("Grave GUID: " .. graveGUID)

        -- Store the GUID of the grave in the database
        local input_Grave_GUID = "UPDATE hc_dead_log SET grave_guid = '" .. graveGUID .. "' WHERE guid = '" .. player:GetGUIDLow() .. "'"
        AuthDBExecute(input_Grave_GUID)
    end
end

local function PlayerDeath(event, killer, player)
    if player:HasItem(666, 1) then
        local playerGUID = player:GetGUIDLow()
        local playerName = player:GetName()
        local playerLevel = player:GetLevel()
        local playerRaceID = player:GetRace()
        local playerClassID = player:GetClass()
        local currLevelPlayTime = player:GetLevelPlayedTime()
        local formattedTimeLvl = formatTime(currLevelPlayTime)

        local playerRace = raceNames[playerRaceID] or "Unknown"
        local playerClass = classNames[playerClassID] or "Unknown"

        local guild = player:GetGuild()
        if guild and guild:GetName() == "HardCore" then
            guild:DeleteMember(player, false)
            SendWorldMessage("|cFFffffffHardcore|r : |cFF007bf6" .. playerName .. " was removed from the Hardcore Guild!|r")
        end

        local players = GetPlayersInWorld()
        local killerName = killer and killer:GetName() or "Unknown"

        local survivalTime = currLevelPlayTime  
        local zoneName = player:GetMap():GetName()

        local quoteIndex = math.random(1, #deathQuotes)
        local deathQuote = deathQuotes[quoteIndex]

        -- Escape single quotes in strings
        playerName = playerName:gsub("'", "''")
        killerName = killerName:gsub("'", "''")
        deathQuote = deathQuote:gsub("'", "''")

        player:AddAura(auraID, player, player):SetDuration(auraDuration * 1000)

        -- Notify the player about the aura and the punishment
        player:SendBroadcastMessage("|cFFFF0000Hardcore |r: |cFFC0C0C0You have failed the Hardcore challenge and are now under a penalty aura for " .. auraDuration .. " seconds. " .. "Reflect on your journey and try again!|r")

        for _, p in ipairs(players) do
            if p == player then
                p:SendBroadcastMessage("|cFFffffffHardcore|r : |cFFffffffLevel " .. playerLevel .. " player |cFF00ff00" .. playerName .. "|r |cFFffffff(" .. playerRace .. " " .. playerClass .. ") was killed by |cFF00ff00" .. killerName .. "|r |cFFffffffin the " .. zoneName .. " zone, after surviving " .. formattedTimeLvl .. ". " .. deathQuote .. "|r")
                p:SendAreaTriggerMessage("|cFFffffffHardcore|r : |cFFffffffLevel " .. playerLevel .. " player |cFF00ff00" .. playerName .. "|r |cFFffffff(" .. playerRace .. " " .. playerClass .. ") was killed by |cFF00ff00" .. killerName .. "|r |cFFffffffin the " .. zoneName .. " zone, after surviving " .. formattedTimeLvl .. ". " .. deathQuote .. "|r")
            end
        end

        local input_HC_Dead = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid, survival_time, player_race, player_class, zone_name, death_quote) VALUES ('" .. playerName .. "', '" .. playerLevel .. "', '" .. killerName .. "',  NOW(), 'DEAD', '" .. playerGUID .. "', '" .. survivalTime .. "', '" .. playerRace .. "', '" .. playerClass .. "', '" .. zoneName .. "', '" .. deathQuote .. "')"
        AuthDBExecute(input_HC_Dead)

        player:RemoveItem(666, 1)

        -- Create and spawn the grave after removing the item
        CreateGrave(player)

        -- Discord embed
        local embed = '{"username": "Hardcore System", "avatar_url": "https://skywall.org/hclogo.png", "content": ":skull: Player **'.. playerName ..' (' .. playerRace .. ' ' .. playerClass .. ')** was killed by **' ..killerName.. '** at Level '.. playerLevel ..' in the ' .. zoneName .. ' zone, after surviving ' ..formattedTimeLvl.. '. ' .. deathQuote .. ' :skull_crossbones:"}'
        -- POST request to Discord Webhook
        HttpRequest("POST", "https://discord.com/api/webhooks/1175435360143159338/5eY7cwlOQ7xbr3MGswxRXM7zXeeBDHTyO2kxITsaFJqA0GFhWAJqYLgNLJrdktUvxhHp",
            embed, "application/json", function(status, body, headers)
                print(body)
            end)
    end
end

RegisterPlayerEvent(6, PlayerDeath)

local function OnFirstTalk(event, player, unit)
    if player:GetLevel() == 1 then
        if player:HasItem(666) then
            player:GossipMenuAddItem(0, "Thanks!", 0, 3)
            player:GossipSendMenu(6668, unit)
        else
            player:GossipMenuAddItem(0, "I am ready to try Hardcore Mode!", 0, 1)
            player:GossipSendMenu(6666, unit)
        end
    else
        player:SendBroadcastMessage("|cFFffffffHardcore|r : Your current level is too high to participate in HC mode. In order to experience the thrill of HC, it is necessary to create a new hero.")
            local function formatTime(seconds)
                local days = math.floor(seconds / 86400)
                local hours = math.floor((seconds % 86400) / 3600)
                local minutes = math.floor((seconds % 3600) / 60)
                local seconds = seconds % 60
                return string.format("%01d days, %01d hours,%02d min.%02d sec.", days, hours, minutes, seconds)
            end
            local currLevelPlayTime = player:GetLevelPlayedTime()
            local totalPlayTime = player:GetTotalPlayedTime()

            local formattedTimeLvl = formatTime(currLevelPlayTime)
            local formattedTimeTotal = formatTime(totalPlayTime)
                SendWorldMessage("Total time played: " .. formattedTimeTotal)
                SendWorldMessage("Total played this level: " .. formattedTimeLvl)
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
        local playerName = player:GetName()  -- Retrieve the player's name

        player:AddItem(666, 1)
        player:SetCoinage(0)
        player:SendAreaTriggerMessage("|cFFffffffWelcome to Hardcore Mode,|cFF00ff00" .. playerName .. ".|r |cFFffffffStay vigilant and tread carefully!|r")
        SendWorldMessage("|cFFffffffHardcore|r : |cFF00ff00" .. playerName .. "|r has entered Hardcore Mode! Best of luck on your journey!")

        local playerGUID = player:GetGUIDLow()

        -- Insert a record into the hc_dead_log table to mark the player's start
        local input_HC_Start = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. playerName .. "', '" .. player:GetLevel() .. "', 'STARTED', NOW(), 'BEGIN', '" .. playerGUID .. "')"
        AuthDBExecute(input_HC_Start)

        -- Discord embed
        local embed = '{"username": "Hardcore System", "avatar_url": "https://skywall.org/hclogo.png", "content": ":tada: Player **' .. playerName .. '** started his HardCore Mode! Good luck! :saluting_face:"}'
        -- POST request to Discord Webhook
        HttpRequest("POST", "https://discord.com/api/webhooks/1175435360143159338/5eY7cwlOQ7xbr3MGswxRXM7zXeeBDHTyO2kxITsaFJqA0GFhWAJqYLgNLJrdktUvxhHp",
            embed, "application/json", function(status, body, headers)
                print(body)
            end)

        -- Add the player to the "HardCore" guild using Guild:AddMember()
        local guild = GetGuildByName("HardCore")
        if guild then
            guild:AddMember(player, 3) -- Replace 3 with the desired rank ID
        end

        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(666, 1, OnFirstTalk)
RegisterCreatureGossipEvent(666, 2, OnSelect)
RegisterCreatureGossipEvent(666, 2, OnHardCore)
RegisterPlayerEvent(8, PlayerDeath)
