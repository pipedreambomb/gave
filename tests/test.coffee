"use strict"

# Add should function to our objects
# so we can assert stuff on them
should = chai.should()

describe 'Transactions', ->

  before ->
    @charity = Charities.insert
      name: 'Test charity'
      area: 'Test'
    @transactions = []
    @transactions[0] = Transactions.insert
      charity_id: @charity
      amount: 123
      date: (new Date 93, 12, 25)
    @transactions[1] = Transactions.insert
      charity_id: @charity
      amount: 456.78
      date: (new Date 12, 12, 25)

  it 'should get fields of a transaction', ->
    tran = Transactions.findOne @transactions[0]
    tran.charity_id.should.equal @charity
    tran.amount.should.equal 123
    tran.date.should.eql (new Date 93, 12, 25)

  it 'calculates subtotal correctly', ->
    subTotal = Template.transactions.SubTotal()
    subTotal.should.equal 579.78 # 123 + 456.78
    
  after ->
    _.each @transactions, (tranId) ->
      Transactions.remove { _id: tranId }
      (Transactions.find { _id: tranId }).count().should.equal 0
    Charities.remove { _id: @charity }
