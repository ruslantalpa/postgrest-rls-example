set search_path = data;
insert into companies( id, name ) values
( 1, 'Dunder Mifflin'),
( 2, 'Wernham Hogg');

insert into users( id, name, email, "password", user_type, company_id ) values
( 1, 'Michael Scott', 'michael@dundermifflin.com', 'pass', 'administrator', 1),
( 2, 'Dwight Schrute', 'dwight@dundermifflin.com', 'pass', 'employee', 1),
( 3, 'Jim Halpert', 'jim@dundermifflin.com', 'pass', 'employee', 1),
( 4, 'Pam Beesly', 'pam@dundermifflin.com', 'pass', 'employee', 1),
( 5, 'Ryan Howard', 'ryan@dundermifflin.com', 'pass', 'employee', 1),
( 6, 'Andy Bernard', 'andy@dundermifflin.com', 'pass', 'employee', 1),
( 7, 'Robert California', 'robert@dundermifflin.com', 'pass', 'employee', 1),
( 8, 'David Brent', 'david@wernhamhogg.com', 'pass', 'administrator', 2),
( 9, 'Tim Canterbury', 'tim@wernhamhogg.com', 'pass', 'employee', 2),
( 10, 'Gareth Keenan', 'gareth@wernhamhogg.com', 'pass', 'employee', 2),
( 11, 'Dawn Tinsley', 'dawn@wernhamhogg.com', 'pass', 'employee', 2);


insert into clients( id, name, address, company_id ) values
( 1, 'Microsoft', 'Redmond', 1 ),
( 2, 'Oracle', 'Redwood Shores', 1 ), 
( 3, 'Apple', 'Cupertino', 2 );

insert into projects( id, name, client_id, company_id ) values
( 1, 'Windows 7', 1, 1 ),
( 2, 'Windows 10', 1, 1 ),
( 3, 'IOS', 2, 2 ),
( 4, 'OSX', 2, 2 );

insert into tasks( id, name, project_id, company_id ) values
( 1, 'Design w7', 1, 1 ),
( 2, 'Code w7', 1, 1 ),
( 3, 'Unassigned Task', 1, 1 ),
( 4, 'Design w10', 2, 1 ),
( 5, 'Code w10', 2, 1 ),

( 6, 'Design IOS', 3, 2 ),
( 7, 'Code IOS', 3, 2 ),
( 8, 'Design OSX', 4, 2 ),
( 9, 'Code OSX', 4, 2 );

insert into users_projects( project_id, user_id, company_id ) values
( 1, 1, 1 ),
( 2, 1, 1 ),
( 1, 2, 1 ),
( 2, 2, 1 ),
( 1, 3, 1 ),
( 3, 8, 2 ),
( 3, 9, 2 ),
( 4, 8, 2 ),
( 4, 11, 2 );

insert into users_tasks( task_id, user_id, company_id ) values
( 1, 1, 1 ),
( 2, 3, 1 ),
( 5, 8, 2 );