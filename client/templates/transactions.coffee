Template.transactions.UserHasTransactions = ->
  gave.Transactions.find().count() > 0

Template.transactions.UserHasAtLeast2Transactions = ->
  gave.Transactions.find().count() >= 2
