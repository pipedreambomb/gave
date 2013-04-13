Meteor.Router.add
  '/': 'home'
  '/about': 'about'
  '/dashboard': 'dashboard'
  '/tests': 'tests'
  '/transactions': 'transactions'
  '/add': ->
    Session.set "currentTransactionId", undefined
    Session.set "currentTransactionAmount", undefined
    Session.set "selectedCause", undefined
    'transaction'
  '/edit/:id': (id) ->
    Session.set "currentTransactionId", id
    tran = gave.Transactions.findOne id
    if tran
      Session.set "currentTransactionAmount", tran.amount
      Session.set "selectedCause", tran.cause_id
    'transaction'
