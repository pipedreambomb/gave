Template.home.events
  'click #resetBtn': (evt) ->
    evt.preventDefault()
    removeAll = (collection) ->
      collection.find().forEach (i) ->
        collection.remove i._id
    removeAll(gave.Causes)
    removeAll(gave.Transactions)
    populateData()
    alert "Data is now reset"
  'click .tran-del': (evt) ->
    evt.preventDefault()
    id = evt.target.getAttribute("data-cause-id")
    bootbox.confirm "Are you sure you want to delete this transaction?", (confirmation) ->
      if confirmation
        gave.Transactions.remove { _id: id }
