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
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,LAST_INSERT_ID(),NULL,'composer',1);

INSERT INTO kml_person (name,birth_date,death_date) values ("Karl Gustaf *Larson","1873-06-05","1948-12-02");
INSERT INTO kml_alias (person_id,alias) values (LAST_INSERT_ID(),"*Larin-Kyösti");
INSERT INTO kml_arrangement_author (arrangement_id,person_id,alias_id,contribution_type,author_order) values (@orig_arr_id,NULL,LAST_INSERT_ID(),'lyricist',1);

INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "mp3" LIMIT 1),"ElämänKertoja-01-Humoreski.mp3","KYL - Elämän kertoja (1. raita)", NULL);
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"07-Humoreski.pdf","Mestarimerkkilaulut, Suomen Mieskuoroliitto",NULL);
INSERT INTO kml_file (arrangement_id,filetype_id,filename,description,version) values (@orig_arr_id,(SELECT id FROM kml_filetype WHERE file_extension = "pdf" LIMIT 1),"Sibelius-Humoreski.pdf","Mieskuorolaulut a cappella / Jean Sibelius (toim. Uolevi Lassander), YL",NULL);



#' == ENTER A TEST GIG LISTING == '

INSERT INTO kml_concert (name,location,start_time,end_time) values ("Ovi auki! - sisään ja ulos","Helsingin Konservatorio, Ruoholahdentori 6","2018-03-24 17:00","2018-03-24 18:30");
SELECT @concert_id:=LAST_INSERT_ID();

# find the first (well LIMIT 1) arrangement of a song titled "Le Bain" and add it to the concert list
SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Le Bain" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id;
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id ,1);

###" === Add a special type of line in the listing - arr_id = -1 - to denote a line other than song in the listing"
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order,line_text) values (@concert_id , -1,2,"-- INTERMISSION --");

# find the first arrangement of a song titled "Aftonen" and add it to the concert list
SELECT @arr_id:=kml_arrangement.id FROM kml_arrangement INNER JOIN (SELECT id, name FROM kml_song WHERE name = "Aftonen" LIMIT 1) AS songselect ON kml_arrangement.song_id = songselect.id; 
INSERT INTO kml_concert_arrangement (concert_id,arrangement_id,arrangement_order) values (@concert_id , @arr_id,3);


