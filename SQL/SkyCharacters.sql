
-- DEFAULT DATA FOR EASY TESTING/DEVELOPMENT
SET @GUILD_ID := 1; -- Default guild ID
SET @GUILD_NAME := 'HardCore';
SET @CHARACTER_ID := 1; -- Character ID that will be the leader of the guild

INSERT INTO `guild` (`guildid`, `name`, `leaderguid`, `motd`) VALUES
(@GUILD_ID, @GUILD_NAME, @CHARACTER_ID, 'HardCore Guild!');
-- DELETE GUILD AFTER TESTING IF YOU WANT
-- DELETE FROM `guild` WHERE `guildid` = @GUILD_ID;
	