function OnPlayerDeath(event, player, killer)
    local causeOfDeath = player:GetDeathState()
    
    if causeOfDeath == 1 then
        -- Le joueur est mort des suites de dégâts de combat
        local lastDamageSource = player:GetLastSpellDamageInfo()
        SendWorldMessage("|cFFffffffHardcore|r :  You are dead dfdffddfl!")

    elseif causeOfDeath == 2 then
        -- Le joueur est mort des suites d'une chute de hauteur
        -- Actions spécifiques à la mort par chute de hauteur
        SendWorldMessage("|cFFffffffHardcore|r :  You are dead l!")

    end
end

RegisterPlayerEvent(3, OnPlayerDeath) -- Événement pour la mort du joueur

