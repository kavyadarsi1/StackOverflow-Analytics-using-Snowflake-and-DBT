with
    f_users as (select * from {{ ref("fact_users") }}),
    dim_users as (select * from {{ ref("dim_users") }}),
    dim_date as (select * from {{ ref("dim_date") }})
select
    dim_users.id,
    dim_users.displayname,
    dim_users.aboutme,
    dim_users.Location, 
    dim_users.Age,       
    f.userkey,
    f.down_votes,
    f.up_votes,
    f.views,
    f.reputation,
    f.name,
    f.User_posts_count,
    f.Number_of_days_Active,
    f.access_as_Badge_Key  ,
    f.User_Created_Date,
    f.User_Ended_Date,
    dim_date.*
from f_users f
left join dim_users on f.userkey = dim_users.userkey
left join dim_date on f.access_as_Badge_Key = dim_date.datekey


order by dim_users.id
limit 10000

