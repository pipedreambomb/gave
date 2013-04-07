Meteor.startup ->

  if 0 == gave.Transactions.find().count() ==
      gave.Causes.find().count()
    gave.populateData()

Meteor.publish "my-transactions", ->
  gave.Transactions.find({owner: this.userId}) if this.userId?

Meteor.publish "all-causes", ->
  gave.Causes.find()
