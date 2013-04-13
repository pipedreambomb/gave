Template.live_effects.Effects = ->
  causeId = Session.get "selectedCause"
  amount = Session.get "currentTransactionAmount"
  if causeId and amount
    cause = gave.Causes.findOne causeId
    pairs = _.pairs cause.effects
    res = _.map pairs, (pair) ->
      description: pair[0].toLowerCase()
      amount: pair[1] * amount / cause.effectPer
