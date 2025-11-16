# README

--------- LOCAL DEVELOPMENT ---------
Start the app with => PORT=4001 bin/dev
Check if the server is running => lsof -i :4001
If port is still open kill it => kill -9 PORT_NUMBER
Delete leftover builds data => rm -f tmp/pids/server.pid

--------- GENERAL INFO ---------

- Ruby version

bin/rails tailwindcss:install

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

bin/rails tailwindcss:build
bin/rails tailwindcss:install

bin/rails db:create
bin/rails db:migrate
