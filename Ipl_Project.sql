select*
from ipl1

create table ipls
(
id float,
inning float,
overr float,
ball float,
batsman nvarchar(255),
non_striker nvarchar(255),
bowler nvarchar(255),
batsman_runs float,
extra_runs float,
total_runs float,
non_boundary float,
is_wicket float,
dismissal_kind nvarchar(255),
player_dismissed nvarchar(255),
fielder nvarchar(255),
extras_type nvarchar(255),
batting_team nvarchar(255),
bowling_team nvarchar(255)
)

insert into ipls
select * from MyProject..ipl1
union
select * from MyProject..ipl2
union
select * from MyProject..ipl3
union
select * from MyProject..ipl4;

select COUNT(*) from ipls

select COUNT(*) from ipl1
select COUNT(*) from ipl2
select COUNT(*) from ipl3
select COUNT(*) from ipl4

select * from ipls
select * from ipl

select distinct(id)
from ipls

 -- matches per season

select yr, count(distinct id) from
(select YEAR(Date) yr, id from myproject..ipl) a
group by yr;

-- most player of match

Select player_of_match, count(player_of_match) mom
from myproject..ipl
group by player_of_match
order by mom desc


-- most player of match per season

select * from
(select player_of_match, season, mom,RANK() over(partition by season order by mom desc) rnk from
(
Select player_of_match, year(Date) season, count(player_of_match) mom
from myproject..ipl
group by player_of_match, year(Date)
 ) a) b 
 where rnk = 1;

 Select *
 from myproject..ipl


-- most wins by any team

 Select winner,  COUNT(winner) as most_winning_team
 from myproject..ipl
 group by winner 
 order by most_winning_team desc


 -- top 5 venues match is played
 Select TOP 5 venue, COUNT(venue) top_venue
 from MyProject..ipl
 group by venue
 order by top_venue desc;

 Select *
 from MyProject..ipls

 --most runs by any batsman

 select batsman, count(total_runs) most_runs
 from MyProject..ipls
 group by batsman
 order by most_runs desc

 --total runs scored in ipl

 Select SUM(total_runs) from
 ( 
 Select batsman, sum(total_runs) total_runs
 from MyProject..ipls
 group by batsman
 )a;


 --% of total runs scored in ipl

 Select*,total_runs/ sum(total_runs) over (order by total_runs rows between unbounded preceding and unbounded following) runs from 
 (Select batsman, sum(total_runs) total_runs
 from MyProject..ipls
 group by batsman) a;

-- most sixes by any batsman

 select top 1 batsman, Count(batsman_runs) most_sixes
 from myproject..ipls
 where batsman_runs = 6
 group by batsman
 order by most_sixes desc;


 -- most fours by any batsman

 select batsman, count(batsman_runs) most_fours from
 (select * from MyProject..ipls where batsman_runs = 1) a
 group by batsman
 order by most_fours desc;

 -- highest strike rate

select batsman, ((btr *1.0) / total_balls)*100 strike_rate from
(Select batsman, sum(batsman_runs) btr, count(batsman) total_balls from MyProject..ipls
 group by batsman) a;
 

 -- 3000 runs club

Select batsman, sum(total_runs)
from MyProject..ipls 
 group by batsman
 having  sum(total_runs)>= 3000 
 
 -- lowest economy rate for the bowler

 select top 1 bowler, (runs_given) / (total_balls*1.0) economy_rate from
 (select bowler, count(bowler)  as total_balls, sum(total_runs) runs_given
 from MyProject..ipls
 group by bowler
)a
where total_balls>300
order by economy_rate 


-- Total number of matches till 2020                        

select count(Date)
from MyProject..ipl

select COUNT(distinct id)
from MyProject..ipl

-- Total number of matches win by each team

select winner, count(winner) max_winner
from MyProject..ipl
group by winner
order by max_winner desc

