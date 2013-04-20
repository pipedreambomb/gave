Template.signup.rendered = ->
  if Meteor.userId()
    Meteor.Router.to('/dashboard')
  Accounts._loginButtonsSession.set('dropdownVisible', true)
  Accounts._loginButtonsSession.set('inSignupFlow', true)
  Accounts._loginButtonsSession.set('inForgotPasswordFlow', false)
  $('.login-close-text').hide()
