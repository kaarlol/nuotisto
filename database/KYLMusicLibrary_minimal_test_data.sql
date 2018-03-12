USE kylfi;
CHARSET utf8;

SET foreign_key_checks = 0;

DELETE FROM kml_song;
DELETE FROM kml_arrangement;
DELETE FROM kml_person;
DELETE FROM kml_alias;
DELETE FROM kml_arrangement_author;
DELETE FROM kml_filetype;
DELETE FROM kml_file;
DELETE FROM kml_concert;
DELETE FROM kml_concert_arrangement;

SET foreign_key_checks = 1;


#' == DEFINE FILETYPES =='
INSERT INTO kml_filetype (file_extension,description) values ("pdf","scanned or typeset sheet music") , ("mscz","MuseScore file") , ("sib","Sibelius file") , ("mxl","Compressed MusicXML") , ("xml","MusicXML") , ("mp3","mp3 audio") , ("ogg","ogg-vorbis audio");


#' == ENTER SPECIAL CASE ITEMS IN SONG & ARRANGEMENTS THAT ARE USED FOR CONCERT LISTINGS AS LINEITEM DUMMIES == '

### ' SPECIAL SONG_ID AND ARR_ID == -1 '
SET @special_id := -1;
INSERT INTO kml_song (id,name,song_date) values (@special_id,"SPECIAL--listing lineitem, thick",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=@special_id;
UPDATE kml_arrangement SET id=@special_id, description=null WHERE id=@orig_arr_id;

### ' SPECIAL SONG_ID AND ARR_ID == -2 '
SET @special_id := -2;
INSERT INTO kml_song (id,name,song_date) values (@special_id,"SPECIAL--listing lineitem, medium",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=@special_id;
UPDATE kml_arrangement SET id=@special_id, description=null WHERE id=@orig_arr_id;

### ' SPECIAL SONG_ID AND ARR_ID == -3 '
SET @special_id := -3;
INSERT INTO kml_song (id,name,song_date) values (@special_id,"SPECIAL--listing lineitem, thin",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=@special_id;
UPDATE kml_arrangement SET id=@special_id, description=null WHERE id=@orig_arr_id;


#' == ENTER SOME MUSIC & AUTHORS & file (names & types) INTO THE DATABASE == '

### Franz Abt : Ave Maria
INSERT INTO kml_song (name,song_date) values ("Ave Maria",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Nun ist der laute Tag verhallt, und Frieden dämmert wieder", orchestration="Ten + Bar + TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Franz Wilhelm *Abt","1819-12-22","1885-03-31");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'composer',1);

INSERT IGNORE INTO kml_person (name,birth_date,death_date) values ("Michel *Berend","1834-00-00","1866-00-00");
INSERT INTO kml_alias (person_id,alias) values (LAST_INSERT_ID(),"Michel *Bender");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,NULL,LAST_INSERT_ID(),'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Abt_Ave_Maria.pdf","Musikverlag Engelhart" );


### LET IT GO
INSERT INTO kml_song (name,song_date) values ("Let it go",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description="Transposed from SATB arrangement to TTBB", starting_lyrics="The snow glows white on the mountain tonight; not a footprint to be seen", orchestration="TTTBBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date) values ("Robert *Lopez","1975-02-23");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',2);

INSERT INTO kml_person (name,birth_date) values ("Kristen *Anderson-Lopez","1972-03-21");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',1);


INSERT INTO kml_person (name,birth_date) values ("Roger *Emerson","1950-01-13");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'arranger',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Anderson-Lopez-Let It Go_TTBB.pdf","Modified SATB version (Hal Leonard)", 1.1 );
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "sib" LIMIT 1),"Anderson-Lopez-Let It Go_TTBB.sib",NULL, NULL );
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "mscz" LIMIT 1),"Anderson-Lopez-Let It Go_TTBB.mscz",NULL, NULL );


#### HEY BROTHER
INSERT INTO kml_song (name,song_date) values ("Hey brother",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Hey brother, there's an endless road to rediscover", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date) values ("Salem *Al Fakir","1981-10-27");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',1);
INSERT INTO kml_person (name,birth_date) values ("Tim *Bergling","1989-09-08");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',2);
INSERT INTO kml_person (name,birth_date) values ("Veronica *Maggio","1981-03-15");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',3);
INSERT INTO kml_person (name,birth_date) values ("Vincent *Pontare","1980-05-13");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',4);
INSERT INTO kml_person (name,birth_date) values ("Arash *Pournouri","1981-08-28");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',5);
INSERT INTO kml_person (name,birth_date) values ("Tommi *Paavilainen","1984-11-23");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'arranger',1);


INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Avicii-Hey Brother-ver.2.1.pdf",NULL, "2.1");


#### ALFVÉN : AFTONEN
INSERT INTO kml_song (name,song_date) values ("Aftonen",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Skogen står tyst, himlen är klar", orchestration="TTTTBBBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Hugo Emil *Alfvén","1872-05-01","1960-05-08");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'composer',1);
INSERT INTO kml_person (name,birth_date,death_date) values ("Herman *Sätherberg","1812-05-19","1897-01-09");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Alfven_Aftonen.pdf","Gehrmans Kvartett-Bibliotek nr 209", NULL);


#### trad. (arr. Alfven) : UTI VÅR HAGE
INSERT INTO kml_song (name,song_date) values ("Uti vår hage",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Uti vår hage där växa blåbär. Kom hjärtans fröjd!", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name) values ("*trad. Gotlanti");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'songwriter',1);
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,(select id from kml_person where name like '%Hugo%Alfven%'),NULL,'arranger',1);


#### RAUTAVAARA : LE BAIN
INSERT INTO kml_song (name,song_date) values ("Le Bain",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="L'homme et la bête, tels que le beau monstre antique", orchestration="TTTBBBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Einojuhani *Rautavaara","1928-10-09","2016-07-16");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'composer',1);
INSERT INTO kml_person (name,birth_date,death_date) values ("José-Maria *de Hérédia","1842-11-22","1905-10-03");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'lyricist',1);
INSERT INTO kml_person (name,birth_date,death_date) values ("Hilkka *Norkamo","1910-11-18","2004-03-24");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'finnish translation',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Rautavaara-Le Bain.pdf","Mieskuorolaulut a cappella / Einojuhani Rautavaara (toim. Uolevi Lassander), YL", NULL);
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "mscz" LIMIT 1),"Rautavaara-Le Bain.mscz",NULL,"1.0");


#### SIBELIUS : HUMORESKI
INSERT INTO kml_song (name,song_date) values ("Humoreski",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Elämä, veitikka viisas ja nuori, mun iloisen pillini laittoi", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Jean *Sibelius","1865-12-08","1957-07-16");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id, LAST_INSERT_ID(), NULL, 'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Karl Gustaf *Larson","1873-06-05","1948-12-02");
INSERT INTO kml_alias (person_id,alias) values (LAST_INSERT_ID(),"*Larin-Kyösti");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id, NULL, LAST_INSERT_ID(), 'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "mp3" LIMIT 1),"ElämänKertoja-01-Humoreski.mp3","KYL - Elämän kertoja (1. raita)", NULL);
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"07-Humoreski.pdf","Mestarimerkkilaulut, Suomen Mieskuoroliitto",NULL);
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Sibelius-Humoreski.pdf","Mieskuorolaulut a cappella / Jean Sibelius (toim. Uolevi Lassander), YL",NULL);

#### ASIKAINEN (Nylon Beat) : VIIMEINEN
INSERT INTO kml_song (name,song_date) values ("Viimeinen",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Nannannaa... Hei sä auton kaadoit taas", orchestration="TTTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date) values ("Risto Armas *Asikainen","1958-08-20");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_person (name,birth_date) values ("Ilkka Jussi *Vainio","1960-10-07");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'lyricist',2);

INSERT INTO kml_person (name) values ("Vesa *Vuopala");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'arranger',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Asikainen-Viimeinen.pdf","AL",NULL);
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"37_viimeinen.pdf","KYL-mustavihko",NULL);


#### TORMIS : RAUA NEEDMINE
INSERT INTO kml_song (name,song_date) values ("Raua needmine",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description="Revised version for female or male choir", starting_lyrics="Ohoi sinda rauda raiska, rauda raiska rähka kurja", orchestration="ten. + bas. + TTTTBBBB",arrangement_date="2001-00-00" WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Veljo *Tormis","1930-08-07","2017-01-21");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name) values ("Kalevala");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("August *Annist","1899-01-28","1972-04-06");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'estonian translation',1);

INSERT INTO kml_person (name,birth_date) values ("Paul-Eerik *Rummo","1942-01-19");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'adapted',1);

INSERT INTO kml_person (name,birth_date) values ("Jaan *Kaplinski","1941-01-22");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'adapted',2);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Tormis-Raua needmine.pdf","Fennica Gehrman",NULL);


