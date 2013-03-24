if Meteor.isClient

  Template.hello.greeting = ->
    "Welcome to gave."

  Template.hello.events = 
    'click input': ->
      # template data, if any, is available in 'this'
      console.log "You pressed the button" if console

if Meteor.isServer
  Meteor.startup ->
