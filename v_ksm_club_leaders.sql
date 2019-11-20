Create or Replace View v_ksm_club_leaders As

Select

--- Pulling Biographic Info
 
entity.id_Number,
entity.first_name, 
entity.last_name,
entity.record_status_code, 
entity.record_type_code,

--- Pulling Committee Name, Role, Role Status, Start + Stop Date

committee_Header.short_desc As Club_Title,
tms_committee_role.short_desc As Leadership_Title,
committee.committee_status_code,
committee.start_dt,
committee.stop_dt,

--- Pulling Degree Info

rpt_pbh634.v_entity_ksm_degrees.DEGREES_VERBOSE,
rpt_pbh634.v_entity_ksm_degrees.FIRST_KSM_YEAR,
rpt_pbh634.v_entity_ksm_degrees.PROGRAM

--- Using Committee as Main Table 

From committee

--- Left Join Entity, Committee Header, Degree Table 
Left Join Entity ON Entity.Id_Number = committee.id_number
Left Join committee_header ON committee_header.committee_code = committee.committee_code
Left Join rpt_pbh634.v_entity_ksm_degrees ON rpt_pbh634.v_entity_ksm_degrees.ID_NUMBER = committee.id_number

--- Inner Joining Description of Committee 

Inner Join tms_committee_role ON tms_committee_role.committee_role_code = committee.committee_role_code

Where 

--- Roles: Executive, Club Leader, President, Vice President, Director, Secretary, President Elect, Treasurer, Executive 
 (committee.committee_role_code = 'CL' 
    OR  committee.committee_role_code = 'P'
    OR  committee.committee_role_code = 'I'
    OR  committee.committee_role_code = 'DIR'
    OR  committee.committee_role_code = 'S'
    OR  committee.committee_role_code = 'PE'
    OR  committee.committee_role_code = 'T'
    OR  committee.committee_role_code = 'E')

--- Pulling Current Members Only 
    
   AND  (committee.committee_status_code = 'C'
   
--- Excluding Kellogg Club Leader (KACLE) Group, Kellogg Alumni Club Regional, Kellogg Women Leadership Advisory, Gift Class Committee, Kellogg Global Advisory Board

   And committee.committee_code != 'KACLE'
   And committee.Committee_Code != '535'
   And committee.committee_code != 'KCGC'
   And committee.committee_code != 'KWLC'
   And committee_header.short_desc != 'KSM Global Advisory Board')
   
--- Pull Committee Codes that Start With: KSM, Kellogg or NU- (This is for the NU-Kellogg Clubs, Pull NU Club of Switzerland 

   AND (committee_header.short_desc LIKE '%KSM%'
   Or committee_header.short_desc LIKE '%Kellogg%'
   Or committee_header.short_desc LIKE '%NU-%'
   Or committee_header.short_desc = 'NU Club of Switzerland'
)
   AND entity.record_status_code = 'A'
   
--- Sort by Club Name 

Order BY committee_header.short_desc
