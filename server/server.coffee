Meteor.startup ->

  if 0 == gave.Transactions.find().count() ==
      gave.Causes.find().count()
    populateData()
