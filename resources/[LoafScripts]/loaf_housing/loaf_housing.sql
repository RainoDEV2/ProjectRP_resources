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
