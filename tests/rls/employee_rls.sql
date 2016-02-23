\unset echo
\i setup_pgtap.sql

--select plan(1);
select * from no_plan();

/****************************************************************************/
-- run the tests.

set local role employee;
set postgrest.claims.company_id = '1';
set postgrest.claims.user_id = '3';

select set_eq(
    'select id from users',
    array[ 1, 2, 3, 4, 5, 6, 7 ],
    'can see only users from his company'
);

select set_eq(
    'select id from clients',
    array[ 1 ],
    'can see only clients for the assigned projects'
);

select set_eq(
    'select id from projects',
    array[ 1 ],
    'can see only projects he is assigned to'
);


select set_eq(
    'select id from tasks',
    array[ 2, 3 ],
    'can see only tasks from projects he is assigned to and those tasks are unassigned or directly assigned to him'
);

select set_eq(
    'select project_id, user_id from users_projects',
    $$
    values
    ( 1, 1 ),( 1, 2 ),( 1, 3 )
    $$,
    'can see user/project associations only from projects he is assigned to'
);

select set_eq(
    'select task_id, user_id from users_tasks',
    $$
    values
    ( 2, 3 )
    $$,
    'can see only his user/task associations'
);


select results_eq(
    'select * from companies',
    $$values ('Dunder Mifflin')$$,
    'can see only his company (without id field)'
);

select throws_ok(
    'select id, name, address from clients where id = 1',
    '42501',
    'permission denied for relation clients',
    'can see only the public fields in clients'
);

select results_eq(
    'select * from projects where id = 1',
    $$values (1, 'Windows 7', 1)$$,
    'can see only the public fields in projects'
);

select results_eq(
    'select * from tasks where id = 2',
    $$values (2, 'Code w7', 1)$$,
    'can see only the public fields in tasks'
);

select results_eq(
    'select * from users_projects where user_id = 1 and project_id = 1',
    $$values (1,1)$$,
    'can see only the public fields in users_projects'
);

select results_eq(
    'select * from users_tasks where user_id = 3 and task_id = 2',
    $$values (3,2)$$,
    'can see only the public fields in users_tasks'
);

/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;