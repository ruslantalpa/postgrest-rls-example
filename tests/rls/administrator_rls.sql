\unset echo
\i setup_pgtap.sql

--select plan(1);
select * from no_plan();

/****************************************************************************/
-- run the tests.

set local role administrator;
set postgrest.claims.company_id = '1';
set postgrest.claims.user_id = '1';

-- select RLS checks
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


-- column visibility checks
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

-- insert privileges check
prepare query_clients as insert into clients (name, address) values ('New Client', 'some address');
select lives_ok(
    'query_clients',
    'can insert clients'
);
prepare query_projects as insert into projects (name, client_id) values ('New Project', 1);
select lives_ok(
    'query_projects',
    'can insert projects'
);
prepare query_tasks as insert into tasks (name, project_id) values ('New Task', 1);
select lives_ok(
    'query_tasks',
    'can insert tasks'
);
prepare query_users_projects as insert into users_projects (user_id, project_id) values (4, 1);
select lives_ok(
    'query_users_projects',
    'can insert users_projects'
);
prepare query_users_tasks as insert into users_tasks (user_id, task_id) values (3, 3);
select lives_ok(
    'query_users_tasks',
    'can insert users_tasks'
);
prepare query_projects2 as insert into projects (name, client_id) values ('Project with invalid client', 3);
select throws_ok(
    'query_projects2',
    '44000',
    'new row violates check option for view "projects"',
    'can not insert project with client_id from another company'
);
prepare query_tasks2 as insert into tasks (name, project_id) values ('Task with invalid project', 4);
select throws_ok(
    'query_tasks2',
    '44000',
    'new row violates check option for view "tasks"',
    'can not insert task with project_id from another company'
);

/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;