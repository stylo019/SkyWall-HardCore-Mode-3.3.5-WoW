--FROSTWEAVE.GG -- HC MODE -- / /
local function onPlayerLevelUp(event, player, oldLevel)
  local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    local days = math.floor(hours / 24)

    local formattedTime = string.format("%dd, %02dh, %02dm", days, hours % 24, minutes % 60)
    return formattedTime
  end

  if oldLevel == 79 and player:HasItem(666, 1) then
    player:AddItem(36941, 1)


    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() ..
    " has reached the max level 80 without dying on Hardcore Mode! Congratulations he is now Immortal!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 80 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end

  if oldLevel == 74 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 75 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 75 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end

  if oldLevel == 69 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 70 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 70 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end

  if oldLevel == 59 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 60 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 60 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end

  if oldLevel == 49 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 50 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 50 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end
  if oldLevel == 39 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 40 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 40 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end
  if oldLevel == 29 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 30 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 30 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end
  if oldLevel == 19 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r: " ..
    player:GetName() .. " has reached level 20 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 20 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end

  if oldLevel == 9 and player:HasItem(666, 1) then
    SendWorldMessage("|cFFffffffHardcore|r : " ..
    player:GetName() .. " has reached level 10 without dying on Hardcore Mode! Congratulations!")
    local players = GetPlayersInWorld()

    for _, player in ipairs(players) do
      player:SendAreaTriggerMessage("|cFFffffff" ..
      player:GetName() .. "|r has reached level 10 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
    end
    local playerGUID = player:GetGUIDLow()
    local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" ..
    player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" .. playerGUID .. "')"
    AuthDBExecute(isertDB)
  end

  if oldLevel and player:HasItem(666, 1) then
    local totalPlayTime = player:GetTotalPlayedTime()
    local formattedTimeTotal = formatTime(totalPlayTime)
    SendWorldMessage("|cFFffffffHardcore|r : Total time played: " .. formattedTimeTotal)
  end
end

RegisterPlayerEvent(13, onPlayerLevelUp)
