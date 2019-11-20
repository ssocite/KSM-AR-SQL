Create or Replace View vt_alumni_volunteership AS

With 

committee_volunteer As (Select *

from rpt_pbh634.v_nu_committees

--- Members of Committees From Bridget's Excel Sheet (Lines 1-59)

where rpt_pbh634.v_nu_committees.committee_code IN 
('KACHB',
'KACAT',
'KACBE',
'KACBX',
'KACBR',
'KACBC',
'KACCS',
'KACCL',
'KACCR',
'KACDA',
'KACGE',
'KACUA',
'KACHO',
'KACIN',
'KACID',
'KACIT',
'KACIL',
'KACJA',
'KACKO',
'KACLG',
'KACNM',
'KACOC',
'KACPR',
'KACSH',
'KACSP',
'KACSZ',
'KACSY',
'KACTA',
'KACTH',
'KACUK',
'KACWD',
'KACWI',
'KACEW',
'KACFE',
'KFN',
'KACRE',
'507',
'508',
'506',
'509',
'515',
'516',
'KACP',
'517',
'519',
'520',
'521',
'KACFS',
'518',
'522',
'KACBL',
'KACGL',
'KACFR',
'KACMX',
'KACPH',
'KACSI',
'NU023',
'587')
And 
rpt_pbh634.v_nu_committees.committee_status_code = 'C'
And
--- Club Leader, President, President Elect, Vice President, Member, Chair, National Trustee, Life Trustee, Charter Trustee, 
rpt_pbh634.v_nu_committees.committee_role_code In ('CL','P','PE','I'))


Select 
committee_volunteer.id_number,
committee_volunteer.committee_desc,
committee_volunteer.committee_status,
committee_volunteer.start_dt_calc,
committee_volunteer.stop_dt_calc,
committee_volunteer.date_modified,
committee_volunteer.committee_role_code,
committee_volunteer.committee_role,
house.HOUSEHOLD_CITY,
house.HOUSEHOLD_STATE,
house.HOUSEHOLD_ZIP,
house.HOUSEHOLD_GEO_CODES,
house.HOUSEHOLD_COUNTRY

From committee_volunteer
Left Join rpt_pbh634.v_entity_ksm_households house On house.ID_NUMBER = committee_volunteer.id_number

UNION ALL

Select 

rpt_pbh634.v_nu_committees.id_number,
rpt_pbh634.v_nu_committees.committee_desc,
rpt_pbh634.v_nu_committees.committee_status,
rpt_pbh634.v_nu_committees.start_dt_calc,
rpt_pbh634.v_nu_committees.stop_dt_calc,
rpt_pbh634.v_nu_committees.date_modified,
rpt_pbh634.v_nu_committees.committee_role_code,
rpt_pbh634.v_nu_committees.committee_role,
house.HOUSEHOLD_CITY,
house.HOUSEHOLD_STATE,
house.HOUSEHOLD_ZIP,
house.HOUSEHOLD_GEO_CODES,
house.HOUSEHOLD_COUNTRY

From rpt_pbh634.v_nu_committees
Left Join rpt_pbh634.v_entity_ksm_households house on house.ID_NUMBER = rpt_pbh634.v_nu_committees.id_number

--- Trying to get the rest of the members from Bridget's Excel Sheet (Below Line 60) 

Where rpt_pbh634.v_nu_committees.committee_code IN 
('227',
'KACNA',
'KACAO',
'KALC',
'KMAR',
'KPH',
'KWLC',
'KWLC',
'KREAC',
'KAMP',
'U',
'HAK',
'TBOT',
'NMP',
'GAMB')

And 

rpt_pbh634.v_nu_committees.committee_status = 'Current'

/*And

--- Life Trustee, Member, Chair, Life Member, Charter Trustee, National Trustee

rpt_pbh634.v_nu_committees.committee_role_code IN ('TL', 'M', 'C', 'LM','CT','NT')*/
