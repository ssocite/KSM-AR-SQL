create or replace view vt_ksm_phs as

With KSM_PHS AS (Select comm.id_number,
       comm.committee_code,
       comm.committee_status_code,
       comm.start_dt
From committee comm
Where comm.committee_code IN ('KPH')
And comm.committee_status_code = 'C'),


employ As (
  Select id_number
  , job_title
  , employment.fld_of_work_code
  , fow.short_desc As fld_of_work
  , employer_name1,
    -- If there's an employer ID filled in, use the entity name
    Case
      When employer_id_number Is Not Null And employer_id_number != ' ' Then (
        Select pref_mail_name
        From entity
        Where id_number = employer_id_number)
      -- Otherwise use the write-in field
      Else trim(employer_name1 || ' ' || employer_name2)
    End As employer_name
  From employment
  Left Join tms_fld_of_work fow
       On fow.fld_of_work_code = employment.fld_of_work_code
  Where employment.primary_emp_ind = 'Y'),

KSM_Assignment AS (
Select summary.prospect_id,
       summary.id_number,
       summary.prospect_manager_id,
       summary.prospect_manager,
       summary.lgo_ids,
       summary.lgos,
       summary.manager_ids,
       summary.managers,
       summary.curr_ksm_manager
From rpt_pbh634.v_assignment_summary summary)

Select house.ID_NUMBER,
       house.REPORT_NAME,       
       house.RECORD_STATUS_CODE,
       entity.gender_code,
       KSM_PHS.committee_code,
       KSM_PHS.committee_status_code,
       KSM_PHS.start_dt,
       house.HOUSEHOLD_KSM_YEAR,
       house.HOUSEHOLD_MASTERS_YEAR,
       house.HOUSEHOLD_PROGRAM,
       house.HOUSEHOLD_PROGRAM_GROUP,
       employ.employer_name,
       employ.job_title,
       employ.fld_of_work,
       house.HOUSEHOLD_CITY,
       house.HOUSEHOLD_STATE,
       house.HOUSEHOLD_ZIP,
       house.HOUSEHOLD_GEO_CODES,
       house.HOUSEHOLD_GEO_PRIMARY,
       house.HOUSEHOLD_COUNTRY,
       house.HOUSEHOLD_CONTINENT,
       KSM_Assignment.prospect_manager,
       KSM_Assignment.lgos,
       KSM_Assignment.managers,
       KSM_Assignment.curr_ksm_manager,
       give.NGC_LIFETIME,
       give.NGC_CFY,
       give.NGC_PFY1,
       give.NGC_PFY2,
       give.NGC_PFY3,
       give.NGC_PFY4,
       give.NGC_PFY5,
       give.AF_CFY,
       give.AF_PFY1,
       give.AF_PFY2,
       give.AF_PFY3,
       give.AF_PFY4,
       give.AF_PFY5,
       give.LAST_GIFT_DATE,
       give.LAST_GIFT_TYPE,
       give.LAST_GIFT_ALLOC_CODE
From rpt_pbh634.v_entity_ksm_households house
Inner Join KSM_PHS ON KSM_PHS.id_number = house.id_number
Left Join employ ON employ.id_number = house.ID_NUMBER
Left Join entity on entity.id_number = house.ID_NUMBER
Left Join KSM_Assignment ON KSM_Assignment.id_number = house.ID_NUMBER
Left Join  rpt_pbh634.v_ksm_giving_summary give on give.ID_NUMBER = house.id_number
Order by house.REPORT_NAME ASC;



