
set search_path to data;

create sequence companies_seq start 100;
create table companies ( 
	id                   int primary key not null unique default nextval('companies_seq'),
	name                 text not null
);


create type user_type as enum ('administrator', 'employee');

create sequence users_seq start 100;
create table users ( 
	id                   int primary key not null unique default nextval('users_seq'),
	name                 text not null,
	email                text unique not null,
	"password"           text,
	user_type            user_type not null default 'employee',
	company_id           int references companies(id)
);
create index users_company_id_index on users(company_id);


create sequence clients_seq start 100;
create table clients ( 
	id                   int primary key not null unique default nextval('clients_seq'),
	name                 text not null,
	address              text,
	company_id           int references companies(id)
);
create index clients_company_id_index on clients(company_id);

create sequence projects_seq start 100;
create table projects ( 
	id                   int primary key not null unique default nextval('projects_seq'),
	name                 text not null,
	client_id            int references clients(id),
	company_id           int references companies(id)
);
create index projects_company_id_index on projects(company_id);

create sequence tasks_seq start 100;
create table tasks ( 
	id                   int primary key not null unique default nextval('tasks_seq'),
	name                 text not null,
	project_id           int references projects(id),
	company_id           int references companies(id)
);
create index tasks_company_id_index on tasks(company_id);

create sequence users_projects_seq start 100;
create table users_projects ( 
	project_id           int references projects(id),
	user_id              int references users(id),
	company_id           int references companies(id),
	primary key (project_id, user_id)
);
create index users_projects_company_id_index on users_projects(company_id);

create sequence users_tasks_seq start 100;
create table users_tasks ( 
	task_id              int references tasks(id),
	user_id              int references users(id),
	company_id           int references companies(id),
	primary key ( task_id, user_id )
);
create index users_tasks_company_id_index on users_tasks(company_id);



set search_path to api, data;

create view companies as
select name from companies
where 
	id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(app_user_type() = 'employee')
	)
;

create view users as
select id, name, email, "password", user_type from users
where
	company_id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(app_user_type() = 'employee')
	)
;

create view clients as
select 
	id, name, 
	case app_user_type() when 'administrator' then address else null end as address
from clients
where
	company_id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(
			app_user_type() = 'employee' and
			id in (
				select client_id from projects
				where
					company_id = app_company_id() and
					id in (
						select project_id from users_projects
						where company_id = app_company_id() and user_id = app_user_id()
					)
			)
		)
	)
;

create view projects as
select id, name, client_id from projects
where
	company_id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(
			app_user_type() = 'employee' and
			id in (
				select project_id from users_projects
				where company_id = app_company_id() and user_id = app_user_id()
			)
		)
	)
;

create view tasks as
select id, name, project_id from tasks
where
	company_id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(
			app_user_type() = 'employee' and
			project_id in (
				select project_id from users_projects
				where company_id = app_company_id() and user_id = app_user_id()
			)
		)
	)
;

create view users_projects as
select user_id, project_id from users_projects
where
	company_id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(
			app_user_type() = 'employee' and
			project_id in (
				select project_id from users_projects
				where company_id = app_company_id() and user_id = app_user_id()
			)
		)
	)
;

create view users_tasks as
select user_id, task_id from users_tasks
where
	company_id = app_company_id() and
	(
		(app_user_type() = 'administrator') or
		(app_user_type() = 'employee')
	)
;
