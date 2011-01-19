--drop view captain_player_affinity; create view captain_player_affinity as
--explain query plan
select pl.id, pl.user_id user, s.tfclass_id class, captains.user_id captain
--,mt.match_id `match`
--,mt.team_id potential_team
,sum(b.id is not null and mt.team_id = pl.team_id) times_picked
,sum((b.id is null and mt.team_id = pl.team_id) or ((mt.team_id = pl.team_id) is null)) times_snubbed
--,b.*
--,mt.team_id = pl.team_id
from signups s
join players pl on s.player_id = pl.id
join matches_teams mt on pl.match_id = mt.match_id
join players captains on captains.team_id = mt.team_id
join picks captainships on captains.id = captainships.player_id
left outer join picks b on b.player_id = s.player_id and +b.tfclass_id = s.tfclass_id
where 10 not in (select tfclass_id from signups where player_id = s.player_id) and captainships.tfclass_id = 10
and user != captain
group by user, class, captain
--order by user, `match`, captain
