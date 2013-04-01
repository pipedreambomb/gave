"use strict"

gave =
  Transactions: new Meteor.Collection("Transactions")
  Causes: new Meteor.Collection("Causes")

if Meteor.isClient

  Meteor.Router.add
    '/': 'home'
    '/tests': 'tests'
    '/add': 'transaction'

  Template.transactions.Transactions = ->
    gave.Transactions.find()

  Template.transaction.Causes = ->
    gave.Causes.find()

  Template.transactions.SubTotal = ->
    subtotal = 0
    gave.Transactions.find().forEach (d) ->
      subtotal += parseFloat d.amount
    subtotal

  Template.transactions.helpers
    niceDate: ->
      moment(this.date)?.fromNow()
    charity: ->
      gave.Causes.findOne(@charity_id)?.name

  Template.home.events
    'click #resetBtn': (evt) ->
      evt.preventDefault()
      removeAll = (collection) ->
        collection.find().forEach (i) ->
          collection.remove i._id
      removeAll(gave.Causes)
      removeAll(gave.Transactions)
      populateData()
      alert "Data is now reset"

  Template.transaction.events
    'click #doneBtn': (evt) ->
      evt.preventDefault()
      fm = document.forms["transaction"]
      newTransaction =
        charity_id: fm["charity"].value
        amount: fm["amount"].value
        date: fm["date"].value
      gave.Transactions.insert newTransaction
      Meteor.Router.to '/'

if Meteor.isServer

  Meteor.startup ->

    if 0 == gave.Transactions.find().count() ==
        gave.Causes.find().count()
      populateData()

populateData = ->
  console.log("no data, populating")

  charityId1 = gave.Causes.insert
    name: 'Against Malaria Foundation'
    category: 'Health'
  charityId2 = gave.Causes.insert
    name: 'Give Direct'
    category: 'Development'

  gave.Transactions.insert
    charity_id: charityId1
    amount: 19
    date: (new Date 93, 12, 25)

  gave.Transactions.insert
    charity_id: charityId2
    amount: 94
    date: (new Date 2011, 7, 19)