#### SAINT-SAËNS : SALTARELLE
INSERT INTO kml_song (name,song_date) values ("Saltarelle",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Venez, enfants de la Romagne, tous, chantant de gais refrains", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Camille *Saint-Saëns","1835-10-09","1921-12-16");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Émile *Deschamps","1791-02-20","1871-04-23");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Saint-Saëns-Saltarelle_ver2.pdf","Den Norske Studentersangforening",NULL);


#### KEDROV : OCE NAS
INSERT INTO kml_song (name,song_date) values ("Oče naš",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Nikolai *Kedrov","1871-10-28","1940-02-02");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name) values ("trad.");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);


#### ALFVEN : VAGGVISA
INSERT INTO kml_song (name,song_date) values ("Vaggvisa",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Dagen blir natt, natten blir dag, ingenting giv, ingenting tag, allting glider mot döden", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,(select id from kml_person where name like '%Hugo%Alfven%'),NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Erik Axel *Blomberg","1894-08-17","1965-04-08");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);


#### ALFVEN : MIN KÄRA
INSERT INTO kml_song (name,song_date) values ("Min kära",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Min kära är fin som en liten prinsessa, som vänaste blomma i markerna står.", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,(select id from kml_person where name like '%Hugo%Alfven%'),NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Sten *Selander","1891-00-00","1957-00-00");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);


#### MATSUSHITA : AVE REGINA COELORUM
INSERT INTO kml_song (name,song_date) values ("Ave Regina coelorum",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Ave, Regina Caelorum, Ave, Domina Angelorum", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Ko *Matsushita","1962-10-16",NULL);
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,(select id from kml_person where name = 'trad.'),NULL,'lyricist',1);


#### MÄNTYJÄRVI : SCURVY TUNE
INSERT INTO kml_song (name,song_date) values ("A scurvy tune",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="The master, the swabber, the bo'sun and I", orchestration="TTTBBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Jaakko *Mäntyjärvi","1963-05-27",NULL);
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("William *Shakespeare","1564-00-00","1616-04-23");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);


#### GORNEY : BROTHER CAN YOU SPARE A DIME
INSERT INTO kml_song (name,song_date) values ("Brother, can you spare a dime?",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="They used to tell my I was building a dream, and so I followed the mob", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Jay *Gorney","1894-12-12","1990-06-14");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Edgar Yipsel *Harburg","1896-04-08","1981-03-05");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("David Lee *Wright","1949-12-01",NULL);
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'arranger',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Gorney-Brother can you spare a dime.pdf","Gas House Gang version",NULL);


#### MAKIHARA : SEKAI NI HITOTUS DAKE NO HANA
INSERT INTO kml_song (name,song_date) values ("Sekai ni hitotsu dake no hana",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Namba wan ni naranakute mo ii, motomoto tokubetsuna only one.", orchestration="ten. x3 + TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Noriyuki *Makihara","1969-05-18",NULL);
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'songwriter',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Martin *Egerhill","1981-11-18",NULL);
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'arranger',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Tomas *Larsson",NULL,NULL);
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'arranger',2);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Makihara-Sekai ni hitotuse dake no hana.pdf",NULL,NULL);


#### TRAD. : SHENANDOAH
INSERT INTO kml_song (name,song_date) values ("Shenandoah",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="Oh, Shenandoah, I long to see you, away you rolling river", orchestration="ten. + TTTTBBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,(select id from kml_person where name = 'trad.'),NULL,'songwriter',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Matti *Apajalahti",NULL,NULL);
INSERT INTO kml_alias (person_id,alias) values (LAST_INSERT_ID(),"*Ahti Pajala");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,NULL,LAST_INSERT_ID(),'arranger',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"trad-Shenandoah.pdf",NULL,NULL);


#### CORNELIUS : DER ALTE SOLDAT
INSERT INTO kml_song (name,song_date) values ("Der alte Soldat",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description="Op.12 nro 1", starting_lyrics="Und wenn es einst dunkelt, der Erd bin ich satt", orchestration="TTTTTTBBB",arrangement_date="1873-01-15" WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Peter *Cornelius","1824-12-24","1874-10-26");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Joseph Freiherr *von Eichendorff","1788-03-10","1857-11-26");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Cornelius-Der alte Soldat.pdf","Peter Cornelius: Musikalische Werke vol. 2, Breitkopf & Härtel",NULL);


