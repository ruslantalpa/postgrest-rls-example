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
	10, -- average_milliseconds 
	20, -- within
	'select from companies is fast'
);

SELECT performs_within( 
	'select * from clients', 
	10, -- average_milliseconds 
	20, -- within
	'select from clients is fast'
);

SELECT performs_within( 
	'select * from projects', 
	10, -- average_milliseconds 
	20, -- within
	'select from projects is fast'
);

SELECT performs_within( 
	'select * from tasks', 
	10, -- average_milliseconds 
	20, -- within
	'select from tasks is fast'
);

-- postgrest like query
prepare postgrest_query as
with pg_source as
(
	select 
		projects.*,
		row_to_json(clients.*) as client,
		coalesce(
			(
				select array_to_json(array_agg(row_to_json(tasks)))
				from
				(
					select tasks.*
					from tasks
					where tasks.project_id = projects.id
				) tasks
			), 
			'[]'
		) as tasks
	from projects
	left outer join (
		select clients.*
		from clients
	) as clients on clients.id = projects.client_id
)
select coalesce(array_to_json(array_agg(row_to_json(t))), '[]')::character varying as body
from (select * from pg_source ) t
;
set local role administrator;
set postgrest.claims.company_id = '101';
set postgrest.claims.user_id = '1'; -- not important here

SELECT performs_within( 
	'postgrest_query', 
	10, -- average_milliseconds 
	20, -- within
	'postgrest like query is fast'
);

/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;