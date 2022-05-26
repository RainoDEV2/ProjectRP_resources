-- Use this if you are installing a new DB/Server (these are the default QB-Management jobs/gangs)
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
('galaxy', 0, 'boss'),
('fightclub', 0, 'boss'),
('lostmc', 0, 'gang'),
('ballas', 0, 'gang'),
('vagos', 0, 'gang'),
('cartel', 0, 'gang'),
('families', 0, 'gang'),
('triads', 0, 'gang'),
('celestial', 0, 'gang'),
('zerotolerance', 0, 'gang'),
('the70s', 0, 'gang');
