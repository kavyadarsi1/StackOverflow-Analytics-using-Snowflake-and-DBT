with
    f_comments as (select * from {{ ref("fact_comments") }}),
    dim_posts as (select * from {{ ref("dim_posts") }}),
    dim_date as (select * from {{ ref("dim_date") }})
select
    dim_posts.*,
    f.postskey,
    f.displayname,
    f.postid,
    f.posttypeid as Post_Type_Name,
    f.score as comment_score,
    f.text,
    f.comment_created_date,
    dim_date.*
from f_comments f
left join dim_posts on f.postskey = dim_posts.postkey
left join dim_date on f.comment_created_date = dim_date.datekey
order by dim_posts.id
limit 10000
