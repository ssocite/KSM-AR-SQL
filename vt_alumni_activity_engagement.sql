create or replace view vt_alumni_activity_engagement as
select activity.id_number,
activity.activity_code,
tms_activity_table.short_desc,
activity.stop_dt,
activity.start_dt,
activity.activity_participation_code,
activity.xcomment
from activity
left Join tms_activity_table on tms_activity_table.activity_code = activity.activity_code
--- Activities include: Kellogg Speakers, Kellogg Magazine, Kellogg Corporate Recruiter, Kellogg Event Host, KSM Communications Feature, KSM Continuing Education
where activity.activity_code in ('KSP','KSM','KCR','KEH','KCF','KCE')

and

activity_participation_code = 'P'

and

activity.start_dt Between ('20180901') And ('20190831')

Order By

activity.start_dt ASC
;
