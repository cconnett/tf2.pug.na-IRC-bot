explain query plan
select pl.user_id user, s.tfclass_id class, captains.user_id captain, mt.match_id `match`, mt.team_id potential_team
,sum(b.id is not null and mt.team_id = pl.team_id) times_picked
,sum(b.id is null) times_snubbed
--,mt.team_id = pl.team_id
--,sum((select count(*) from picks where picks.player_id = s.player_id and picks.tfclass_id = s.tfclass_id and mt.team_id = pl.team_id)) picked
--,sum((select count(*) from picks where picks.player_id = s.player_id and picks.tfclass_id = s.tfclass_id and mt.team_id != pl.team_id)) opp_picked
from signups s
join players pl on s.player_id = pl.id
join matches_teams mt on pl.match_id = mt.match_id
join players captains on captains.team_id = mt.team_id
join picks captainships on captains.id = captainships.player_id
left outer join picks b on b.player_id = s.player_id and b.tfclass_id = s.tfclass_id
where s.tfclass_id != 10 and captainships.tfclass_id = 10
and user != captain
group by user, class, captain

