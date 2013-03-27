# Add should function to our variables
# so we can assert stuff on them
should = chai.should()

describe 'Donations', ->

  before ->
    @donations = []
    @donations[0] = Donations.insert
      charity: "test123"
      amount: 123
      date: "25th December 1993"
    @donations[1] = Donations.insert
      charity: "test456"
      amount: 456
      date: "25th December 2012"

  it 'should get fields of a donation', ->
    don = Donations.findOne @donations[0]
    don.charity.should.equal "test123"
    don.amount.should.equal 123
    don.date.should.equal "25th December 1993"

  it 'calculates subtotal correctly', ->
    subTotal = Template.donations.SubTotal()
    subTotal.should.equal 579 # 123 + 456
    
  after ->
    _.each @donations, (donId) ->
      Donations.remove { _id: donId }
      (Donations.find { _id: donId }).count().should.equal 0
