with
    stg_badges as (
        select 
            userid, 
            name,
            replace(to_date(Date)::varchar,'-','')::int as access_as_Badge_Key
        from {{ source("stackoverflow", "badges") }}),
    stg_users as (
        select
            id,
            downvotes as Down_Votes,
            upvotes as Up_votes,
            views as Views,
            reputation as Reputation,
            replace(to_date(CreationDate)::varchar,'-','')::int as User_Created_Date,
            replace(to_date(LastAccessDate)::varchar,'-','')::int as User_Ended_Date,
            TO_DATE(CAST(to_date(CreationDate) AS VARCHAR)) AS Createddatekey,
            TO_DATE(CAST(to_date(LastAccessDate) AS VARCHAR)) AS LastAccessDateKey,
            {{ dbt_utils.generate_surrogate_key(["id"]) }} as userkey
        from {{ source("stackoverflow", "users") }}
    ),
    stg_posts as 
    (
        select 
            count(id) as User_posts_count, 
            OwnerUserid
        from {{ source("stackoverflow", "posts")}}
        group by OwnerUserid
    )
select
    userkey,
    userid,
    Down_Votes,
    Up_votes,
    Views,
    name,
    User_posts_count,
    access_as_Badge_Key,
    Reputation,
    User_Created_Date,
    User_Ended_Date,
    DATEDIFF('DAY',Createddatekey ,LastAccessDateKey) AS Number_of_days_Active
from stg_badges
join stg_users on stg_badges.userid = stg_users.id
join stg_posts on stg_badges.userid = stg_posts.owneruserid


