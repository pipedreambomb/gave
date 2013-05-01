Meteor.startup ->
  Meteor.autorun ->
    title = Session.get("pageTitle") || "Loading"
    document.title = title + " - Giving Counts"

Meteor.Router.filters
  'logOutDemoUser': (page) ->
    if Meteor.user()?.username == "Demo_User"
      Meteor.logout()
    gave.utils.resetLoginBox()
    page
  'checkLoggedIn': (page) ->
    if Meteor.loggingIn() then 'loading'
    else if Meteor.user() then page
    else 'home'

Meteor.Router.filter 'logOutDemoUser', {only: ['home', 'faq', 'signup']}
Meteor.Router.filter 'checkLoggedIn', {except: ['home', 'faq', 'signup', 'tests']}

Meteor.Router.add
  '/': ->
    Session.set "pageTitle", "Home"
    'home'
  '/faq': ->
    Session.set "pageTitle", "FAQ"
    'faq'
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
    gave.utils.resetLoginBox()
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
