use womenbb ;
-- Q : Which countries outside the U.S. have supplied the most players?
-- A : Canada, Australia and Spain provide the most non-U.S. players by far.
-- With australia being on the top with 19 players, then spain with 15players and last canada with 12 players. 
select 
    count(player_id) c,
    country_clean
from players_coord
where country_clean != 'USA'
group by country_clean
order by c desc ;

-- Q : How many teams are considered for each conference? 
select 
    count( distinct team ) t ,
    conference
from teams
group by conference
order by t desc ;

-- Q : who is the tallest player?
-- A :the tallest player is 'Sela Heide' with a height of 6'7", playing fro Californation team.
-- Her position is 'Center' 
select 
	ph.player_id,
    name,
    height_clean,
    pp.team,
    pp.position_clean
from players_height ph
join players_position pp
	using(player_id)
order by height_clean desc ;

-- Q : What is the average height of all basketball players in the dataset?
-- A : The average height of all players in the dataset is : 69.50 inches which is equal to 5 feet and 9.5 inches
select 
    avg(distinct total_inches) as 'Avr Height' 
from players_height ;

-- Q : What is the average height of all players in each conference?
select 
	pp.conference,
    avg( distinct total_inches) as 'Avr Height' 
from players_height ph
join players_position pp 
	using(player_id) 
group by conference ;

-- Which teams/conferences/divisions have the most first-year players? 
-- A1 : The top 3 teams that have the most first-year players are 'Mary Hardin-Baylor', 'Montevallo' and 'Mount St. Joseph'
-- A2 : The top 3 conferences that have the most first-year players is 'ASC', 'MEC' and 'Great Northwest' 
-- A3 : The division that has the most first-year players is 'DEvision 3' with 341 Players followed by Divion2 and then Division 1 
select 
    count(pp.player_id) nbr_players,
    team,
    year_clean
from players_position pp
join players_coord pc
	using (player_id)
where pc.year_clean = 'Freshman'
group by team
order by nbr_players desc ;
--
select 
    count(player_id) nbr_players,
	conference 
from players_position
join players_coord pc
	using (player_id)
where pc.year_clean = 'Freshman'
group by conference
order by nbr_players desc ;
--
select 
    count(player_id) nbr_players,
	division 
from players_position pp
join players_coord pc
	using (player_id)
where pc.year_clean = 'Freshman'
group by division
order by nbr_players desc ;

-- Q : Which division has the least Seniors and graduate players?
-- A : The division with most senior and graduate players is Division1 with 70 players 
select 
	count(pp.player_id) nbr_players,
    pp.division
from players_position pp
join players_coord pc
	using (player_id) 
where pc.year_clean = 'Senior' or 'Graduate'
group by division
order by nbr_players asc;
