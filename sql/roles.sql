
drop role if exists administrator, employee;
create role administrator;
create role employee;

grant usage on schema api to administrator, employee;

set search_path to api;

grant select
on companies,users,clients,projects,tasks,users_projects,users_tasks
to administrator;

grant insert, update, delete
on users,clients,projects,tasks,users_projects,users_tasks
to administrator;

grant usage 
on public.companies_seq, public.users_seq, public.clients_seq, public.projects_seq, public.tasks_seq, public.users_projects_seq, public.users_tasks_seq
to administrator;

grant select
on companies,users,projects,tasks,users_projects,users_tasks
to employee;

grant select (id, name)
on clients
to employee;
