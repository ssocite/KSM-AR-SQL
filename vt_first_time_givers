create or replace view vt_first_time_givers as
select
household_id,
min (date_of_record) As minimum_dor
From rpt_pbh634.v_ksm_giving_trans_hh gth
 Where
  -- Not counting matching gifts
  gth.tx_gypm_ind <> 'M'
  -- Sum of Gifts Over $0
 Having Sum (gth.HH_RECOGNITION_CREDIT ) > 0
  Group By
  household_id
;
