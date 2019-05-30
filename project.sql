/*
Andmebaasi koodi esimene osa on autogenereeritud.

Genereerimiseks kasutati internetist kättesaadavat tööriista QuickDBD. SQL-i
genereerimiseks tuleb eksportida MySql-ina ja siis teha järgmine tekstiasendus.

'AUTO_INCREMENT NOT NULL' -> 'NOT NULL DEFAULT AUTOINCREMENT'

Siis saab SAP interactive SQL sellest aru.

Peale selle eemaldati tekstist kõik '`' märgid, et vähendada müra.

Lisaks sellele on saadud SQL-i koodis tehtud mõned muudatused, mille
kirjeldamine pole QuickDBD-ga võimalik. Ning lõpuks lisati kommentaarid.
*/

/*----------------------------------------------------------------------------*/

/* See on hiljem vajalik. */
SET OPTION PUBLIC.continue_after_raiserror = OFF;

CREATE TABLE Book (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    isbn varchar(13)  NULL ,
    title varchar(50)  NOT NULL ,
    printed_year integer  NULL ,
    written_year integer  NULL ,
    print_name varchar(20)  NOT NULL DEFAULT '',
    tags varchar(100)  NOT NULL DEFAULT '' ,
    comments varchar(2000)  NOT NULL DEFAULT '',
    PRIMARY KEY (
        id
    )
);
/*
Märkused:

isbn -- Kontrollisin pikkust vikipeediast. ISBN-il on ka kontrollsumma,
    aga seda see andmebaas ei kontrolli. Igal raamatukogus oleval raamatul ei
    pruugi ISBN olla.
title -- Kui title on pikem kui 50 siis kirjuta see comments-isse.
printed_year, written_year -- Ei pruugi teada olla.
print_name -- Näiteks 'Esimene trükk' või 'Teine trükk'. See võiks ka integer
    olla, kuid kuna eri kirjastused võivad sama asja välja anda, siis võivad
    trükki numbrid sassi minna. See andmebaad ei tea kirjastustest midagi ja
    seetõttu panin siia igaks juhuks varchar-i. Samuti võib ISBN mitmel trükil
    sama olla; oleneb sellest, kas tegu on nn edition-ide või reprint-idega.
    Kui on teada vaid üks trükk, siis soovitan kasutada väljendit
    'Esimene trükk' või jätta väli tühjaks.
tags -- Teost kirjeldavad märksõnad komadega eraldatud. Näiteks
    'füüsika, kosmos, astronoomia, kuu'. See pole ilus lahendus; targem oleks
    teha eraldi märksõnade tabel ja märksõna-raamatu-seoste tabel, mis
    kiirendaks otsingut ja aitaks ennetada kirjavigu märksõnades. Kuna QuickDBD
    lubab teha vaid kuni 10 tabelit, siis jäi see ära.
comments -- Siin on nii palju ruumi, et võib kirjutada, mis süda lustib. Ma
    lugesin StackOverflows-t, et mõistlikud andmebaasid optimiseerivad selle ära
    ja iga raamatu kohta ei tule umbes 2000 tähe jagu raisatud kettaruumi.
*/


CREATE TABLE Exemplar (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    book integer  NOT NULL ,
    place integer  NOT NULL ,
    lending_rule integer  NOT NULL ,
    condition char(1)  NOT NULL CHECK (condition in ('S', 'D', 'M')),
    comments varchar(50)  NOT NULL DEFAULT '',
    lending_count integer  NOT NULL DEFAULT 0,
    PRIMARY KEY (
        id
    )
);
/*
Märkused:

book, place, lending_rule -- Välisvõtmed vastavatesse tabelitesse.
condition -- Variandid on 'S' (suurepärane), 'D' (defektne),
    'M' (mahakandmisele).
comments -- Näiteks 'kohviplekid lehekülgedel 48-52'.
lending_count -- See andmebaas ei pea meeles mineviku laenutusi ja seega on
    see veerg ainukene võimalus statistika tegemiseks.
*/


