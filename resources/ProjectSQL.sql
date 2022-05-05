-- --------------------------------------------------------
-- Host:                         51.210.222.129
-- Server version:               10.3.27-MariaDB-0+deb10u1 - Debian 10
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for ProjectRP
CREATE DATABASE IF NOT EXISTS `ProjectRP` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `ProjectRP`;

-- Dumping structure for table ProjectRP.apartments
CREATE TABLE IF NOT EXISTS `apartments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `citizenid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.apartments: ~28 rows (approximately)
/*!40000 ALTER TABLE `apartments` DISABLE KEYS */;
INSERT INTO `apartments` (`id`, `name`, `type`, `label`, `citizenid`) VALUES
	(1, 'apartment54282', 'apartment5', 'Fantastic Plaza 4282', 'GLU16588'),
	(3, 'apartment59894', 'apartment5', 'Fantastic Plaza 9894', 'YJF16118'),
	(4, 'apartment21140', 'apartment2', 'Morningwood Blvd 1140', 'LUE38187'),
	(13, 'apartment52089', 'apartment5', 'Fantastic Plaza 2089', 'RLN47341'),
	(14, 'apartment59223', 'apartment5', 'Fantastic Plaza 9223', 'TPJ65091'),
	(15, 'apartment59721', 'apartment5', 'Fantastic Plaza 9721', 'KAJ38332'),
	(16, 'apartment3727', 'apartment3', 'Integrity Way 727', 'FDP84651'),
	(17, 'apartment32766', 'apartment3', 'Integrity Way 2766', 'HLT35396'),
	(18, 'apartment11300', 'apartment3', 'Integrity Way', 'GNB89310'),
	(19, 'apartment32823', 'apartment3', 'Integrity Way 2823', 'RLM66480'),
	(20, 'apartment52115', 'apartment5', 'Fantastic Plaza 2115', 'PDP48852'),
	(21, 'apartment37090', 'apartment3', 'Integrity Way 7090', 'WDR25895'),
	(23, 'apartment58257', 'apartment5', 'Fantastic Plaza 8257', 'QRV28044'),
	(24, 'apartment15210', 'apartment1', 'South Rockford Drive 5210', 'SZC76946'),
	(25, 'apartment33672', 'apartment3', 'Integrity Way 3672', 'DHQ50495'),
	(26, 'apartment51314', 'apartment5', 'Fantastic Plaza 1314', 'KNE47910'),
	(27, 'apartment24359', 'apartment2', 'Morningwood Blvd 4359', 'FRU80192'),
	(28, 'apartment33795', 'apartment3', 'Integrity Way 3795', 'CZW07621'),
	(29, 'apartment33671', 'apartment3', 'Integrity Way 3671', 'UQY95064'),
	(30, 'apartment3899', 'apartment3', 'Integrity Way 899', 'VKE75892'),
	(32, 'apartment35826', 'apartment3', 'Integrity Way 5826', 'LGW06073'),
	(33, 'apartment59213', 'apartment5', 'Fantastic Plaza 9213', 'JFN70828'),
	(34, 'apartment43006', 'apartment4', 'Tinsel Towers 3006', 'GPZ13033'),
	(35, 'apartment54407', 'apartment5', 'Fantastic Plaza 4407', 'WIB36516'),
	(36, 'apartment51882', 'apartment5', 'Fantastic Plaza 1882', 'ACS69891'),
	(38, 'apartment56060', 'apartment5', 'Fantastic Plaza 6060', 'YSK97488'),
	(40, 'apartment44035', 'apartment4', 'Tinsel Towers 4035', 'TYQ95339'),
	(41, 'apartment5251', 'apartment5', 'Fantastic Plaza 251', 'LOJ14600'),
	(42, 'apartment5351', 'apartment5', 'Fantastic Plaza 351', 'BXC86041'),
	(43, 'apartment57169', 'apartment5', 'Fantastic Plaza 7169', 'WYY64466'),
	(44, 'apartment35553', 'apartment3', 'Integrity Way 5553', 'QIR20104'),
	(45, 'apartment36160', 'apartment3', 'Integrity Way 6160', 'FPF61986'),
	(46, 'apartment35917', 'apartment3', 'Integrity Way 5917', 'YXU34760');
