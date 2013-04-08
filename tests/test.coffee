"use strict"

# Add should function to our objects
# so we can assert stuff on them
should = chai.should()

insertFixtures = ->

  @causeIds = []
  @causeIds[0] = gave.Causes.insert
    name: 'Test cause'
    area: 'Test'
    effectPer: 100
    effects:
      "Lives saved": 5
      "Tests run": 20
  @causeIds[1] = gave.Causes.insert
    name: 'Test cause 2'
    area: 'Test'
    effectPer: 100
    effects:
      "Lives saved": 1
      "Tests run": 2
  @transactions = []
  @transactions[0] = gave.Transactions.insert
    cause_id: @causeIds[0]
    amount: 123
    date: (new Date 93, 12, 25)
  @transactions[1] = gave.Transactions.insert
    cause_id: @causeIds[0]
    amount: 456.78
    date: (new Date 12, 12, 25)
  @transactions[2] = gave.Transactions.insert
    cause_id: @causeIds[1]
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
      tran.cause_id.should.equal @causeIds[0]
      tran.amount.should.equal 123
      tran.date.should.eql (new Date 93, 12, 25)

    it 'calculates subtotal correctly', ->
      subTotal = Template.transactions.SubTotal()
      subTotal.should.equal 1579.78 # 123 + 456.78 + 1000

    it 'displays name of charity', ->
      frag = Meteor.render Template.transactions
      (frag.querySelector "td").innerHTML.should.have.string "Test cause"
      
    it 'updates transactions'

  describe 'Transaction validation', ->

    insertTransaction = (tran, callback) ->
      Meteor.call "insertTransaction", tran, @causeIds, callback

    insertAndExpectError = (badTrans, presentInDetails, done) ->
      insertTransaction.call this, badTrans, (error, result) ->
        should.exist error
        error.details.should.contain presentInDetails
        done()

    it 'inserts a new transaction', ->
      goodTrans =
        amount: 10
        cause_id: @causeIds[0]
        date: new Date()
        owner: Meteor.userId()
      insertTransaction.call this, goodTrans, (error, result) ->
        should.exist result
        result.should.be.a 'string'
        done()

    it 'requires amount in new transaction', (done) ->

      badTrans =
        cause_id: @causeIds[0]
        date: new Date()
        owner: Meteor.userId()
      insertAndExpectError.call this, badTrans, "Amount", done

    it 'requires cause_id in new transaction', (done) ->

      badTrans =
        amount: 10
        date: new Date()
        owner: Meteor.userId()
      insertAndExpectError.call this, badTrans, "Cause", done

    it 'requires date in new transaction', (done) ->

      badTrans =
        amount: 10
        cause_id: @causeIds[0]
        owner: Meteor.userId()
      insertAndExpectError.call this, badTrans, "Date", done

    it 'requires owner in new transaction', (done) ->

      badTrans =
        amount: 10
        date: new Date()
        cause_id: @causeIds[0]
      insertAndExpectError.call this, badTrans, "Owner", done

    it 'accepts only numeric amounts', (done) ->
      badTrans =
        amount: "jr92ede2"
        cause_id: @causeIds[0]
        date: new Date()
        ownerId: Meteor.userId
      insertTransaction.call this, badTrans, (error, result) ->
        should.exist error
        error.details.should.contain "NaN"
        done()

    it 'requires cause_id refers to a real Cause', (done) ->
      badTrans =
        amount: 10
        cause_id: "invalid cause id"
        date: new Date()
        ownerId: Meteor.userId
      insertTransaction.call this, badTrans, (error, result) ->
        should.exist error
        error.error.should.equal 404
        error.details.should.contain "Cause"
        done()

    it 'requires owner is logged-in user', (done) ->
      badTrans =
        amount: 10
        cause_id: @causeIds[0]
        date: new Date()
        ownerId: "invalid owner id"
      insertTransaction.call this, badTrans, (error, result) ->
        should.exist error
        error.error.should.equal 400
        error.details.should.contain "Owner"
        done()

  describe 'Causes', ->

    it 'calculates totals per cause', ->

      frag = Meteor.render Template.causes
      tds = frag.querySelectorAll "td"
      tds[0].innerHTML.should.have.string "Test cause"
      tds[1].innerHTML.should.have.string "579.78"
      tds[2].innerHTML.should.have.string "Test cause 2"
      tds[3].innerHTML.should.have.string "1000"
      tds[4].innerHTML.should.have.string "Total: $1579.78"

    it 'calculates effects', ->
      frag = Meteor.render Template.effects
      uls = frag.querySelectorAll "ul"
      lis = uls[1].querySelectorAll "li" # use second cause as math is easier
      lis[0].innerHTML.should.have.string "Lives saved: 10"
      lis[1].innerHTML.should.have.string "Tests run: 20"

  after ->
    gave.Transactions = @realTransactions
    gave.Causes = @realCauses
    Template.transactions.SubTotal().should.equal @preSubTotal
