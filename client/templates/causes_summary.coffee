Template.causes_summary.UserHasTransactions = ->
  gave.Transactions.find().count() > 0

Template.causes_summary.Causes = ->
  debugger
  okCauses = []
  gave.Causes.find().map (cause) ->
    totalDonated = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
    if totalDonated > 0
      okCauses.push {cause: cause, total: totalDonated}
  sorted = (_.sortBy okCauses, "total").reverse() # can't specify sort descending
  _.pluck sorted, "cause"

Template.causes_summary.SubTotal = ->
  subtotal = gave.utils.sum gave.Transactions.find(), "amount"
  subtotal.toFixed(2)

Template.causes_summary.helpers
  total: -> 
    total = gave.utils.sum gave.Transactions.find({ cause_id: this._id }), "amount"
    total.toFixed(2)

Template.causes_summary.rendered = ->
  el = $(".causes-pie-chart").get(0)
  if el
    ctx = el.getContext("2d")
    colors = ["#F38630", "#E0E4CC", "#69D2E7"]
    data = gave.Causes.find().map (cause) ->
      total = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
      { value: total, color: colors.shift() }

    new Chart(ctx).Pie data
