-- acore_auth
CREATE TABLE IF NOT EXISTS `hc_dead_log` (
  `username` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `level` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `killer` TEXT COLLATE utf8mb4_general_ci,
  `date` DATETIME DEFAULT NULL,
  `result` TEXT COLLATE utf8mb4_general_ci,
  `guid` TEXT COLLATE utf8mb4_general_ci,
  `survival_time` TEXT COLLATE utf8mb4_general_ci,
  `player_race` TEXT COLLATE utf8mb4_general_ci,
  `player_class` TEXT COLLATE utf8mb4_general_ci,
  `zone_name` TEXT COLLATE utf8mb4_general_ci,
  `death_quote` TEXT COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
