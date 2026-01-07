
use Apr22
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    goals_won INT
);
INSERT INTO matches (match_id, winning_team_id, losing_team_id, goals_won) VALUES
(1, 1001, 1007, 1),
(2, 1007, 1001, 2),
(3, 1006, 1003, 3),
(4, 1001, 1003, 1),
(5, 1007, 1001, 1),
(6, 1006, 1003, 2),
(7, 1006, 1001, 3),
(8, 1007, 1003, 5),
(9, 1001, 1003, 1),
(10, 1007, 1006, 2),
(11, 1006, 1003, 3),
(12, 1001, 1003, 4),
(13, 1001, 1006, 2),
(14, 1007, 1001, 4),
(15, 1006, 1007, 3),
(16, 1001, 1003, 3),
(17, 1001, 1007, 3),
(18, 1006, 1007, 2),
(19, 1003, 1001, 1);
select * from matches

with cte as(
select winning_team_id as team_id,1 as points, goals_won from matches
union all
select losing_team_id,-1 as points,0 as goals_won from matches
),cte2 as (
select team_id,sum(points) as total_points,sum(goals_won) as total_goals
from cte
group by team_id
)

select *,
RANK() over(order by total_points desc,total_goals desc) as team_rnk
from cte2