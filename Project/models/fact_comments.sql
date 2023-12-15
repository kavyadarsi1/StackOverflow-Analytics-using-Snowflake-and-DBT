with
    stg_comments as (
        select
            userid,
            postid,
            score,
            text,
            replace(to_date(creationdate)::varchar, '-', '')::int
            as comment_created_date
        from {{ source("stackoverflow", "comments") }}
    ),
    stg_posts as (
        select
            id,
            case
                when posttypeid = 1
                then 'Question'
                when posttypeid = 2
                then 'Answer'
                when posttypeid = 3
                then 'Wiki'
                when posttypeid = 4
                then 'TagWikiExpert'
                when posttypeid = 5
                then 'TagWiki'
                when posttypeid = 6
                then 'ModeratorNomination'
                when posttypeid = 7
                then 'WikiPlaceholder'
                else 'PrivilegeWiki'
            end as posttypeid,
            owneruserid,
            {{ dbt_utils.generate_surrogate_key(["id"]) }} as postskey
        from {{ source("stackoverflow", "posts") }}
    ),
    stg_users as (
        select
            id, displayname, {{ dbt_utils.generate_surrogate_key(["Id"]) }} as userkey
        from {{ source("stackoverflow", "users") }}
    )

select
    stg_comments.userid,
    postskey,
    displayname,
    postid,
    posttypeid,
    score,
    text,
    stg_posts.owneruserid,
    comment_created_date

from stg_comments
join stg_posts on stg_comments.postid = stg_posts.id
join stg_users on stg_users.id = stg_comments.userid


