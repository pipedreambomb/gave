@gave =
  Transactions: new Meteor.Collection("Transactions")
  Causes: new Meteor.Collection("Causes")

  utils:
    # From http://stackoverflow.com/questions/18082
    #     /validate-numbers-in-javascript-isnumeric
    parsesToNumber: (n) ->
      !isNaN(parseFloat(n)) && isFinite(n)
      
    sum: (collectionIterator, property) ->
      total = 0
      collectionIterator.forEach (i) ->
        total += parseFloat i[property]
      total
    resetLoginBox: ->
      Accounts._loginButtonsSession.set('dropdownVisible', false)
      Accounts._loginButtonsSession.set('inSignupFlow', false)
      Accounts._loginButtonsSession.set('inForgotPasswordFlow', false)
