# Rails 6 boilerplate with devise, JWT, graphQL, CanCanCan and RailsAdmin.

This is a boilerplate to build your next SaaS product. It's a RubyOnRails 6 backend with Authentication and GraphQL API. It works nicely together with clients made with **React.js & React.Native** or any other frontend which implements the [JSON Web Tokens](https://jwt.io/introduction/) philosophy.

## Versions

- Current ruby version `2.6.x`
- Bundler version `2.1.4`
- Rails version `6.0.X`
- Postgresql Server as db connector

## Dependencies
This boilerplate works like a charm with the following gems:
- pg
- devise
- graphql
- graphql-auth
- graphql-errors
- rack-cors
- rails_admin
- cancancan
- image_processing
- mini_magick
- puma
- bootsnap


## Quick start

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/zauberware/rails-devise-graphql)

or

clone the repo:

```sh
git clone https://github.com/zauberware/rails-devise-graphql my-saas-backend
cd my-saas-backend
```

Clone `env_sample` to .env for local development. We set it up with default rails `3000` and gatsby `8000` ports:

```sh
cp env_sample .env
```

Install the bundle:

```sh
bundle install
```

Make sure the postresql is running on localhost. You may have to change your credentials under `/config/database.yml`:

```sh
rake db:create
rake db:migrate
rake db:seed
```

Run the development server:

```
rails s
```

While this is an API-only application you will not be able to access any routes via browser. Download a GraphQL client like [GraphiQL](https://github.com/graphql/graphiql) or others.

Point the GraphQL IDE to `http://0.0.0.0:3000/graphql`

**Note:** Make sure that the `.env` file is included in the root of your project and you have defined `CLIENT_URL` and `DEVISE_JWT_SECRET_KEY`. You can try out the [Demo frontend](https://github.com/zauberware/gatsby-starter-redux-saas) or you implement the actions in any other client. Read more about the JSON Web Token [this](https://github.com/zauberware/rails-devise-graphql). There are plenty of packages available.

## What's included?

### 1. Database
The app uses a postgresql database. It implements the connector with the gem `pg`. The app already includes a `User` model with basic setup.

### 2. Authentication
The app uses [devise](https://github.com/plataformatec/devise)'s logic for authentication. For graphQL API we use the JWT token, but to access the rails_admin backend we use standard devise views, but registration is excluded.

### 3. JSON Web Token
[graphql-auth](https://github.com/o2web/graphql-auth) is a graphql/devise extension which uses JWT tokens for user authentication. It follows [secure by default](https://en.wikipedia.org/wiki/Secure_by_default) principle.

### 4. GraphQL
[graphql-ruby](https://github.com/rmosolgo/graphql-ruby) is a Ruby implementation of GraphQL. Sadly it's not 100% open source, but with the free version allows you amazing things to do. See the [Getting Started Guide](https://graphql-ruby.org/) and the current implementations in this project under `app/graphql/`.

### 5. CORS
Protect your app and only allow specific domains to access your API. Set `CLIENT_URL=` in `.env` to your prefered client. If you need advanced options please change the CORS settings here `config/initializers/cors.rb`.

### 6. App server
The app uses [Puma](https://github.com/puma/puma) as the web serber. It is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications in development and production.

### 7. UUID
The app uses UUID as ids for active record entries in the database. If you want to know more about using uuid instead of integers read this [article by pawelurbanek.com](https://pawelurbanek.com/uuid-order-rails).

### 8. Automatic model annotation
Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema. See [annotate_models gem](https://github.com/ctran/annotate_models).

### 9. Abilities with CanCanCan
[CanCanCan](https://github.com/CanCanCommunity/cancancan) is an authorization library for Ruby and Ruby on Rails which restricts what resources a given user is allowed to access. We combine this gem with a `role` field defined on user model.

### 10. Rails Admin
To access the data of your application you can access the [rails_admin](https://github.com/sferik/rails_admin) dashboard under route `/admin`. It's currently only allowed for users with role superadmin.

If you want to give your admin interface a custom branding you can override sass variables or write your own css under `app/assets/stylesheets/rails_admin/custom`.

### 11. Testing

We are using the wonderful framework [rspec](https://github.com/rspec/rspec). The testsuit also uses [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails) for fixtures.

Run `rspec spec`

#### FactoryBot
To create mock data in your tests we are using [factory_bot](https://github.com/thoughtbot/factory_bot). The gem is fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), includéng factory inheritance.

#### Faker
Create fake data easily with [faker gem](https://github.com/faker-ruby/faker). Caution: The created data is not uniq by default.

#### Shoulda Matchers
[Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) provides RSpec- and Minitest-compatible one-liners to test common Rails functionality that, if written by hand, would be much longer, more complex, and error-prone.

#### Simplecov
[SimpleCov](https://github.com/simplecov-ruby/simplecov) is a code coverage analysis tool for Ruby. It uses Ruby's built-in Coverage library to gather code coverage data, but makes processing its results much easier by providing a clean API to filter, group, merge, format, and display those results, giving you a complete code coverage suite that can be set up with just a couple lines of code.

Access results with `$ open /coverage/index.html`.


### 12. Linter with Rubocop

We are using the wonderful [rubocop](https://github.com/rubocop-hq/rubocop-rails) to lint and autofix the code. Install the rubocop VSCode extension to get best experience during development.


### 13. Deployment
The project runs on every webhoster with ruby installed. The only dependency is a PostgreSQL database. Create a block `production:` in the`config/database.yml` for your connection.

#### Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/zauberware/rails-devise-graphql)

Choose the one click installer or push a clone of this repo to heroku by yourself. We added a `Profile` to the project and heroku run the `release:` statement after deploying a new version. Heroku will automatically set the db settings for your project, so there is nothing to do in `config/database.yml`.


**Make sure all ENV vars are set and the database settings are valid.**

#### Bitbucket Pipelines
If you want to use [bitbucket pipelines](https://bitbucket.org/product/de/features/pipelines) for CI you can use the sample file `bitbucket-pipelines.yml` in the project root.

Make sure to set ENV vars `$HEROKU_API_KEY` and `$HEROKU_APP_NAME` in bitbuckets pipeline settings. (Will appear after enabling pipelines for your project.)

The pipeline has 2 environments: staging and production. Staging pipline is getting triggered in `develop` branch. Production deploy triggered by `master` branch.

It also triggers pipeline when opening a PR.

## What's missing?

* We want to move to https://github.com/o2web/graphql-auth


Feel free to join development!

## Author

__Script:__ <https://github.com/zauberware/rails-devise-graphql>
__Author website:__ [https://www.zauberware.com](https://www.zauberware.com)

![zauberware technologies](https://avatars3.githubusercontent.com/u/1753330?s=200&v=4)
