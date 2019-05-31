-- Exported from QuickDBD: https://www.quickdatatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/vMC8i4
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE `Book` (
    `id` integer AUTO_INCREMENT NOT NULL ,
    `isbn` varchar(13)  NULL ,
    `title` varchar(50)  NOT NULL ,
    `printed_year` integer  NULL ,
    `written_year` integer  NULL ,
    `print_name` varchar(20)  NOT NULL DEFAULT '',
    `tags` varchar(100)  NOT NULL ,
    `comments` varchar(2000)  NOT NULL ,
    PRIMARY KEY (
        `id`
    )
);

CREATE TABLE `Exemplar` (
    `id` integer AUTO_INCREMENT NOT NULL ,
    `book` integer  NOT NULL ,
    `place` integer  NOT NULL ,
    `lending_rule` integer  NOT NULL ,
    `condition` char  NOT NULL ,
    `comments` varchar(50)  NOT NULL DEFAULT '',
    `lending_count` integer  NOT NULL DEFAULT 0,
    PRIMARY KEY (
        `id`
    )
);

CREATE TABLE `Reader` (
    `id` integer AUTO_INCREMENT NOT NULL ,
    `reader_card_number` varchar  NOT NULL ,
    `name` varchar(100)  NOT NULL ,
    `phone` varchar(20)  NULL ,
    `address` varchar(100)  NULL ,
    `debt` integer  NOT NULL ,
    PRIMARY KEY (
        `id`
    ),
    CONSTRAINT `uc_Reader_reader_card_number` UNIQUE (
        `reader_card_number`
    )
);

CREATE TABLE `Author` (
    `id` integer AUTO_INCREMENT NOT NULL ,
    `name` varchar(100)  NOT NULL ,
    PRIMARY KEY (
        `id`
    ),
    CONSTRAINT `uc_Author_name` UNIQUE (
        `name`
    )
);

CREATE TABLE `Authoring` (
    `autor` integer  NOT NULL ,
    `book` integer  NOT NULL 
);

CREATE TABLE `Lending` (
    `exemplar` integer  NOT NULL ,
    `reader` integer  NOT NULL ,
    `deadline` date  NOT NULL ,
    PRIMARY KEY (
        `exemplar`,`reader`
    )
);

CREATE TABLE `Place` (
    `id` integer AUTO_INCREMENT NOT NULL ,
    `pointer` varchar(20)  NOT NULL ,
    PRIMARY KEY (
        `id`
    ),
    CONSTRAINT `uc_Place_pointer` UNIQUE (
        `pointer`
    )
);

CREATE TABLE `LendingRule` (
    `id` integer AUTO_INCREMENT NOT NULL ,
    `name` varchar(20)  NOT NULL ,
    `days` integer  NOT NULL ,
    `fine` integer  NOT NULL ,
    PRIMARY KEY (
        `id`
    ),
    CONSTRAINT `uc_LendingRule_name` UNIQUE (
        `name`
    )
);

CREATE TABLE `BusOrder` (
    `id` INTEGER AUTO_INCREMENT NOT NULL ,
    `day` date  NOT NULL ,
    `reader` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `id`
    )
);

CREATE TABLE `OrderedBook` (
    `book` INTEGER  NOT NULL ,
    `bus_order` INTEGER  NOT NULL 
);

ALTER TABLE `Exemplar` ADD CONSTRAINT `fk_Exemplar_book` FOREIGN KEY(`book`)
REFERENCES `Book` (`id`);

ALTER TABLE `Exemplar` ADD CONSTRAINT `fk_Exemplar_place` FOREIGN KEY(`place`)
REFERENCES `Place` (`id`);

ALTER TABLE `Exemplar` ADD CONSTRAINT `fk_Exemplar_lending_rule` FOREIGN KEY(`lending_rule`)
REFERENCES `LendingRule` (`id`);

ALTER TABLE `Authoring` ADD CONSTRAINT `fk_Authoring_autor` FOREIGN KEY(`autor`)
REFERENCES `Author` (`id`);

ALTER TABLE `Authoring` ADD CONSTRAINT `fk_Authoring_book` FOREIGN KEY(`book`)
REFERENCES `Book` (`id`);

ALTER TABLE `Lending` ADD CONSTRAINT `fk_Lending_exemplar` FOREIGN KEY(`exemplar`)
REFERENCES `Exemplar` (`id`);

ALTER TABLE `Lending` ADD CONSTRAINT `fk_Lending_reader` FOREIGN KEY(`reader`)
REFERENCES `Reader` (`id`);

ALTER TABLE `BusOrder` ADD CONSTRAINT `fk_BusOrder_reader` FOREIGN KEY(`reader`)
REFERENCES `Reader` (`id`);

ALTER TABLE `OrderedBook` ADD CONSTRAINT `fk_OrderedBook_book` FOREIGN KEY(`book`)
REFERENCES `Book` (`id`);

ALTER TABLE `OrderedBook` ADD CONSTRAINT `fk_OrderedBook_bus_order` FOREIGN KEY(`bus_order`)
REFERENCES `BusOrder` (`id`);

