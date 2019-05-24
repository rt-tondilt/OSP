/*
Andmebaasi koodi esimene osa on autogenereeritud.
Selle saamiseks tuleb eksportida MySql-ina ja siis teha järgmine tekstiasendus.
"AUTO_INCREMENT NOT NULL" -> "NOT NULL DEFAULT AUTOINCREMENT"
Siis saab SAP interactive SQL sellest aru.
*/

CREATE TABLE `Book` (
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
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
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
    `book` integer  NOT NULL ,
    `place` integer  NOT NULL ,
    `lending_rule` integer  NOT NULL ,
    `condition` char(1)  NOT NULL CHECK (`condition` in ('S', 'P', 'M')),
    `comments` varchar(50)  NOT NULL DEFAULT '',
    `lending_count` integer  NOT NULL DEFAULT 0,
    PRIMARY KEY (
        `id`
    )
);

CREATE TABLE `Reader` (
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
    `reader_card_number` varchar(13)  NOT NULL ,
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
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
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
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
    `pointer` varchar(20)  NOT NULL ,
    PRIMARY KEY (
        `id`
    ),
    CONSTRAINT `uc_Place_pointer` UNIQUE (
        `pointer`
    )
);

CREATE TABLE `LendingRule` (
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
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
    `id` integer NOT NULL DEFAULT AUTOINCREMENT ,
    `day` date  NOT NULL ,
    `reader` integer  NOT NULL ,
    PRIMARY KEY (
        `id`
    )
);

CREATE TABLE `OrderedBook` (
    `book` integer  NOT NULL ,
    `bus_order` integer  NOT NULL
);

ALTER TABLE `Exemplar` ADD CONSTRAINT `fk_Exemplar_book` FOREIGN KEY(`book`)
REFERENCES `Book` (`id`);
/* Raamatut ei saa kustutada, kui tal on eksemplare. */

ALTER TABLE `Exemplar` ADD CONSTRAINT `fk_Exemplar_place` FOREIGN KEY(`place`)
REFERENCES `Place` (`id`);
/* Kohaviita ei saa kustutada, kui seal on eksemplare. */

ALTER TABLE `Exemplar` ADD CONSTRAINT `fk_Exemplar_lending_rule` FOREIGN KEY(`lending_rule`)
REFERENCES `LendingRule` (`id`);
/* Laenureeglit ei saa kustutada, kui leidub selle reegliga eksemplaare. */

ALTER TABLE `Authoring` ADD CONSTRAINT `fk_Authoring_autor` FOREIGN KEY(`autor`)
REFERENCES `Author` (`id`)
ON DELETE CASCADE;
/* Autori kustutamine kustutab autorluse. */

ALTER TABLE `Authoring` ADD CONSTRAINT `fk_Authoring_book` FOREIGN KEY(`book`)
REFERENCES `Book` (`id`)
ON DELETE CASCADE;
/* Raamatu kustutamine kustutab autorluse. */

ALTER TABLE `Lending` ADD CONSTRAINT `fk_Lending_exemplar` FOREIGN KEY(`exemplar`)
REFERENCES `Exemplar` (`id`);
/* Eksemplaari ei saa kustutada, kui ta pole tagastatud. */

ALTER TABLE `Lending` ADD CONSTRAINT `fk_Lending_reader` FOREIGN KEY(`reader`)
REFERENCES `Reader` (`id`);
/* Lugejat ei saa kustutada, kui ta pole mingit eksemplaari tagastanud. */

ALTER TABLE `BusOrder` ADD CONSTRAINT `fk_BusOrder_reader` FOREIGN KEY(`reader`)
REFERENCES `Reader` (`id`)
ON DELETE CASCADE;
/* Lugeja kustutamine kustutab tema bussitellimused. */

ALTER TABLE `OrderedBook` ADD CONSTRAINT `fk_OrderedBook_book` FOREIGN KEY(`book`)
REFERENCES `Book` (`id`)
ON DELETE CASCADE;
/* Raamatu kustutamine eemaldab selle raamatu bussitellimuse ridadest. */

ALTER TABLE `OrderedBook` ADD CONSTRAINT `fk_OrderedBook_bus_order` FOREIGN KEY(`bus_order`)
REFERENCES `BusOrder` (`id`)
ON DELETE CASCADE;
/* Bussitellimuse kustutamine eemaldab selle bussitellimuse kõik read. */


/*============================================================================*/