/*!40000 ALTER TABLE `apartments` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.bank_accounts
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `record_id` bigint(255) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(250) DEFAULT NULL,
  `buisness` varchar(50) DEFAULT NULL,
  `buisnessid` int(11) DEFAULT NULL,
  `gangid` varchar(50) DEFAULT NULL,
  `amount` bigint(255) NOT NULL DEFAULT 0,
  `account_type` enum('Current','Savings','Buisness','Gang') NOT NULL DEFAULT 'Current',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `citizenid` (`citizenid`),
  KEY `buisness` (`buisness`),
  KEY `buisnessid` (`buisnessid`),
  KEY `gangid` (`gangid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;



-- Dumping structure for table ProjectRP.bank_statements
CREATE TABLE IF NOT EXISTS `bank_statements` (
  `record_id` bigint(255) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `account` varchar(50) DEFAULT NULL,
  `business` varchar(50) DEFAULT NULL,
  `businessid` int(11) DEFAULT NULL,
  `gangid` varchar(50) DEFAULT NULL,
  `deposited` int(11) DEFAULT NULL,
  `withdraw` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`record_id`),
  KEY `business` (`business`),
  KEY `businessid` (`businessid`),
  KEY `gangid` (`gangid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;



-- Dumping structure for table ProjectRP.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.crypto
CREATE TABLE IF NOT EXISTS `crypto` (
  `crypto` varchar(50) NOT NULL DEFAULT 'qbit',
  `worth` int(11) NOT NULL DEFAULT 0,
  `history` text DEFAULT NULL,
  PRIMARY KEY (`crypto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.crypto_transactions
CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

/*!40000 ALTER TABLE `crypto_transactions` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.dealers: ~0 rows (approximately)
/*!40000 ALTER TABLE `dealers` DISABLE KEYS */;
/*!40000 ALTER TABLE `dealers` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.fine_types
CREATE TABLE IF NOT EXISTS `fine_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `jailtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.fine_types: ~89 rows (approximately)
/*!40000 ALTER TABLE `fine_types` DISABLE KEYS */;
INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`, `jailtime`) VALUES
(1, 'First Degree Murder', 7500, 0, 250),
(2, 'Second Degree Murder', 6500, 0, 150),
(3, 'Vehicular Manslaughter', 4000, 0, 40),
(4, 'Attempted Murder on Public Offical', 5500, 0, 100),
(5, 'Attempted Murder', 5000, 0, 75),
(6, 'Assault w/ Deadly Weapon on Public Offical', 2000, 0, 45),
(7, 'Assault w/ Deadly Weapon', 1750, 0, 30),
(8, 'Assault on Public Offical', 1000, 0, 15),
(9, 'Assault', 750, 0, 10),
(10, 'Kidnapping of an Public Offical', 3000, 0, 15),
(11, 'Kidnapping / Hostage Taking', 2000, 0, 15),
(12, 'Bank Robbery', 3000, 0, 60),
(13, 'Armored Truck Robbery', 650, 0, 20),
(14, 'Jewelery Store Robbery ', 1000, 0, 30),
(15, 'Store Robbery', 1000, 0, 15),
(16, 'House Robbery', 750, 0, 10),
(17, 'Corruption', 10000, 0, 450),
(18, 'Felony Driving Under the Influence', 750, 0, 15),
(19, 'Grand Theft Auto', 1500, 0, 20),
(20, 'Evading Arrest', 200, 0, 20),
(21, 'Driving Under the Influence', 150, 0, 15),
(22, 'Hit and Run', 150, 0, 15),
(23, 'Operating a Motor Vehicle without a License', 100, 0, 10),
(24, 'Criminal Speeding', 300, 0, 10),
(25, 'Excessive Speeding 4', 250, 0, 0),
(26, 'Excessive Speeding 3', 200, 0, 0),
(27, 'Excessive Speeding 2', 150, 0, 0),
(28, 'Excessive Speeding', 100, 0, 0),
(29, 'Operating an Unregisted Motor Vehicle', 100, 0, 5),
(30, 'Reckless Endangerment', 150, 0, 5),
(31, 'Careless Driving', 100, 0, 0),
(32, 'Operating a Non-Street Legal Vehicle', 200, 0, 5),
(33, 'Failure to Stop', 100, 0, 0),
(34, 'Obstructing Traffic', 150, 0, 0),
(35, 'Illegal Lane Change', 100, 0, 0),
(36, 'Failure to Yield to an Emergency Vehicle', 150, 0, 0),
(37, 'Illegal Parking', 100, 0, 0),
(38, 'Excessive Vehicle Noise', 100, 0, 0),
(39, 'Driving without Proper Use of Headlights', 100, 0, 0),
(40, 'Illegal U-Turn', 100, 0, 0),
(41, 'Drug Manufacturing/Cultivation', 5500, 0, 40),
(42, 'Possession of Class 1 Drug', 750, 0, 15),
(43, 'Possession of Class 2 Drug', 1250, 0, 20),
(44, 'Sale/Distribution of Class 1 Drug', 1750, 0, 40),
(45, 'Sale/Distribution of Class 2 Drug', 2500, 0, 60),
(46, 'Drug Trafficking', 5000, 0, 100),
(47, 'Weapons Caching of Class 2s', 2500, 0, 80),
(48, 'Weapons Caching of Class 1s', 1250, 0, 60),
(49, 'Weapons Trafficking of Class 2s', 1700, 0, 80),
(50, 'Weapons Trafficking of Class 1s', 800, 0, 45),
(51, 'Possession of a Class 2 Firearm', 800, 0, 40),
(52, 'Possession of a Class 1 Firearm', 150, 0, 15),
(53, 'Brandishing a Firearm', 100, 0, 5),
(54, 'Unlawful discharge of a firearm', 150, 0, 10),
(55, 'Perjury', 1000, 0, 60),
(56, 'Arson', 500, 0, 30),
(57, 'False Impersonation of a Government Official', 200, 0, 25),
(58, 'Possession of Dirty Money', 200, 0, 25),
(59, 'Possession of Stolen Goods', 100, 0, 15),
(60, 'Unlawful Solicitation', 150, 0, 20),
(61, 'Larceny', 150, 0, 20),
(62, 'Felony Attempted Commision of an Offence/Crime', 350, 0, 20),
(63, 'Tampering With Evidence', 200, 0, 20),
(64, 'Illegal Gambling', 200, 0, 20),
(65, 'Bribery', 200, 0, 20),
(66, 'Stalking', 350, 0, 20),
(67, 'Organizing an illegal event', 150, 0, 15),
(68, 'Participating in an illegal event', 50, 0, 5),
(69, 'Criminal Mischief', 100, 0, 15),
(70, 'Prostitution', 250, 0, 15),
(71, 'Failure to Identify', 150, 0, 15),
(72, 'Obstruction of Justice', 150, 0, 15),
(73, 'Resisting Arrest', 100, 0, 10),
(74, 'Disturbing the Peace', 100, 0, 10),
(75, 'Threat to do Bodily Harm', 100, 0, 10),
(76, 'Terroristic Threat', 150, 0, 10),
(77, 'Damage to Government Property', 150, 0, 10),
(78, 'Contempt of Court', 250, 0, 10),
(79, 'Failure to Obey a Lawful Order', 150, 0, 10),
(80, 'False Report', 100, 0, 10),
(81, 'Trespassing', 100, 0, 10),
(82, 'Loitering', 100, 0, 0),
(83, 'Public Intoxication', 100, 0, 0),
(84, 'Indecent Exposure', 100, 0, 0),
(85, 'Verbal Harassment ', 100, 0, 0),
(86, 'Aiding and Abetting', 100, 0, 0),
(87, 'Incident Report', 0, 0, 0),
(88, 'Written Citation', 0, 0, 0),
(89, 'Verbal Warning', 0, 0, 0);
/*!40000 ALTER TABLE `fine_types` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.gloveboxitems
CREATE TABLE IF NOT EXISTS `gloveboxitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.gloveboxitems: ~0 rows (approximately)
/*!40000 ALTER TABLE `gloveboxitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `gloveboxitems` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.houselocations
CREATE TABLE IF NOT EXISTS `houselocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `owned` tinyint(1) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` tinyint(4) DEFAULT NULL,
  `garage` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.houselocations: ~12 rows (approximately)
/*!40000 ALTER TABLE `houselocations` DISABLE KEYS */;
INSERT INTO `houselocations` (`id`, `name`, `label`, `coords`, `owned`, `price`, `tier`, `garage`) VALUES
	(1, 'integrity way1', 'Integrity Way 1', '{"cam":{"z":43.87287521362305,"yaw":-10.0,"h":340.1207275390625,"x":222.262451171875,"y":-595.3666381835938},"enter":{"z":43.87287521362305,"x":222.262451171875,"h":340.1207275390625,"y":-595.3666381835938}}', 1, 1, 1, NULL),
	(2, 'fudge ln1', 'Fudge Ln 1', '{"enter":{"x":1286.6531982421876,"h":203.42593383789063,"y":-1604.4854736328126,"z":54.82489395141601},"cam":{"h":203.42593383789063,"y":-1604.4854736328126,"z":54.82489395141601,"yaw":-10.0,"x":1286.6531982421876}}', 0, 10, 2, NULL),
	(3, 'cortes st1', 'Cortes St 1', '{"cam":{"z":7.60462570190429,"h":114.6382064819336,"y":-1149.8697509765626,"yaw":-10.0,"x":-1257.4605712890626},"enter":{"h":114.6382064819336,"y":-1149.8697509765626,"z":7.60462570190429,"x":-1257.4605712890626}}', 1, 1100, 1, NULL),
	(4, 'nikola pl1', 'Nikola Pl 1', '{"enter":{"y":-546.7946166992188,"x":1348.3580322265626,"h":348.4354553222656,"z":73.89158630371094},"cam":{"z":73.89158630371094,"y":-546.7946166992188,"yaw":-10.0,"h":348.4354553222656,"x":1348.3580322265626}}', 0, 100000, 1, NULL),
	(5, 'nikola pl2', 'Nikola Pl 2', '{"enter":{"y":-555.8810424804688,"x":1373.1978759765626,"h":269.35736083984377,"z":74.68562316894531},"cam":{"z":74.68562316894531,"y":-555.8810424804688,"yaw":-10.0,"h":269.35736083984377,"x":1373.1978759765626}}', 0, 50000, 5, NULL),
	(6, 'nikola pl3', 'Nikola Pl 3', '{"enter":{"y":-606.6294555664063,"x":1367.2489013671876,"h":183.4028778076172,"z":74.71175384521485},"cam":{"z":74.71175384521485,"y":-606.6294555664063,"yaw":-10.0,"h":183.4028778076172,"x":1367.2489013671876}}', 0, 100, 10, NULL),
	(7, 'nikola pl4', 'Nikola Pl 4', '{"enter":{"y":-606.6295166015625,"x":1367.2489013671876,"h":183.4029998779297,"z":74.71161651611328},"cam":{"z":74.71161651611328,"y":-606.6295166015625,"yaw":-10.0,"h":183.4029998779297,"x":1367.2489013671876}}', 0, 100, 9, NULL),
	(8, 'nikola pl5', 'Nikola Pl 5', '{"enter":{"y":-606.6295166015625,"x":1367.2489013671876,"h":183.4029998779297,"z":74.71150207519531},"cam":{"z":74.71150207519531,"y":-606.6295166015625,"yaw":-10.0,"h":183.4029998779297,"x":1367.2489013671876}}', 0, 100, 7, NULL),
	(9, 'nikola pl6', 'Nikola Pl 6', '{"enter":{"y":-606.6295166015625,"x":1367.2489013671876,"h":183.4029998779297,"z":74.7114028930664},"cam":{"z":74.7114028930664,"y":-606.6295166015625,"yaw":-10.0,"h":183.4029998779297,"x":1367.2489013671876}}', 0, 100, 2, NULL),
	(10, 'nikola pl7', 'Nikola Pl 7', '{"enter":{"y":-606.6295166015625,"x":1367.2489013671876,"h":183.4029998779297,"z":74.71131134033203},"cam":{"z":74.71131134033203,"y":-606.6295166015625,"yaw":-10.0,"h":183.4029998779297,"x":1367.2489013671876}}', 0, 100, 1, NULL),
	(11, 'nikola pl8', 'Nikola Pl 8', '{"enter":{"y":-597.2819213867188,"x":1341.416259765625,"h":66.16448974609375,"z":74.7007064819336},"cam":{"z":74.7007064819336,"y":-597.2819213867188,"yaw":-10.0,"h":66.16448974609375,"x":1341.416259765625}}', 0, 100, 6, NULL),
	(12, 'nikola pl9', 'Nikola Pl 9', '{"enter":{"y":-582.7540283203125,"x":1324.1099853515626,"h":129.3260498046875,"z":73.24649047851563},"cam":{"z":73.24649047851563,"y":-582.7540283203125,"yaw":-10.0,"h":129.3260498046875,"x":1324.1099853515626}}', 0, 100, 6, NULL);
