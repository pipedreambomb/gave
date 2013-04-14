causes = [
    name: 'Against Malaria Foundation'
    website:'http://www.againstmalaria.com'
    description: 'AMF provides long-lasting insecticide-treated nets (for protection against malaria) in bulk to other organizations, which then distribute them in developing countries.'
    category: 'Health'
    effects: [
        descr_singular: "Life Saved"
        descr_plural: "Lives Saved"
        perDollars: 1865
        evidence: "http://www.thelifeyoucansave.com/organizations"
      ,
        descr_singular: "Net Distributed"
        descr_plural: "Nets Distributed"
        perDollars: 5.15
        evidence: "http://www.givewell.org/international/top-charities/AMF#CostperLLINdistributed"
    ]
  ,
    name: 'Give Direct'
    website: 'http://www.givedirectly.org'
    description: 'GiveDirectly transfers money directly to extremely poor households in Kenya. At least 90% of donations goes straight to the recipients, with less than 10% used to identify and track recipients and on transfer costs.'
    category: 'Development'
    effectPer: 100
    effects: [
        descr_singular: "Dollar Transferred"
        descr_plural: "Dollars Transferred"
        perDollars: 1.11
        evidence: "http://www.thelifeyoucansave.com/organization"
    ]
]

Meteor.startup ->
  # To trigger this, will currently need to use 'meteor mongo' shell
  # to empty out collection using 'db.Causes.remove({})'.
  # Still not sure how to get this to happen when deployed to meteor.com
  if 0 == gave.Causes.find().count()
    console.log("no data, populating")
    _.map causes, (cause) ->
      gave.Causes.insert cause
