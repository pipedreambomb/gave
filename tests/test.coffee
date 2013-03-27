# Add should function to our variables
# so we can assert stuff on them
should = chai.should()

describe 'Donations', ->

  beforeEach ->
    @donId = Donations.insert
      charity: "test123"
      amount: 123
      date: "25th December 1993"

  it 'should get fields of a donation', ->
    don = Donations.findOne @donId
    don.charity.should.equal "test123"
    don.amount.should.equal 123
    don.date.should.equal "25th December 1993"
  
  afterEach ->
    Donations.remove { _id: @donId }
    don = Donations.findOne @donId
    chai.assert.isUndefined don
