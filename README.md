# 💎 Rails 6 boilerplate with devise, JWT, graphQL, CanCanCan and RailsAdmin.
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/zauberware/rails-devise-graphql/graphs/commit-activity)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/zauberware/rails-devise-graphql/blob/master/LICENSE)
![GitHub top language](https://img.shields.io/github/languages/top/zauberware/rails-devise-graphql)
![GitHub issues](https://img.shields.io/github/issues/zauberware/rails-devise-graphql)

This is a boilerplate to build your next SaaS product. It's a RubyOnRails 6 backend with authentication, GraphQL API, Roles & Ability management and a admin dashboard. It works nicely together with clients made with **Angular, React, Vue.js, React.Native, Swift, Kotlin** or any other client framework which implements the [JSON Web Tokens](https://jwt.io/introduction/) philosophy.

### Versions

- Current ruby version `2.6.x`
- Bundler version `2.1.4`
- Rails version `6.0.X`
- PostgreSQL Server as db connector

### Dependencies
This boilerplate works like a charm with the following gems:
- pg
- devise
- devise_invitable
- graphql
- graphql-auth
- graphql-errors
- rack-cors
- rack_attack
- rails_admin
- cancancan
- image_processing
- mini_magick
- puma
- bootsnap
- friendly_id
- dotenv


## 🚀 Quick start

You can have a running backend in seconds on [heroku](https://www.heroku.com):

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/zauberware/rails-devise-graphql) 

or clone this repo:

```sh
git clone https://github.com/zauberware/rails-devise-graphql my-saas-backend
cd my-saas-backend
```

Clone `env_sample` to .env for local development. We set it up with default rails `3000` and client  `8000` ports:

```sh
cp env_sample .env
```

Install the bundle:

```sh
bundle install
```

Make sure the PostgreSQL is running on localhost. You may have to change your credentials under `/config/database.yml`:

```sh
rake db:create
rake db:migrate
rake db:seed
```

Run the development server:

```sh
rails s
```

Download a GraphQL client like [GraphiQL](https://github.com/graphql/graphiql) or others to access and test your API. Point the GraphQL IDE to `http://0.0.0.0:3000/graphql`

**Note:** Make sure that the `.env` file is included in the root of your project and you have defined `CLIENT_URL` and `DEVISE_SECRET_KEY`. Read more about the JSON Web Token [this](https://github.com/zauberware/rails-devise-graphql). There are plenty of packages available.

## 🎁 What's included?

### 1. Database
The app uses a PostgreSQL database. It implements the connector with the gem `pg`. The app already includes a `User` and a `Company` model with basic setup. We see an `Company` as a company with it's users. We did **not** add multi-tenancy to this app. If you want to do it by yourself check out the [apartment](https://github.com/influitive/apartment) gem.


### 2. Authentication
The app uses [devise](https://github.com/plataformatec/devise)'s logic for authentication. For graphQL API we use the JWT token, but to access the rails_admin backend we use standard devise views, but registration is excluded.

Change devise settings under `config/initializers/devise.rb` and `config/initializers/graphql_auth.rb`.

#### Invitations
Admins of a company can invite new users. The process is handled with `devise_invitable`. We added a `inviteUser` and `acceptInvite` mutation to handle this process via graphql.

Like in the reset password process we redirect the users to the frontend domain and not to backend.


### 3. JSON Web Token
[graphql-auth](https://github.com/o2web/graphql-auth) is a graphql/devise extension which uses JWT tokens for user authentication. It follows [secure by default](https://en.wikipedia.org/wiki/Secure_by_default) principle.


### 4. GraphQL
[graphql-ruby](https://github.com/rmosolgo/graphql-ruby) is a Ruby implementation of GraphQL. Sadly it's not 100% open source, but with the free version allows you amazing things to do. See the [Getting Started Guide](https://graphql-ruby.org/) and the current implementations in this project under `app/graphql/`.

#### Filters, Sorting & Pagination
Our `BaseResolver` class provides everything you need to achieve filter, sorting and pagination. Have a look at the resolver `resolvers/users/users.rb`:

**How to:**

Include `SearchObject` module in your resolver:

```ruby
  class Users < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)
```

Define the scope for this resolver:

```ruby
scope { resources }

def resources
  ::User.accessible_by(current_ability)
end
```

Set a connection_type as return type to allow pagination:
```ruby
type Types::Users::UserType.connection_type, null: false
```

Set `order_by` as query option and define allowed order attributes:

```ruby
option :order_by, type: Types::ItemOrderType, with: :apply_order_by
def allowed_order_attributes
  %w[email first_name last_name created_at updated_at]
end
```

Allow filtering with a custom defined filter object & define allowed filter attributes:

```ruby
# inline input type definition for the advanced filter
class UserFilterType < ::Types::BaseInputObject
  argument :OR, [self], required: false
  argument :email, String, required: false
  argument :first_name, String, required: false
  argument :last_name, String, required: false
end
option :filter, type: UserFilterType, with: :apply_filter
def allowed_filter_attributes
  %w[email first_name last_name]
end
```

#### Schema on production

We have disabled introspection of graphQL entry points here `app/graphql/graphql_schema.rb`. Remove `disable_introspection_entry_points` if you want to make the schema public accessible.


### 5. CORS
Protect your app and only allow specific domains to access your API. Set `CLIENT_URL=` in `.env` to your prefered client. If you need advanced options please change the CORS settings here `config/initializers/cors.rb`.


### 6. App server
The app uses [Puma](https://github.com/puma/puma) as the web serber. It is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications in development and production.


### 7. UUID
The app uses UUID as ids for active record entries in the database. If you want to know more about using uuid instead of integers read this [article by pawelurbanek.com](https://pawelurbanek.com/uuid-order-rails).


### 8. Automatic model annotation
Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema. See [annotate_models gem](https://github.com/ctran/annotate_models).

Run `$ annotate` in project root folder to update annotations.


### 9. Abilities with CanCanCan
[CanCanCan](https://github.com/CanCanCommunity/cancancan) is an authorization library for Ruby and Ruby on Rails which restricts what resources a given user is allowed to access. We combine this gem with a `role` field defined on user model.

Start defining your abilities under `app/models/ability.rb`.


### 10. Rails Admin
To access the data of your application you can access the [rails_admin](https://github.com/sferik/rails_admin) dashboard under route `http://0.0.0.0:3000/admin`. Access is currently only allowed for users with super admin role.

If you want to give your admin interface a custom branding you can override sass variables or write your own css under `app/assets/stylesheets/rails_admin/custom`.

Change rails_admin settings under `config/initializers/rails_admin.rb`.


### 11. I18n
This app has the default language `en` and already set a secondary language `de`. We included the [rails-i18n](https://github.com/svenfuchs/rails-i18n) to support other languages out of the box. Add more languages under `config/initializers/locale.rb`.

#### Setting locale

To switch locale just append `?locale=de` at the end of your url. If no `locale` param was set it uses browser default language (request env `HTTP_ACCEPT_LANGUAGE`). If this is unknown it takes the default language of the rails app.

#### Devise

For devise we use [devise-i18n](https://github.com/tigrish/devise-i18n) to support other languages.

Change translations under `config/locales/devise`.If you want to support more languages install them with `rails g devise:i18n:locale fr`. (<-- installs French)

#### Rails Admin

To get translations for rails admin out of the box we use [rails_admin-i18n](https://github.com/starchow/rails_admin-i18n).

#### Testing Locales

How to test your locale files and how to find missing one read [this](https://github.com/svenfuchs/rails-i18n#testing-your-locale-file).


### 12. HTTP Authentication
For your staging environment we recommend to use a HTTP Auth protection. To enable it set env var `IS_HTTP_AUTH_PROTECTED` to `true`.

Set user with `HTTP_AUTH_USER` and password with `HTTP_AUTH_PASSWORD`.

We enable HTTP auth currently for all controllers. The `ApplicationController` class includes the concern `HttpAuth`. Feel free to change it.


### 13. Auto generated slugs
To provider more user friendly urls for your frontend we are using [friendly_id](https://github.com/norman/friendly_id) to auto generate slugs for models. We have already implemented it for the `Company` model. For more configuration see `config/initializers/friendly_id.rb`.

To create a new slug field for a model add a field `slug`:

```sh
$ rails g migration add_slug_to_resource slug:uniq
$ bundle exec rake db:migrate
```

Edit your model file as the following:

```ruby
class Company < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
end
```

Replace traditional `Company.find(params[:id])` with `Company.friendly.find(params[:id])`
```ruby
  company = Company.friendly.find(params[:id])
```


### 14. Testing

We are using the wonderful framework [rspec](https://github.com/rspec/rspec). The test suit also uses [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails) for fixtures.

Run `rspec spec`

#### FactoryBot

To create mock data in your tests we are using [factory_bot](https://github.com/thoughtbot/factory_bot). The gem is fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

#### Faker

Create fake data easily with [faker gem](https://github.com/faker-ruby/faker). Caution: The created data is not uniq by default.

#### Shoulda Matchers

[Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) provides RSpec- and Minitest-compatible one-liners to test common Rails functionality that, if written by hand, would be much longer, more complex, and error-prone.

#### Simplecov

[SimpleCov](https://github.com/simplecov-ruby/simplecov) is a code coverage analysis tool for Ruby. It uses Ruby's built-in Coverage library to gather code coverage data, but makes processing its results much easier by providing a clean API to filter, group, merge, format, and display those results, giving you a complete code coverage suite that can be set up with just a couple lines of code.

Open test coverage results with 

```sh
  $ open /coverage/index.html
```

### 15. Linter with Rubocop

We are using the wonderful [rubocop](https://github.com/rubocop-hq/rubocop-rails) to lint and auto fix the code. Install the rubocop VSCode extension to get best experience during development.

### 16. Security with Rack Attack
See `config/initializers/rack_attack.rb` file. We have defined a common set of rules to block users trying to access the application multiple times with wrong credentials, or trying to create a hundreds requests per minute.

To speed up tests add this to your `.env.test`

```
ATTACK_REQUEST_LIMIT=30
ATTACK_AUTHENTICATED_REQUEST_LIMIT=30
```

### 17. Sending emails
Set your SMTP settings with these environment variables:
- `SMTP_ADDRESS`
- `SMTP_PORT`
- `SMTP_DOMAIN`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `SMTP_AUTH`
- `SMTP_ENABLE_STARTTLS_AUTO`

Have a look at `config/environments/production.rb` where we set the `config.action_mailer.smtp_settings`.

#### from: email

Set the email address for your `ApplicationMailer` and devise emails with env var `DEVISE_MAILER_FROM`.


### 18. Deployment
The project runs on every server with ruby installed. The only dependency is a PostgreSQL database. Create a block `production:` in the`config/database.yml` for your connection.

#### Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/zauberware/rails-devise-graphql)

Choose the one click installer or push a clone of this repo to heroku by yourself. We added a `Profile` to the project and heroku run the `release:` statement after deploying a new version. Heroku will automatically set the db settings for your project, so there is nothing to do in `config/database.yml`.

**Make sure all ENV vars are set and the database settings are valid.**

#### Bitbucket Pipelines

If you want to use [Bitbucket pipelines](https://bitbucket.org/product/de/features/pipelines) for CI you can use the sample file `bitbucket-pipelines.yml` in the project root.

Make sure to set ENV vars `$HEROKU_API_KEY` and `$HEROKU_APP_NAME` in Bitbuckets pipeline settings. (Will appear after enabling pipelines for your project.)

The pipeline has 2 environments: staging and production. Staging pipeline is getting triggered in `develop` branch. Production deploy triggered by `master` branch.

It also triggers pipeline while opening a PR.

## What's missing?
- Check & retest locked accounts
- Invite for users, inviteMutation & acceptInviteMutation
- Registration add more fields (Firstname, Last name)
- Tests for filter, sorting & pagination
- Security: brakeman and bundler-audit

Feel free to make feature request or join development!

## Share this repo
Help us to get more attention to this project:

![Twitter URL](https://img.shields.io/twitter/url?label=Tweet%20about%20this%20project&style=social&url=https%3A%2F%2Fgithub.com%2Fzauberware%2Frails-devise-graphql)

## 🚀 Contributors, backers & sponsors

This project exists thanks to all the **people who contribute**.
<a href="https://github.com/zauberware/rails-devise-graphql/graphs/contributors"><img src="https://opencollective.com/rails-devise-graphql/contributors.svg?width=890&button=false" /></a>

Thank you to **all our backers**! 🙏 ([Become a backer](https://opencollective.com/rails-devise-graphql#backer))

<a href="https://opencollective.com/rails-devise-graphql#backers" target="_blank"><img src="https://opencollective.com/rails-devise-graphql/backers.svg?width=890"></a>

**Support this project by becoming a sponsor.** Your logo will show up here with a link to your website. ([Become a sponsor](https://opencollective.com/rails-devise-graphql#sponsor))

<a href="https://opencollective.com/rails-devise-graphql/sponsor/0/website" target="_blank"><img src="https://opencollective.com/rails-devise-graphql/sponsor/0/avatar.svg"></a>


## ❤️ Code of Conduct

Please note that zauberware has a [Code of Conduct](https://github.com/zauberware/rails-devise-graphql/blob/master/CODE_OF_CONDUCT.md). By participating in this project online or at events you agree to abide by its terms.


## Author

__Script:__ <https://github.com/zauberware/rails-devise-graphql>

__Author website:__ [https://www.zauberware.com](https://www.zauberware.com)

![zauberware technologies](https://avatars3.githubusercontent.com/u/1753330?s=200&v=4)

