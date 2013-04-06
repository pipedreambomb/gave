Template.transactions.Transactions = ->
  gave.Transactions.find {}, { sort: {date: -1} }

Template.transactions.SubTotal = ->
  sum gave.Transactions.find(), "amount"

Template.transactions.helpers
  niceDate: ->
    moment(this.date).fromNow()
  cause: ->
    gave.Causes.findOne(@cause_id)?.name
