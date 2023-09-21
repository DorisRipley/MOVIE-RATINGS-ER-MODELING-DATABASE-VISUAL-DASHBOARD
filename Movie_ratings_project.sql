-- This script creates a users table in the G11 schema with the userId as the primary key
--  and various other fields to store user information such as birthdate, gender, zip code,
-- and occupation. The NOT NULL constraint on userId ensures that this field must contain a
-- value, while other fields can be left empty (NULL).

CREATE TABLE `Movie_ratings`.`users` (
  `userId` INT NOT NULL,
  `birthdate` DATE NULL,
  `gender` CHAR(1) NULL,
  `zip` CHAR(5) NULL,
  `occupation` VARCHAR(30) NULL,
  PRIMARY KEY (`userId`));

-- Creating a table named genres in the schema Movie_ratings.
-- This table is designed to store different genres of movies.
CREATE TABLE `Movie_ratings`.`genres` (
  `genreId` int NOT NULL auto_increment,
  `genre` varchar(77) NOT NULL,
  PRIMARY KEY (`genreId`));

-- Creating `tags` table in `Movie_ratings` schema. 
-- It holds unique `tagId` as primary key and non-nullable `tag` column to store tag descriptions.  
CREATE TABLE `Movie_ratings`.`tags` (
  `tagId` int NOT NULL auto_increment,
  `tag` varchar(85) NOT NULL,
  PRIMARY KEY (`tagId`));
  
-- Creating `movies` table in `Movie_ratings` schema to store various information related to movies.
-- `movieId` is the primary key, `title`, `imdbId`, and `tmdbId` are mandatory fields, whereas `yearReleased` is optional.
  
CREATE TABLE `Movie_ratings`.`movies` (
  `movieId` int NOT NULL,
  `title` varchar(83) NOT NULL,
`yearReleased` year NULL,
`imdbId` char(7) NOT NULL,
`tmdbId` INT NOT NULL,
  PRIMARY KEY (`movieId`));

