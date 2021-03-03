create or replace view vt_ksm_alumni_clubs as
Select Distinct committee_header.committee_code,
       committee_header.short_desc As Club_Name,
       rpt_pbh634.v_nu_committees.ksm_committee AS Kellogg_Club,
       Tms_Committee_Status.short_desc As Status,
       committee_header.date_added,
       committee_header.date_modified,
       committee_header.operator_name
from committee_header
Left Join rpt_pbh634.v_nu_committees on rpt_pbh634.v_nu_committees.committee_code = committee_header.committee_code
Left Join Tms_Committee_Status on Tms_Committee_Status.committee_status_code = committee_header.status_code
Where rpt_pbh634.v_nu_committees.ksm_committee = 'Y'
Order by committee_header.short_desc ASC;
