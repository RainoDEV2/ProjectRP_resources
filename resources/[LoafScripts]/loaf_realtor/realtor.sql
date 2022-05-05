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