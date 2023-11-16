#include "ScriptMgr.h"
#include "Player.h"
#include "Creature.h"
#include "Guild.h"
#include "World.h"
#include "GossipDef.h"
#include "GossipScript.h"
#include "WorldSession.h"
#include "Chat.h"
#include "ObjectAccessor.h"
#include "DatabaseEnv.h"

class HardcoreScript : public PlayerScript {
public:
    HardcoreScript() : PlayerScript("HardcoreScript") {}

    void OnPlayerDeath(Player* player, Unit* killer) override {
        if (player->HasItemCount(666, 1)) {
            uint32 playerGUID = player->GetGUIDLow();
            std::string playerName = player->GetName();
            uint32 playerLevel = player->getLevel();
            uint8 playerRaceID = player->getRace();
            uint8 playerClassID = player->getClass();
            uint32 currLevelPlayTime = player->GetLevelPlayedTime();
            std::string formattedTimeLvl = FormatTime(currLevelPlayTime);

            std::string playerRace = raceNames[playerRaceID] ? raceNames[playerRaceID] : "Unknown";
            std::string playerClass = classNames[playerClassID] ? classNames[playerClassID] : "Unknown";

            Guild* guild = player->GetGuild();
            if (guild && guild->GetName() == "HardCore") {
                guild->DeleteMember(player, false);
                sWorld->SendWorldText(LANG_SYSTEM_MESSAGE, "|cFFffffffHardcore|r : |cFF007bf6%s was removed from the Hardcore Guild!|r", playerName.c_str());
            }

            auto players = sWorld->GetPlayers();
            std::string killerName = killer ? killer->GetName() : "Unknown";

            uint32 survivalTime = currLevelPlayTime;
            std::string zoneName = player->GetMap()->GetName();

            uint32 quoteIndex = urand(1, deathQuotes.size());
            std::string deathQuote = deathQuotes[quoteIndex];

            // Escape single quotes in strings
            playerName = EscapeString(playerName);
            killerName = EscapeString(killerName);
            deathQuote = EscapeString(deathQuote);

            player->AddAura(auraID, player, player)->SetDuration(auraDuration * IN_MILLISECONDS);

            // Notify the player about the aura and the punishment
            player->SendBroadcastMessage("|cFFFF0000Hardcore |r: |cFFC0C0C0You have failed the Hardcore challenge and are now under a penalty aura for " + std::to_string(auraDuration) + " seconds. " + "Reflect on your journey and try again!|r");

            for (auto p : players) {
                if (p == player) {
                    p->SendBroadcastMessage("|cFFffffffHardcore|r : |cFFffffffLevel %u player |cFF00ff00%s|r |cFFffffff(%s %s) was killed by |cFF00ff00%s|r |cFFffffffin the %s zone, after surviving %s. %s|r",
                        playerLevel, playerName.c_str(), playerRace.c_str(), playerClass.c_str(), killerName.c_str(), zoneName.c_str(), formattedTimeLvl.c_str(), deathQuote.c_str());
                    p->SendAreaTriggerMessage("|cFFffffffHardcore|r : |cFFffffffLevel %u player |cFF00ff00%s|r |cFFffffff(%s %s) was killed by |cFF00ff00%s|r |cFFffffffin the %s zone, after surviving %s. %s|r",
                        playerLevel, playerName.c_str(), playerRace.c_str(), playerClass.c_str(), killerName.c_str(), zoneName.c_str(), formattedTimeLvl.c_str(), deathQuote.c_str());
                }
            }

            std::string input_HC_Dead = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid, survival_time, player_race, player_class, zone_name, death_quote) VALUES ('" +
                playerName + "', '" + std::to_string(playerLevel) + "', '" + killerName + "', NOW(), 'DEAD', '" + std::to_string(playerGUID) + "', '" + std::to_string(survivalTime) + "', '" +
                playerRace + "', '" + playerClass + "', '" + zoneName + "', '" + deathQuote + "')";
            CharacterDatabase.Execute(input_HC_Dead);

            player->RemoveItem(666, 1);

            // Create and spawn the grave after removing the item
            CreateGrave(player);

            // Discord embed
            std::string embed = "{\"username\": \"Hardcore System\", \"avatar_url\": \"https://skywall.org/hclogo.png\", \"content\": \":skull: Player **" + playerName + " (" + playerRace + " " +
                playerClass + ")** was killed by **" + killerName + "** at Level " + std::to_string(playerLevel) + " in the " + zoneName + " zone, after surviving " + formattedTimeLvl + ". " + deathQuote + " :skull_crossbones:\"}";
            // POST request to Discord Webhook
            HttpRequest("POST", "https://discord.com/api/webhooks/1171672579170377778/myo2lUfv-dKIyubF18iXyOVeFY_4I5ylsg7fjMal5zHQaJoC7zb84w7irAnpGFQQIi2Z",
                embed, "application/json", [](int32 status, const std::string& body, const std::multimap<std::string, std::string>& headers) {
                    sLog->out("Discord Webhook Response: %s", body.c_str());
                });
        }
    }

private:
    uint32 auraID = 43869; // Replace with the actual ID of the aura you want to apply
    uint32 auraDuration = 600; // Replace with the desired duration of the aura in seconds

