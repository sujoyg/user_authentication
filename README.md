User authentication engine requires Rails 3.2.1 or above.

### Installing the engine:

* Add the following to the `Gemfile`<br>
  `gem 'user_authentication'`
* Run `bundle install`

### Creating the User model:

If the model does not exist, run the following:

* `bundle exec rake user_authentication:install:migrations`
* `bundle exec rake db:migrate`

Else if the model exists:

* Ensure that the user model has an `email` (`VARCHAR(255)`) and a `password_digest` (`VARCHAR(255)`) field.
* Add the following line at the top of app/models/user.rb:
  `require File.join UserAuthentication::Engine.config.root, 'app/models/user.rb'`

### Configuring the application:

Add the following to `config/application.rb`:<br>
`config.railties_order = [UserAuthentication::Engine, :main_app, :all]`<br>
as the first line after<br>
`class Application < Rails::Application`

### Creating a login form:
There are three ways of creating a login form:

1. Use the ready made login page provided by the railtie at `/login`.
2. Use the ready made partial `shared/login` provided by the railtie, in any page.
3. Create a custom login form with an `email` field, a `password` field and the action set to `login_path`. On a successful login, site will be redirected to the `next` field, if any.

On a successful login:

1. `current_user` will be set to the logged in user.
2. If a `UsersController` with `on_login` action is defined, that will be invoked.
3. If it is not defined:
	1. If a `next` field is set in the form, site will be redirected to its value.
	2. If a `next` field is not set, site will be redirected back to the referrer.

On a failed login:

1. `current_user` will be nil.
2. Site will be redirected back to the referrer.

A user should be assumed to be logged in if `current_user` is set.
You can render a logged in experience based on whether `current_user` was set.

### Creating a signup form:
There are three ways of creating a signup form:

1. Use the ready made signup provided by the railtie at `/signup`.
2. Use the ready made partial `shared/signup` provided by the railtie, in any page.
3. Create a custom form with an `email` field, a `password` field an the action set to `signup_path`.

On a successful signup:

1. A user will be created in the database, logged in, and `current_user` set to this signed up and logged in user.
2. If a `UsersController` with `on_signup` action is defined, that will be invoked.
3. If it is not defined:
	1. If a `next` field is set in the form, site will be redirected to its value.
	2. If a `next` field is not set, site will be redirected back to the referrer.

On a failed signup:

1. `current_user` will be nil.
2. Site will be redirected back to the referrer.
