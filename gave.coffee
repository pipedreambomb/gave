"use strict"

Transactions = new Meteor.Collection("Transactions")
Charities = new Meteor.Collection("Charities")

if Meteor.isClient

  Meteor.Router.add
    '/': 'home'
    '/tests': 'tests'
    '/add': 'transaction'

  Template.transactions.Transactions = ->
    Transactions.find()

  Template.transaction.Charities = ->
    Charities.find()

  Template.transactions.SubTotal = ->
    subtotal = 0
    Transactions.find().forEach (d) ->
      subtotal += parseFloat d.amount
    subtotal

  Template.transactions.helpers
    niceDate: ->
      moment(this.date)?.fromNow()
    charity: ->
      Charities.findOne(@charity_id)?.name

  Template.home.events
    'click #resetBtn': (evt) ->
      evt.preventDefault()
      removeAll = (collection) ->
        collection.find().forEach (i) ->
          collection.remove i._id
      removeAll(Charities)
      removeAll(Transactions)
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
      Transactions.insert newTransaction
      Meteor.Router.to '/'

if Meteor.isServer

  Meteor.startup ->

    if 0 == Transactions.find().count() ==
        Charities.find().count()
      populateData()

populateData = ->
  console.log("no data, populating")

  charityId1 = Charities.insert
    name: 'Against Malaria Foundation'
    category: 'Health'
  charityId2 = Charities.insert
    name: 'Give Direct'
    category: 'Development'

  Transactions.insert
    charity_id: charityId1
    amount: 19
    date: (new Date 93, 12, 25)

  Transactions.insert
    charity_id: charityId2
    amount: 94
    date: (new Date 2011, 7, 19)
