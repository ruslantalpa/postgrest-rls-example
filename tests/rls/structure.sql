\unset echo
\i ./setup_pgtap.sql

--select plan(1);
select * from no_plan();

/****************************************************************************/
-- run the tests.

select * from check_test(
    views_are('api', array['companies', 'users', 'clients', 'projects', 'tasks', 'users_projects', 'users_tasks'], 'tables present' ),
    true,
    'all views are present in schema api',
    'tables present',
    ''
);


/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;