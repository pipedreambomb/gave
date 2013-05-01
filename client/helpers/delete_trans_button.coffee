Template.delete_trans_button.UserIsDemoUser = -> gave.utils.userIsDemoUser()
Template.delete_trans_button.events
  'click #delete_transactions': ->
    bootbox.confirm "Are you sure you want to remove all donations?", (confirmation) ->
      Meteor.call "removeAllTransactions" if confirmation
