User authentication engine requires Rails 3.2.1 or above.

### Configuring the application:

* Add the following to the **`Gemfile`**<br>
  `gem 'user_authentication'`

* Add the following to **`config/application.rb`**:<br>
  `config.railties_order = [UserAuthentication::Engine, :main_app, :all]`<br>
  as the first line after<br>
  `class Application < Rails::Application`

* Add the following to **`config/routes.rb`**:<br>
  `UserAuthentication::Engine.routes`<br>
  as the first line after<br>
  `YourApplication::Application.routes.draw do`

### Creating the Account model:

If the model does not exist, which is the most common case, run the following:

* `bundle exec rake user_authentication:install:migrations`
* `bundle exec rake db:migrate`

Else in the unlikely case that your application already has the model:

* Ensure that the account model has an `email` (`VARCHAR(255)`) and a `password_digest` (`VARCHAR(255)`) field.
* Add the following line at the top of app/models/account.rb:
  `require File.join UserAuthentication::Engine.config.root, 'app/models/account.rb'`

### Creating a login form:
There are three ways of creating a login form:

1. Use the ready made login page provided by the railtie at `/login`.
2. Use the ready made partial `shared/login` provided by the railtie, in any page.
3. Create a custom login form with an `email` field, a `password` field and the action set to `login_path`. On a successful login, site will be redirected to the `next` field, if any.

On a successful login:

1. `current_account` will be set to the logged in account.
2. If an `on_login` action on `AccountsController` is defined, that will be invoked.
3. If it is not defined:
	1. If a `redirect` field is set in the form, site will be redirected to its value.
	2. If a `redirect` field is not set, site will be redirected back to the referrer.

On a failed login:

1. `current_account` will be nil.
2. Site will be redirected back to the referrer.

Notes:

* You can render a logged in experience based on whether `current_account` was set.
* If you want to set the redirect URL, you can render the partial directly as `render "shared/login", redirect: <custom_url>` or define an `on_login` action in your `AccountsController` that performs the redirect.

### Creating a signup form:
There are three ways of creating a signup form:

1. Use the ready made signup provided by the railtie at `/signup`.
2. Use the ready made partial `shared/signup` provided by the railtie, in any page.
3. Create a custom form with an `email` field, a `password` field an the action set to `signup_path`.

On a successful signup:

1. An account will be created in the database, logged in, and `current_account` set to this signed up and logged in account.
2. If an `on_signup` action on `AccountsController` is defined, that will be invoked.
3. If it is not defined:
	1. If a `redirect` field is set in the form, site will be redirected to its value.
	2. If a `redirect` field is not set, site will be redirected back to the referrer.

On a failed signup:

1. `current_account` will be nil.
2. Site will be redirected back to the referrer.

Notes:

* You can render a logged in experience based on whether `current_account` was set.
* If you want to set the redirect URL, you can render the partial directly as `render "shared/signup", redirect: <custom_url>` or define an `on_signup` action in your `AccountsController` that performs the redirect.
