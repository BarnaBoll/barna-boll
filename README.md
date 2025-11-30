# README

The app is built with **Ruby on Rails 8**, **PostgreSQL**, **Tailwind CSS**, and **Devise** (with Google & Facebook login).

--------- LOCAL DEVELOPMENT ---------

- Start the app with
  PORT=4001 bin/dev

- Check if the server is running
  lsof -i :4001

- If port is still open kill it
  kill -9 PORT_NUMBER
- Delete leftover builds data
  rm -f tmp/pids/server.pid

## Tech Stack

- **Language:** Ruby `3.3.7`
- **Framework:** Rails `~> 8.1.1`
- **Database:** PostgreSQL
- **Auth:** Devise + OmniAuth (Google & Facebook)
- **Front-end:** Tailwind CSS, Turbo, Stimulus, Importmap
- **Background jobs:** Solid Queue
- **Cache:** Solid Cache
- **File storage:** Local disk (Active Storage)
- **Mailers:**
  - Dev: `letter_opener`
  - Prod: SMTP via Hostup (cPanel)

### Prerequisites

- Ruby `3.3.7` (see `.ruby-version`)
- Bundler
- PostgreSQL running locally
- Yarn/Node **not strictly required** (assets handled by `tailwindcss-rails` + importmap)

### Setup

bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails tailwindcss:install
bin/rails tailwindcss:build

### Deployment instructions

git add .
git commit -am "make it better"
git push heroku main

heroku run rails db:migrate
