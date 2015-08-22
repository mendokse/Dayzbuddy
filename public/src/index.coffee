require 'roles'
jQuery ($) ->
  socket = io.connect()
  $nickForm = $('#setNick')
  $nickError = $('#nickError')
  $nickBox = $('#nickname')
  $chatForm = $('#SubmitMessage')
  $messageBox = $('#message')
  $users = $('#users')
  $chat = $('#chatWrap')
  $loader = $('#loadWrap')
  $chatWrap = $('#contentWrap')

  # Sanitize user input
  # (function($) {
  #  $.sanitize = function(input) {
  #     var SubmitMessage = input.replace(/<script[^>]*?>.*?<\/script>/gi, '').
  #         replace(/<[\/\!]*?[^<>]*?>/gi, '').
  #         replace(/<style[^>]*?>.*?<\/style>/gi, '').
  #         replace(/<![\s\S]*?--[ \t\n\r]*>/gi, '');
  #         return SubmitMessage;
  #     };
  #     })(jQuery);
  #     $(function() {
  #         $('#sanitize').click(function() {
  #             var $input = $('#input').val();
  #             $('#SubmitMessage').text($.sanitize($input));
  #         });
  #     });
  # Login

  $nickForm.submit (e) ->
    e.preventDefault()
    if $nickBox.val().trim()
      socket.emit 'new user', $nickBox.val(), (data) ->
        if data
          $('#nickWrap').hide()
          $loader.show()
        return
      $nickBox.val ''
    else if $nickBox.val() and !$nickBox.val().trim()
      $nickBox.val ''
    return
  # Message
  $chatForm.submit (e) ->
    if !$messageBox.val()
      e.preventDefault()
      $messageBox.val ''
    else
      e.preventDefault()
      socket.emit 'new message', $messageBox.val()
      $messageBox.val ''
    return
  socket.on 'match found', ->
    $loader.hide()
    $chatWrap.show()
    return
  # Print message
  socket.on 'broadcast', (data) ->
    $chat.append '<b> CupidBOT:</b> Match found, chatroom initialized <br/> <b>Suggested meetup location:</b> ' + data.location.name + ' <a target="_blank" href="  ' + data.location.coords + '">Map</a><br>Now kiss!'
    return
  socket.on 'send message', (data) ->
    $chat.append '<p><b>' + data.username + ': </b>' + data.msg + '</p>'
    $chat.stop().animate { scrollTop: $chat[0].scrollHeight }, 800
    return
  return

# ---
# generated by js2coffee 2.1.0