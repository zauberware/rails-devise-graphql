# Rails API-only boilerplate with devise & graphQL

This is a boilerplate to build your next Saas product. It's a RubyOnRails 5 API only backend with Authentication and GrpahQL API. It works nicely together with clients made with **React.js & React.Native** or any other frontend which implements the [JSON Web Tokens](https://jwt.io/introduction/) philosophy. We have a demo frontend made with [gatsbyJS](https://www.gatsbyjs.org/) available here: <https://gatsby-redux.zauberware.com/>.

## Versions

- Tested with ruby version `2.4.x`
- Rails version `~>5.2.2`
- Postgresql Server

## Quick start

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/zauberware/rails-devise-graphql)

or

clone the repo:

```sh
git clone my-saas-backend https://github.com/zauberware/rails-devise-graphql
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

**Note:** Make sure that the `.env` file is included in the root of your project and you have defined `DOMAIN`, `CLIENT_URL` and `DEVISE_JWT_SECRET_KEY`. You can try out the [Demo frontend](https://github.com/zauberware/gatsby-starter-redux-saas) or you implement the actions in any other client. Read more about the JSON Web Token [this](https://github.com/zauberware/rails-devise-graphql). There are plenty of packages available.

## What's included?

### 1. Database
The app uses a postgresql database. It implements the connector with the gem `pg`. The app already includes a `User` model with basic setup.

### 2. Authentication
The app uses [devise](https://github.com/plataformatec/devise)'s logic for authentication. Emails are currently disabled in the environment settings.

### 3. JSON Web Token
[devise-jwt](https://github.com/waiting-for-dev/devise-jwt) is a devise extension which uses JWT tokens for user authentication. It follows [secure by default](https://en.wikipedia.org/wiki/Secure_by_default) principle.


### 4. GraphQL
[graphql-ruby](https://github.com/rmosolgo/graphql-ruby) is a Ruby implementation of GraphQL. Sadly it's not 100% open source, but with the free version allows you amazing things to do. See the [Getting Started Guide](https://graphql-ruby.org/) and the current implementations in this project under `app/graphql/`.

### 5. CORS
Protect your app and only allow specific domains to access your API. Set `CLIENT_URL=` in `.env` to your prefered client. If you need advanced options please change the CORS settings here `config/initializers/cors.rb`.

### 6. App server
The app uses [Puma](https://github.com/puma/puma) as the web serber. It is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications in development and production.

### 7. Testing

TBD: rspect

### 8. Deployment
The project runs on every webhoster with ruby installed. The current demo was deployed to an heroku dyno with a Postgresql database as the only resource.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/zauberware/rails-devise-graphql)


**Make sure all ENV vars are set and the database settings are valid.**

### 9. Frontend

#### GatsbyJS

If you need a frontend than have a look at this basic [Gatsby boilerplate](https://github.com/zauberware/gatsby-starter-redux-saas). A Gatsby Redux Saas starter for your next Saas product. Uses react-redux, apollo-client, magicsoup.io, styled-components, styled-system.

![zauberware technologies](https://github.com/zauberware/gatsby-starter-redux-saas/raw/master/static/website-preview.jpg)



## Author

__Script:__ <https://github.com/zauberware/rails-devise-graphql>  
__Author website:__ [https://www.zauberware.com](https://www.zauberware.com)    

![zauberware technologies](https://avatars3.githubusercontent.com/u/1753330?s=200&v=4)