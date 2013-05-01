pageIs = (name) -> Meteor.Router.page() == name

_.extend Template.navbar

  UserIsLoggedInAndNotDemoUser: ->
    user = Meteor.user()
    user.username != "Demo_User" if user?

  PageIsHome: -> pageIs "home"
  PageIsAbout: -> pageIs "about"
  PageIsDashboard: -> pageIs "dashboard"
  PageIsDemo: ->
    # Meteor.Router.page() returns "dashboard", so no use
    document.location.pathname == "/demo"
  PageIsSignUp: -> pageIs "signup"

Template.navbar.events
  'click #login-buttons-logout': -> Meteor.Router.to("/")
