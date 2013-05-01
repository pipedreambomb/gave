Meteor.publish "my-transactions", ->
  gave.Transactions.find({owner: this.userId}) if this.userId?

Meteor.publish "all-causes", ->
  gave.Causes.find()

Meteor.methods
  insertTransaction: (tran, causeIds) ->
    if validateTransaction tran, causeIds, false
      gave.Transactions.insert tran

  updateTransaction: (tran, causeIds) ->
    if tran.owner != Meteor.userId()
      throw new Meteor.Error 403, "Forbidden", "Cannot change another user's transactions"
    if validateTransaction tran, causeIds, true
      tranId = tran._id
      # Don't want to update _id or owner
      delete tran._id
      delete tran.owner
      mongoModifier = {$set: tran}
      gave.Transactions.update tranId, mongoModifier
      # Return updated Transaction
      gave.Transactions.findOne tranId

  removeTransaction: (tranId) ->
    tran = gave.Transactions.findOne tranId
    if tran.owner != Meteor.userId()
      throw new Meteor.Error 403, "Forbidden", "Cannot remove another user's transactions"
    gave.Transactions.remove tranId
    # Return confirmation
    "Transaction removed"

  removeAllTransactions: ->
    userId = Meteor.userId()
    count = gave.Transactions.find({owner: userId}).count()
    gave.Transactions.remove {owner: userId}
    "Removed " + count

validateTransaction = (tran, causeIds, isUpdate) ->
  # This bit is to allow validation against a list of cause_ids,
  # as cannot dependency inject a whole collection over EJSON.
  # Otherwise, it validates against the wrong (server's) collection,
  # and never finds the cause_id it's looking for.
  matchingCause = false
  if tran.cause_id?
    if causeIds?
      matchingCause = _.contains causeIds, tran.cause_id
    else
      matchingCause = gave.Causes.find({_id: tran.cause_id}).count() > 0

  if Meteor.userId() == null
    throw new Meteor.Error 403, "No User", "User is not logged in"
  unless tran.amount? and typeof tran.amount == "number"
    throw new Meteor.Error 400, "Transaction Invalid", "Amount not entered or not a number."
  unless tran.amount? and tran.amount > 0
    throw new Meteor.Error 400, "Transaction Invalid", "Amount must be greater than 0."
  unless tran.date and tran.date instanceof Date
    throw new Meteor.Error 400, "Transaction Invalid", "Date is not present or not a Date."
  unless tran.cause_id and matchingCause
    throw new Meteor.Error 404, "Transaction Invalid", "You must select a cause."
  unless tran.owner and Meteor.userId() == tran.owner
    throw new Meteor.Error 400, "Transaction Invalid", "Owner id does not match logged-in user."

  # Transaction is valid
  true
