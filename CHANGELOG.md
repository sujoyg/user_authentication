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
