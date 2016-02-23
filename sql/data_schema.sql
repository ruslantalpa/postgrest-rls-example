
set search_path to data, public;

create sequence public.companies_seq start 100;
create table companies ( 
	id                   int primary key not null unique default nextval('companies_seq'),
	name                 text not null
);


create type user_type as enum ('administrator', 'employee');

create sequence public.users_seq start 100;
create table users ( 
	id                   int primary key not null unique default nextval('users_seq'),
	name                 text not null,
	email                text unique not null,
	"password"           text,
	user_type            user_type not null default 'employee',
	company_id           int references companies(id) default app_company_id()
);
create index users_company_id_index on users(company_id);


create sequence public.clients_seq start 100;
create table clients ( 
	id                   int primary key not null unique default nextval('clients_seq'),
	name                 text not null,
	address              text,
	company_id           int references companies(id) default app_company_id()
);
create index clients_company_id_index on clients(company_id);

create sequence public.projects_seq start 100;
create table projects ( 
	id                   int primary key not null unique default nextval('projects_seq'),
	name                 text not null,
	client_id            int references clients(id),
	company_id           int references companies(id) default app_company_id()
);
create index projects_company_id_index on projects(company_id);

create sequence public.tasks_seq start 100;
create table tasks ( 
	id                   int primary key not null unique default nextval('tasks_seq'),
	name                 text not null,
	project_id           int references projects(id),
	company_id           int references companies(id) default app_company_id()
);
create index tasks_company_id_index on tasks(company_id);

create sequence public.users_projects_seq start 100;
create table users_projects ( 
	project_id           int references projects(id),
	user_id              int references users(id),
	company_id           int references companies(id) default app_company_id(),
	primary key (project_id, user_id)
);
create index users_projects_company_id_index on users_projects(company_id);

create sequence public.users_tasks_seq start 100;
create table users_tasks ( 
	task_id              int references tasks(id),
	user_id              int references users(id),
	company_id           int references companies(id) default app_company_id(),
	primary key ( task_id, user_id )
);
create index users_tasks_company_id_index on users_tasks(company_id);
