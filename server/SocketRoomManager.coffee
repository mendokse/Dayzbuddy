_ = require 'lodash'

module.exports = exports = (io) -> class SocketRoomManager
    constructor: (@socket, @mainRoom) ->

    moveFromMainRoomTo: (newRoom) ->
        @moveFromRoomTo @mainRoom, newRoom
        newRoom

    moveFromRoomTo: (oldRoom, newRoom) ->
        moveFromRoomToWithSocket @socket, oldRoom, newRoom

    moveFromRoomToWithSocket: (socket, oldRoom, newRoom) ->
        socket.leave oldRoom
        socket.join newRoom
        console.log "\
        #{socket.request.session.username}\
         moved from #{oldRoom} to #{newRoom}"
        newRoom

    joinMainRoom: -> @socket.join @mainRoom

    makeNewRandomRoom: ->
        (Math.random() + 1)
        .toString 36
        .substring 2

    moveToNewRandomRoomFromMainRoom: ->
        moveFromMainRoomTo makeNewRandomRoom()

    mainRoomOk: ->
        @mainRoom of @rooms and _.size(@rooms[@mainRoom]) is 1

    eachSocketsInMainRoom: (fn) ->
        _ @rooms[@mainRoom]
        .each (val, id) ->
            fn(io.sockets.connected[id])
        .value()

    moveAllSocketsToNewRoomFromMainRoom: (newRoom) ->
        @eachSocketsInMainRoom (socket) =>
            @moveFromRoomToWithSocket socket, @mainRoom, newRoom

    rooms: io.sockets.adapter.rooms