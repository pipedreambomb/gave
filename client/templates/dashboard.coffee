Template.dashboard.PageTitle = ->
  if Meteor.user().username == "Demo_User"
    "Demo Dashboard"
  else
    "My Dashboard"
