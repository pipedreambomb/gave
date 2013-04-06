Meteor.Router.add
  '/': 'home'
  '/tests': 'tests'
  '/transactions': 'transactions'
  '/add': ->
    Session.set "currentTransactionId", undefined
    'transaction'
  '/edit/:id': (id) ->
    Session.set "currentTransactionId", id
    'transaction'
