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