/*!40000 ALTER TABLE `houselocations` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.house_plants
CREATE TABLE IF NOT EXISTS `house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `building` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT 'stage-a',
  `sort` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `food` int(11) DEFAULT 100,
  `health` int(11) DEFAULT 100,
  `progress` int(11) DEFAULT 0,
  `coords` text DEFAULT NULL,
  `plantid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `building` (`building`),
  KEY `plantid` (`plantid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;



-- Dumping structure for table ProjectRP.inside_jobs
CREATE TABLE IF NOT EXISTS `inside_jobs` (
  `id` int(11) DEFAULT NULL,
  `identifier` varchar(255) CHARACTER SET latin1 NOT NULL,
  `experience` int(11) NOT NULL,
  `job` varchar(255) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.race_tracks
CREATE TABLE IF NOT EXISTS `race_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creatorid` varchar(50) DEFAULT NULL,
  `creatorname` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `incident` longtext DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `char_id` int(11) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `report_title` varchar(255) DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `expire` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.mdt_warrants: ~0 rows (approximately)
/*!40000 ALTER TABLE `mdt_warrants` DISABLE KEYS */;
/*!40000 ALTER TABLE `mdt_warrants` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.occasion_vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `occasion_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `occasion_vehicles` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `permission` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.permissions: ~16 rows (approximately)

CREATE TABLE IF NOT EXISTS `phone_gallery` (
  `citizenid` VARCHAR(255) NOT NULL , 
  `image` VARCHAR(255) NOT NULL ,
  `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `firstName` varchar(25) DEFAULT NULL,
  `lastName` varchar(25) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `url` text DEFAULT NULL,
  `picture` text DEFAULT './img/default.png',
  `tweetId` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Dumping structure for table ProjectRP.phone_invoices
CREATE TABLE IF NOT EXISTS `phone_invoices` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `society` tinytext DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.phone_invoices: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_invoices` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `number` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.phone_messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=3605 DEFAULT CHARSET=utf8mb4;



-- Dumping structure for table ProjectRP.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.playerskins: ~31 rows (approximately)

-- Dumping structure for table ProjectRP.player_boats
CREATE TABLE IF NOT EXISTS `player_boats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `boathouse` varchar(50) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `state` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.player_boats: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_boats` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_boats` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.player_contacts
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.player_contacts: ~2 rows (approximately)
/*!40000 ALTER TABLE `player_contacts` DISABLE KEYS */;
INSERT INTO `player_contacts` (`id`, `citizenid`, `name`, `number`, `iban`) VALUES
	(1, 'SZC76946', 'Diaye Thelegend', '1211665849', 'US03ProjectRP9710835995');
