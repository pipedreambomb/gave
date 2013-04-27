$datepickerEl = -> $ '.datepick'

Template.transaction.rendered = ->
  $el = $datepickerEl()
  options =
    showAnim: "slideDown"
  $el.datepicker options


Template.transaction.Transaction = ->
  id = Session.get "currentTransactionId"
  t = gave.Transactions.findOne { _id: id } if id
  Session.set "selectedCause", t.cause_id if t
  #feed the template some empty fields if no transaction matches
  t or { amount: "", date: "" }

Template.transaction.TransactionError = ->
  Session.get "Transaction_error"

Template.transaction.UserHasSelectedCause = ->
  (Session.get "selectedCause")?
  
Template.transaction.Causes = ->
  gave.Causes.find({}, {sort: {name: 1}})

# To display in heading, New Transaction or Edit Transaction
Template.transaction.Action = ->
  if Session.get "currentTransactionId" then "Edit" else "New"

Template.transaction.events
  'focus .datepick': ->
    ($ '.datepicker-days td.day').click ->
      $datepickerEl().datepicker "hide"

  'keyup #tranAmount': (event) ->
    fieldVal = event.target.value
    if gave.utils.parsesToNumber fieldVal
      amount = parseFloat event.target.value
    Session.set "currentTransactionAmount", amount or "error"

  'click #cancelBtn': (event) ->
    Meteor.Router.to '/dashboard'
    
  'click #doneBtn': (event) ->
    # Clear the error message
    Session.set "Transaction_error", null
    event.preventDefault()
    fm = document.forms["transaction"]
    tran =
      cause_id: Session.get "selectedCause"
      amount: parseFloat fm["amount"].value
      date: parseDateOrUseNowIfToday fm["date"].value
      owner: Meteor.userId()
    id = Session.get "currentTransactionId"
    if id
      tran._id = id
      Meteor.call "updateTransaction", tran, null, insertOrUpdateCallback
    else
      Meteor.call "insertTransaction", tran, null, insertOrUpdateCallback

insertOrUpdateCallback = (error, result) ->
  if error?
    Session.set "Transaction_error", error.details
  else
    #ensures new transaction is displayed if recent
    Session.set "transactionsInBarChart", null
    Meteor.Router.to '/dashboard'

# Without this, it creates a date at 0 hours, 0 minutes,
# so it will immediately say your new donation was 18 hours ago,
# for example, which looks strange.
parseDateOrUseNowIfToday = (dateStr) ->
  if typeof dateStr == "string" and dateStr.length > 0
    date = moment(dateStr).toDate() #parse string as date
    now = new Date()
    if date.getDate() == now.getDate() and
        date.getMonth() == now.getMonth() and
         date.getYear() == now.getYear()
      return now
    else
      return date


Template.transaction.helpers
  shortDate: ->
    moment(this.date).format('L') if this and this.date
  selected: ->
    this._id == Template.transaction.Transaction()?.cause_id
