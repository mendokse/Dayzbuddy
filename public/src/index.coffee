window.jQuery = $   = require 'jquery'
roles               = require 'roles'
socket = io()

$(document).ready ->

    $nickForm   = $('#setNick')
    $nickError  = $('#nickError')
    $nickBox    = $('#nickname')
    $chatForm   = $('#SubmitMessage')
    $messageBox = $('#message')
    $users      = $('#users')
    $chat       = $('#chatWrap')
    $loader     = $('#loadWrap')
    $chatWrap   = $('#contentWrap')
    $findBuddy  = $('#find-buddy')

    $('#find-buddy').click ->
        $findBuddy.submit()
        return false

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

    $chatForm.submit (e) ->
        if !$messageBox.val()
            e.preventDefault()
            $messageBox.val ''
        else
            e.preventDefault()
            socket.emit 'new message', $messageBox.val()
            $messageBox.val ''
        return

    socket.on 'match found', (data) ->
        $loader.hide()
        $chatWrap.show()
        $chat.append \
            '<b> CupidBOT:</b> Match found, chatroom initialized <br/\
        > <b>Suggested meetup location:</b> ' + data.location.name + ' <a targ\
        et="_blank" href="  ' + data.location.coords + '">Map</a><br>Now kiss!'

    sanitize = (input) ->
        input.replace(/<script[^>]*?>.*?<\/script>/gi, '')
            .replace(/<[\/\!]*?[^<>]*?>/gi, '')
            .replace(/<style[^>]*?>.*?<\/style>/gi, '')
            .replace(/<![\s\S]*?--[ \t\n\r]*>/gi, '')

    socket.on 'send message', (data) ->
        console.log 'got message'
        $chat.append \
            "<p>\
                <b> #{sanitize data.username}: </b>\
                #{sanitize data.msg}\
            </p>"
        $chat.stop().animate { scrollTop: $chat[0].scrollHeight }, 800

    { characters, missions, randomize } = roles

    do showQuotation = ->
        $('#characters').html characters[randomize characters]
        $('#missions').html missions[randomize missions]

    $('#randomize').click ->
        showQuotation()
        false