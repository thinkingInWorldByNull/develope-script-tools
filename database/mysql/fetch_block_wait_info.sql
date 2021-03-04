with t_block_and_wait as (
	SELECT
		waiting_trx_id,
		waiting_pid,
		waiting_query,
		blocking_trx_id,
		blocking_pid,
		blocking_query
	FROM sys.innodb_lock_waits
),
t_block_and_wait_thread as (
SELECT 'wait' as type, thread_id, name as thread_name, PROCESSLIST_USER as thread_user FROM `performance_schema`.threads t inner join t_block_and_wait block_and_wait on t.PROCESSLIST_id = block_and_wait.waiting_pid
union all
SELECT 'block' as type, thread_id, name as thread_name, PROCESSLIST_USER as thread_user  FROM `performance_schema`.threads t inner join t_block_and_wait block_and_wait on PROCESSLIST_id=block_and_wait.blocking_pid
)
select block_and_wait_thread.type, 
	block_and_wait_thread.thread_name, 
	block_and_wait_thread.thread_user,
	cur.thread_id, 
	cur.sql_text, 
	cur.NESTING_EVENT_TYPE
from t_block_and_wait_thread block_and_wait_thread 
inner join `performance_schema`.events_statements_current cur on cur.thread_id = block_and_wait_thread.thread_id
where cur.NESTING_EVENT_ID is not null
order by block_and_wait_thread.type;