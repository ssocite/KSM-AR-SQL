--- *** Views for the alumni data mobile project ***
--- The following views are provided: entity, address, relationship 


--- Entity View: v_ksm_mobile_entity

Create or Replace View v_ksm_mobile_entity as 

With KSM_Email AS (select email.id_number,
       email.email_address,
       email.preferred_ind,
       email.forwards_to_email_address
From email
Where email.preferred_ind = 'Y'),

pm_manager as (select assign.id_number,
assign.prospect_manager
from rpt_pbh634.v_assignment_summary assign),

KSM_telephone AS (Select t.id_number,
t.area_code,
t.telephone_number
From telephone t
Where t.preferred_ind = 'Y'),

linked as (select distinct ec.id_number,
max(ec.start_dt) keep(dense_rank First Order By ec.start_dt Desc, ec.econtact asc) As Max_Date,
max (ec.econtact) keep(dense_rank First Order By ec.start_dt Desc, ec.econtact asc) as linkedin_address
from econtact ec
where  ec.econtact_status_code = 'A'
and  ec.econtact_type_code = 'L'
Group By ec.id_number),

ksm_give as (select give.ID_NUMBER,
       give.NGC_LIFETIME
From rpt_pbh634.v_ksm_giving_summary give),

kac as (select kac.id_number
From Table(rpt_pbh634.ksm_pkg.tbl_committee_kac) kac)


select house.ID_NUMBER,
       entity.institutional_suffix,
       house.PREF_MAIL_NAME,  
       linked.linkedin_address,
       pm_manager.prospect_manager,
       KSM_Email.email_address as preferred_email,
       KSM_telephone.area_code as preferred_area_code,
       KSM_telephone.telephone_number as preferred_phone,
       ksm_give.NGC_LIFETIME
       
from entity house
left join KSM_Email on KSM_Email.id_number = house.ID_NUMBER
left join pm_manager on pm_manager.id_number = house.ID_NUMBER
left join KSM_telephone on KSM_telephone.id_number = house.ID_NUMBER
left join linked on linked.id_number = house.ID_NUMBER
left join entity on entity.id_number = house.ID_NUMBER
left join ksm_give on ksm_give.id_number = house.ID_NUMBER
inner join kac on kac.id_number = house.ID_NUMBER;


--- Relationship View: v_ksm_mobile_realtionship


Create or Replace View v_ksm_mobile_realtionship as

with kac as (select kac.id_number
From Table(rpt_pbh634.ksm_pkg.tbl_committee_kac) kac)

select relationship.id_number,
       relationship.relation_id_number,
       TMS_RELATIONSHIPS.short_desc as relationship_type,
       case when relationship.relation_name = ' 'then entity2.pref_mail_name
         when relationship.relation_name is not null then relationship.relation_name
           else ' ' End as realtionship_name,
        entity2.institutional_suffix,
        entity2.birth_dt
    from relationship
left join entity entity2 on entity2.id_number = relationship.relation_id_number
left join entity on entity.id_number = relationship.id_number
left join TMS_RELATIONSHIPS on TMS_RELATIONSHIPS.relation_type_code = relationship.relation_type_code
inner join kac on kac.id_number = relationship.id_number
order by relationship.id_number ASC;


--- Address View: v_ksm_mobile_address

Create or Replace View v_ksm_mobile_contact as

With KSM_telephone AS (Select t.id_number, t.area_code, t.telephone_number, t.telephone_type_code
From telephone t),

kac as (select kac.id_number
From Table(rpt_pbh634.ksm_pkg.tbl_committee_kac) kac)

Select  
         a.Id_number
      ,  a.xsequence
      ,  tms_addr_status.short_desc AS Address_Status
      ,  a.addr_type_code
      ,  tms_address_type.short_desc AS Address_Type
      --- Preferred Address Indicator Added
      ,  a.addr_pref_ind
      ,  a.street1
      ,  a.street2
      ,  a.street3
      ,  a.foreign_cityzip
      ,  a.city
      ,  a.state_code
      ,  a.zipcode
      ,  tms_country.short_desc AS Country
      ,  tms_telephone_type.short_desc
      ,  KSM_telephone.area_code
      ,  KSM_telephone.telephone_number
      FROM address a
      Left JOIN tms_addr_status ON tms_addr_status.addr_status_code = a.addr_status_code
      LEFT JOIN tms_address_type ON tms_address_type.addr_type_code = a.addr_type_code
      LEFT JOIN tms_country ON tms_country.country_code = a.country_code
      LEFT JOIN KSM_telephone on KSM_telephone.id_number = a.id_number
      Left JOIN tms_telephone_type on tms_telephone_type.telephone_type_code = a.addr_type_code
      inner join kac on kac.id_number = a.id_number
      --- Active Addreess
      Where a.addr_status_code IN('A')
      --- Addresses: Home, Business, Alt Home, Alt Business
      and a.addr_type_code IN ('H','B','AH','AB')