#### KUULA : ILTAPILVIÄ
INSERT INTO kml_song (name,song_date) values ("Iltapilviä",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description="op.27a nro 5", starting_lyrics="Mun uneni iltapilviä on, punaviittaurhoja kunniavahdissa ylt'ympäri kuolevan auringon", orchestration="TTBB",arrangement_date="1914-00-00" WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Toivo *Kuula","1883-07-07","1918-05-18");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Veikko Antero *Koskenniemi","1885-07-08","1962-08-04");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Kuula-Iltapilviä.pdf","R.E. Westerlund 1672 nro 13",NULL);


#### KUULA : VIRTA VENHETTÄ VIE
INSERT INTO kml_song (name,song_date) values ("Virta venhettä vie",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description="op.4 nro 5a", starting_lyrics="Virta venhettä vie, mihin päättyvi tie? Lyö kuohut purren puuta ja talkaa", orchestration="TTBB",arrangement_date="1907-00-00" WHERE id=@orig_arr_id;

INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,(select id from kml_person where name LIKE 'Toivo%Kuula'),NULL,'songwriter',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Eino *Leino","1878-07-06","1926-01-10");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Kuula-Virta venhettä vie.pdf","Taitomerkkilaulut (20. pakollista), Mieskuoroliito",NULL);


#### SULLIVAN : LONG DAY CLOSES
INSERT INTO kml_song (name,song_date) values ("The long day closes",NULL);
SELECT @orig_arr_id:=id FROM kml_arrangement WHERE song_id=LAST_INSERT_ID();
UPDATE kml_arrangement SET description=NULL, starting_lyrics="No star is o'er the lake, its pale watch keeping, the moon is half awake, through gray mist creeping", orchestration="TTBB",arrangement_date=NULL WHERE id=@orig_arr_id;

INSERT INTO kml_person (name,birth_date,death_date) values ("Arthur Seymour *Sullivan","1842-05-13","1900-11-22");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Henry Fothergill *Chorley","1808-12-15","1872-02-16");
SET @person_id = LAST_INSERT_ID();
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,@person_id,NULL,'lyricist',1);

INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,NULL,(select id from kml_alias where alias LIKE '%Ahti%Pajala%'),'arranger',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Sullivan-The long day closes.pdf",NULL,NULL);


#' ========================================================================'
#' == OVI AUKI'

INSERT INTO kml_concert (name,location,start_time,end_time) values ("Ovi auki! - sisään ja ulos","Helsingin Konservatorio, Ruoholahdentori 6","2018-03-24 17:00","2018-03-24 18:30");
SELECT @concert_id:=LAST_INSERT_ID();

###" === Add a special type of line in the listing - arr_id = -2- to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -2,0,"KYL (Visa) &mdash; taidemusaa");

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Le Bain" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id;
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id ,1);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Raua needmine" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id;
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id ,2);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Saltarelle" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id;
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id ,3);

###" === Add a special type of line in the listing - arr_id = -2 - to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -2,10,"Psaldo (Matti) &mdash; taidemusaa");

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name LIKE "Oce nas" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,11);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Vaggvisa" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,12);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Min kära" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,13);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Ave Regina coelorum" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,14);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "A scurvy tune" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,15);


###" === Add a special type of line in the listing - arr_id = -1 - to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -1,20,"&mdash; VÄLIAIKA &mdash;");

###" === Add a special type of line in the listing - arr_id = -2 - to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -2,30,"KYL (Matti) — kiertuepoppia");


SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name LIKE "Viimeinen" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,31);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name LIKE "Brother, can you spare a dime?" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,32);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name LIKE "Sekai ni hitotsu dake no hana" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,33);


INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -2,40,"KYL + Psaldo — kuoroklassikot");

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Shenandoah" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,41);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Der alte Soldat" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,42);

SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Iltapilviä" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,43);


###" === Add a special type of line in the listing - arr_id = -3 - to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -3,50,"seniorit mukaan");


SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Virta venhettä vie" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,51);


###" === Add a special type of line in the listing - arr_id = -1 - to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -1,60,"&mdash; ENCORE &mdash;");


SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "The long day closes" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,61);


#' ========================================================================'
#' == PRINTEMPO'

INSERT INTO kml_concert (name,location,start_time,end_time) values ("Printempo","Tapiola-sali, Espoon kulttuurikeskus","2018-04-19 16:00","2018-04-19 21:00");

SELECT @concert_id:=LAST_INSERT_ID();


#' ========================================================================'
#' == ÄITIENPÄIVÄ '

INSERT INTO kml_concert (name,location,start_time,end_time) values ("Äitienpäiväkonsertit","?, Amos Rex","2018-05-13 12:00","2018-04-19 20:00");

SELECT @concert_id:=LAST_INSERT_ID();
