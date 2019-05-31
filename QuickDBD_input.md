
Book
-
id integer PK AUTOINCREMENT
isbn varchar(13) NULL
title varchar(50)
printed_year integer NULL
written_year integer NULL
print_name varchar(20) default=''
tags varchar(100)
comments varchar(2000)


Exemplar
-
id integer PK AUTOINCREMENT
book integer FK >- Book.id
place integer FK >- Place.id
lending_rule integer FK >- LendingRule.id
condition char(1)
comments varchar(50) default=''
lending_count integer default=0

Reader
-
id integer PK AUTOINCREMENT
reader_card_number varchar(10) UNIQUE
name varchar(100)
phone varchar(20) NULL
address varchar(100) NULL
debt integer

Author
-
id integer PK AUTOINCREMENT
name varchar(100) UNIQUE

Authoring
-
autor integer FK >- Author.id
book integer FK >- Book.id

Lending
-
exemplar integer FK >- Exemplar.id PK
reader integer FK >- Reader.id PK
deadline date

Place
-
id integer PK AUTOINCREMENT
pointer varchar(20) UNIQUE

LendingRule
-
id integer PK AUTOINCREMENT
name varchar(20) UNIQUE
days integer
fine integer

BusOrder
-
id integer PK AUTOINCREMENT
day date
reader integer FK >- Reader.id

OrderedBook
-
book integer FK >- Book.id
bus_order integer FK >- BusOrder.id
