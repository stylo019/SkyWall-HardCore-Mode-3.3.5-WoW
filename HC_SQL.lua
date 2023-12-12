----------------------------------------------------------
-- HC SQL CONFIG

-- Names of the tables used in the Characters database.
local tableName1 = "hc_dead_log"
local tableName2 = "hc_death_duels_table"

-- Specify the data for the Hardcore guild
local GUILD_ID = 1
local GUILD_NAME = 'HardCore'
local GUILD_MOTD = 'HardCore Guild!'
local CHARACTER_ID = 1
local GUILD_ID_RANK = 0

-- HC SQL CONFIG END
------------------------------------------------------------

local function checkAndCreateTable(tableName, creacionSQL)
    local checkTableSQL = string.format([[SELECT COUNT(*) FROM information_schema.tables WHERE  table_name = '%s';]],  tableName)

    local result = CharDBQuery(checkTableSQL)

    if result then
        local rowCount = result:GetUInt32(0)

        if rowCount == 0 then
            local query = string.format(creacionSQL, tableName)
            CharDBQuery(query)
        --else
           -- print(string.format("La tabla %s ya existe", tableName))
        end
    else
        print(string.format("Error al verificar la existencia de la tabla %s.", tableName))
    end
end

local function checkAndInsertGuildData(GUILD_ID,GUILD_NAME,CHARACTER_ID,GUILD_MOTD)
    -- Verificar si la GUILD_ID existe en la tabla guild
    local checkGuildSQL = string.format([[SELECT COUNT(*) FROM `guild` WHERE `guildid` = '%d';]], GUILD_ID)
    local result = CharDBQuery(checkGuildSQL)

    if result then
        local rowCount = result:GetUInt32(0)

        if rowCount == 0 then
            -- Insertar datos en la tabla guild
            local insertGuildSQL = string.format([[
                INSERT INTO `guild` (`guildid`, `name`, `leaderguid`, `motd`) VALUES
                (%d, '%s', %d, '%s');
            ]], GUILD_ID, GUILD_NAME, CHARACTER_ID, GUILD_MOTD)

            CharDBQuery(insertGuildSQL)
            local insertGuildMemberSQL = string.format([[
                INSERT INTO `guild_member` (`guildid`, `guid`, `rank`) VALUES
                (%d, %d, %d);
            ]], GUILD_ID, CHARACTER_ID, GUILD_ID_RANK)

            CharDBQuery(insertGuildMemberSQL)

            print(string.format("Datos insertados en la guild con ID %d.", GUILD_ID))
            
        else
            print(string.format("¡La guild con ID %d ya existe!", GUILD_ID))
        end
    else
        print("Error al verificar la existencia de la guild.")
    end
end

-- Table creation query for each table
local hc_dead_log = [[
    CREATE TABLE IF NOT EXISTS `%s` (
        `username` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
        `level` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
        `killer` TEXT COLLATE utf8mb4_general_ci,
        `date` DATETIME DEFAULT NULL,
        `result` TEXT COLLATE utf8mb4_general_ci,
        `guid` TEXT COLLATE utf8mb4_general_ci,
        `grave_guid` TEXT COLLATE utf8mb4_general_ci, 
        `survival_time` TEXT COLLATE utf8mb4_general_ci,
        `player_race` TEXT COLLATE utf8mb4_general_ci,
        `player_class` TEXT COLLATE utf8mb4_general_ci,
        `zone_name` TEXT COLLATE utf8mb4_general_ci,
        `death_quote` TEXT COLLATE utf8mb4_general_ci
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]]

local hc_death_duels_table = [[
    CREATE TABLE IF NOT EXISTS `%s` (
        `character_name` VARCHAR(255) PRIMARY KEY,
        `account_id` INT,
        `class_id` INT,
        `race_id` INT,
        `level` INT,
        `honor_points` INT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
]]

checkAndCreateTable(tableName1, hc_dead_log)
checkAndCreateTable(tableName2, hc_death_duels_table)
checkAndInsertGuildData(GUILD_ID, GUILD_NAME, CHARACTER_ID, GUILD_MOTD)