-- SKYWALL.ORG -- HC MODE --

local HC_ITEM_ID = 666

-- Utility function to check if a player is in Hardcore Mode
local function isInHardcoreMode(player)
    return player:HasItem(HC_ITEM_ID, 1)
end

-- Event handler for player login
local function onHardcoreLogin(event, player)
    if isInHardcoreMode(player) then
        player:SendAreaTriggerMessage("|cFFffffffWelcome to HardCore Mode, " .. player:GetName() .. ".|r Watch your step!|r")
    end
end

-- Event handler to restrict trading in Hardcore Mode
local function onCanTrade(event, player, target)
    if isInHardcoreMode(player) or isInHardcoreMode(target) then
        player:SendBroadcastMessage("|cFFFFD000Hardcore Mode is active. You are not authorized to perform this action.")
        return false
    end
    return true
end

-- Event handler to restrict sending mail in Hardcore Mode
local function onCanSendMail(event, player, receiverGuid, mailbox, subject, body, money, cod, item)
    local receiver = GetPlayerByGUID(receiverGuid)
    if isInHardcoreMode(player) or (receiver and isInHardcoreMode(receiver)) then
        player:SendBroadcastMessage("|cFFFFD000Hardcore Mode is detected. You are not authorized to perform this action.")
        return false
    end
    return true
end

-- Event handler to restrict group invitations in Hardcore Mode
local function onCanGroupInvite(event, player, memberName)
    local member = GetPlayerByName(memberName)
    if isInHardcoreMode(player) or (member and isInHardcoreMode(member)) then
        player:SendBroadcastMessage("|cFFFFD000Hardcore Mode is detected. You are not authorized to make a group.")
        return false
    end
    return true
end

-- Event handler to restrict bank usage in Hardcore Mode
local function blockBankers(event, player, creature)
    if creature:IsBanker() then
        if isInHardcoreMode(player) then
            player:SendBroadcastMessage("|cFFFFD000Hardcore Mode is detected. You are not authorized to use the bank.")
        else
            player:SendShowBank(creature)
        end
    end
end

local enabledBankers = false
local Bankers = {
    2455, 2456, 2457, 2458, 2459, 2460, 2461, 2625, 2996, 3309, 3318, 3320, 3496, 4155, 4208, 4209, 4549, 4550, 5060, 5099, 7799, 8119, 8123, 8124, 8356, 8357,
    13917, 16615, 16616, 16617, 16710, 17631, 17632, 17633, 17773, 18350, 19034, 19246, 19318, 19338, 21732, 21733, 21734, 28343, 28675, 28676, 28677, 28678,
    28679, 28680, 29282, 29283, 29530, 30604, 30605, 30606, 30607, 30608, 31420, 31421, 31422, 36284, 36351, 36352, 38919, 38920, 38921
}

if enabledBankers then
    for _, bankerId in ipairs(Bankers) do
        RegisterCreatureGossipEvent(bankerId, 1, blockBankers)
    end
end
local ObjectRespawnRange = 5
-- Event handler to restrict mailbox usage in Hardcore Mode
local function blockMailboxes(event, gameobject)
    local players = gameobject:GetPlayersInRange(ObjectRespawnRange)
    for _, player in ipairs(players) do
        if isInHardcoreMode(player) then
            gameobject:Despawn()
            return
        end
    end
    gameobject:Respawn(ObjectRespawnRange)
end

local enabledMail = true
local Mailboxes = {
    32349, 140908, 142075, 142089, 142093, 142094, 142095, 142102, 142103, 142109, 142110, 142111, 142117, 142119, 143981, 143982,
    143983, 143984, 143985, 143986, 143987, 143988, 143989, 143990, 144011, 144112, 144125, 144126, 144127, 144128, 144129, 144130, 144131, 144179,
    144570, 153578, 153716, 157637, 163313, 163645, 164618, 164840, 171556, 171699, 171752, 173047, 173221, 175864, 176319, 176324, 176404, 177044,
    178864, 179895, 179896, 180451, 181236, 181380, 181381, 181639, 181883, 181980, 182356, 182357, 182359, 182360, 182361, 182362, 182363, 182364,
    182365, 182567, 182939, 182946, 182948, 182949, 182950, 182955, 183037, 183038, 183039, 183040, 183042, 183047, 183167, 183856, 183857, 183858,
    184085, 184133, 184134, 184135, 184136, 184137, 184138, 184139, 184140, 184147, 184148, 184490, 184652, 184944, 185102, 185471, 185472, 185473,
    185477, 185965, 186230, 186435, 186506, 186629, 187113, 187260, 187268, 187316, 187322, 188123, 188132, 188241, 188256, 188355, 188486,
    188531, 188534, 188541, 188604, 188618, 188682, 188710, 189328, 189329, 189969, 190914, 190915, 191228, 191521, 191832, 191946, 191947,
    191948, 191949, 191950, 191951, 191952, 191953, 191954, 191955, 191956, 191957, 192952, 193043, 193044, 193045, 193071, 193791, 193972,
    194016, 194027, 194147, 194492, 194788, 195218, 195219, 195467, 195468, 195528, 195529, 195530, 195554, 195555, 195556, 195557, 195558,
    195559, 195560, 195561, 195562, 195603, 195604, 195605, 195606, 195607, 195608, 195609, 195610, 195611, 195612, 195613, 195614, 195615,
    195616, 195617, 195618, 195619, 195620, 195624, 195625, 195626, 195627, 195628, 195629
}



if enabledMail then
    for _, mailboxId in ipairs(Mailboxes) do
        RegisterGameObjectEvent(mailboxId, 1, blockMailboxes)
    end
end

RegisterPlayerEvent(3, onHardcoreLogin)
RegisterPlayerEvent(48, onCanTrade)
RegisterPlayerEvent(49, onCanSendMail)
RegisterPlayerEvent(55, onCanGroupInvite)
