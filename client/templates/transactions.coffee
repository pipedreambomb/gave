Template.transactions.UserHasTransactions = ->
  gave.Transactions.find().count() > 0
