
create sequence companies_seq;
create table companies ( 
	id                   int primary key not null unique default nextval('companies_seq'),
	name                 text not null
);


create type user_type as enum ('administrator', 'employee');

create sequence users_seq;
create table users ( 
	id                   int primary key not null unique default nextval('users_seq'),
	name                 text not null,
	email                text unique not null,
	"password"           text,
	user_type            user_type not null default 'employee',
	company_id           int references companies(id)
);

create sequence clients_seq;
create table clients ( 
	id                   int primary key not null unique default nextval('clients_seq'),
	name                 text not null,
	company_id           int references companies(id)
);

create sequence projects_seq;
create table projects ( 
	id                   int primary key not null unique default nextval('projects_seq'),
	name                 text not null,
	active               bool default true not null,
	client_id            int references clients(id),
	company_id           int references companies(id)
);

create sequence tasks_seq;
create table tasks ( 
	id                   int primary key not null unique default nextval('tasks_seq'),
	name                 text not null,
	project_id           int references projects(id),
	company_id           int references companies(id)
);

create sequence users_projects_seq;
create table users_projects ( 
	project_id           int references projects(id),
	user_id              int references users(id),
	company_id           int references companies(id),
	primary key (project_id, user_id)
);

create sequence users_tasks_seq;
create table users_tasks ( 
	task_id              int references tasks(id),
	user_id              int references users(id),
	company_id           int references companies(id),
	primary key ( task_id, user_id )
);