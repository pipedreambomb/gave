Template.navbar.UserIsLoggedInAndNotDemoUser = ->
  user = Meteor.user()
  user?.username != "Demo_User"

Template.navbar.PageIsHome = -> pageIs "home"
Template.navbar.PageIsAbout = -> pageIs "about"
Template.navbar.PageIsDashboard = -> pageIs "dashboard"
Template.navbar.PageIsDemo = ->
  # Meteor.Router.page() returns "dashboard"
  document.location.pathname == "/demo"
Template.navbar.PageIsSignUp = -> pageIs "signup"

pageIs = (name) -> Meteor.Router.page() == name
