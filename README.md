User authentication engine requires Rails 3.2.1 or above.

### Installing the engine:

* Add the following to the `Gemfile`<br>
  `gem 'user_authentication', '~> 0.0.8'`
* Run `bundle install`

### Creating the User model:

If the model does not exist, run the following:

* `rake user_authentication:install:migrations`
* `rake db:migrate`

If the model exists:

* Ensure that the user model has an `email` (`VARCHAR(255)`) and a `password_digest` (`VARCHAR(255)`) field.
* Add the following line at the top of app/models/user.rb:
  `require File.join UserAuthentication::Engine.config.root, 'app/models/user.rb'`

### Configuring the application:

* Add the following to `config/application.rb`
  `config.railties_order = [UserAuthentication::Engine, :main_app, :all]

### Creating a login form:

Create a form with an `email` field, a `password` field and the action set to `login_path`.

On a successful login, current_user will be set to the logged in user.

The default action is to redirect back to the referrer. You can render a logged in experience based on whether `current_user` was set.

You can implement a custom action by creating a controller named UsersController and implementing a method named `on_login`, that does not take any parameters. If this method is defined, the default redirect will not happen.

On failure, form will redirect back to the referrer with a flash[:alert] set to the error.


### Creating a signup form:

Create a form with an 'email' field, a `password` field and the action set to `signup_path`.

On a successful signup, the user will be created in the database, logged in and `current_user` set to this user.

The default action is to redirect back to the referrer. You can render a logged in experience based on whether `current_user` was set.

You can implement a custom action by creating a controller named UsersController and implementing a method named `on_signup`, that does not take any parameters. If this method is defined, the default redirect will not happen.

On failure, form will redirect back to the referrer with a flash[:alert] set to the error.