CREATE TABLE Reader (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    reader_card_number varchar(13)  NOT NULL ,
    name varchar(100)  NOT NULL ,
    phone varchar(20)  NULL ,
    address varchar(100)  NULL ,
    debt integer  NOT NULL ,
    PRIMARY KEY (
        id
    ),
    CONSTRAINT uc_Reader_reader_card_number UNIQUE (
        reader_card_number
    )
);
/*
Märkused:

reader_card_number -- Lugejakaardi number. Sellel võiks pms ka kontrollsumma
    olla, aga ütleme, et raamatukogu töötajatel on oma meetod numbrite andmiseks
    ja nad tahavad seda muuta ja seetõttu pole ei kontrollsummat ega
    AUTOINCREMENT-i.
name -- Eesnimi ja perekonnanimi pole eraldatud, kuna inimesel ei pruugi olla
    üheselt eristatavat ees- ja perekonnanime. Kui see teema rohkem huvitab,
    siis võib guugeldada 'Falsehoods Programmers Believe About Names'. Ma jään
    selle peale lootma et iga inimene ise valib, kuidas ta nimi andmebaasi
    läheb. Tavaliste eestlaste puhul tuleks eesnimi enne panna.
phone -- Võib anda telefoninumbri.
address -- See võiks olla mitu erinevat veergu nt riik, maakond, linn, tänav,
    maja, korter. Aga lisaks sellele on ka talu nimed ja nii edasi. Seepärast
    valisin lihtsama viisi. Vaata ka 'Falsehoods programmers believe about
    geography'.
debt -- Lugeja võlg. Siia lähevad need raamatud, mis on tagastatud peale
    tähtaega, kuid viivist pole makstud. Võlg on 0 või positiivne.
*/

CREATE TABLE Author (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    name varchar(100)  NOT NULL ,
    PRIMARY KEY (
        id
    ),
    CONSTRAINT uc_Author_name UNIQUE (
        name
    )
);
/*
Märkused:

name -- Vaata märkust Reader.name kohta. Siin saab õnneks rohkem eksootilisi
    näiteid tuua. 'Gaius Julius Caesar', 'Guido van Rossum',
    'Leonardo da Vinci', 'Kong Fuzi' e. 'Konfutsius'.
*/


CREATE TABLE Authoring (
    author integer  NOT NULL ,
    book integer  NOT NULL
);
/*
Märkused:

author, book -- Välisvõtmed vastavatesse tabelitesse.
*/

CREATE TABLE Lending (
    exemplar integer  NOT NULL ,
    reader integer  NOT NULL ,
    deadline date  NOT NULL ,
    PRIMARY KEY (
        exemplar,reader
    ),
    CONSTRAINT uc_Lending_exemplar UNIQUE (
        exemplar
    )
);
/*
Märkused:

exemplar, reader -- Välisvõtmed vastavatesse tabelitesse.
deadline -- Ilma viivisetta tagastamise viimane päev.
*/

CREATE TABLE Place (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    pointer varchar(20)  NOT NULL ,
    PRIMARY KEY (
        id
    ),
    CONSTRAINT uc_Place_pointer UNIQUE (
        pointer
    )
);
/*
Märkused:

pointer -- Kohaviit. Sellel võik ka olla kontrollsumma või midagi sellesarnast,
    kuid ma arvan, et on parem kui töötajad saavad ise oma lühendeid välja
    mõelda.
*/

CREATE TABLE LendingRule (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    name varchar(20)  NOT NULL ,
    days integer  NOT NULL ,
    fine integer  NOT NULL ,
    PRIMARY KEY (
        id
    ),
    CONSTRAINT uc_LendingRule_name UNIQUE (
        name
    )
);
/*
Märkused:

name -- Näiteks 'kuulaenutus', 'nädalalaenutus', 'ei laenutata'.
days -- Päevade arv.
fine -- Viivis sentides päeva kohta.
*/

CREATE TABLE BusOrder (
    id integer NOT NULL DEFAULT AUTOINCREMENT ,
    day date  NOT NULL ,
    reader integer  NOT NULL ,
    PRIMARY KEY (
        id
    )
);
/*
Märkused:
day -- Mis päevasele bussile raamatud tellitakse.
reader -- Kes tellis raamatud.
*/

CREATE TABLE OrderedBook (
    book integer  NOT NULL ,
    bus_order integer  NOT NULL
);
/*
Märkused:
book -- Mis raamat telliti
bus_order -- Mis tellimusega see raamat tuleb.
*/

/*----------------------------------------------------------------------------*/

/*
Järgnevalt paneme paika välisvõtmed. Kuna kõik välisvõtmed on id-d, siis
välisvõtmete uuendamisel pole mõtet. Kustutamiskäitumise valin aga ise.

NB: Vaikimisi käitumine on "ON DELETE RESTRICT ON UPDATE RESTRICT".
*/

ALTER TABLE Exemplar ADD CONSTRAINT fk_Exemplar_book FOREIGN KEY(book)
REFERENCES Book (id);
/* Raamatut ei saa kustutada, kui tal on eksemplare. */

ALTER TABLE Exemplar ADD CONSTRAINT fk_Exemplar_place FOREIGN KEY(place)
REFERENCES Place (id);
/* Kohaviita ei saa kustutada, kui seal on eksemplare. */

ALTER TABLE Exemplar ADD CONSTRAINT fk_Exemplar_lending_rule FOREIGN KEY(lending_rule)
REFERENCES LendingRule (id);
/* Laenureeglit ei saa kustutada, kui leidub selle reegliga eksemplaare. */

