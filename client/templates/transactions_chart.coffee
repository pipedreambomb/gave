updateBarChart = ->
  ctx = $('.transactions-bar-chart').get(0).getContext("2d")
  labels = []
  dataset = []
  limit = (Session.get "transactionsInBarChart") ? 4
  limit = parseInt limit

  # Get latest transactions
  gave.Transactions.find({}, { limit: limit, sort: {date: -1} }).forEach (tran) ->
    formatted = (moment tran.date).format 'L'
    labels.push formatted
    dataset.push tran.amount

  # Reverse the order so in chronological order for chart
  data = {
    labels : labels.reverse()
    datasets : [
      fillColor : "rgba(220,220,220,0.5)"
      strokeColor : "rgba(220,220,220,1)"
      data : dataset.reverse()
    ]
  }
  new Chart(ctx).Bar data,
    scaleShowLabels: true
    scaleLabel: "$<%=value%>" # $<%=value%> would translate into $0, $10 etc

Template.transactions_chart.SelectNumberOfTransactionsOptions = ->
  BARS_MIN = 2 # 1 bar doesn't seem to display right, and is probably a bit useless
  BARS_MAX = 6 # Bar Chart is too small for much more than this
  
  totalTrans = gave.Transactions.find().count()
  limit = if totalTrans < BARS_MAX then totalTrans else BARS_MAX

  selected = Session.get "transactionsInBarChart"
  unless selected?
    Session.set "transactionsInBarChart", limit
    selected = limit
  for i in [BARS_MIN..limit]
    do -> {numTrans: i, selected: i == selected}

Template.transactions_chart.events

  'change .transactions-to-show-select': (event) ->
    Session.set "transactionsInBarChart", event.target.value
    updateBarChart()

Template.transactions_chart.rendered = ->

    limit = (Session.get "transactionsInBarChart")
    $(".transactions-to-show-select").val(limit) if limit?
    updateBarChart()
