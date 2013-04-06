Template.transaction.Causes = ->
  gave.Causes.find()

Template.transaction.events
  'click #doneBtn': (evt) ->
    evt.preventDefault()
    fm = document.forms["transaction"]
    newTransaction =
      cause_id: fm["cause"].value
      amount: fm["amount"].value
      date: moment(fm["date"].value).toDate() #parse string as date
    id = Session.get "currentTransactionId"
    if id
      gave.Transactions.update { _id: id }, { $set: newTransaction }
    else
      gave.Transactions.insert newTransaction
    Meteor.Router.to '/'

Template.transaction.rendered = ->
  # Set up the datepicker ui object
  $('.datepicker').datepicker()

Template.transaction.helpers
  shortDate: ->
    moment(this.date).format('L') if this
  selected: ->
    this._id == Template.transaction.Transaction()?.cause_id

Template.transaction.Transaction = ->
  id = Session.get "currentTransactionId"
  gave.Transactions.findOne { _id: id } if id
