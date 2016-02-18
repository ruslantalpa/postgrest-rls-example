drop role if exists administrator, employee;
create role administrator;
create role employee;

grant usage on schema api to administrator, employee;

set search_path to api;

grant select
on companies,users,clients,projects,tasks,users_projects,users_tasks
to administrator, employee;

