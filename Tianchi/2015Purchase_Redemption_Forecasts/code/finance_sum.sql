CREATE TABLE user_balance_table (
    user_id VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    report_date VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    tBalance bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    yBalance bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    total_purchase_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	direct_purchase_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    purchase_bal_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    purchase_bank_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    total_redeem_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    consume_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    transfer_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    tftobal_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    tftocard_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    share_amt bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    category1 bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    category2 bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    category3 bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    category4 bigint NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci'
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
drop table user_balance_table;

LOAD DATA LOCAL INFILE
    'G:\\DataScience\\competition\\TianChi\\finance\\data\\user_balance_table.csv'
   # IGNORE INTO TABLE `gz_bus`.`gd_weather`
    IGNORE INTO TABLE `user_balance_table`
    CHARACTER SET utf8
    FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n'
    (user_id, report_date, tBalance,yBalance, total_purchase_amt, direct_purchase_amt, purchase_bal_amt, 
    purchase_bank_amt, total_redeem_amt, consume_amt, transfer_amt, 
    tftobal_amt, tftocard_amt, share_amt, category1, 
    category2, category3, category4);
/* 184 rows imported in 0.078 seconds. */
SHOW WARNINGS;

select * from user_balance_table ;

drop table tianchi_finance_sum;
create table if not exists tianchi_finance_sum 
select report_date,sum(tBalance) as tBalance,sum(total_redeem_amt) as total_redeem,
sum(consume_amt) as consume,sum(transfer_amt) as transfer,sum(tftobal_amt) as tftobal,sum(tftocard_amt) as tftocard
from user_balance_table
group by report_date
order by report_date desc;

select * from tianchi_finance_sum 
order by report_date asc
limit 1000;














use tianchi;
select * from user_balance_table where report_date='20130705';

drop table tianchi_finance_sum;

create table tianchi_finance_sum as
select 
	report_date,
    sum(tBalance) as tBalance,
    sum(total_redeem_amt) as total_redeem,
	sum(consume_amt) as consume,
    sum(transfer_amt) as transfer,
    sum(tftobal_amt) as tftobal,
    sum(tftocard_amt) as tftocard
from user_balance_table
group by report_date
;

select * from tianchi_finance_sum 
order by report_date asc;

create table tianchi_finance_sum as
select 
	report_date,
    tBalance,
    sum(total_redeem_amt),
	consume_amt,
    transfer_amt,
    tftobal_amt,
    tftocard_amt
from user_balance_table
group by report_date
;

select report_date,
	sum(tBalance) as tBalance,
    sum(total_redeem_amt) as total_redeem,
    sum(consume_amt) as consume,
    sum(transfer_amt) as transfer,
    sum(tftobal_amt) as tftobal,
    sum(tftocard_amt) as tftocard
from user_balance_table
group by report_date;