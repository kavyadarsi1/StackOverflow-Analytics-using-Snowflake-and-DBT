with
    stg_votes as (
        select
            case
                when votetypeid = 1
                then 'Accepted_By_Orginator'
                when votetypeid = 2
                then 'UpMod'
                when votetypeid = 3
                then 'DownMod'
                when votetypeid = 4
                then 'Offensive'
                when votetypeid = 5
                then 'Favorite'
                when votetypeid = 6
                then 'Close'
                when votetypeid = 7
                then 'Reopen'
                when votetypeid = 8
                then 'Bounty Start'
                when votetypeid = 9
                then 'Bounty Close'
                when votetypeid = 10
                then 'Deletion'
                when votetypeid = 11
                then 'UnDeletion'
                when votetypeid = 12
                then 'Spam'
                when votetypeid = 13
                then 'Inform Moderator'
                when votetypeid = 15
                then 'Moderator Review'
                else 'Approved Edit Suggestion'
            end as votetypeid,
            postid,
            count(id) as vote_id,
            sum(bountyamount) as bounty_amount
        from {{ source("stackoverflow", "votes") }}
        group by votetypeid, postid
    ),
    stg_posts as (
        select
            id,
            score,
            body,
            owneruserid,
            replace(to_date(creationdate)::varchar, '-', '')::int as creationdatekey,
            {{ dbt_utils.generate_surrogate_key(["id"]) }} as postkey
        from {{ source("stackoverflow", "posts") }}
    ),
    stg_users as (
        select
            id, displayname, {{ dbt_utils.generate_surrogate_key(["Id"]) }} as userkey
        from {{ source("stackoverflow", "users") }}
    )
select
    postid,
    postkey as post_key,
    vote_id as vote_count,
    bounty_amount,
    score as post_score,
    votetypeid as type_of_vote,
    body,
    creationdatekey,
    displayname
from stg_votes v
join stg_posts p on v.postid = p.id
join stg_users u on u.id = p.owneruserid
