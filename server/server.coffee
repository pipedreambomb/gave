Meteor.startup ->

  if 0 == gave.Transactions.find().count() ==
      gave.Causes.find().count()
    gave.populateData()

Meteor.publish "my-transactions", ->
  gave.Transactions.find({owner: this.userId}) if this.userId?

Meteor.publish "all-causes", ->
  gave.Causes.find()

Meteor.methods
  insertTransaction: (tran, causeIds) ->
    if validateTransaction tran, causeIds
      gave.Transactions.insert tran

  updateTransaction: (tranId, mongoCode) ->
    gave.Transactions.update tran, mongoCode

  removeTransaction: (tranId) ->
    gave.Transactions.remove tranId

validateTransaction = (tran, causeIds) ->
  # This bit is to allow validation against a list of cause_ids,
  # as cannot dependency inject a whole collection over EJSON.
  # Otherwise, it validates against the wrong (server's) collection,
  # and never finds the cause_id it's looking for.
  matchingCause = false
  if tran.cause_id?
    if causeIds?
      matchingCause = _.contains causeIds, tran.cause_id
      console.log "cause matched: " + matchingCause
    else
      matchingCause = gave.Causes.find({_id: tran.cause_id}).count() > 0

  unless tran.amount and typeof tran.amount == "number"
    throw new Meteor.Error 400, "Transaction Invalid", "Amount is not present or NaN"
  unless tran.date and tran.date instanceof Date
    throw new Meteor.Error 400, "Transaction Invalid", "Date is not present or not a Date"
  unless tran.cause_id and matchingCause
    throw new Meteor.Error 404, "Transaction Invalid", "Cause not found"
  unless tran.owner and Meteor.userId == tran.owner
    throw new Meteor.Error 400, "Transaction Invalid", "Owner id does not match logged-in user"

  # Transaction is valid
  true
