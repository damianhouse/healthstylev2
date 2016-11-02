jQuery(document).on('turbolinks:load', function() {
  var messages, messages_to_bottom;
  messages = $('#messages');
  if ($('#messages').length > 0) {
    messages_to_bottom = function() {
      return messages.scrollTop(messages.prop('scrollHeight'));
    };
    messages_to_bottom();
    App.global_chat = App.cable.subscriptions.create({
      channel: "ConversationsChannel",
      conversation_id: messages.data('conversation-id'),
      current_user_id: messages.data('current-user-id')
    }, {
      connected: function(conversation_id, current_user_id) {
        return this.perform('update_read', {
          conversation_id: messages.data('conversation-id'),
          current_user_id: messages.data('current-user-id')
        });
      },
      disconnected: function() {},
      received: function(data) {
        console.log(JSON.stringify(data));
        const current_user_id = messages.data('current-user-id');
        if (data["messages"] !== undefined && data["messages"].constructor === Array) {
          updatedMessages = data["messages"];
          messagesUpdate(updatedMessages);
        } else if (data !== null) {
          message = data["message"];
          current_user_id: messages.data('current-user-id');
          messageAppend(message, current_user_id);
        };

        function messagesUpdate(updatedMessages) {
          updatedMessages.map(function (message) {
            if (message !== updatedMessages[updatedMessages.length - 1]) {
              $('.received').text("");
            } else {
                if (message.read === true && message.user_id === current_user_id) {
                  var date = new Date(message.updated_at);
                  var time = date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
                  $('#'+ message.id +'').text("Read "+ time);
                } else if (message.user_id === current_user_id) {
                  var date = new Date(message.updated_at);
                  var time = date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
                  $('#'+ message.id +'').text("Delivered "+ time);
                }
              }
              return;
          });
        }

        function checkReadStatus(message) {
          if (message.read === "true") {
            return "Read "
          } else {
            return "Delivered "
          }
        }

        function messageAppend(message, current_user_id) {
          console.log(message);
          message_user_id = message.user_id;
          date = new Date(message.updated_at);
          time = date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
          readStatus = checkReadStatus(message);
          current_user_message = '<div id="messages" class="msg send"><div id="message_body" class="msgtext">'+ message.body +'</div><div id="'+ message.id +'" class="time">'+ time +'</div></div>';
          other_user_message = '<div id="messages" class="msg receive"><div id="message_body" class="msgtext">'+ message.body +'</div><div id="'+ message.id +'" class="time ">'+ time +'</div></div>';
          if (current_user_id === message_user_id) {
            $("#messages").append(current_user_message);
          } else {
            $("#messages").append(other_user_message);
          }
          return messages_to_bottom();
        }

      },
      send_message: function(message, conversation_id, current_user_id) {
        return this.perform('send_message', {
          message: message,
          conversation_id: conversation_id,
          current_user_id: current_user_id
        });
      }
    });
    return $('#new_message').submit(function(e) {
      var $this, textarea;
      $this = $(this);
      textarea = $this.find('#message_body');
      if ($.trim(textarea.val()).length > 1) {
        App.global_chat.send_message(textarea.val(), messages.data('conversation-id'), messages.data('current-user-id'));
        textarea.val('');
      }
      e.preventDefault();
      return false;
    });
  }
});
