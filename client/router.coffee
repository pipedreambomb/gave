Meteor.startup ->
  Meteor.autorun ->
    document.title = Session.get("pageTitle") + " - Giving Counts"

Meteor.Router.filters
  'checkLoggedIn': (page) ->
    if Meteor.loggingIn() then 'loading'
    else if Meteor.user() then page
    else 'home'

Meteor.Router.filter 'checkLoggedIn', {except: ['home', 'about', 'signup']}

Meteor.Router.add
  '/': ->
    Session.set "pageTitle", "Home"
    'home'
  '/about': ->
    Session.set "pageTitle", "About"
    'about'
  '/signup': ->
    Session.set "pageTitle", "Sign Up"
    'signup'
  '/dashboard': ->
    Session.set "pageTitle", "My Dashboard"
    'dashboard'
  '/demo': ->
    Session.set "pageTitle", "My Dashboard"
    unless Meteor.userId()?
      Meteor.loginWithPassword "Demo_User", "demo123"
    'dashboard'
  '/tests': 'tests'
  '/add': ->
    Session.set "currentTransactionId", undefined
    Session.set "currentTransactionAmount", undefined
    Session.set "selectedCause", undefined
    Session.set "pageTitle", "Add New Donation"
    'transaction'
  '/edit': 'home'
  '/edit/:id': (id) ->
    Session.set "currentTransactionId", id
    tran = gave.Transactions.findOne id
    if tran
      Session.set "currentTransactionAmount", tran.amount
      Session.set "selectedCause", tran.cause_id
      Session.set "pageTitle", "Edit Donation"
    'transaction'
