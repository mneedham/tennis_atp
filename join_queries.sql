-- Joining CSV files
CREATE OR REPLACE TABLE players
AS SELECT * FROM read_csv_auto(
    'atp_players.csv', SAMPLE_SIZE=-1);

SELECT player_id, name_first, name_last
FROM players 
LIMIT 5;

CREATE OR REPLACE TABLE rankings AS 
select * 
from 'atp_rankings_*.csv';


SELECT * FROM rankings LIMIT 5;

select name_first, name_last, ioc, 
       min(ranking_date) AS rankingDate, 
       max(ranking_date) AS lastRankingDate
from rankings
INNER JOIN players ON 
  players.player_id = rankings.player
WHERE rank = 1
GROUP BY name_first, name_last, ioc
ORDER BY rankingDate DESC 
LIMIT 10;

DESCRIBE 
select * 
from 'atp_matches_[0-9]*.csv';


CREATE OR REPLACE TABLE matches AS 
select tourney_name AS tournament, 
       tourney_date as date, surface, 
       winner_id, loser_id, score
from read_csv_auto('atp_matches_[0-9]*.csv', 
  ALL_VARCHAR=TRUE);

select * 
from matches 
LIMIT 5;

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
