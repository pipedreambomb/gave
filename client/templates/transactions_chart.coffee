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
      { fillColor : "rgba(220,220,220,0.5)", strokeColor : "rgba(220,220,220,1)", data : dataset.reverse() }
    ]
  }
  new Chart(ctx).Bar data

Template.transactions_chart.events

  'change .transactions-to-show-select': (event) ->
    Session.set "transactionsInBarChart", event.target.value
    updateBarChart()

Template.transactions_chart.rendered = ->

    limit = (Session.get "transactionsInBarChart")
    $(".transactions-to-show-select").val(limit) if limit?
    updateBarChart()
