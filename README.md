NOTE!
While the techniques in this repo are still useful, for a better way of doing RLS check out this link
https://twitter.com/graphqlapi/status/813655206344921089


This project is an example of a PostgreSQL schema that would be used with PostgREST on top.
The purpose is to test if flexible RLS (Row Level Security) is possible using views (or RLS in 9.5) for a nontrivial setup.

The schema models a basic "project management" application with companies/users/clients/projects/tasks.
The data is stored in tables in the `data` schema. The `api` schema holds the views that would be exposed using PostgREST. Tests are implemented using pgTap to test the RLS features and performance of the queries. The tests are not complete, they are just an example of how you would go about doing things.
To run this on your machine, execute the following commands.
```
# boot the vagrant instance
git clone https://github.com/ruslantalpa/postgrest-rls-example
cd postgrest-rls-example
vagrant up
vagrant ssh

# init the database
cd /vagrant
./resetdb.sh

# run the RLS tests
./run_rls_tests.sh

# load the tables with a lot of data (wait for a minute or two)
./load_sample_data.sh

# execute the tests to check the speed of the queries
./run_performance_tests.sh

# if you want to play with the view definitions from api schema
# you can reset just the api schema like this
./reset_api_schema.sh
```