CREATE TABLE `Movie_ratings`.`movie_genome` (
  `movieId` INT NOT NULL,
  `tagId` INT NOT NULL,
  `relevance` DECIMAL(21,20) NULL,
  PRIMARY KEY (`movieId`, `tagId`),
  INDEX `tagId_Idx` (`tagId` ASC) VISIBLE,
  CONSTRAINT `FK_tagId_genome`
    FOREIGN KEY (`tagId`)
    REFERENCES `Movie_ratings`.`tags` (`tagId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_movieId_genome`
    FOREIGN KEY (`movieId`)
    REFERENCES `Movie_ratings`.`movies` (`movieId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- Creating `movie_genome` table in `Movie_ratings` schema to store the relevance of tags to movies.
-- The table has a composite primary key consisting of `movieId` and `tagId`.
-- `movieId` and `tagId` are foreign keys referring to `movies` and `tags` tables respectively.
-- The table has an indexed `tagId` for optimized searches and the constraints ensure referential integrity,
-- meaning that there will be no orphan records and the changes in the parent tables are cascaded to this table.


CREATE TABLE `Movie_ratings`.`movie_genre` (
  `movieId` INT NOT NULL,
  `genreId` INT NOT NULL,
  PRIMARY KEY (`movieId`, `genreId`),
  INDEX `genreId_Idx` (`genreId` ASC) VISIBLE,
  CONSTRAINT `FK_movieId_genre`
    FOREIGN KEY (`movieId`)
    REFERENCES `Movie_ratings`.`movies` (`movieId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_movie_genreId`
    FOREIGN KEY (`genreId`)
    REFERENCES `Movie_ratings`.`genres` (`genreId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- The `tagged` table within the `Movie_ratings` schema represents tagging events, where users tag movies.
-- It includes `userId`, `tagId`, and `movieId` as a composite primary key, indicating a unique tagging event.
-- `timestamp` represents when the tagging event occurred.
-- The table has two additional indices on `tagId` and `movieId` to optimize searches involving these columns.
-- Constraints are defined to maintain referential integrity with the `users`, `tags`, and `movies` tables, ensuring
-- that there will be no orphan records, and that changes to connected records are properly cascaded.

CREATE TABLE `Movie_ratings`.`tagged` (
  `userId` INT NOT NULL,
  `tagId` INT NOT NULL,
  `movieId` INT NOT NULL,
  `timestamp` DATETIME NULL,
  PRIMARY KEY (`userId`, `tagId`, `movieId`),
  INDEX `FK_tagid_Tagged_idx` (`tagId` ASC) VISIBLE,
  INDEX `FK_movieId_tagged_idx` (`movieId` ASC) VISIBLE,
  CONSTRAINT `FK_userId_tagged`
    FOREIGN KEY (`userId`)
    REFERENCES `Movie_ratings`.`users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_tagid_tagged`
    FOREIGN KEY (`tagId`)
    REFERENCES `Movie_ratings`.`tags` (`tagId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_movieId_tagged`
    FOREIGN KEY (`movieId`)
    REFERENCES `Movie_ratings`.`movies` (`movieId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- The `ratings` table within the `Movie_ratings` schema is designated to store user ratings for movies.
-- It consists of `userId` and `movieId` as a composite primary key to uniquely identify a user's rating for a specific movie.
-- The `rating` column holds the user's rating for the movie, and `timestamp` denotes when the rating was made.
-- An additional index on `movieId` enhances search efficiency on this column.
-- The table also establishes foreign key constraints to link to the `users` and `movies` tables, maintaining 
-- referential integrity by ensuring that there are no orphan records and managing updates or deletions appropriately.

CREATE TABLE `Movie_ratings`.`ratings` (
  `userId` INT NOT NULL,
  `movieId` INT NOT NULL,
  `rating` DECIMAL(2,1) NULL,
  `timestamp` DATETIME NULL,
  PRIMARY KEY (`userId`, `movieId`),
  INDEX `FK_movieId_ratings_idx` (`movieId` ASC) VISIBLE,
  CONSTRAINT `FK_userId_ratings`
    FOREIGN KEY (`userId`)
    REFERENCES `Movie_ratings`.`users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_movieId_ratings`
    FOREIGN KEY (`movieId`)
    REFERENCES `Movie_ratings`.`movies` (`movieId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- Insert into tables normalized data from denormalized data:

INSERT INTO `Movie_ratings`.`users` (userId, birthdate, gender, zip,occupation)
SELECT DISTINCT userId,birthdate,gender,zip,occupation FROM `fcp_2022`.`ratings_csv`
UNION DISTINCT
SELECT DISTINCT userId,birthdate,gender,zip,occupation FROM `fcp_2022`.`tagged_csv`;

INSERT INTO `Movie_ratings`.`tags` (tagId,tag)
SELECT DISTINCT tag FROM `fcp_2022`.`genome-scores_csv`
UNION DISTINCT
SELECT DISTINCT tag FROM `fcp_2022`.`tagged_csv`;

INSERT INTO `Movie_ratings`.`movies` (movieId,title,yearReleased,imdbId,tmdbId)
SELECT  DISTINCT movieId,title,yearReleased,imdbId,tmdbId 
FROM `fcp_2022`.`tagged_csv` 
UNION DISTINCT
SELECT  DISTINCT movieId,title,yearReleased,imdbId,tmdbId 
FROM `fcp_2022`.`ratings_csv` ;

INSERT INTO `Movie_ratings`.`tagged` (userId,movieId,tagId,timestamp)
SELECT DISTINCT userID, movieID, B.tagID, timestamp
FROM `fcp_2022`.`tagged_csv` AS A
JOIN `Movie_ratings`.`genres2_tags_AnuA` AS B
on A.tag = B.tag;

INSERT INTO `Movie_ratings`.`ratings` (userId,movieId,rating,timestamp)
SELECT distinct userId,movieId,rating,timestamp FROM fcp_2022.ratings_csv;

INSERT INTO `Movie_ratings`.`movie_genome` (movieId,tagId,relevance)
SELECT movieId,tagId,relevance FROM fcp_2022.`genome-scores_csv`;

INSERT INTO `Movie_ratings`.`genres` (name)
select distinct 
   SUBSTRING_INDEX(SUBSTRING_INDEX(fcp_2022.ratings_csv.genres, '|', numbers.n), '|', -1) name
from
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9
   union all select 10) numbers INNER JOIN fcp_2022.ratings_csv
  on CHAR_LENGTH(fcp_2022.ratings_csv.genres)
     -CHAR_LENGTH(REPLACE(fcp_2022.ratings_csv.genres, '|', ''))>=numbers.n-1
union distinct
select distinct 
  SUBSTRING_INDEX(SUBSTRING_INDEX(fcp_2022.tagged_csv.genres, '|', numbers.n), '|', -1) name
from
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9
   union all select 10) numbers INNER JOIN fcp_2022.tagged_csv
  on CHAR_LENGTH(fcp_2022.tagged_csv.genres)
     -CHAR_LENGTH(REPLACE(fcp_2022.tagged_csv.genres, '|', ''))>=numbers.n-1;


INSERT INTO `Movie_ratings`.`movie_genre`
(`movieId`,`genreId`)
select distinct 
fcp_2022.ratings_csv.movieId,
   genreId
from
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9
   union all select 10) numbers INNER JOIN fcp_2022.ratings_csv
  on CHAR_LENGTH(fcp_2022.ratings_csv.genres)
     -CHAR_LENGTH(REPLACE(fcp_2022.ratings_csv.genres, '|', ''))>=numbers.n-1
     INNER JOIN Movie_ratings.genres gc on gc.genre = SUBSTRING_INDEX(SUBSTRING_INDEX(fcp_2022.ratings_csv.genres, '|', numbers.n), '|', -1)
union distinct
select distinct 
fcp_2022.tagged_csv.movieId,
   genreId
from
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9
   union all select 10) numbers INNER JOIN fcp_2022.tagged_csv
  on CHAR_LENGTH(fcp_2022.tagged_csv.genres)
     -CHAR_LENGTH(REPLACE(fcp_2022.tagged_csv.genres, '|', ''))>=numbers.n-1
     INNER JOIN Movie_ratings.genres gc on gc.name = SUBSTRING_INDEX(SUBSTRING_INDEX(fcp_2022.tagged_csv.genres, '|', numbers.n), '|', -1)
