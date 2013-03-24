Donations = new Meteor.Collection("Donations")
Donations.removeAll = ->
  @remove({})

if Meteor.isClient

  Template.donations.Donations = ->
    Donations.find()

  Template.donations.SubTotal = ->
    subtotal = 0
    Donations.find().forEach (d) ->
      subtotal += d.amount
    subtotal

if Meteor.isServer

	Meteor.startup ->

		Donations.removeAll()
		
		Donations.insert
			charity: "Oxfam"
			amount: 19
			date: "Wednesday 19th July 2011"
    
		Donations.insert
			charity: 'JRS'
			amount: 94
			date: 'Wednesday 19th July 2011'

