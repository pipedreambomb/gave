Template.effects.Causes = ->
  gave.Causes.find().map (cause) ->
    _.extend cause,
      Effects: ->
        totalDonated = sum gave.Transactions.find({ cause_id: this._id }), "amount"
        res = []
        self = this
        _.each this.effects, (val, key) ->
          res.push {unit: key, totalEffects: totalDonated * val / self.effectPer}
        res

Template.effects.helpers = Template.causes.helpers
