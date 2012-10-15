User authentication engine requires Rails 3.2.1 or above.

### Installing the engine:

* Add the following to the `Gemfile`<br>
  `gem 'user_authentication', '~> 0.0.3'`
* Run `bundle install`

### Creating the User model:

If the model does not exist, run the following:

* `rake user_authentication:install:migrations`
* `rake db:migrate`

If the model exists:

* Ensure that the user model has an `email` and a `password_digest` field.
* Add the following line at the top of app/models/user.rb:
  `require File.join UserAuthentication::Engine.config.root, 'app/models/user.rb'`

### Configuring the application:

* Add the following to `config/application.rb`
  `config.railties_order = [UserAuthentication::Engine, :main_app, :all]
