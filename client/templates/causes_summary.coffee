Template.causes_summary.Causes = ->
  gave.Causes.find()

Template.causes_summary.SubTotal = ->
  gave.utils.sum gave.Transactions.find(), "amount"

Template.causes_summary.helpers
  total: ->
    gave.utils.sum gave.Transactions.find({ cause_id: this._id }), "amount"

Template.causes_summary.rendered = ->
  ctx = $(".causes-pie-chart").get(0).getContext("2d")
  colors = ["#F38630", "#E0E4CC", "#69D2E7"]
  data = gave.Causes.find().map (cause) ->
    total = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
    { value: total, color: colors.shift() }

  new Chart(ctx).Pie data
