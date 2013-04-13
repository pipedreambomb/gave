Template.causes_info.Causes = ->
  gave.Causes.find().map (cause) ->
    _.extend cause,
      Effects: ->
        pairs = _(cause.effects).pairs()
        res = _.map pairs, (pair) ->
          description: pair[0].toLowerCase()
          amount: pair[1]
          effectPer: cause.effectPer
