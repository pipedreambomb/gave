Template.causes_info.helpers
  # Set the CSS class to 'selected' if this cause is selected
  selected: -> 'selected' if this._id == Session.get "selectedCause"

Template.causes_info.Causes = ->
  gave.Causes.find().map (cause) ->
    _.extend cause,
      Effects: ->
        pairs = _.pairs cause.effects
        res = _.map pairs, (pair) ->
          description: pair[0].toLowerCase()
          amount: pair[1]
          effectPer: cause.effectPer

Template.causes_info.events
  'click .select-cause': (event) ->
    event.preventDefault()
    Session.set "selectedCause", $(event.target).data().causeId
