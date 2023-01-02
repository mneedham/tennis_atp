CREATE TABLE rankings AS 
select * 
from 'atp_rankings_*.csv';

-- This doesn't work (auto detect goes rogue)
CREATE TABLE players AS 
select * 
from 'atp_players.csv';

CREATE TABLE players(
    player_id INTEGER,
    name_first VARCHAR,
    name_last VARCHAR,
    hand VARCHAR,
    dob VARCHAR,
    ioc VARCHAR,
    height INTEGER,
    wikidata_id VARCHAR
);

COPY players 
FROM 'atp_players.csv' (AUTO_DETECT TRUE);

-- Join rankings and players
select * 
from rankings
INNER JOIN players ON players.player_id = rankings.player
LIMIT 10;

select name_first, name_last, ioc, min(ranking_date) AS rankingDate, max(ranking_date) AS lastRankingDate
from rankings
INNER JOIN players ON players.player_id = rankings.player
WHERE rank = 1
GROUP BY name_first, name_last, ioc
ORDER BY rankingDate
LIMIT 30;

select * from read_csv(
    'atp_players.csv', 
    header=True, 
    columns={
        'player_id': 'INTEGER', 
        'name_first': 'VARCHAR', 
        'name_last': 'VARCHAR', 
        'hand': 'VARCHAR', 
        'dob': 'VARCHAR', 
        'ioc': 'VARCHAR', 
        'height': 'INTEGER', 
        'wikidata_id': 'VARCHAR'
    });

select min(dob) 
from 'atp_players.csv';

select count(*)
from 'atp_players.csv';

-- Inferring the schema of CSV files with DuckDB
DESCRIBE 
select * 
from 'atp_players.csv';

select count(*)
from read_csv_auto('atp_players.csv', ALL_VARCHAR=TRUE);

DESCRIBE 
select * 
from read_csv_auto('atp_players.csv', ALL_VARCHAR=TRUE);

DESCRIBE 
select * 
from read_csv_auto('atp_players.csv', SAMPLE_SIZE=10000);

DESCRIBE 
select * 
from read_csv_auto('atp_players.csv', SAMPLE_SIZE=-1);

-- Dirty data with DuckDB

-- Fails because of weird date
CREATE TABLE players AS 
select *
from 'atp_players.csv';

-- all varchar
CREATE TABLE players1 AS 
select *
from read_csv_auto('atp_players.csv', ALL_VARCHAR=TRUE);

DESCRIBE players1;

SELECT count(*) FROM players1;

-- sample all rows
CREATE TABLE players2 AS 
select *
from read_csv_auto('atp_players.csv', SAMPLE_SIZE=-1);

DESCRIBE players2;

SELECT count(*) FROM players2;

-- manual schema
CREATE TABLE players3 AS 
SELECT * FROM read_csv('atp_players.csv', 
header=True, 
columns={'player_id': 'INTEGER', 'name_first': 'VARCHAR', 'name_last': 'VARCHAR', 'hand': 'VARCHAR', 'dob': 'VARCHAR', 'ioc': 'VARCHAR', 'height': 'INTEGER', 'wikidata_id': 'VARCHAR'
});

DESCRIBE players3;

SELECT count(*) FROM players3;

-- ignore errors
CREATE TABLE players4 AS 
select *
from read_csv_auto('atp_players.csv', IGNORE_ERRORS=TRUE);

DESCRIBE players4;

SELECT count(*) FROM players4;


-- Not using
CREATE TABLE players(
    player_id INTEGER,
    name_first VARCHAR,
    name_last VARCHAR,
    hand VARCHAR,
    dob VARCHAR,
    ioc VARCHAR,
    height INTEGER,
    wikidata_id VARCHAR
);

COPY players FROM 'atp_players.csv' (AUTO_DETECT TRUE);

-- Joining CSV files
CREATE OR REPLACE TABLE players
AS SELECT * FROM read_csv_auto('atp_players.csv', SAMPLE_SIZE=-1);

CREATE OR REPLACE TABLE rankings AS 
select * 
from 'atp_rankings_*.csv';

SELECT player_id, name_first, name_last
FROM players 
LIMIT 5;

SELECT * FROM rankings LIMIT 5;

select name_first, name_last, ioc, 
       min(ranking_date) AS rankingDate, max(ranking_date) AS lastRankingDate
from rankings
INNER JOIN players ON players.player_id = rankings.player
WHERE rank = 1
GROUP BY name_first, name_last, ioc
ORDER BY rankingDate DESC 
LIMIT 10;

DESCRIBE select * from 'atp_matches_[0-9]*.csv';


CREATE OR REPLACE TABLE matches AS 
select tourney_name AS tournament, 
       tourney_date as date, surface, winner_id, loser_id, score
from read_csv_auto('atp_matches_[0-9]*.csv', ALL_VARCHAR=TRUE);

select * from matches LIMIT 5;

select winner.name_last AS winner,
       tournament, score, date
FROM matches
INNER JOIN players AS winner ON winner.player_id = matches.winner_id
INNER JOIN players AS loser ON loser.player_id = matches.loser_id
WHERE (winner.name_last = 'Nadal' AND loser.name_last = 'Federer')
OR (winner.name_last = 'Federer' AND loser.name_last = 'Nadal')
ORDER BY date DESC
LIMIT 10;

select winner.name_last AS winningPlayer, count(*)
FROM matches
INNER JOIN players AS winner ON winner.player_id = matches.winner_id
INNER JOIN players AS loser ON loser.player_id = matches.loser_id
WHERE (winner.name_last = 'Nadal' AND loser.name_last = 'Federer')
OR (winner.name_last = 'Federer' AND loser.name_last = 'Nadal')
GROUP BY winningPlayer
LIMIT 10;

select winner.name_last AS winningPlayer, surface, count(*)
FROM matches
INNER JOIN players AS winner ON winner.player_id = matches.winner_id
INNER JOIN players AS loser ON loser.player_id = matches.loser_id
WHERE (winner.name_last = 'Nadal' AND loser.name_last = 'Federer')
OR (winner.name_last = 'Federer' AND loser.name_last = 'Nadal')
GROUP BY winningPlayer, surface
LIMIT 10;


select winner.name_last AS winningPlayer, count(*)
FROM matches
INNER JOIN players AS winner ON winner.player_id = matches.winner_id
INNER JOIN players AS loser ON loser.player_id = matches.loser_id
WHERE (winner.name_last = 'Nadal' AND loser.name_last = 'Federer')
OR (winner.name_last = 'Federer' AND loser.name_last = 'Nadal')
AND matches.surface = 'Clay'
GROUP BY winningPlayer
LIMIT 10;
