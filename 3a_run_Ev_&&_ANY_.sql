
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++   
--  gm


--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++ 
--  TEST   'nmi','transaction'
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
--  call _sp_imports_run_bulk_all_by_one_shot('nmi','_vw_nmi_transaction_action_mids_map','_cb911_trx_imports_hdr','gm',48) ;
--  call _sp_imports_run_bulk_all_by_one_shot_cancel('nmi','_vw_nmi_transaction_action_mids_map','_cb911_trx_imports_hdr','gm') ;
--  update nmi.transaction set pk_ts_trx ='' where id>0;
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
 	select @@event_scheduler;
 	select @@sql_big_selects ;
--  ++++++++++++++++++++++++++++++++++  
	select @@event_scheduler;
	show events;
	show variables like '%event%';
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++

--  ++++++++++++++++++++++++++++++++++ 
 
--  ++++++++++++++++++++++++++++++++++ 
--  call _sp_imports_run_bulk_all_by_one_shot('limelight','orders','_cb911_trx_imports_hdr','gm',48) ;
--  call _sp_imports_run_bulk_all_by_one_shot_cancel('limelight','orders','_cb911_trx_imports_hdr','gm') ;
set sql_big_selects =1;
select count(*) from limelight.orders where pk_ts_trx <>'';
-- update limelight.orders set pk_ts_trx ='' where id >0;
--  ++++++++++++++++++++++++++++++++++ 
create event `_Ev_bulk_1m_limelight_orders_imports` on schedule at '2016-05-17 18:00:00.000000' 
on completion preserve enable do call _sp_imports_run_bulk_all_by_one_shot('limelight','orders','_cb911_trx_imports_hdr','gm',1000000) ;

--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++

--  ++++++++++++++++++++++++++++++++++ 
--  call _sp_imports_run_bulk_all_by_one_shot('nmi','_vw_nmi_transaction_action_mids_map','_cb911_trx_imports_hdr','gm',48) ;
--  call _sp_imports_run_bulk_all_by_one_shot_cancel('nmi','_vw_nmi_transaction_action_mids_map','_cb911_trx_imports_hdr','gm') ;
set sql_big_selects =1;
select count(*) from nmi.transaction where pk_ts_trx <>'';
-- update nmi.transaction set pk_ts_trx ='' where id >0;
--  ++++++++++++++++++++++++++++++++++ 
create event `_Ev_bulk_1m_limelight_nmi_transaction_imports` on schedule at '2016-05-17 18:00:00.000000' 
on completion preserve enable do call _sp_imports_run_bulk_all_by_one_shot('nmi','_vw_nmi_transaction_action_mids_map','_cb911_trx_imports_hdr','gm',1000000) ;
 
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++ 
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++

--  ++++++++++++++++++++++++++++++++++
select current_time() as 'check_time', current_date() as 'check_date', count(*) as '_cb911_trx_imports_hdr count', '`gma` posting' 
from  _cb911_trx_imports_hdr where ifnull(pk_ts_trx,'')<>''; 
--  ++++++++++++++++++++++++++++++++++ 
select count(pk_ts_trx) ,pk_ts_trx from _cb911_trx_imports_hdr
group by pk_ts_trx;

--  ++++++++++++++++++++++++++++++++++ 
select * from _tbl_imports_bulk_all_by_one_shot_proc;

--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++

--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++


--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
-- not yet
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  



