set search_path to api, data;

create or replace function app_user_type()
returns text
stable
language sql
as $$
    select current_user::text;
$$;

create or replace function app_user_id()
returns integer
stable
language sql
as $$
    select nullif(current_setting('postgrest.claims.user_id'), '')::integer;
$$;


create or replace function app_company_id()
returns integer
stable
language sql
as $$
    select nullif(current_setting('postgrest.claims.company_id'), '')::integer;
$$;


create or replace view companies as
select name from data.companies as c
where 
	c.id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or
		(app_user_type() = 'employee')
	)
;

create or replace view users as
select id, name, email, "password", user_type from data.users as u
where
	u.company_id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or
		(app_user_type() = 'employee')
	)
;

create or replace view clients as
select 
	id, name, 
	case app_user_type() when 'administrator' then address else null end as address
from data.clients as c
where
	c.company_id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or -- admins can see all clients
		(
			app_user_type() = 'employee' and
			c.id in ( -- employees can see only clients from projects they are assgned to
				select client_id from data.projects as p
				where
					p.company_id = app_company_id() and
					p.id in ( -- a list of project ids the employee is assigned to
						select project_id from data.users_projects as up
						where up.company_id = app_company_id() and up.user_id = app_user_id()
					)
			)
		)
	)
;

create or replace view projects as
select id, name, client_id from data.projects as p
where
	p.company_id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or -- admins can see all projects
		(
			app_user_type() = 'employee' and --employees can see only the projects they are assigned to
			p.id in ( -- a list of project ids the employee is assigned to
				select project_id from data.users_projects as up
				where up.company_id = app_company_id() and up.user_id = app_user_id()
			)
		)
	)
;

create or replace view tasks as
select id, name, project_id from data.tasks as t
where
	t.company_id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or
		(
			app_user_type() = 'employee' and
			t.id in (
				select t.id from data.tasks as t
				left join data.users_tasks as ut on t.id = ut.task_id
				where 
					t.company_id = app_company_id() and -- filter tasks from current company
					t.project_id in ( -- filter tasks from projects the employee is assigned to
						select project_id from data.users_projects as up2
						where up2.company_id = app_company_id() and up2.user_id = app_user_id()
					) and
					(ut.user_id = app_user_id() or ut.user_id is null) -- filter tasks that are unassigend or directly assigned to the current employee
			)
		)
	)
;

create or replace view users_projects as
select user_id, project_id from data.users_projects as up
where
	up.company_id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or -- admins can see all associations
		(
			app_user_type() = 'employee' and
			up.project_id in ( -- employees can see only the assiciations for projects they are assigned to
				select project_id from data.users_projects as up2
				where up2.company_id = app_company_id() and up2.user_id = app_user_id()
			)
		)
	)
;

create or replace view users_tasks as
select user_id, task_id from data.users_tasks as ut
where
	ut.company_id = app_company_id() and -- filter only current company id
	(
		(app_user_type() = 'administrator') or
		(app_user_type() = 'employee' and -- employees can see only thier own task assignaments
			ut.user_id = app_user_id()
		)
	)
;
