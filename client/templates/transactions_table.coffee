_.extend Template.transactions_table,
  
  Transactions: ->
    gave.Transactions.find {}, { sort: {date: -1} }

  SubTotal: ->
    subtotal = gave.utils.sum gave.Transactions.find(), "amount"
    # Display with two decimal places, e.g. 4.00
    subtotal.toFixed(2)

  events:

    'click .tran-del': (event) ->
      event.preventDefault()
      id = $(event.target).attr("data-cause-id")
      bootbox.confirm "Are you sure you want to remove this transaction?", (confirmation) ->
        Meteor.call "removeTransaction", id if confirmation

Template.transactions_table.helpers
  niceDate: ->
    moment(this.date).fromNow()
  cause: ->
    gave.Causes.findOne(@cause_id)?.name
  # Amount with 2 decimal places, usual for money.
  amount2dp: ->
    this.amount.toFixed(2)
