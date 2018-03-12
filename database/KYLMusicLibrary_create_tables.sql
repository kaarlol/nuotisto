USE kylfi;
CHARSET utf8;

#### drop tables & triggers if they already exist 

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS kml_song;
DROP TABLE IF EXISTS kml_arrangement;
DROP TABLE IF EXISTS kml_concert;
DROP TABLE IF EXISTS kml_concert_arrangement;
DROP TABLE IF EXISTS kml_collection;
DROP TABLE IF EXISTS kml_collection_arrangement;
DROP TABLE IF EXISTS kml_person;
DROP TABLE IF EXISTS kml_alias;
DROP TABLE IF EXISTS kml_arrangement_author;
DROP TABLE IF EXISTS kml_filetype;
DROP TABLE IF EXISTS kml_file;

DROP TRIGGER IF EXISTS kml_concert_added_ins;
DROP TRIGGER IF EXISTS auto_add_arrangement; 
DROP TRIGGER IF EXISTS kml_collection_added_ins;
DROP TRIGGER IF EXISTS arrangement_author_both_person_alias_both_not_null_upd;
DROP TRIGGER IF EXISTS arrangement_author_both_person_alias_both_not_null_ins;

SET foreign_key_checks = 1;




#### now create the tables

CREATE TABLE kml_song (
	id INT NOT NULL AUTO_INCREMENT, 
	name VARCHAR(255) NOT NULL, 
	song_date DATE, 
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id) ) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TABLE kml_arrangement (
	id INT NOT NULL AUTO_INCREMENT, 
	song_id INT NOT NULL,
	description VARCHAR(255), 
	starting_lyrics VARCHAR(255),
	orchestration VARCHAR(255),
	arrangement_date DATE, 
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id),
	FOREIGN KEY (song_id) REFERENCES kml_song(id) ON DELETE CASCADE)
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 
	
CREATE TRIGGER auto_add_arrangement AFTER INSERT ON kml_song FOR EACH ROW 
	INSERT INTO kml_arrangement (song_id, arrangement_date, description) values (NEW.id, NEW.song_date, 'original');
	
## N.B. MySQL versions below don`t 5.7 allow multiple timestamps with CURRENT_TIMESTAMP
## as a workaround define the on update TIMESTAMP first, and use TRIGGER to set the not 
## changing TIMESTAMP in BEFORE INSERT

CREATE TABLE kml_concert (
	id INT NOT NULL AUTO_INCREMENT, 
	name VARCHAR(255) NOT NULL,
	location VARCHAR(255),
	start_time DATETIME,
	end_time DATETIME, 
	modified TIMESTAMP, 
	added TIMESTAMP, 
	PRIMARY KEY (id) ) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TRIGGER kml_concert_added_ins BEFORE INSERT ON kml_concert FOR EACH ROW 
	SET NEW.added = NOW();

CREATE TABLE kml_concert_arrangement (
	id INT NOT NULL AUTO_INCREMENT, 
	arrangement_id INT NOT NULL,
	concert_id INT NOT NULL,
	arrangement_order INT,
	line_text VARCHAR(64),
	PRIMARY KEY (id),
	FOREIGN KEY (arrangement_id) REFERENCES kml_arrangement(id) ON DELETE CASCADE,
	FOREIGN KEY (concert_id) REFERENCES kml_concert(id) ON DELETE CASCADE) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TABLE kml_collection (
	id INT NOT NULL AUTO_INCREMENT, 
	name VARCHAR(255) NOT NULL,
	modified TIMESTAMP, 
	added TIMESTAMP, 
	PRIMARY KEY (id) ) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TRIGGER kml_collection_added_ins BEFORE INSERT ON kml_collection FOR EACH ROW 
	SET NEW.added = NOW();

CREATE TABLE kml_collection_arrangement (
	id INT NOT NULL AUTO_INCREMENT, 
	arrangement_id INT NOT NULL,
	collection_id INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (arrangement_id) REFERENCES kml_arrangement(id) ON DELETE CASCADE,
	FOREIGN KEY (collection_id) REFERENCES kml_collection(id) ON DELETE CASCADE) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TABLE kml_person (
	id INT NOT NULL AUTO_INCREMENT, 
	name VARCHAR(255) NOT NULL,
	birth_date DATE,
	death_date DATE,
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id) ) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TABLE kml_alias (
	id INT NOT NULL AUTO_INCREMENT, 
	alias VARCHAR(255) NOT NULL,
	person_id INT NOT NULL,
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id),
	FOREIGN KEY (person_id) REFERENCES kml_person(id) ON DELETE CASCADE) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

CREATE TABLE kml_arrangement_author (
	id INT NOT NULL AUTO_INCREMENT, 
	arrangement_id INT NOT NULL,
	person_id INT,
	alias_id INT,
	author_order INT,
	contribution_type ENUM('songwriter','composer','lyricist','adapted','translation','finnish translation','swedish translation','english translation','latin translation','estonian translation','arranger','version','TTBB version','SATB version'),
	PRIMARY KEY (id),
	FOREIGN KEY (arrangement_id) REFERENCES kml_arrangement(id) ON DELETE CASCADE,
	FOREIGN KEY (person_id) REFERENCES kml_person(id) ON DELETE CASCADE,
	FOREIGN KEY (alias_id) REFERENCES kml_alias(id) ON DELETE CASCADE) 
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; 

DELIMITER //
CREATE TRIGGER arrangement_author_both_person_alias_both_not_null_ins BEFORE INSERT ON kml_arrangement_author FOR EACH ROW 
BEGIN
	IF (NEW.person_id IS NULL AND NEW.alias_id IS NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '\'person_id\' and \'alias_id\' cannot both be null';
	END IF;
	IF (NEW.person_id IS NOT NULL AND NEW.alias_id IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Either \'person_id\' or \'alias_id\' must be null';
	END IF;
END//

CREATE TRIGGER arrangement_author_both_person_alias_both_not_null_upd BEFORE UPDATE ON kml_arrangement_author FOR EACH ROW 
BEGIN
	IF (NEW.person_id IS NULL AND NEW.alias_id IS NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '\'person_id\' and \'alias_id\' cannot both be null';
	END IF;
	IF (NEW.person_id IS NOT NULL AND NEW.alias_id IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Either \'person_id\' or \'alias_id\' must be null';
	END IF;
END//
DELIMITER ;

CREATE TABLE kml_filetype (
	id INT NOT NULL AUTO_INCREMENT,
	file_extension VARCHAR(12) NOT NULL,
	icon_file VARCHAR(64),
	description VARCHAR(255),
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(id))
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

CREATE TABLE kml_file (
	id INT NOT NULL AUTO_INCREMENT,
	arrangement_id INT NOT NULL,
	filetype_id INT NOT NULL,
	filename VARCHAR(255) NOT NULL,
	version VARCHAR(10),
	description VARCHAR(255),
	icon_file VARCHAR(64),
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(id),
	FOREIGN KEY (arrangement_id) REFERENCES kml_arrangement(id) ON DELETE CASCADE,
	FOREIGN KEY (filetype_id) REFERENCES kml_filetype(id) ON DELETE CASCADE)
	DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
	
