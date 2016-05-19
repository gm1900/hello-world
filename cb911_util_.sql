

		--  ALTER TABLE ( PARTITIONING ) `nmi`.`action`  add partition, unique, index & unique index
		
		
--  gm
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++ 
--  every unique key on the table must use every column in the table's partitioning expression

--  only the mysql functions shown in the following table are allowed in partitioning expressions.
/*
	abs()	ceiling() (see ceiling() and floor())	day()
	dayofmonth()	dayofweek()	dayofyear()
	datediff()	extract() (see extract() function with week specifier)	floor() (see ceiling() and floor())
	hour()	microsecond()	minute()
	mod()	month()	quarter()
	second()	time_to_sec()	to_days()
	to_seconds()	unix_timestamp() (with timestamp columns)	weekday()
	year()	 	yearweek()
*/
--  ++++++++++++++++++++++++++++++++++ 

--  max(date1), 	min(date1)
--  '2015-07-14', 	'2014-11-15'

alter table `nmi`.`action` 
rename to  `nmi`.`action_part` ;

alter table `nmi`.`action_part` remove partitioning ;

alter table `nmi`.`action_part` 
--  change column `date1` `date1` date not null ,
--  drop primary key,
--  add primary key (`transaction_id`, `date`, `date1`);
--  ++++++++++++++++++++++++++++++++++ 

alter table nmi.action_part partition by range( to_days( date((`date`))))
	( 
		partition rx2014xx values less than( to_days('2014-01-01 00:00:00')), 
		partition rx201401 values less than( to_days('2014-02-01 00:00:00')), 
		partition rx201402 values less than( to_days('2014-03-01 00:00:00')), 
		partition rx201403 values less than( to_days('2014-04-01 00:00:00')), 
		partition rx201404 values less than( to_days('2014-05-01 00:00:00')), 
		partition rx201405 values less than( to_days('2014-06-01 00:00:00')), 
		partition rx201406 values less than( to_days('2014-07-01 00:00:00')), 
		partition rx201407 values less than( to_days('2014-08-01 00:00:00')), 
		partition rx201408 values less than( to_days('2014-09-01 00:00:00')), 
		partition rx201409 values less than( to_days('2014-10-01 00:00:00')), 
		partition rx201410 values less than( to_days('2014-11-01 00:00:00')), 
		partition rx201411 values less than( to_days('2014-12-01 00:00:00')), 
		partition rx201501 values less than( to_days('2015-01-01 00:00:00')), 
		partition rx2011 values less than maxvalue 
	);


alter table `nmi`.`action_part` 
add unique index `uk_id_action_type` (`transaction_id` asc, `action_type` asc, `date1` asc);


alter table nmi.action_part partition by list columns(action_type) (
	partition p0 values in (''),
	partition p1 values in ('auth'),
	partition p2 values in ('capture'),
	partition p3 values in ('credit'),
	partition p4 values in ('refund'),
	partition p5 values in ('sale'),
	partition p6 values in ('settle'),
	partition p7 values in ('void')
);



auth
capture
credit
refund
sale
settle
void


		select `transaction`.`user` as `user`,
						`action`.`username` as `username`,
						`transaction`.`processor_id` as `processor_id`,
						`transaction`.`currency` as `currency`,
						sum(`action`.`amount`) as `total dollars`,
						count(0) as `total trans`,
						sum(if((left(`transaction`.`cc_bin`,1) = 4),1,0)) as `visa sales count`,
						sum(if((left(`transaction`.`cc_bin`,1) = 5),1,0)) as `mc sales count`,
						sum(if((left(`transaction`.`cc_bin`,1) = 6),1,0)) as `disc sales count`,
						sum(if((left(`transaction`.`cc_bin`,1) = 3),1,0)) as `amex sales count`
		from (`transaction`
			join `action` on((`transaction`.`transaction_id` = `action`.`transaction_id`)))
		where ((`transaction`.`condition` not in ('failed','canceled','unknown'))
			and (`action`.`action_type` not in ('void','settle','refund','auth'))
			and (`action`.`date1` >= ((curdate() - dayofmonth(curdate())) + 1)))
		group by `transaction`.`user`,`transaction`.`processor_id`,`transaction`.`currency`,`action`.`username`





















alter table nmi.action_part partition by range(month(date1))(
partition _jan values less than (month('2014-01-01')),
partition _feb values less than (month('2014-02-01')),
partition _mar values less than (month('2014-03-01')),
partition _apr values less than (month('2014-04-01')),
partition _may values less than (month('2014-05-01')),
partition _jun values less than (month('2014-06-01')),
partition _jul values less than (month('2014-07-01')),
partition _aug values less than (month('2014-08-01')),
partition _sep values less than (month('2014-09-01')),
partition _oct values less than (month('2014-10-01')),
partition _nov values less than (month('2014-11-01')),
partition _dec values less than (month('2014-12-01'))
);



