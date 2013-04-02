"use strict"

# Add should function to our objects
# so we can assert stuff on them
should = chai.should()

insertFixtures = ->

  @causes = []
  @causes[0] = gave.Causes.insert
    name: 'Test cause'
    area: 'Test'
  @causes[1] = gave.Causes.insert
    name: 'Test cause 2'
    area: 'Test'
  @transactions = []
  @transactions[0] = gave.Transactions.insert
    cause_id: @causes[0]
    amount: 123
    date: (new Date 93, 12, 25)
  @transactions[1] = gave.Transactions.insert
    cause_id: @causes[0]
    amount: 456.78
    date: (new Date 12, 12, 25)
  @transactions[2] = gave.Transactions.insert
    cause_id: @causes[1]
    amount: 1000.00
    date: (new Date 2013, 1, 5)

describe 'Giving Counts', ->

  before ->
    @preSubTotal = Template.transactions.SubTotal()
    @realCauses = gave.Causes
    @realTransactions = gave.Transactions

    gave.Causes = new Meteor.Collection null
    gave.Transactions = new Meteor.Collection null

    insertFixtures.apply(this)

  describe 'Transactions', ->

    it 'should get fields of a transaction', ->
      tran = gave.Transactions.findOne @transactions[0]
      tran.cause_id.should.equal @causes[0]
      tran.amount.should.equal 123
      tran.date.should.eql (new Date 93, 12, 25)

    it 'calculates subtotal correctly', ->
      subTotal = Template.transactions.SubTotal()
      subTotal.should.equal 1579.78 # 123 + 456.78 + 1000

    it 'displays name of charity', ->
      frag = Meteor.render Template.transactions
      (frag.querySelector "td").innerHTML.should.have.string "Test cause"

  describe 'Causes', ->

    it 'calculates totals per cause', ->

      frag = Meteor.render Template.causes
      tds = frag.querySelectorAll "td"
      tds[0].innerHTML.should.have.string "Test cause"
      tds[1].innerHTML.should.have.string "579.78"
      tds[2].innerHTML.should.have.string "Test cause 2"
      tds[3].innerHTML.should.have.string "1000"
      tds[4].innerHTML.should.have.string "Total: $1579.78"

  after ->
    gave.Transactions = @realTransactions
    gave.Causes = @realCauses
    Template.transactions.SubTotal().should.equal @preSubTotal
