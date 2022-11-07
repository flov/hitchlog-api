![Github actions CI pipeline Badge](https://github.com/flov/hitchlog-api/actions/workflows/ci.yml/badge.svg)

# Rails 7 API only app for the hitchlog

- JWT Authentication with devise-jwt

## Tech stack

![techstack](/public/techstack.png)

## Install

Edit the content of `.env.example` and copy it over to `.env`
`bundle install`
`rake db:schema:load && rake db:migrate`
should do the trick

Then `rails s` to start the server
