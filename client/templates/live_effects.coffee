Template.live_effects.Effects = ->
  res = [{}]
  causeId = Session.get "selectedCause"
  tranAmount = Session.get "currentTransactionAmount"
  if !causeId
    res[0].nocause = true
  else if !tranAmount
    res[0].noamount = true
  else
    cause = gave.Causes.findOne causeId
    if cause
      res = _.map cause.effects, (effect) ->
        description: effect.descr_plural
        amount: tranAmount / effect.perDollars
  res

Template.live_effects.helpers
  # 2 decimal places
  amount_2dp: -> this.amount.toFixed(2)
