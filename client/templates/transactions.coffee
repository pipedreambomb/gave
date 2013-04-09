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

_.extend Template.transactions,
  
  Transactions: ->
    gave.Transactions.find {}, { sort: {date: -1} }

  SubTotal: ->
    gave.sum gave.Transactions.find(), "amount"

  created: ->
   
  events:
    'change .transactions-to-show-select': (event) ->
      Session.set "transactionsInBarChart", event.target.value
      updateBarChart()

    'click .tran-del': (event) ->
      event.preventDefault()
      id = $(event.target).attr("data-cause-id")
      Meteor.call "removeTransaction", id

  rendered: ->
    limit = (Session.get "transactionsInBarChart")
    $(".transactions-to-show-select").val(limit) if limit?
    updateBarChart()

Template.transactions.helpers
  niceDate: ->
    moment(this.date).fromNow()
  cause: ->
    gave.Causes.findOne(@cause_id)?.name
