"use strict"

Donations = new Meteor.Collection("Donations")
Donations.removeAll = ->
  @remove({})

if Meteor.isClient

  Meteor.Router.add
    '/': 'home'
    '/tests': 'tests'
    '/add': 'donation'

  Template.donations.Donations = ->
    Donations.find()

  Template.donations.SubTotal = ->
    subtotal = 0
    Donations.find().forEach (d) ->
      subtotal += d.amount
    subtotal

  Template.donations.helpers
    niceDate: ->
      moment(this.date).fromNow()

  Template.donation.events 
    'click #doneBtn': (evt) ->
      evt.preventDefault()
      fm = document.forms["donation"]
      newDonation =
        charity: fm["charity"].value
        amount: fm["amount"].value
        date: fm["date"].value
      Donations.insert newDonation
      Meteor.Router.to '/'

if Meteor.isServer

        Meteor.startup ->

  Donations.removeAll()

  Donations.insert
    charity: "Oxfam"
    amount: 19
    date: (new Date 93, 12, 25)

  Donations.insert
    charity: 'JRS'
    amount: 94
    date: (new Date 2011, 7, 19)
