Template.causes_info.helpers
  # Set the CSS class to 'selected' if this cause is selected
  selected: -> 'selected' if this._id == Session.get "selectedCause"

Template.causes_info.Causes = ->
  causes = gave.Causes.find {}, {sort: {name: 1}}

Template.causes_info.helpers
  # Ascending by cost, so most affordable shown first in list
  sorted_effects: -> _.sortBy this.effects, "perDollars"

Template.causes_info.events
  'click .select-cause': (event) ->
    event.preventDefault()
    Session.set "selectedCause", $(event.target).data().causeId
