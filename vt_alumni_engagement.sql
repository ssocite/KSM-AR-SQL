--- KSM Engagement SQL Query!

--- Create 3 subquries: Events, Volunteership and Giving. 
--- Basetable: KSM Degrees Table 

--- Create Event Subquery --- Using Paul's NU Events Now. Selecting only relevant information. 
--- Include event codes concat just in case we want to look at specific events later once work-study cleanup is finished.

Create or Replace View vt_alumni_engagement AS

With Club_Event As (Select Distinct 

EP_Participant.Id_Number,

Event.event_id,

Event.event_name,

Event.start_dt,

Event.start_fy_calc,

Event.ksm_event,

Event.event_codes_concat

From rpt_pbh634.v_nu_events Event

Left Join EP_Participant ON Event.Event_Id = Ep_Participant.Event_Id

Where Event.ksm_event = 'Y'),

--- Creating Givers Subquery ---- From Paul's reccomended code in April. Including FY 17-20 Giving. 
--- Givers = NGC or Cash with Stewardship > 0 

KSM_Givers As (Select

rpt_pbh634.v_ksm_giving_summary.id_number, 

rpt_pbh634.v_ksm_giving_summary.NGC_CFY, 

rpt_pbh634.v_ksm_giving_summary.CASH_CFY,

rpt_pbh634.v_ksm_giving_summary.ngc_pfy1, 

rpt_pbh634.v_ksm_giving_summary.cash_pfy1, 

rpt_pbh634.v_ksm_giving_summary.ngc_pfy2,

rpt_pbh634.v_ksm_giving_summary.cash_pfy2,

rpt_pbh634.v_ksm_giving_summary.ngc_pfy3,

rpt_pbh634.v_ksm_giving_summary.cash_pfy3

From rpt_pbh634.v_ksm_giving_summary

--- Inner Join because we want only donors from this subquery 

Inner Join rpt_pbh634.v_entity_ksm_degrees ON rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER = rpt_pbh634.v_ksm_giving_summary.ID_NUMBER

Where stewardship_cfy > 0

or stewardship_pfy1 > 0

or stewardship_pfy2 > 0

or stewardship_pfy3 > 0
),

--- Volunteer Subquery --- From Bridget's Volunteer Code
--- Volunteer View Modified (I took out the trustee inclusion). Added KACAO and KALC.  

Volunteer AS (Select 

vt_alumni_volunteership.id_number,

vt_alumni_volunteership.committee_desc,

vt_alumni_volunteership.committee_status,

vt_alumni_volunteership.start_dt_calc,

vt_alumni_volunteership.stop_dt_calc,

vt_alumni_volunteership.committee_role_code,

vt_alumni_volunteership.committee_role

From vt_alumni_volunteership)

--- Select ID, Name, Record Status, Degrees Information, Name/Date of Event, Giving in FY 17, 18, 19, 20, Volunteer Information

Select 

--- Degrees from Basetable. Used to identify Kellogg alumns in the giving, event volunteer section. 

deg.ID_NUMBER,

deg.RECORD_STATUS_CODE,

deg.FIRST_KSM_YEAR,

deg.PROGRAM,

deg.PROGRAM_GROUP,

Club_Event.Event_Name,

Club_Event.start_dt,

Club_Event.start_fy_calc,

--- Identifying Givers in FY 17, 18, 19, 20 From Givers Subquery. 

KSM_Givers.ngc_pfy1,

KSM_Givers.cash_pfy1,

KSM_Givers.ngc_pfy2,

KSM_Givers.cash_pfy2,

KSM_Givers.ngc_pfy3,

KSM_Givers.cash_pfy3,

KSM_Givers.ngc_cfy, 

KSM_Givers.cash_cfy,

Volunteer.committee_desc,

Volunteer.committee_status,

Volunteer.start_dt_calc,

Volunteer.stop_dt_calc,

Volunteer.committee_role_code,

--- Creating Case When for Recent, Mid-Career and Mature. 
CASE -- starting an If statement
     WHEN first_ksm_year >= cal.curr_fy - 6 -- this is where you give your conditions
       THEN 'Recent'
     WHEN first_ksm_year >= cal.curr_fy - 16
       THEN 'Mid-Career'
     WHEN first_ksm_year <= cal.curr_fy - 17
       THEN 'Mature'
     END -- Same as in Tableau
AS life_stage

--- We are using KSM Degrees as our base. We want this to be our demoninator in the metrics. 

From rpt_pbh634.v_entity_ksm_degrees deg

Cross Join rpt_pbh634.v_current_calendar cal

Left Join Club_Event on Club_Event.id_number = deg.ID_NUMBER

Left Join KSM_Givers on KSM_Givers.id_number = deg.ID_number

Left Join Volunteer on Volunteer.id_number = deg.ID_NUMBER
