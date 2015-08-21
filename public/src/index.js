(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-47339612-2', 'dayzbuddy.com');
  ga('send', 'pageview');

require('roles');

jQuery(function($){
    var socket = io.connect();
    var $nickForm = $('#setNick');
    var $nickError = $('#nickError');
    var $nickBox = $('#nickname');
    var $chatForm = $('#SubmitMessage');
    var $messageBox = $('#message');
    var $users = $('#users');
    var $chat = $('#chatWrap');
    var $loader = $('#loadWrap');
    var $chatWrap = $('#contentWrap')


    // Sanitize user input

    // (function($) {
    //  $.sanitize = function(input) {
    //     var SubmitMessage = input.replace(/<script[^>]*?>.*?<\/script>/gi, '').
    //         replace(/<[\/\!]*?[^<>]*?>/gi, '').
    //         replace(/<style[^>]*?>.*?<\/style>/gi, '').
    //         replace(/<![\s\S]*?--[ \t\n\r]*>/gi, '');
    //         return SubmitMessage;
    //     };
    //     })(jQuery);

    //     $(function() {
    //         $('#sanitize').click(function() {
    //             var $input = $('#input').val();
    //             $('#SubmitMessage').text($.sanitize($input));
    //         });

    //     });

    // Login

    $nickForm.submit(function(e){
        e.preventDefault();

        if ($nickBox.val().trim()){
            socket.emit('new user', $nickBox.val(), function(data) {
                if(data){
                    $('#nickWrap').hide();
                    $loader.show();
                 }
             });

            $nickBox.val('');
        } else if ($nickBox.val() && !$nickBox.val().trim()) {
            $nickBox.val('');
        }

    });

    // Message

    $chatForm.submit(function(e){

        if (!$messageBox.val()){

            e.preventDefault();
            $messageBox.val("")

        } else{

            e.preventDefault();
            socket.emit('new message', $messageBox.val());
            $messageBox.val("");
        }

    });

    socket.on('match found', function() {
        $loader.hide();
        $chatWrap.show();
     });

    // Print message

    socket.on('broadcast', function(data){
        $chat.append('<b> CupidBOT:</b> Match found, chatroom initialized <br/> <b>Suggested meetup location:</b> '+ data.location.name + ' <a target="_blank" href="  '+data.location.coords+'">Map</a><br>Now kiss!');

    });

    socket.on('send message', function(data){
        $chat.append('<p><b>' + data.username + ': </b>' + data.msg + "</p>");
        $chat.stop().animate({scrollTop: $chat[0].scrollHeight}, 800);
    });
});
