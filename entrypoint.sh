#!/bin/bash
set -e

#Remove a potentally pre-existing server.pid for Rails.
rm -f /tmp/pids/server.pid

# Sleep for 14 seconds to allow mysql db to setup and connect
# sleep 14

# Check and wait for mysql container to be setup and connected
echo "Waiting for MySQL DB connection ..."

status=$(nc -z db_primary 3306; echo $?)
echo $status

while [ $status != 0 ]
do
  echo "Waiting 3s ..."
  sleep 3s
  status=$(nc -z db_primary 3306; echo $?)
  echo $status
done

echo "DB is up ..."

# # Dropping existing db
# printf "\nDropping exising db ...\n"
# rake db:drop

# # Create all databases
# printf "\nCreating new databases ...\n"
# rake db:create

# # Migrate all pending db migrations
# printf "\nMigrating new databases ...\n"
# printf "[db:migrate]\n"
# rails db:migrate
# printf "[db:migrate RAILS_ENV=test]\n"
# rails db:migrate RAILS_ENV=test

# # Push seeds into database
# printf "\nPushing seeds to database ...\n"
# printf "[rake db:seed]\n"
# rake db:seed

RAILS_ENV=development rails db:environment:set


# Reseting database (dropping previous, creating and migrating fresh db)
printf "\nResetting database ...\n"
printf "[db:migrate:reset] => [db:drop]-[db:create]-[db:migrate]\n"
rails db:migrate:reset

# Pushing seeds into database
printf "\nPushing seeds to database ...\n"
printf "[db:setup] => [db:schema:load]-[db:seed]\n"
rails db:setup

printf "\n------------------------\n"
printf "Completed database setup\nStarting server ...\n"
printf "hosted on: localhost:3000\n\n"

# Then exec the containers main process (what's set as CMD in the Dockerfile).
exec "$@"
