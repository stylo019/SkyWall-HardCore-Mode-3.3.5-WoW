--SKYWALL.ORG -- HC MODE --
local function onPlayerLevelUp(event, player, newLevel)
  if newLevel == 79 and player:HasItem(666, 1) then
      player:AddItem(36941, 1) 

      SendWorldMessage(player:GetName() .. " has reached the max level 80 without dying on Hardcore Mode! Congratulations he is now Immortal!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 80 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
  
    end
    if newLevel == 59 and player:HasItem(666, 1) then
      SendWorldMessage(player:GetName() .. " has reached level 60 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 60 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
  
    end
    if newLevel == 29 and player:HasItem(666, 1) then
      SendWorldMessage(player:GetName() .. " has reached level 30 without dying on Hardcore Mode! Congratulations!")
      local players = GetPlayersInWorld()

      for _, player in ipairs(players) do
              player:SendAreaTriggerMessage("|cFFffffff" .. player:GetName() .. "|r has reached level 30 without dying on Hardcore Mode! |cFF00ff00Congratulations!|r")
      end
  
    end
end


-- Register the level up event
RegisterPlayerEvent(13, onPlayerLevelUp)
