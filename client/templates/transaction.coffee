Template.transaction.Transaction = ->
  id = Session.get "currentTransactionId"
  t = gave.Transactions.findOne { _id: id } if id
  #feed the template some empty fields if no transaction matches
  t or { amount: "", date: "" }

Template.transaction.TransactionError = ->
  Session.get "Transaction_error"
  
Template.transaction.Causes = ->
  gave.Causes.find()

Template.transaction.events
  'keyup #tranAmount': (event) ->
    debugger
    fieldVal = event.target.value
    if gave.utils.parsesToNumber fieldVal
      amount = parseFloat event.target.value
    Session.set "currentTransactionAmount", amount or "error"

  'click #doneBtn': (event) ->
    # Clear the error message
    Session.set "Transaction_error", null
    event.preventDefault()
    fm = document.forms["transaction"]
    tran =
      cause_id: Session.get "selectedCause"
      amount: parseFloat fm["amount"].value
      date: moment(fm["date"].value).toDate() #parse string as date
      owner: Meteor.userId()
    id = Session.get "currentTransactionId"
    if id
      tran._id = id
      Meteor.call "updateTransaction", tran, null, (error, result) ->
        if error?
          Session.set "Transaction_error", error.details
        else
          Meteor.Router.to '/dashboard'
    else
      Meteor.call "insertTransaction", tran, null, (error, result) ->
        if error?
          Session.set "Transaction_error", error.details
        else
          Meteor.Router.to '/dashboard'

Template.transaction.rendered = ->
  # Set up the datepicker ui object
  try
    $('.datepicker').datepicker()
  # Ignore error thrown when datepicker tries to parse an empty string.
  # We definitely want a datepicker object on that input, especially
  # if it is empty, or else how will it ever get a real value?

Template.transaction.helpers
  shortDate: ->
    moment(this.date).format('L') if this and this.date
  selected: ->
    this._id == Template.transaction.Transaction()?.cause_id
