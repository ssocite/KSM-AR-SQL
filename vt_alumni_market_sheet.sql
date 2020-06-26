create or replace view vt_alumni_market_sheet as
With
-- Employment table subquery
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
  Where employment.primary_emp_ind = 'Y'
),

KSM_Continent As (Select rpt_pbh634.v_addr_continents.country,
rpt_pbh634.v_addr_continents.KSM_Continent
From rpt_pbh634.v_addr_continents
Where rpt_pbh634.v_addr_continents.KSM_Continent is not null)

--- Degree Fields

Select Distinct
rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER,

rpt_pbh634.v_entity_ksm_degrees.REPORT_NAME,

rpt_pbh634.v_entity_ksm_degrees.RECORD_STATUS_CODE,

rpt_pbh634.v_entity_ksm_degrees.FIRST_KSM_YEAR,

rpt_pbh634.v_entity_ksm_degrees.PROGRAM,

rpt_pbh634.v_entity_ksm_degrees.PROGRAM_GROUP,

--- Gender Code

Entity.Gender_Code,

--- Employment

Employ.fld_of_work_code,

Employ.fld_of_work,

Employ.employer_name,

Employ.job_title,

--- City, State, Zip, Geo Codes By Household

rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_CITY,

rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_STATE,

rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_ZIP,

rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_GEO_CODES,

rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_COUNTRY,

rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_CONTINENT,

KSM_Continent.KSM_Continent,

rpt_pbh634.v_assignment_summary.prospect_manager,

rpt_pbh634.v_assignment_summary.lgos,

rpt_pbh634.v_assignment_summary.managers

From rpt_pbh634.v_entity_ksm_degrees

---- Join Entity

Inner Join Entity on rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER = Entity.Id_Number

---- Join Households

Left Join rpt_pbh634.v_entity_ksm_households On rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER = rpt_pbh634.v_entity_ksm_households.ID_NUMBER

---- Join Employment

Left Join Employ On rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER = Employ.Id_Number

---- Join Prospect

Left Join rpt_pbh634.v_ksm_prospect_pool on rpt_pbh634.v_ksm_prospect_pool.ID_NUMBER = rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER

---- Join Assignment 

Left Join rpt_pbh634.v_assignment_summary on rpt_pbh634.v_assignment_summary.id_number = rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER

---- Join Contitent Subquery (Used to get Special Regions: Middle East, South Asia, Latin America)

Left Join KSM_Continent ON KSM_Continent.country = rpt_pbh634.v_entity_ksm_households.HOUSEHOLD_Country

Where rpt_pbh634.v_entity_ksm_degrees.RECORD_STATUS_CODE = 'A'
