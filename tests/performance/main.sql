\unset echo
\i setup_pgtap.sql

--select plan(1);
select * from no_plan();

/****************************************************************************/
-- run the tests.

set local role administrator;
set postgrest.claims.company_id = '1';
set postgrest.claims.user_id = '1';

SELECT performs_within( 
	'select * from companies', 
	50, -- average_milliseconds 
	100, -- within
	'select from companies is fast'
);

SELECT performs_within( 
	'select * from clients', 
	20, -- average_milliseconds 
	100, -- within
	'select from clients is fast'
);

SELECT performs_within( 
	'select * from projects', 
	50, -- average_milliseconds 
	100, -- within
	'select from projects is fast'
);

SELECT performs_within( 
	'select * from tasks', 
	250, -- average_milliseconds 
	300, -- within
	'select from tasks is fast'
);

/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;