"use strict"

gave =
  Transactions: new Meteor.Collection("Transactions")
  Causes: new Meteor.Collection("Causes")

sum = (collectionIterator, property) ->
    total = 0
    collectionIterator.forEach (i) ->
      total += parseFloat i[property]
    total

if Meteor.isClient

  Meteor.Router.add
    '/': 'home'
    '/tests': 'tests'
    '/add': ->
      Session.set "currentTransactionId", undefined
      'transaction'
    '/edit/:id': (id) ->
      Session.set "currentTransactionId", id
      'transaction'

  Template.transactions.Transactions = ->
    gave.Transactions.find()

  Template.transactions.SubTotal = ->
    sum gave.Transactions.find(), "amount"

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
    'click .tran-del': (evt) ->
      evt.preventDefault()
      id = evt.target.getAttribute("data-cause-id")
      bootbox.confirm "Are you sure you want to delete this transaction?", (confirmation) ->
        if confirmation
          gave.Transactions.remove { _id: id }

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
      id = Session.get "currentTransactionId"
      if id
        gave.Transactions.update { _id: id }, { $set: newTransaction }
      else
        gave.Transactions.insert newTransaction
      Meteor.Router.to '/'

  Template.transaction.rendered = ->
    $('.datepicker').datepicker()

  Template.transaction.Transaction = ->
    id = Session.get "currentTransactionId"
    gave.Transactions.findOne { _id: id } if id

  Template.causes.Causes = ->
    gave.Causes.find()

  Template.causes.helpers
    total: ->
      sum gave.Transactions.find({ cause_id: this._id }), "amount"

  Template.causes.SubTotal = ->
    sum gave.Transactions.find(), "amount"

  Template.effects.Causes = ->
    gave.Causes.find().map (cause) ->
      _.extend cause,
        Effects: ->
          totalDonated = sum gave.Transactions.find({ cause_id: this._id }), "amount"
          res = []
          self = this
          _.each this.effects, (val, key) ->
            res.push {unit: key, totalEffects: totalDonated * val / self.effectPer}
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