/*!40000 ALTER TABLE `player_contacts` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.player_houses
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `house` (`house`),
  KEY `citizenid` (`citizenid`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.player_outfits
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;



-- Dumping structure for table ProjectRP.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(15) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT 'pillboxgarage',
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `paymentamount` int(11) NOT NULL DEFAULT 0,
  `paymentsleft` int(11) NOT NULL DEFAULT 0,
  `financetime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Dumping data for table ProjectRP.player_vehicles: ~3 rows (approximately)


-- Dumping structure for table ProjectRP.player_warns
CREATE TABLE IF NOT EXISTS `player_warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.player_warns: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_warns` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_warns` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.stashitems
CREATE TABLE IF NOT EXISTS `stashitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(255) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`stash`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.tattoos
CREATE TABLE IF NOT EXISTS `tattoos` (
  `identifier` varchar(100) NOT NULL,
  `tattoos` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.trunkitems
CREATE TABLE IF NOT EXISTS `trunkitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.trunkitems: ~0 rows (approximately)
/*!40000 ALTER TABLE `trunkitems` DISABLE KEYS */;
INSERT INTO `trunkitems` (`id`, `plate`, `items`) VALUES
	(1, '27YNF959', '[]');
/*!40000 ALTER TABLE `trunkitems` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.user_convictions
CREATE TABLE IF NOT EXISTS `user_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `offense` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;


-- Dumping structure for table ProjectRP.user_mdt
CREATE TABLE IF NOT EXISTS `user_mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `mugshot_url` varchar(255) DEFAULT NULL,
  `bail` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

/*!40000 ALTER TABLE `user_mdt` ENABLE KEYS */;

