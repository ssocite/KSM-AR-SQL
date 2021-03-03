create or replace view vt_alumni_committee_engagement as
Select Committee.Id_Number,
       rpt_pbh634.v_entity_ksm_degrees.RECORD_STATUS_CODE,
       TMS_COMMITTEE_TABLE.short_desc AS Club_Title,
       Committee.Committee_Title AS Leadership_Title,
       Committee.Committee_Status_Code,
       Committee.Start_Dt,
       Committee.Stop_Dt

From Committee
Left Join rpt_pbh634.v_entity_ksm_degrees On rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER = Committee.Id_Number
Left Join TMS_COMMITTEE_TABLE On TMS_COMMITTEE_TABLE.committee_code = committee.committee_code

--- NAA Mentoring Program, KSM Reunion Committee, Pete Henderson, KAC, Kellogg Recent Graduate Network, KSM Global Advisory Board,
--- KSM Women's Leadership, Kellogg Aluimni Mentorship Program, AMP Advisory Council, Kellogg Alumni Council, KMAR, Real Estate Advisory Council,
--- Healthcare at Kellogg Advisory Council, Global Alumni Ambassador

Where committee.committee_code in ('NMP', '227', 'KPH', 'KACNA', 'KARG', 'U', 'KWLC', 'KACMP', 'KAMP', 'KACNA','KMAR','KREAC','HAK', 'GAMB')

And

Committee.Committee_Status_Code = 'C'

And

rpt_pbh634.v_entity_ksm_degrees.RECORD_STATUS_CODE = 'A'

Order By Committee.Start_Dt ASC
;
