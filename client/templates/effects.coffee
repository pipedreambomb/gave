Template.effects.UserHasTransactions = ->
  gave.Transactions.find().count() > 0

Template.effects.Causes = ->
  gave.Causes.find().map (cause) ->
      totalDonated = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
      if totalDonated > 0
        _.extend cause,
          Effects: ->
            res = _.map this.effects, (effect) ->
              unit: effect.descr_plural
              totalEffects: (totalDonated / effect.perDollars).toFixed(2)
            # Biggest impacts first, makes users feel better!
            (_.sortBy res, "totalEffects").reverse()

Template.effects.helpers = Template.causes_summary.helpers

updateLineChart = ->
  el = $(".effects-line-chart").get(0)
  ctx = el?.getContext("2d")
  
  year = 2013

  effectsCollection = []

  gave.Causes.find().map (cause) ->
    debugger
    for effect in cause.effects
      do ->
        effects = effectsInRange cause._id, year, effect
        effectsCollection.push effects

  datasets = for effects in effectsCollection
    {
      fillColor : "rgba(220,220,220,0.5)",
      strokeColor : "rgba(220,220,220,1)",
      pointColor : "rgba(220,220,220,1)",
      pointStrokeColor : "#fff",
      data : effects
    }

  data = {
    labels : ["January","February","March","April"],
    datasets: datasets
  }

  new Chart(ctx).Line(data)

effectsInRange = (causeId, year, effect) ->
  perDollars = effect.perDollars
  runningTotal = effectsBeforeDate causeId, (new Date year, 0, 1), perDollars
  effectsPerMonth = for month in [0..3]
    do ->
      runningTotal += effectsInMonth causeId, year, month, perDollars

effectsBeforeDate = (causeId, date, perDollars) ->
  trans = gave.Transactions.find
    cause_id: causeId
    date:
      "$lt": date
  amount = gave.utils.sum trans, "amount"
  amount / perDollars

effectsInMonth = (causeId, year, month, perDollars) -> # Month 0-indexed so Jan=0, Dec=11
  monthStart = new Date year, month, 1
  monthEnd = new Date year, month + 1, 0
  trans = gave.Transactions.find
    cause_id: causeId
    date:
      "$gte": monthStart
      "$lte": monthEnd
  amount = gave.utils.sum trans, "amount"
  amount / perDollars

Template.effects.SelectNumberOfMonthsOptions = ->
  maxLimit = 12
  monthsAvailable = 3 # now minus earliest
  limit = if monthsAvailable < maxLimit then monthsAvailable else maxLimit
  selected = Session.get "monthsInLineChart"
  unless selected?
    Session.set "monthsInLineChart", limit
    selected = limit
  for i in [1..limit]
    do -> {numMonths: i, selected: i == selected}

Template.effects.events

  'change .months-to-show-select': (event) ->
    Session.set "monthsInLineChart", event.target.value
    updateLineChart()

Template.effects.rendered = -> updateLineChart()