-- Dumping structure for table ProjectRP.vehicle_mdt
CREATE TABLE IF NOT EXISTS `vehicle_mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) DEFAULT NULL,
  `stolen` bit(1) DEFAULT b'0',
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ProjectRP.vehicle_mdt: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicle_mdt` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_mdt` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

CREATE TABLE IF NOT EXISTS `storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `pincode` int(11) DEFAULT NULL,
  `coords` longtext DEFAULT '[]',
  `keyholders` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `scenes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `creator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `color` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `viewdistance` int DEFAULT NULL,
  `expiration` int DEFAULT NULL,
  `fontsize` decimal(10,1) DEFAULT NULL,
  `fontstyle` int DEFAULT NULL,
  `coords` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `date_creation` datetime DEFAULT NULL,
  `date_deletion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `management_funds` (
`id` INT(11) NOT NULL AUTO_INCREMENT,
`job_name` VARCHAR(50) NOT NULL,
`amount`  INT(100) NOT NULL,
`type` ENUM('boss','gang') NOT NULL DEFAULT 'boss',
PRIMARY KEY (`id`),
UNIQUE KEY `job_name` (`job_name`),
KEY `type` (`type`)
);

INSERT INTO `management_funds` (`job_name`, `amount`, `type`) VALUES
('police', 0, 'boss'),
('ambulance', 0, 'boss'),
('realestate', 0, 'boss'),
('taxi', 0, 'boss'),
('cardealer', 0, 'boss'),
('pizza', 0, 'boss'),
('burger', 0, 'boss'),
('vu', 0, 'boss'),
('tequilala', 0, 'boss'),
('recycling', 0, 'boss'),
('mechanic', 0, 'boss'),
('lostmc', 0, 'gang'),
('ballas', 0, 'gang'),
('vagos', 0, 'gang'),
('cartel', 0, 'gang'),
('families', 0, 'gang'),
('triads', 0, 'gang');
('celestial', 0, 'gang');
('flowersociety', 0, 'gang');

CREATE TABLE IF NOT EXISTS `cd_dispatch` (
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`callsign` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

ALTER TABLE `player_vehicles`
ADD COLUMN `traveldistance` INT(50) NULL DEFAULT 0 AFTER `financetime`,
ADD COLUMN `noslevel` INT(10) NULL DEFAULT 0 AFTER `traveldistance`,
ADD COLUMN `hasnitro` TINYINT(0) NULL DEFAULT 0 AFTER `noslevel`;

CREATE TABLE IF NOT EXISTS `configs` (
  `name` varchar(20) NOT NULL,
  `config` text DEFAULT NULL,
  PRIMARY KEY (`name`)
);

INSERT INTO `configs` (`name`, `config`) VALUES (
	'keylabs', '{"worth1":0,"worth3":0,"washer3":0,"cokelab":0,"weedlab":0,"worth4":0,"methlab":0,"methlab2":0,"washer1":0,"worth2":0,"washer4":0,"washer2":0}'
);


-- LOAF HOUSING
CREATE TABLE IF NOT EXISTS `loaf_properties` (
  `owner` VARCHAR(100) NOT NULL,
  `propertyid` INT NOT NULL,
  `shell` VARCHAR(75) NOT NULL,
  `furniture` LONGTEXT,
  `id` VARCHAR(10),
  `rent` VARCHAR(100),
  PRIMARY KEY (`owner`, `propertyid`)
);

CREATE TABLE IF NOT EXISTS `loaf_rent` (
  `rent_wallet` VARCHAR(100) NOT NULL,
  `owner` VARCHAR(100) NOT NULL,
  `propertyid` INT NOT NULL,
  `balance` INT NOT NULL DEFAULT 0,
  `rent_due` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`rent_wallet`)
);

CREATE TABLE IF NOT EXISTS `loaf_furniture` (
  `identifier` VARCHAR(100) NOT NULL,
  `object` VARCHAR(100) NOT NULL,
  `amount` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`, `object`)
);

