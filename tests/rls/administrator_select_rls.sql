\unset echo
\i setup_pgtap.sql

--select plan(1);
select * from no_plan();

/****************************************************************************/
-- run the tests.

set local role administrator;
set postgrest.claims.company_id = '1';
set postgrest.claims.user_id = '1';

select set_eq(
    'select id from users',
    array[ 1, 2, 3, 4, 5, 6, 7 ],
    'can see only users from his company'
);

select set_eq(
    'select id from clients',
    array[ 1, 2 ],
    'can see only clients from his company'
);

select set_eq(
    'select id from projects',
    array[ 1, 2 ],
    'can see only projects from his company'
);


select set_eq(
    'select id from tasks',
    array[ 1, 2, 3, 4, 5 ],
    'can see only tasks from his company'
);

select set_eq(
    'select project_id, user_id from users_projects',
    $$
    values
    ( 1, 1 ),( 2, 1 ),( 1, 2 ),( 2, 2 ),( 1, 3 )
    $$,
    'can see user/project associations only from his company'
);

select set_eq(
    'select task_id, user_id from users_tasks',
    $$
    values
    ( 1, 1 ), (2, 3)
    $$,
    'can see user/task associations only from his company'
);


select results_eq(
    'select * from companies',
    $$values ('Dunder Mifflin')$$,
    'can see only his company (without id field)'
);

select results_eq(
    'select * from clients where id = 1',
    $$values (1, 'Microsoft', 'Redmond')$$,
    'can see only the public fields in clients'
);

select results_eq(
    'select * from projects where id = 1',
    $$values (1, 'Windows 7', 1)$$,
    'can see only the public fields in projects'
);

select results_eq(
    'select * from tasks where id = 1',
    $$values (1, 'Design w7', 1)$$,
    'can see only the public fields in tasks'
);

select results_eq(
    'select * from users_projects where user_id = 1 and project_id = 1',
    $$values (1,1)$$,
    'can see only the public fields in users_projects'
);

select results_eq(
    'select * from users_tasks where user_id = 1 and task_id = 1',
    $$values (1,1)$$,
    'can see only the public fields in users_tasks'
);

/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;