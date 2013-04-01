"use strict"

# Add should function to our objects
# so we can assert stuff on them
should = chai.should()

describe 'Transactions', ->

  before ->
    @preSubTotal = Template.transactions.SubTotal()
    @realCauses = gave.Causes
    @realTransactions = gave.Transactions

    gave.Causes = new Meteor.Collection null
    gave.Transactions = new Meteor.Collection null
    @cause = gave.Causes.insert
      name: 'Test cause'
      area: 'Test'
    @transactions = []
    @transactions[0] = gave.Transactions.insert
      cause_id: @cause
      amount: 123
      date: (new Date 93, 12, 25)
    @transactions[1] = gave.Transactions.insert
      cause_id: @cause
      amount: 456.78
      date: (new Date 12, 12, 25)

  it 'should get fields of a transaction', ->
    tran = gave.Transactions.findOne @transactions[0]
    tran.cause_id.should.equal @cause
    tran.amount.should.equal 123
    tran.date.should.eql (new Date 93, 12, 25)

  it 'calculates subtotal correctly', ->
    subTotal = Template.transactions.SubTotal()
    subTotal.should.equal 579.78 # 123 + 456.78

  after ->
    gave.Transactions = @realTransactions
    gave.Causes = @realCauses
    Template.transactions.SubTotal().should.equal @preSubTotal
