
drop role if exists administrator, employee;
create role administrator;
create role employee;



-- policies for administrators
grant select, insert, update, delete
on companies,users,clients,projects,tasks,users_projects,users_tasks
to administrator;

create policy administrator_policy on companies      to administrator 
using (true);

create policy administrator_policy on clients        to administrator 
using (true);

create policy administrator_policy on users          to administrator 
using (true);

create policy administrator_policy on projects       to administrator 
using (true);

create policy administrator_policy on tasks          to administrator 
using (true);

create policy administrator_policy on users_projects to administrator
using (true);

create policy administrator_policy on users_tasks    to administrator
using (true);


-- policies for employees users
grant select
on companies,users,clients,projects,tasks,users_projects,users_tasks
to employee;

grant insert, update, delete
on tasks,users_tasks
to employee;

create policy employee_policy on companies      to employee 
using (true);

create policy employee_policy on clients        to employee 
using (true);

create policy employee_policy on users          to employee 
using (true);

create policy employee_policy on projects       to employee 
using (true);

create policy employee_policy on tasks          to employee 
using (true);

create policy employee_policy on users_projects to employee
using (true);

create policy employee_policy on users_tasks    to employee
using (true);


alter table companies       enable row level security;
alter table users           enable row level security;
alter table clients         enable row level security;
alter table projects        enable row level security;
alter table tasks           enable row level security;
alter table users_projects  enable row level security;
alter table users_tasks     enable row level security;
