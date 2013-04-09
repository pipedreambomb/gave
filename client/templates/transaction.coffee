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
  'click #doneBtn': (evt) ->
    # Clear the error message
    Session.set "Transaction_error", null
    evt.preventDefault()
    fm = document.forms["transaction"]
    tran =
      cause_id: fm["cause"].value
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
          Meteor.Router.to '/'
    else
      Meteor.call "insertTransaction", tran, null, (error, result) ->
        if error?
          Session.set "Transaction_error", error.details
        else
          Meteor.Router.to '/'

Template.transaction.rendered = ->
  # Set up the datepicker ui object
  $('.datepicker').datepicker()

Template.transaction.helpers
  shortDate: ->
    moment(this.date).format('L') if this and this.date
  selected: ->
    this._id == Template.transaction.Transaction()?.cause_id
