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
  
  labels = generateChartLabels()
  effectsCollection = findAllEffectsInUserSelectedRange()

  datasets = for effects in effectsCollection
    {
      fillColor : "rgba(220,220,220,0.5)",
      strokeColor : "rgba(220,220,220,1)",
      pointColor : "rgba(220,220,220,1)",
      pointStrokeColor : "#fff",
      data : effects
    }

  data = {
    labels: labels
    datasets: datasets
  }

  new Chart(ctx).Line(data)

generateChartLabels = ->

  numMonths = Session.get 'monthsInLineChart'
  currentMonth = moment().subtract 'months', numMonths
  monthNames = [ "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December" ]
  for [0..numMonths]
    monthName = monthNames[currentMonth.month()]
    currentMonth.add 'months', 1
    monthName

findAllEffectsInUserSelectedRange = ->
  res = []

  gave.Causes.find().map (cause) ->
   for effect in cause.effects
      do ->
        effects = effectsInUserSelectedRange cause._id, effect
        res.push effects
  res

effectsInUserSelectedRange = (causeId, effect) ->
  
  res = []
  monthsSelected = Session.get "monthsInLineChart"
  # Start from the first month in the range
  m = moment().subtract 'months', monthsSelected
  # Get the running total to include all the transactions before the range
  runningTotal = effectsBeforeDate causeId, m.toDate(), effect.perDollars
  for i in [0..monthsSelected]
    runningTotal += effectsInMonth causeId, m.year(), m.month(), effect.perDollars
    m.add 'months', 1
    res.push runningTotal
  res

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
  monthsAvailable = findMonthsSinceFirstTransaction()
  limit = if monthsAvailable < maxLimit then monthsAvailable else maxLimit
  selected = Session.get "monthsInLineChart"
  unless selected?
    Session.set "monthsInLineChart", limit
    selected = limit
  for i in [1..limit]
    do -> {numMonths: i, selected: i == selected}

findMonthsSinceFirstTransaction = ->
  firstTran = gave.Transactions.findOne {}, { sort: {date: 1} }
  # compares a new Moment (i.e. now) to date in question, with months as unit
  moment().diff firstTran.date, 'months'

Template.effects.events

  'change .months-to-show-select': (event) ->
    Session.set "monthsInLineChart", event.target.value
    updateLineChart()

Template.effects.rendered = -> updateLineChart() if Template.effects.UserHasTransactions()