ALTER TABLE Authoring ADD CONSTRAINT fk_Authoring_author FOREIGN KEY(author)
REFERENCES Author (id)
ON DELETE CASCADE;
/* Autori kustutamine kustutab autorluse. */

ALTER TABLE Authoring ADD CONSTRAINT fk_Authoring_book FOREIGN KEY(book)
REFERENCES Book (id)
ON DELETE CASCADE;
/* Raamatu kustutamine kustutab autorluse. */

ALTER TABLE Lending ADD CONSTRAINT fk_Lending_exemplar FOREIGN KEY(exemplar)
REFERENCES Exemplar (id);
/* Eksemplaari ei saa kustutada, kui ta pole tagastatud. */

ALTER TABLE Lending ADD CONSTRAINT fk_Lending_reader FOREIGN KEY(reader)
REFERENCES Reader (id);
/* Lugejat ei saa kustutada, kui ta pole mingit eksemplaari tagastanud. */

ALTER TABLE BusOrder ADD CONSTRAINT fk_BusOrder_reader FOREIGN KEY(reader)
REFERENCES Reader (id)
ON DELETE CASCADE;
/* Lugeja kustutamine kustutab tema bussitellimused. */

ALTER TABLE OrderedBook ADD CONSTRAINT fk_OrderedBook_book FOREIGN KEY(book)
REFERENCES Book (id)
ON DELETE CASCADE;
/* Raamatu kustutamine eemaldab selle raamatu bussitellimuse ridadest. */

ALTER TABLE OrderedBook ADD CONSTRAINT fk_OrderedBook_bus_order FOREIGN KEY(bus_order)
REFERENCES BusOrder (id)
ON DELETE CASCADE;
/* Bussitellimuse kustutamine eemaldab selle bussitellimuse kõik read. */


/*----------------------------------------------------------------------------*/

INPUT INTO Author (id, "name")
FROM 'example_data\\author.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO Book (id, title, written_year)
FROM 'example_data\\book.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO Authoring (book, author)
FROM 'example_data\\authoring.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO Place (id, pointer)
FROM 'example_data\\place.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO LendingRule (id, "name", days, fine)
FROM 'example_data\\lending_rule.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO Exemplar (id, book, place, lending_rule, condition, comments, lending_count)
FROM 'example_data\\exemplar.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO Reader (id, reader_card_number, "name", debt)
FROM 'example_data\\reader.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

INPUT INTO Lending (exemplar, reader, deadline)
FROM 'example_data\\lending.csv'
FORMAT ASCII DELIMITED BY ',' ENCODING 'UTF-8';

/*----------------------------------------------------------------------------*/


/*
Vaade raamatute laenutamise kohta statistika tegemiseks.
*/
CREATE VIEW v_book_statistics AS
SELECT Book.id, Book.title, SUM(lending_count) as lending_count
FROM Book KEY JOIN Exemplar
GROUP BY Book.id, Book.title
ORDER BY lending_count DESC, Book.title;

/*
Vaade mis vormindab raamatu autorid semikoolonitega eraldatud sõneks.
*/
CREATE VIEW v_book_authors AS
SELECT Book.id, Book.title, LIST(Author.name, '; ' ORDER BY Author.name) AS authors
FROM Book KEY JOIN Authoring KEY JOIN Author
GROUP BY Book.id, Book.title;

/*
Vaade, mis kuvab kogu eksemplariga seotud info, mis raamatukogutöötajat või lugejat
võib huvitada.
*/
CREATE VIEW v_exemplar_pretty AS
SELECT
    Exemplar.id, isbn, Book.title, authors, printed_year, written_year, print_name,
    tags, condition, Exemplar.comments, lending_count, pointer,
    LendingRule.name AS lending_rule
FROM Book KEY JOIN Exemplar KEY JOIN Place KEY JOIN LendingRule JOIN v_book_authors
ON Book.id = v_book_authors.id;


/*
Vaade, mis on kasulik kohaviidale vastava riiuli inspekteerimiseks.
*/
CREATE VIEW v_shelf_state AS
SELECT Place.pointer, Exemplar.id as exemplar_id, isbn, Book.title, authors,
    CASE WHEN EXISTS (
        SELECT * FROM Lending WHERE Lending.exemplar = Exemplar.id
    ) THEN 1 ELSE 0 END
    AS is_lended
FROM Place KEY JOIN Exemplar KEY JOIN Book JOIN v_book_authors
ON Book.id = v_book_authors.id;


