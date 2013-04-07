Template.transaction.Transaction = ->
  id = Session.get "currentTransactionId"
  t = gave.Transactions.findOne { _id: id } if id
  #feed the template some empty fields if no transaction matches
  t or { amount: "", date: "" }

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
      owner: Meteor.userId()
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
    moment(this.date).format('L') if this and this.date
  selected: ->
    this._id == Template.transaction.Transaction()?.cause_id
