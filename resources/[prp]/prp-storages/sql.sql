
CREATE TABLE IF NOT EXISTS `storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `pincode` int(11) DEFAULT NULL,
  `coords` longtext DEFAULT '[]',
  `keyholders` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

