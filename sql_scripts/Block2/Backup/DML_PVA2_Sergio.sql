USE hotel;

insert into Titel values (1, 'Professor');
insert into Titel values (2, 'Doktor');
insert into Titel values (3, 'Dipl.Ing.');

insert into Person values (1, 1,  'John', 'Schnee', 'de', 'm', '1980-07-20');
insert into Person values (2, 2,  'Barbara', 'Blume', 'de', 'f', '1980-12-31');
insert into Person values (3, 3,  'Steven', 'Smith', 'en', 'm', '1971-01-01');
insert into Person values (4, null,  'Bob', 'Bolo', 'en', 'm', '1969-01-01');

insert into TelefonTyp values (1, 'Mobile');
insert into TelefonTyp values (2, 'Festnetz');
insert into TelefonTyp values (3, 'Geschäft');

insert into Mitarbeiter values (8, 3, 'xx-bb-yy', '12a-45g-hdj');

insert into AnsprechPerson values (1, 4);

insert into Firma values (8080, 'JB Monolith');
insert into Firma values (8090, 'Moon Holiday');

insert into GeschaeftsPartner values (44, 8090);

insert into Telefon values (7,1,null, 1, '041 78 78 78');
insert into Telefon values (8,2,null, 1, '041 79 87 63');
insert into Telefon values (9,null,8080, 1, '041 82 37 27');

insert into Email values (1, 'a1@bar.com', 1, null);
insert into Email values (2, 'a2@bar.com', 2, null);
insert into Email values (3, 'a3@bar.com', null, 8080);

insert into Land values (1, 'ch');
insert into Land values (2, 'de');

insert into Ort values (1, 'zurich', '8000', 1);
insert into Ort values (2, 'frankfurt', '6400', 2);

insert into PrivatKunde values (1);

insert into Kunde values (1,1);

insert into Reiseunternehmen values (1, 8080, 1);

insert into Buchunganfrage values (1, 1, '2017-12-31', '2018-01-31', 4, '2017-05-05', false);

insert into GeschaeftsKunde values (1,44);

insert into BettenTyp values (1, 2, 'Doppelbett');
insert into BettenTyp values (2, 1, 'Einzelbett');

insert into ZimmerTyp values (1, 1, 'Einzelzimmer', false, false, false);
insert into ZimmerTyp values (2, 2, 'Doppelimmer', false, false, false);

insert into Trakt values (1, 'Hauptgebäude');

insert into Zimmer values (1, 1, 1, 1, false);
insert into Zimmer values (2, 2, 1, 1, false);
insert into Zimmer values (3, 1, 1, 1, true);

insert into ZimmerBelegungPerson values (1, 1);


insert into OnlineBuchung values (1, 'qux', 'joe', 'qux@joe.com');

insert into Adresse values (1, 'zeile1', 'zeile2', 'zeile3', 1, 1, null);

insert into Buchung values (1, 1, null, 1, null, '123456', '2017-12-31', '2018-01-31');

insert into ZimmerBelegung values (1, 1, 1);