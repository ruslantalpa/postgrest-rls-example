
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