/*
Funktsioon lugejakaardi esitanud lugejale eksemlaari laenamiseks.

Funktsioon loob andmebaasi uue laenutuse.
Funktsioon tagastab tagastustähtaja.

Funktsioon ei tööta kui:
    * Eksemplaari pole olemas
    * Sellise lugejakaardi numbriga lugejat pole.
    * Eksemplar on juba välja laenutatud.
    * Eksemplar on kohalkasutuseks.
*/
CREATE FUNCTION f_lend_exemplar(
a_exemplar integer,
a_reader_card_number varchar(13)
)
RETURNS date
NOT DETERMINISTIC
BEGIN
    DECLARE d_deadline date;
    DECLARE d_reader integer;

    SELECT DATEADD(DAY, days, CURRENT DATE) INTO d_deadline
    FROM Exemplar KEY JOIN LendingRule
    WHERE Exemplar.id = a_exemplar AND NOT days=0;

    SELECT id INTO d_reader FROM Reader
    WHERE reader_card_number = a_reader_card_number;

    INSERT INTO Lending (exemplar, reader, deadline)
    VALUES (a_exemplar, d_reader, d_deadline);

    RETURN d_deadline;
END;


/*
Funktsioon eksemplaari tagastamiseks.

Funktsioon eemaldab andmebaasist laenutuse.
Funktsioon tagastab nõutava viivise.

Funktsioon ei tööta kui:
    * Eksemplaari pole olemas
    * Eksemplaar pole välja laenutatud.
*/
CREATE FUNCTION f_return_exemplar(
a_exemplar integer
)
RETURNS integer
NOT DETERMINISTIC
BEGIN
    DECLARE d_datediff integer;
    DECLARE d_total_fine integer;

    SELECT DATEDIFF(DAY, Lending.deadline, CURRENT DATE) INTO d_datediff
    FROM Lending
    WHERE Lending.exemplar = a_exemplar;

    IF d_datediff IS NULL THEN
        RAISERROR 19999 'This exemplar is not lended.'
    END IF;

    SELECT (
    CASE WHEN d_datediff > 0 THEN d_datediff * fine ELSE 0 END
    ) INTO d_total_fine
    FROM Exemplar KEY JOIN LendingRule
    WHERE Exemplar.id = a_exemplar;

    UPDATE Exemplar SET lending_count = lending_count + 1
    WHERE id = a_exemplar;

    DELETE FROM Lending WHERE Lending.exemplar = a_exemplar;

    RETURN d_total_fine;
END;

/*
Protseduur, mis tagastab eksemplarid, mis peavad hetkel riiulis olema
tähestikulises järjekorras.
*/
CREATE PROCEDURE sp_examine_place (a_pointer varchar(13))
RESULT (
exemplar_id integer,
isbn varchar(13),
title varchar(50),
authors varchar(2000)
)
BEGIN
    SELECT exemplar_id, isbn, title, authors FROM v_shelf_state
    WHERE pointer = a_pointer AND is_lended=0
    ORDER BY authors, title;
END;

/*
Vaata, mis eksemplarid lugejal on laenutatud.
*/
CREATE PROCEDURE sp_reader_lendings (a_reader_card_number varchar(13))
RESULT (
exemplar_id integer,
isbn varchar(13),
title varchar(50),
authors varchar(2000),
deadline date
)
BEGIN
    SELECT v_exemplar_pretty.id, isbn, title, authors, deadline
    FROM Reader KEY JOIN Lending KEY JOIN v_exemplar_pretty
    WHERE reader_card_number = a_reader_card_number
    ORDER BY deadline, authors, title;
END;

/*
//INSERT INTO Lending (exemplar, reader, deadline) VALUES (2, 1, DATEADD(DAY, 4, CURRENT DATE));

CREATE FUNCTION f_lend_exemplar2(
a_exemplar integer,
a_reader_card_number varchar(13)
)
RETURNS date
NOT DETERMINISTIC
BEGIN
    DECLARE d_deadline date;
    DECLARE d_reader integer;

    SELECT DATEADD(DAY, "days", CURRENT DATE) INTO d_deadline
    FROM Exemplar KEY JOIN LendingRule
    WHERE Exemplar.id = a_exemplar;

    SELECT id INTO d_reader FROM Reader
    WHERE reader_card_number = a_reader_card_number;

    INSERT INTO Lending (exemplar, reader, deadline)
    VALUES (a_exemplar, d_reader, d_deadline);

    RETURN d_deadline;
END;*/

/*CREATE PROCEDURE sp_reader_loaned_exemplars (reader_id integer)
RESULT (
book_title varchar(100),
deadline date,
days_over_deadline integer,
fine_
)
BEGIN
SELECT eesnimi, perenimi, CURRENT DATE
FROM isikud
WHERE klubi = a_klubi_id ORDER BY eesnimi ;
END ;*/
