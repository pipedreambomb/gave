@gave =
  Transactions: new Meteor.Collection("Transactions")
  Causes: new Meteor.Collection("Causes")

  utils:
    parsesToNumber: (n) ->
      !isNaN(parseFloat(n)) && isFinite(n)
      
    sum: (collectionIterator, property) ->
      total = 0
      collectionIterator.forEach (i) ->
        total += parseFloat i[property]
      total

    populateData: ->
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
