App.chatroom = App.cable.subscriptions.create "ChatroomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').append data['message']
    $('#message_content').val ''
    scrollToBottom()
    return
    
  jQuery(document).on 'turbolinks:load', ->
    scrollToBottom()
    return
    
  scrollToBottom = ->
    if $('#messages').length > 0
      last_message = $('#messages')[0]
      last_message.scrollTop = last_message.scrollHeight - 
                                          (last_message.clientHeight)
    return