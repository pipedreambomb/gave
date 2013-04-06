Template.causes.Causes = ->
  gave.Causes.find()

Template.causes.SubTotal = ->
  sum gave.Transactions.find(), "amount"

Template.causes.helpers
  total: ->
    sum gave.Transactions.find({ cause_id: this._id }), "amount"

Template.causes.rendered = ->
  ctx = $(".causes-pie-chart").get(0).getContext("2d")
  colors = ["#F38630", "#E0E4CC", "#69D2E7"]
  data = gave.Causes.find().map (cause) ->
    total = sum gave.Transactions.find({ cause_id: cause._id }), "amount"
    { value: total, color: colors.shift() }

  myNewChart = new Chart(ctx).Pie data
