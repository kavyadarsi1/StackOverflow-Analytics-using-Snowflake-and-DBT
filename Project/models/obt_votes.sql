with
    f_votes as (select * from {{ ref("fact_votes_post") }}),
    dim_posts as (select * from {{ ref("dim_posts") }}),
    dim_date as (select * from {{ ref("dim_date") }})
select
    dim_posts.*,
    f.vote_count,
    f.displayname,
    f.bounty_amount,
    f.post_score,
    f.type_of_vote,
    dim_date.* 
from f_votes f
left join dim_posts on f.post_key = dim_posts.postkey
left join dim_date on f.Post_Created_Date = dim_date.datekey
order by dim_posts.id
limit 10000