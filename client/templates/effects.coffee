Template.effects.UserHasTransactions = ->
  gave.Transactions.find().count() > 0

Template.effects.Causes = ->
  gave.Causes.find().map (cause) ->
      totalDonated = gave.utils.sum gave.Transactions.find({ cause_id: cause._id }), "amount"
      if totalDonated > 0
        _.extend cause,
          Effects: ->
            res = _.map this.effects, (effect) ->
              unit: effect.descr_plural
              totalEffects: (totalDonated / effect.perDollars).toFixed(2)
            # Biggest impacts first, makes users feel better!
            (_.sortBy res, "totalEffects").reverse()

Template.effects.helpers = Template.causes_summary.helpers
