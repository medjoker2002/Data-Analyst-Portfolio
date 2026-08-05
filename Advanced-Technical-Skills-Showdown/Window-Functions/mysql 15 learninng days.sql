
WITH subs_count AS
(
    select 
        submission_date,
        hacker_id,
        count(*) no_subs
    from submissions
    where submission_date <= "2016-03-15"
    group by 1,2
),
streaks AS
(
     select 
        submission_date,
        hacker_id,
        no_subs,
        count(*) over(partition by hacker_id) streak
    from subs_count
),
ranked AS
(
    select 
        submission_date,
        hacker_id,
        no_subs,
        row_number() over(partition by submission_date order by no_subs desc, hacker_id) rn
    from streaks
    where streak = 15
)
select
    submission_date,
    hacker_id,
    no_subs
from ranked
where rn = 1