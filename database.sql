DROP DATABASE IF EXISTS `skyeframework`;
CREATE DATABASE `skyeframework` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `skyeframework`;

CREATE TABLE IF NOT EXISTS `server_players` (
  `#` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `money` longtext NOT NULL DEFAULT '{}',
  `userdata` longtext NOT NULL DEFAULT '{}',
  `status` longtext NOT NULL DEFAULT '{}',
  `jobs` longtext NOT NULL DEFAULT '{}',
  `metadata` longtext NOT NULL DEFAULT '{}'
) ENGINE=MyISAM AUTO_INCREMENT=542 DEFAULT CHARSET=latin1;	

CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(2) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=MyISAM AUTO_INCREMENT=542 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `outfitId` (`outfitId`)
) ENGINE=MyISAM AUTO_INCREMENT=542 DEFAULT CHARSET=latin1;