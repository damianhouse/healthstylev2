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
      connected: function() {},
      disconnected: function() {},
      received: function(data) {
        var message = data["message"];
        var current_user_id = messages.data('current-user-id');
        var message_user_id = message.user_id;
        console.log(current_user_id);
        console.log(message.body);
        console.log(message_user_id);
        current_user_message = '<div class="card"><div class="card-block"><div class="row"><div class="col-md-1"></div><div class="col-md-11"><p class="card-text"><span class="text-muted"> says</span><br>'+ message.body +'</p></div></div></div></div>';
        console.log(current_user_message);
        other_user_message = '<div class="card"><div class="card-block"><div class="row"><div class="col-md-11"><p class="card-text"><span class="text-muted"> says</span><br>'+ message.body +'</p></div><div class="col-md-1"></div></div></div></div>';
        if (current_user_id === message_user_id) {
          $("#messages").append(current_user_message);
        } else {
          $("#messages").append(other_user_message);
        }
        return messages_to_bottom();
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
