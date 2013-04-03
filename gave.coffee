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

  Template.transactions.SubTotal = ->
    subtotal = 0
    gave.Transactions.find().forEach (d) ->
      subtotal += parseFloat d.amount
    subtotal

  Template.transactions.helpers
    niceDate: ->
      moment(this.date)?.fromNow()
    cause: ->
      gave.Causes.findOne(@cause_id)?.name

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

  Template.transaction.Causes = ->
    gave.Causes.find()

  Template.transaction.events
    'click #doneBtn': (evt) ->
      evt.preventDefault()
      fm = document.forms["transaction"]
      newTransaction =
        cause_id: fm["cause"].value
        amount: fm["amount"].value
        date: fm["date"].value
      gave.Transactions.insert newTransaction
      Meteor.Router.to '/'

  Template.causes.Causes = ->
    gave.Causes.find()

  Template.causes.helpers
    total: ->
      total = 0
      trans = gave.Transactions.find({ cause_id: this._id }).forEach (tran) ->
        total += parseFloat tran.amount
      total

  Template.causes.SubTotal = ->
    subtotal = 0
    gave.Transactions.find().forEach (d) ->
      subtotal += parseFloat d.amount
    subtotal

  Template.effects.helpers
    total: ->
      total = 0
      trans = gave.Transactions.find({ cause_id: this._id }).forEach (tran) ->
        total += parseFloat tran.amount
      total

  Template.effects.Causes = ->
    gave.Causes.find().map (cause) ->
      _.extend cause,
        Effects: ->
          totalDonated = 0
          trans = gave.Transactions.find({ cause_id: this._id }).forEach (tran) ->
            totalDonated += parseFloat tran.amount
          res = []
          per = this.effectPer
          _.each this.effects, (val, key) ->
            debugger
            res.push {unit: key, totalEffects: totalDonated * val / per}
          res

  Template.effects.helpers = Template.causes.helpers

if Meteor.isServer

  Meteor.startup ->

    if 0 == gave.Transactions.find().count() ==
        gave.Causes.find().count()
      populateData()

populateData = ->
  console.log("no data, populating")

  causeId1 = gave.Causes.insert
    name: 'Against Malaria Foundation'
    category: 'Health'
    effectPer: 100
    effects:
      "Lives saved": 5
      "Tests run": 20
  causeId2 = gave.Causes.insert
    name: 'Give Direct'
    category: 'Development'
    effectPer: 100
    effects:
      "Lives saved": 1
      "Tests run": 2

  gave.Transactions.insert
    cause_id: causeId1
    amount: 19
    date: (new Date 93, 12, 25)

  gave.Transactions.insert
    cause_id: causeId2
    amount: 6
    date: (new Date 2010, 2, 19)

  gave.Transactions.insert
    cause_id: causeId2
    amount: 94
    date: (new Date 2011, 7, 19)
