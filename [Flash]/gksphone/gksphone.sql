ALTER TABLE `owned_vehicles` ADD COLUMN `carseller` INT(11) NULL DEFAULT '0';

CREATE TABLE IF NOT EXISTS `gksphone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gksphone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` LONGTEXT NOT NULL COMMENT 'Num tel proprio' COLLATE 'utf8_general_ci',
  `num` LONGTEXT NOT NULL COMMENT 'Num reférence du contact' COLLATE 'utf8_general_ci',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gksphone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
  `receiver` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
  `message` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gksphone_users_contacts` (
  	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`number` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`display` LONGTEXT NULL DEFAULT '-1' COLLATE 'utf8mb4_general_ci',
	`avatar` LONGTEXT NOT NULL DEFAULT 'https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png' COLLATE 'utf8_general_ci',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

CREATE TABLE `gksphone_insto_accounts` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`forename` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`surname` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`username` VARCHAR(250) NOT NULL COLLATE 'utf8_general_ci',
	`password` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`avatar_url` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`takip` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `username` (`username`) USING BTREE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB;


CREATE TABLE `gksphone_insto_instas` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`authorId` INT(11) NOT NULL,
	`realUser` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci',
	`message` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`image` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`filters` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`likes` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `FK_gksphone_insto_instas_gksphone_insto_accounts` (`authorId`),
	CONSTRAINT `FK_gksphone_insto_instas_gksphone_insto_accounts` FOREIGN KEY (`authorId`) REFERENCES `gksphone_insto_accounts` (`id`)
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;

CREATE TABLE `gksphone_insto_likes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`authorId` INT(11) NULL DEFAULT NULL,
	`inapId` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_gksphone_insto_likes_gksphone_insto_accounts` (`authorId`),
	INDEX `FK_gksphone_insto_likes_gksphone_insto_instas` (`inapId`),
	CONSTRAINT `FK_gksphone_insto_likes_gksphone_insto_accounts` FOREIGN KEY (`authorId`) REFERENCES `gksphone_insto_accounts` (`id`),
	CONSTRAINT `FK_gksphone_insto_likes_gksphone_insto_instas` FOREIGN KEY (`inapId`) REFERENCES `gksphone_insto_instas` (`id`) ON DELETE CASCADE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_twitter_accounts` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`password` VARCHAR(64) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_bin',
	`avatar_url` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`profilavatar` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `username` (`username`) USING BTREE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
;



CREATE TABLE IF NOT EXISTS `gksphone_twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_gksphone_twitter_tweets_gksphone_twitter_accounts` (`authorId`),
  CONSTRAINT `FK_gksphone_twitter_tweets_gksphone_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `gksphone_twitter_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gksphone_twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_gksphone_twitter_likes_gksphone_twitter_accounts` (`authorId`),
  KEY `FK_gksphone_twitter_likes_gksphone_twitter_tweets` (`tweetId`),
  CONSTRAINT `FK_gksphone_twitter_likes_gksphone_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `gksphone_twitter_accounts` (`id`),
  CONSTRAINT `FK_gksphone_twitter_likes_gksphone_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `gksphone_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `gksphone_yellow` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`phone_number` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`firstname` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`lastname` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`message` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`image` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_bank_transfer` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`type` INT(11) NOT NULL,
	`identifier` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`price` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`name` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_gallery` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`hex` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`image` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;

CREATE TABLE `gksphone_gps` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`hex` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`nott` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`gps` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;

CREATE TABLE `gksphone_news` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`hex` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`haber` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`baslik` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`resim` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`video` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`zaman` TIMESTAMP NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `gksphone_settings` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`crypto` LONGTEXT NOT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`phone_number` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`avatar_url` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_blockednumber` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`hex` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`number` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE IF NOT EXISTS `gksphone_insto_story` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
  `stories` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `isRead` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_gksphone_insto_story_gksphone_insto_accounts` (`authorId`) USING BTREE,
  CONSTRAINT `FK_gksphone_insto_story_gksphone_insto_accounts` FOREIGN KEY (`authorId`) REFERENCES `gksphone_insto_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `gksphone_messages_group` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`owner` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
	`ownerphone` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`groupname` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`gimage` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
	`contacts` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_group_message` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`groupid` INT(11) NOT NULL,
	`owner` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`ownerphone` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`groupname` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`messages` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`contacts` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `groupid` (`groupid`) USING BTREE,
	CONSTRAINT `FK_phonegroupmessage` FOREIGN KEY (`groupid`) REFERENCES `gksphone_messages_group` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_vehicle_sales` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`owner` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
	`ownerphone` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`plate` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`model` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`price` INT(11) NOT NULL,
	`image` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `gksphone_gotur` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`label` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`price` INT(11) NULL DEFAULT '0',
	`count` INT(11) NOT NULL,
	`item` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`kapat` VARCHAR(50) NULL DEFAULT 'false' COLLATE 'utf8mb4_general_ci',
	`adet` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_job_message` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`number` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`message` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`photo` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`gps` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`owner` INT(11) NOT NULL DEFAULT '0',
	`jobm` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;

CREATE TABLE `gksphone_mails` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`sender` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`subject` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`image` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`message` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


CREATE TABLE `gksphone_tinderacc` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`username` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`passaword` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`date` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`image` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`gender` INT(11) NULL DEFAULT NULL,
	`identifier` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;



CREATE TABLE `gksphone_tindermatch` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`user_id` INT(11) NOT NULL DEFAULT '0',
	`friend_id` INT(11) NOT NULL DEFAULT '0',
	`is_match` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;


CREATE TABLE `gksphone_tindermessage` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`message` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`tinderes` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`owner` INT(11) NOT NULL DEFAULT '0',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `gksphone_gallery` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`hex` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`image` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
;