CREATE TABLE IF NOT EXISTS `loaf_current_property` (
  `identifier` VARCHAR(100) NOT NULL,
  `propertyid` INT NOT NULL,
  `id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`identifier`)
);

-- LOAF REALATOR
CREATE TABLE IF NOT EXISTS `loaf_houses` (
  `id` INT NOT NULL,
  
  `label` VARCHAR(40) NOT NULL DEFAULT "Property",
  `house_apart` VARCHAR(40) NOT NULL DEFAULT "house",

  `interior_type` VARCHAR(40) NOT NULL DEFAULT "shell",
  `interior` VARCHAR(40) NOT NULL,
  `category` VARCHAR(40),

  `entrance` VARCHAR(255) NOT NULL,
  `price` INT NOT NULL DEFAULT 100000,

  `garage_entrance` VARCHAR(255),
  `garage_exit` VARCHAR(255),

  PRIMARY KEY(`id`)
);

-- LOAF GARAGE
ALTER TABLE `player_vehicles` ADD COLUMN IF NOT EXISTS `damages` LONGTEXT;
ALTER TABLE `player_vehicles` ADD COLUMN IF NOT EXISTS `garage` VARCHAR(50) NOT NULL DEFAULT "square";

UPDATE `player_vehicles` SET `damages`=NULL WHERE `damages` IS NOT NULL;

-- LOAF BILLING
CREATE TABLE IF NOT EXISTS `loaf_invoices` (
  `id` VARCHAR(15), -- unique bill id
  `issued` DATE DEFAULT CURRENT_DATE, -- the date the bill was issued

  `biller` VARCHAR(150) NOT NULL, -- the identifier who issued the bill
  `biller_name` VARCHAR(150) NOT NULL, -- the name of the person who issued the bill
  `billed` VARCHAR(150) NOT NULL, -- the identifier who received the bill
  `billed_name` VARCHAR(150) NOT NULL, -- the name of the person who received the bill
  `owner` VARCHAR(150) NOT NULL, -- current person that has the bill

  `due` DATE NOT NULL, -- last date for signing, before interest starts
  `interest` INT NOT NULL DEFAULT 0, -- interest, in percent 
  `late` INT NOT NULL DEFAULT 0, -- how many days late the invoice was paid

  `amount` INT NOT NULL DEFAULT 0, -- the price of the bill
  `name` VARCHAR(150) NOT NULL, -- the name of the bill, used by scripts
  `description` VARCHAR(150) NOT NULL DEFAULT "Unknown", -- the bill description (shown to players)

  `company` VARCHAR(50),
  `company_name` VARCHAR(150),

  `signed` BOOLEAN NOT NULL DEFAULT 0, -- if the bill has been paid
  `signature` LONGTEXT, -- image data (url/base64) for the signature

  PRIMARY KEY (`id`)
);

-- LOAF KEY SYSTEM
CREATE TABLE IF NOT EXISTS `loaf_keys` (
  `unique_id` VARCHAR(15) NOT NULL,
  `key_id` VARCHAR(255) NOT NULL,
  `identifier` VARCHAR(255) NOT NULL,
  `key_data` LONGTEXT,
  PRIMARY KEY (`unique_id`)
);
