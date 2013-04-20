Template.demo.UserIsDemoUser = -> Meteor.user().username == "Demo_User"

Template.demo.events
  'click #demo-signup': (event) ->
    event.preventDefault()
    Meteor.logout ->
      Meteor.Router.to('/signup')
