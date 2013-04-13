Meteor.Router.add
  '/': 'home'
  '/about': 'about'
  '/dashboard': 'dashboard'
  '/tests': 'tests'
  '/transactions': 'transactions'
  '/add': ->
    Session.set "currentTransactionId", undefined
    'transaction'
  '/edit/:id': (id) ->
    Session.set "currentTransactionId", id
    'transaction'
