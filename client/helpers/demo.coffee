Template.demo.UserIsDemoUser = -> gave.utils.userIsDemoUser()

Template.demo.events
  'click #demo-signup': (event) ->
    event.preventDefault()
    Meteor.logout ->
      Meteor.Router.to('/signup')
