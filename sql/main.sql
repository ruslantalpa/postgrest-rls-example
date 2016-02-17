-- execute with
-- sudo -H -u postgres bash -c 'psql -f ./main.sql'

drop database app;
create database app;

\connect app

begin;
ALTER DATABASE app SET postgrest.claims.user_id TO '';
ALTER DATABASE app SET postgrest.claims.company_id TO '';
\i ./functions.sql
\i ./schema.sql
\i ./data.sql
\i ./rls.sql
commit;
