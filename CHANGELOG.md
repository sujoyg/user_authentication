# 0.2.3
  * Feature: Displaying an error on authentication failure.

# 0.2.1
  * Other: Remove depedency on ruby-openid.

# 0.2.0
  * Other: Upgrade to Rails 4.

# 0.1.4
  * Feature: If a page requires authorization, redirect back to it after login.
  * Feature: Allow setting login page to redirect to for authorization.

# 0.1.3
  * Feature: Ready made login and signup forms.
  * Other: Improved documentation.

# 0.1.2
  * Feature: Support for setting passwords.

# 0.1.1
  * Bug: If app adds a blanket authorize before filter, user signups will fail. Always disable authorize for signups.

# 0.1.0
  * Feature: Support for signups and custom actions on login, logout and signup.

# 0.0.9
  * Bug: Remove dependency on rspec and lower bcrypt version requirement.

# 0.0.8
  * Bug: current_user was not available in helpers and views.

# 0.0.7
  * Bug: User model was not loading in the main app if the user authentication engine was loaded as part of another engine.

# 0.0.6
  * Bug: current_user was not accessible from view specs of an app using this engine.

# 0.0.5
  * Feature: Allow user model to be overridden in the app.

# 0.0.4
  * Feature: A default login form partial (users/_form) which posts to /login.
  * Feature: If a password is not set, a default random password is generated.

# 0.0.3
  * Feature: Reduce rails dependency to 3.2.1. It was 3.2.8 earlier.

# 0.0.2
  * Bug: Models and controllers are loaded from both the engine and the application even if they have the same name.

# 0.0.1
  * Feature: A rails engine for email and password based user authentication.