    std::unordered_map<uint8, std::string> raceNames = {
        {1, "Human"},
        {2, "Orc"},
        {3, "Dwarf"},
        {4, "Night Elf"},
        {5, "Undead"},
        {6, "Tauren"},
        {7, "Gnome"},
        {8, "Troll"},
    };

    std::unordered_map<uint8, std::string> classNames = {
        {1, "Warrior"},
        {2, "Paladin"},
        {3, "Hunter"},
        {4, "Rogue"},
        {5, "Priest"},
        {6, "Death Knight"},
        {7, "Shaman"},
        {8, "Mage"},
        {9, "Warlock"},
    };

    std::vector<std::string> deathQuotes = {
        "Better luck next time!",
        // Add other death quotes here...
    };

    std::string FormatTime(uint32 seconds) {
        uint32 days = seconds / 86400;
        uint32 hours = (seconds % 86400) / 3600;
        uint32 minutes = (seconds % 3600) / 60;
        uint32 remainingSeconds = seconds % 60;
        return format("%u days, %u hours, %02u min, %02u sec", days, hours, minutes, remainingSeconds);
    }

    void CreateGrave(Player* player) {
        uint32 gameObjectEntry = 194537; // Replaces with the input ID of the desired GameObject
        uint32 gameObjectDuration = 86400; // Replaces with the desired duration of the GameObject in seconds // 86400 seconds = 1 day
        float x, y, z, o;
        player->GetPosition(x, y, z, o);

        GameObject* gameObject = player->SummonGameObject(gameObjectEntry, x, y, z, o);

        if (gameObject) {
            // Schedules the removal of the GameObject after the specified duration
            sEventMgr->AddEvent(gameObject, &GameObject::DespawnOrUnsummon, EVENT_GAMEOBJECT_EXPIRE, gameObjectDuration * IN_MILLISECONDS, 1, EVENT_FLAG_DO_NOT_EXECUTE_IN_WORLD_CONTEXT);
        }
    }

    std::string EscapeString(const std::string& input) {
        // Implement string escaping logic if necessary
        return input;
    }

    void HttpRequest(const std::string& method, const std::string& url, const std::string& postData, const std::string& contentType, std::function<void(int32, const std::string&, const std::multimap<std::string, std::string>&)> callback) {
        // Implement HTTP request logic using AzerothCore's HTTP client or an external library
        // Refer to AzerothCore documentation for more details
    }
};

class HardcoreGossipScript : public CreatureScript {
public:
    HardcoreGossipScript() : CreatureScript("HardcoreGossipScript") {}

