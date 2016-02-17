\unset echo
\i ./setup_pgtap.sql

--select plan(1);
select * from no_plan();

/****************************************************************************/
-- run the tests.

select * from check_test(
    tables_are( 'public', array['companies', 'users', 'clients', 'projects', 'tasks', 'users_projects', 'users_tasks'], 'tables present' ),
    true,
    'all tables are present in schema public',
    'tables present',
    ''
);


/****************************************************************************/
-- finish the tests and clean up.
select * from finish();
rollback;