--SKYWALL.ORG -- HC MODE --
local function onPlayerLevelUp(event, player, newLevel)
  local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
      return string.format("%01d days, %01d hours,%02d min.%02d sec.", days, hours, minutes, seconds)
  end

  if newLevel == 79 and player:HasItem(666, 1) then
      player:AddItem(36941, 1) 

      SendWorldMessage("|cFFffffffHardcore|r : " .. player:GetName() .. " has reached the max level 80 without dying on Hardcore Mode! Congratulations he is now Immortal!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 80 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
        local playerGUID = player:GetGUIDLow()
        local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" ..playerGUID.."')"
        AuthDBExecute(isertDB)
    end

    if newLevel == 69 and player:HasItem(666, 1) then
      SendWorldMessage("|cFFffffffHardcore|r : " .. player:GetName() .. " has reached level 70 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 70 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
        local playerGUID = player:GetGUIDLow()
        local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" ..playerGUID.."')"
        AuthDBExecute(isertDB)
    end

    if newLevel == 59 and player:HasItem(666, 1) then
      SendWorldMessage("|cFFffffffHardcore|r : " .. player:GetName() .. " has reached level 60 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 60 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
        local playerGUID = player:GetGUIDLow()
        local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" ..playerGUID.."')"
        AuthDBExecute(isertDB)
    end

    if newLevel == 49 and player:HasItem(666, 1) then
      SendWorldMessage("|cFFffffffHardcore|r : " .. player:GetName() .. " has reached level 50 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 50 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
        local playerGUID = player:GetGUIDLow()
        local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" ..playerGUID.."')"
        AuthDBExecute(isertDB)
    end

    if newLevel == 29 and player:HasItem(666, 1) then
      SendWorldMessage("|cFFffffffHardcore|r : " .. player:GetName() .. " has reached level 30 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 30 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
        local playerGUID = player:GetGUIDLow()
        local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" ..playerGUID.."')"
        AuthDBExecute(isertDB)
    end
    
    if newLevel == 9 and player:HasItem(666, 1) then
      SendWorldMessage("|cFFffffffHardcore|r : " .. player:GetName() .. " has reached level 10 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 10 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
        local playerGUID = player:GetGUIDLow()
        local isertDB = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" .. player:GetName() .. "', '" .. player:GetLevel() .. "', 'LEVELUP', NOW(), 'LEVELUP', '" ..playerGUID.."')"
        AuthDBExecute(isertDB)
    end

    if newLevel and player:HasItem(666, 1) then
      local totalPlayTime = player:GetTotalPlayedTime()
      local formattedTimeTotal = formatTime(totalPlayTime)
        SendWorldMessage("|cFFffffffHardcore|r : Total time played: " .. formattedTimeTotal)
    end

end

RegisterPlayerEvent(13, onPlayerLevelUp)