    bool OnGossipHello(Player* player, Creature* creature) override {
        if (player->getLevel() == 1) {
            if (player->HasItemCount(666, 1)) {
                player->PlayerTalkClass->ClearMenus();
                player->ADD_GOSSIP_ITEM(0, "Thanks!", GOSSIP_SENDER_MAIN, 3);
                player->SEND_GOSSIP_MENU(6668, creature->GetGUID());
            }
            else {
                player->PlayerTalkClass->ClearMenus();
                player->ADD_GOSSIP_ITEM(0, "I am ready to try Hardcore Mode!", GOSSIP_SENDER_MAIN, 1);
                player->SEND_GOSSIP_MENU(6666, creature->GetGUID());
            }
        }
        else {
            player->SendBroadcastMessage("|cFFffffffHardcore|r : Your current level is too high to participate in HC mode. In order to experience the thrill of HC, it is necessary to create a new hero.");

            uint32 currLevelPlayTime = player->GetLevelPlayedTime();
            uint32 totalPlayTime = player->GetTotalPlayedTime();

            std::string formattedTimeLvl = FormatTime(currLevelPlayTime);
            std::string formattedTimeTotal = FormatTime(totalPlayTime);

            sWorld->SendWorldText(LANG_SYSTEM_MESSAGE, "Total time played: %s", formattedTimeTotal.c_str());
            sWorld->SendWorldText(LANG_SYSTEM_MESSAGE, "Total played this level: %s", formattedTimeLvl.c_str());
        }

        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 /*sender*/, uint32 action) override {
        if (action == 1) {
            player->PlayerTalkClass->ClearMenus();
            player->ADD_GOSSIP_ITEM(0, "Yes, these are my last words!", GOSSIP_SENDER_MAIN, 2);
            player->ADD_GOSSIP_ITEM(0, "No, take me back!", GOSSIP_SENDER_MAIN, 3);
            player->SEND_GOSSIP_MENU(6667, creature->GetGUID());
        }
        else if (action == 3) {
            player->PlayerTalkClass->ClearMenus();
            player->CLOSE_GOSSIP_MENU();
        }

        return true;
    }

    bool OnGossipSelectCode(Player* player, Creature* creature, uint32 /*sender*/, uint32 action, const std::string& /*code*/) override {
        if (action == 2) {
            player->AddItem(666, 1);
            player->SetCoinage(0);
            player->SendAreaTriggerMessage("|cFFffffffWelcome to Hardcore Mode,|cFF00ff00%s.|r |cFFffffffStay vigilant and tread carefully!|r", player->GetName().c_str());
            sWorld->SendWorldText(LANG_SYSTEM_MESSAGE, "|cFFffffffHardcore|r : |cFF00ff00%s|r has entered Hardcore Mode! Best of luck on your journey!", player->GetName().c_str());

            uint32 playerGUID = player->GetGUIDLow();

            // Insert a record into the hc_dead_log table to mark the player's start
            std::string input_HC_Start = "INSERT INTO hc_dead_log (username, level, killer, date, result, guid) VALUES ('" + player->GetName() + "', '" + std::to_string(player->getLevel()) + "', 'STARTED', NOW(), 'BEGIN', '" + std::to_string(playerGUID) + "')";
            CharacterDatabase.Execute(input_HC_Start);

            // Discord embed
            std::string embed = "{\"username\": \"Hardcore System\", \"avatar_url\": \"https://skywall.org/hclogo.png\", \"content\": \":tada: Player **" + player->GetName() + "** started his HardCore Mode! Good luck! :saluting_face:\"}";
            // POST request to Discord Webhook
            HttpRequest("POST", "https://discord.com/api/webhooks/1171672579170377778/myo2lUfv-dKIyubF18iXyOVeFY_4I5ylsg7fjMal5zHQaJoC7zb84w7irAnpGFQQIi2Z",
                embed, "application/json", [](int32 status, const std::string& body, const std::multimap<std::string, std::string>& headers) {
                    sLog->out("Discord Webhook Response: %s", body.c_str());
                });

            // Add the player to the "HardCore" guild using Guild:AddMember()
            Guild* guild = sGuildMgr->GetGuildByName("HardCore");
            if (guild) {
                guild->AddMember(player, 3); // Replace 3 with the desired rank ID
            }

            player->PlayerTalkClass->ClearMenus();
            player->CLOSE_GOSSIP_MENU();
        }

        return true;
    }
};

void AddSC_HardcoreScript() {
    new HardcoreScript();
    new HardcoreGossipScript();
}
