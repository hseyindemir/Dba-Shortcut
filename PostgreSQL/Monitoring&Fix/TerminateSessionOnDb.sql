------------------------- Idle Durumdaki Tüm Sorguları Kill Eder--------------------------------------

select pg_terminate_backend(pid) from pg_stat_activity where state = 'idle';
------------------------------------------------------------------------------------------------------



------------------------- Idle in Transaction Durumundaki Tüm Sorguları Kill Eder---------------------

select pg_terminate_backend(pid) from pg_stat_activity where state = 'idle in transaction';

------------------------------------------------------------------------------------------------------