Template.causes_summary.Causes = ->
  okIds = []
  gave.Causes.find().map (cause) ->
    totalDonated = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
    if totalDonated > 0
      okIds.push cause._id
  # Return cursor
  gave.Causes.find {_id: {$in: okIds}}

Template.causes_summary.SubTotal = ->
  subtotal = gave.utils.sum gave.Transactions.find(), "amount"
  subtotal.toFixed(2)

Template.causes_summary.helpers
  total: -> 
    total = gave.utils.sum gave.Transactions.find({ cause_id: this._id }), "amount"
    total.toFixed(2)

Template.causes_summary.rendered = ->
  ctx = $(".causes-pie-chart").get(0).getContext("2d")
  colors = ["#F38630", "#E0E4CC", "#69D2E7"]
  data = gave.Causes.find().map (cause) ->
    total = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
    { value: total, color: colors.shift() }

  new Chart(ctx).Pie data
