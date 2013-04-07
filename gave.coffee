@gave =
  Transactions: new Meteor.Collection("Transactions")
  Causes: new Meteor.Collection("Causes")

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

    gave.Transactions.insert
      cause_id: causeId1
      amount: 19
      date: (new Date 93, 12, 25)
      owner: 'ajr4emTdGGkP9iP9x' #my Facebook login Meteor.userId
      
    gave.Transactions.insert
      cause_id: causeId2
      amount: 6
      date: (new Date 2010, 2, 19)
      owner: 'ajr4emTdGGkP9iP9x'

    gave.Transactions.insert
      cause_id: causeId2
      amount: 94
      date: (new Date 2011, 7, 19)
      owner: 'ajr4emTdGGkP9iP9x'
 
@gave.Transactions.allow
  insert: (userId, tran) ->
    # the user must be logged in, and the transaction must be owned by the user
    userId and tran.owner == userId
       
  update: (userId, tran, fields, modifier) ->
    # can only change your own transactions
    tran.owner == userId and _.filter fields, ['date', 'amount', 'cause_id'] == []

  remove: (userId, tran) ->
    # can only remove your own transactions
    tran.owner == userId
   
  # Optional performance enhancement. Limits the fields that will be fetched 
  # from the database for inspection by your update and remove functions.
  fetch: ['owner']