alter table nmi.action_part 
partition by range( month(from_unixtime(date1) )
subpartition by hash( day(from_unixtime(date1)) )
subpartitions 31 (
    partition p0 values less than (2),
    partition p1 values less than (3),
    partition p2 values less than (4),
    partition p3 values less than (5),
    partition p4 values less than (6),
    partition p5 values less than (7),
    partition p6 values less than (8),
    partition p7 values less than (9),
    partition p8 values less than (10),
    partition p9 values less than (11),
    partition p10 values less than (12),
    partition p11 values less than maxvalue
);

--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  

select @@event_scheduler;

show events;

show variables like '%event%';

--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++ 

row_number() 

select  
       @rownum := @rownum + 1 as rank
       , @n
       , t.*
  from `transaction` t, 
       (select @rownum := 0) r
       ,(select @n :='Vasiliy') v
       ;


select t0.col3
from table as t0
left join table as t1 on t0.col1=t1.col1 and t0.col2=t1.col2 and t1.col3>t0.col3
where t1.col1 is null;


select 
    col1, col2, 
    row_number() over (partition by col1, col2 order by col3 desc) as introw
from table1


select cur.id, cur.signal, cur.station, cur.ownerid
from yourtable cur
where not exists (
    select * 
    from yourtable high 
    where high.id = cur.id 
    and high.signal > cur.signal
)
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++ 


create event `_ev_bulk_0__cb911_trx_imports_hdr_2_limelight_orders` on schedule at '2016-05-17 18:00:00.000000' 
on completion preserve enable do call _sp_imports_run_bulk_all_by_one_shot('limelight','orders','_cb911_trx_imports_hdr','gm',0) ;

set @r := 0;
update posts set rownum = (@r:=@r+1) order by postid;


set session group_concat_max_len = 100000;
select group_concat(concat( '  `', column_name,'`    ',data_type, '(',ifnull(character_maximum_length,''),')') separator ' \n')
from information_schema.columns
where table_name = 'transaction'
and table_schema = 'nmi'




--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++ 
--  TEST   'limelight','orders'
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
--  call _sp_imports_run_bulk_all_by_one_shot('limelight','orders','_cb911_trx_imports_hdr','gm',48) ;
--  call _sp_imports_run_bulk_all_by_one_shot_cancel('limelight','orders','_cb911_trx_imports_hdr','gm') ;
--  update limelight.orders set pk_ts_trx ='' where id>0;
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++

--  ++++++++++++++++++++++++++++++++++ 
select current_time() as 'check_time', current_date() as 'check_date', count(*) as '_cb911_trx_imports_hdr count', '`gma` posting' 
from  _cb911_trx_imports_hdr where ifnull(pk_ts_trx,'')<>''; 
 
# id, source_db_schema, target_table, source_table, _cancel, user_key, trx_count, date_created, date_start, date_end, date_cancel
'1', 'limelight', '_cb911_trx_imports_hdr', 'orders', '1', 'gm', '288', '2016-05-18 08:55:03', '2016-05-18 08:55:03', '0000-00-00 00:00:00', '2016-05-18 08:55:28'

--  ++++++++++++++++++++++++++++++++++ 
select * from _tbl_imports_bulk_all_by_one_shot_proc;

# id, source_db_schema, target_table, source_table, _cancel, user_key, trx_count, date_created, date_start, date_end, date_cancel
'1', 'limelight', '_cb911_trx_imports_hdr', 'orders', '1', 'gm', '288', '2016-05-18 08:55:03', '2016-05-18 08:55:03', '0000-00-00 00:00:00', '2016-05-18 08:55:28'

--  ++++++++++++++++++++++++++++++++++ 
select count(pk_ts_trx) ,pk_ts_trx from _cb911_trx_imports_hdr
group by pk_ts_trx;

	count(pk_ts_trx)	pk_ts_trx
	48	LIMELIGHT.ORDERS.BULK.48_1463576103355
	48	LIMELIGHT.ORDERS.BULK.48_1463576111107
	48	LIMELIGHT.ORDERS.BULK.48_1463576116855
	48	LIMELIGHT.ORDERS.BULK.48_1463576119630
	48	LIMELIGHT.ORDERS.BULK.48_1463576124008
	48	LIMELIGHT.ORDERS.BULK.48_1463576128188
	
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++
--  DONE
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  
--  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  --  ++++++++++++++++++++++++++++++++++  

