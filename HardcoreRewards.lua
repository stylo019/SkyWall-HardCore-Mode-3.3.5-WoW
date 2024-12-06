-- SKYWALL.ORG -- HC MODE

local function formatTime(seconds)
  local minutes = math.floor(seconds / 60)
  local hours = math.floor(minutes / 60)
  local days = math.floor(hours / 24)

  local formattedTime = string.format("%dd, %02dh, %02dm", days, hours % 24, minutes % 60)
  return formattedTime
end

local function broadcastMessage(player, message)
  local players = GetPlayersInWorld()
  for _, p in ipairs(players) do
      p:SendAreaTriggerMessage(message)
  end
end

local function sendDiscordNotification(content)
  local embed = '{"username": "Hardcore System", "avatar_url": "https://skywall.org/hclogo.png", "content": "' .. content .. '"}'
  HttpRequest("POST", "https://discord.com/api/webhooks/1128075342033207336/XXXXXXX PAST HERE YOUR DISCORD CHANNEL ID XXXXXXXX", embed, "application/json", function(status, body, headers)
      print(body)
  end)
end

local function logLevelUp(player, level)
  local playerGUID = player:GetGUIDLow()
  local insertDB = string.format("INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('%s', '%d', 'LEVELUP', NOW(), 'LEVELUP', '%d')", player:GetName(), level, playerGUID)
  AuthDBExecute(insertDB)
end

local function handleLevelUp(player, newLevel, message, discordContent)
  SendWorldMessage(message)
  broadcastMessage(player, message)
  sendDiscordNotification(discordContent)
  logLevelUp(player, newLevel)
end

local function getLevelUpMessage(level, playerName)
  local messages = {
      [9] = "|cFFffffffHardcore|r : %s has reached level 10 without dying on Hardcore Mode! Congratulations!",
      [14] = "|cFFffffffHardcore|r : %s has reached level 15 without dying on Hardcore Mode! Great job!",
      [19] = "|cFFffffffHardcore|r : %s has reached level 20 without dying on Hardcore Mode! Keep it up!",
      [29] = "|cFFffffffHardcore|r : %s has reached level 30 without dying on Hardcore Mode! Impressive!",
      [49] = "|cFFffffffHardcore|r : %s has reached level 50 without dying on Hardcore Mode! Remarkable achievement!",
      [59] = "|cFFffffffHardcore|r : %s has reached level 60 without dying on Hardcore Mode! You're a legend!",
      [69] = "|cFFffffffHardcore|r : %s has reached level 70 without dying on Hardcore Mode! Incredible!",
      [74] = "|cFFffffffHardcore|r : %s has reached level 75 without dying on Hardcore Mode! Unbelievable!",
      [79] = "|cFFffffffHardcore|r : %s has reached the max level 80 without dying on Hardcore Mode! Congratulations, you are now Immortal!"
  }
  return string.format(messages[level], playerName)
end

local function getDiscordContent(level, playerName)
  local contents = {
      [9] = ":star: Player **%s** has reached level 10 without dying on Hardcore Mode! Congratulations!",
      [14] = ":star: Player **%s** has reached level 15 without dying on Hardcore Mode! Great job!",
      [19] = ":star: Player **%s** has reached level 20 without dying on Hardcore Mode! Keep it up!",
      [29] = ":star: Player **%s** has reached level 30 without dying on Hardcore Mode! Impressive!",
      [49] = ":star: Player **%s** has reached level 50 without dying on Hardcore Mode! Remarkable achievement!",
      [59] = ":star: Player **%s** has reached level 60 without dying on Hardcore Mode! You're a legend!",
      [69] = ":star: Player **%s** has reached level 70 without dying on Hardcore Mode! Incredible!",
      [74] = ":star: Player **%s** has reached level 75 without dying on Hardcore Mode! Unbelievable!",
      [79] = ":star: Player **%s** has reached the max level 80 without dying on Hardcore Mode! Congratulations, you are now Immortal!"
  }
  return string.format(contents[level], playerName)
end

local function onPlayerLevelUp(event, player, newLevel)
  if not player:HasItem(666, 1) then
      return
  end

  local playerName = player:GetName()

  if newLevel == 79 then
      player:AddItem(36941, 1)
      handleLevelUp(player, newLevel, getLevelUpMessage(newLevel, playerName), getDiscordContent(newLevel, playerName))
  elseif newLevel == 74 or newLevel == 69 or newLevel == 59 or newLevel == 49 or newLevel == 29 or newLevel == 19 or newLevel == 14 or newLevel == 9 then
      handleLevelUp(player, newLevel, getLevelUpMessage(newLevel, playerName), getDiscordContent(newLevel, playerName))
  elseif newLevel == 5 then
      local guild = GetGuildByName("HardCore")
      if guild then
          guild:AddMember(player, 3)
          broadcastMessage(player, string.format("|cFFffffff%s|r. Nice! You deserve to join the HardCore guild! |cFF00ff00Congratulations and Welcome!|r", playerName))
          sendDiscordNotification(string.format(":loudspeaker: Player **%s** has joined the HardCore Guild!", playerName))
      end
  end

  if newLevel then
      local totalPlayTime = player:GetTotalPlayedTime()
      local formattedTimeTotal = formatTime(totalPlayTime)
      SendWorldMessage("|cFFffffffHardcore|r : Total time played: " .. formattedTimeTotal)
  end
end

RegisterPlayerEvent(13, onPlayerLevelUp)
