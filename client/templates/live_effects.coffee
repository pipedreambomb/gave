Template.live_effects.Effects = ->
  causeId = Session.get "selectedCause"
  amount = Session.get "currentTransactionAmount"
  if causeId and amount
    cause = gave.Causes.findOne causeId
    pairs = _.pairs cause.effects
    res = _.map pairs, (pair) ->
      if typeof amount == "string"
        amount = "error"
      else
        amount =  pair[1] * amount / cause.effectPer
      { description: pair[0], amount: amount }
