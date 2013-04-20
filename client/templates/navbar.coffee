Template.navbar.UserIsLoggedIn = -> (Meteor.user())?

Template.navbar.PageIsHome = -> pageIs "home"
Template.navbar.PageIsAbout = -> pageIs "about"
Template.navbar.PageIsDashboard = -> pageIs "dashboard"
Template.navbar.PageIsSignUp = -> pageIs "signup"

pageIs = (name) -> Meteor.Router.page() == name
