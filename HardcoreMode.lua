-- SkyWall.org

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
    [11] = "Druid",
}

local deathQuotes = {
    "Better luck next time!",
    "A valiant effort, but fate has spoken.",
    "Adventure ends, memories endure.",
    "Legends fall, but stories live on.",
    "Your journey ends, but courage remains.",
    "Even in defeat, a hero shines bright.",
    "In death, your legacy is forged.",
    "The final chapter is written.",
    "Beyond this life, new tales await.",
    "Hardcore claims another brave soul.",
    "Rest now, for your deeds are remembered.",
    "Mortality embraced, eternity earned.",
    "Heroes rise, heroes fall, legends remain.",
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

local startQuotes = {
    "Prepare for an epic journey!",
    "May fortune favor you!",
    "The adventure begins!",
    "Brace yourself for the challenges ahead!",
    "Your story starts now!",
    "Embark on your epic quest!",
    "The journey of a thousand miles begins!",
    "Heroic deeds await you!",
    "Good luck, brave soul!",
    "May your path be filled with glory!",
    "Adventure and danger lie ahead!",
    "Step boldly into your destiny!",
    "Your epic tale starts here!",
    "Prepare for the trials ahead!",
    "Your legend begins!",
    "Embrace the challenge!",
    "The road to greatness starts here!",
    "Embark on your hardcore journey!",
    "Greatness awaits you!",
    "Forge your legacy!",
}

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    seconds = seconds % 60
    return string.format("%d days, %d hours, %02d min, %02d sec", days, hours, minutes, seconds)
end

local function BroadcastDeathMessage(player, killer)
    local playerName = player:GetName():gsub("'", "''")
    local playerLevel = player:GetLevel()
    local playerRace = raceNames[player:GetRace()] or "Unknown"
    local playerClass = classNames[player:GetClass()] or "Unknown"
    local killerName = killer and killer:GetName() or "Unknown"
    local formattedTimeLvl = formatTime(player:GetLevelPlayedTime())
    local zoneName = player:GetMap():GetName()
    local deathQuote = deathQuotes[math.random(1, #deathQuotes)]:gsub("'", "''")

    local message = string.format("|cFFffffffHardcore|r : |cFFffffffLevel %d player |cFF00ff00%s|r |cFFffffff(%s %s) was killed by |cFF00ff00%s|r |cFFffffffin the %s zone. %s|r", 
                                  playerLevel, playerName, playerRace, playerClass, killerName, zoneName, formattedTimeLvl, deathQuote)
    
    for _, p in ipairs(GetPlayersInWorld()) do
        p:SendBroadcastMessage(message)
        p:SendAreaTriggerMessage(message)
    end
end

local function LogDeathToDatabase(player, killer)
    local playerGUID = player:GetGUIDLow()
    local playerName = player:GetName():gsub("'", "''")
    local playerLevel = player:GetLevel()
    local killerName = killer and killer:GetName() or "Unknown"
    killerName = killerName:gsub("'", "''")

    local query = string.format("INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('%s', '%d', '%s', NOW(), 'DEAD', '%d')", 
                                playerName, playerLevel, killerName, playerGUID)
    AuthDBExecute(query)
end

local function NotifyDiscord(player, killer)
    local playerName = player:GetName()
    local playerRace = raceNames[player:GetRace()] or "Unknown"
    local playerClass = classNames[player:GetClass()] or "Unknown"
    local playerLevel = player:GetLevel()
    local zoneName = player:GetMap():GetName()
    local formattedTimeLvl = formatTime(player:GetLevelPlayedTime())
    local killerName = killer and killer:GetName() or "Unknown"
    local deathQuote = deathQuotes[math.random(1, #deathQuotes)]

    local embed = string.format('{"username": "Hardcore System", "avatar_url": "https://skywall.org/hclogo.png", "content": ":skull: Player **%s (%s %s)** was killed by **%s** at Level %d in the %s zone. %s :skull_crossbones:"}', 
                                playerName, playerRace, playerClass, killerName, playerLevel, zoneName, deathQuote)
    HttpRequest("POST", "https://discord.com/api/webhooks/1128075342033207336/XXXXXXX PAST HERE YOUR DISCORD CHANNEL ID XXXXXXXX", embed, "application/json", function(status, body, headers)
        print(body)
    end)
end

local function PlayerDeath(event, killer, player)
    if type(player) ~= "userdata" or not (player:HasItem(666, 1) or player:HasItem(666, 1, 255)) then
        return
    end

    local guild = player:GetGuild()
    if guild and guild:GetName() == "HardCore" then
        guild:DeleteMember(player, false)
        SendWorldMessage("|cFFffffffHardcore|r : |cFF007bf6" .. player:GetName() .. " was removed from the Hardcore Guild!|r")
    end

    BroadcastDeathMessage(player, killer)
    LogDeathToDatabase(player, killer)
    player:RemoveItem(666, 1)
    player:RemoveItem(666, 1, 255)
    --CreateGrave(player)
    NotifyDiscord(player, killer)
end

RegisterPlayerEvent(6, PlayerDeath)

local function HandleFirstTalk(event, player, unit)
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
    end
end

local function OnSelect(event, player, unit, sender, intid, code)
    if intid == 1 then
        player:GossipMenuAddItem(0, "Yes, these are my last words!", 0, 2)
        player:GossipMenuAddItem(0, "No, take me back!", 0, 3)
        player:GossipSendMenu(6667, unit)
    elseif intid == 3 then
        player:GossipComplete()
    end
end

local function StartHardCoreMode(player)
    local playerName = player:GetName()
    player:AddItem(666, 1)
    player:SetCoinage(0)
    player:SendAreaTriggerMessage("|cFFffffffWelcome to Hardcore Mode,|cFF00ff00" .. playerName .. ".|r |cFFffffffStay vigilant and tread carefully!|r")
    SendWorldMessage("|cFFffffffHardcore|r : |cFF00ff00" .. playerName .. "|r has entered Hardcore Mode! Best of luck on your journey!")

    local playerGUID = player:GetGUIDLow()
    local startQuote = startQuotes[math.random(1, #startQuotes)]
    local query = string.format("INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('%s', '%d', 'STARTED', NOW(), 'BEGIN', '%d')", 
                                playerName, player:GetLevel(), playerGUID)
    AuthDBExecute(query)

    local embed = string.format('{"username": "Hardcore System", "avatar_url": "https://skywall.org/hclogo.png", "content": ":tada: Player **%s** has entered his HardCore Mode and receive his sign! %s :saluting_face:"}', 
                                playerName, startQuote)
    
    HttpRequest("POST", "https://discord.com/api/webhooks/1128075342033207336/XXXXXXX PAST HERE YOUR DISCORD CHANNEL ID XXXXXXXX", embed, "application/json", function(status, body, headers)
        print(body)
    end)

    player:GossipComplete()
end

local function OnHardCore(event, player, unit, sender, intid, code)
    if intid == 2 then
        StartHardCoreMode(player)
    end
end

RegisterCreatureGossipEvent(666, 1, HandleFirstTalk)
RegisterCreatureGossipEvent(666, 2, OnSelect)
RegisterCreatureGossipEvent(666, 2, OnHardCore)
RegisterPlayerEvent(8, PlayerDeath)
