express     = require 'express'
app         = express()
http        = require('http').Server app
io          = require('socket.io') http
_           = require 'lodash'

{ getMeetLocation } = require './meetup'

port = process.env.PORT ? 9000

app.use express.static process.cwd() + '/public'

app.get '/', (req, res) ->
    res.sendFile process.cwd() + '/public/html/index.html'
    return

http.listen port, ->
    console.log "listening on port #{port}"
    return

newRoom = null
mainRoom = 'lobby'

moveFromRoomTo = (socket, oldRoom, newRoom) ->
    socket.leave oldRoom
    socket.join newRoom
    console.log "#{socket.username} moved to #{newRoom}"

makeNewRandomRoom = ->
    (Math.random() + 1)
    .toString 36
    .substring 2

io.on 'connection', (socket) ->
    socket.on 'new user', (data, callback) ->
        rooms = io.sockets.adapter.rooms
        socket.username = data

        if mainRoom of rooms and _.size(rooms[mainRoom]) is 1

            newRoom = makeNewRandomRoom()
            moveRoom = (s) -> moveFromRoomTo s, mainRoom, newRoom
            moveRoom socket

            _ rooms[mainRoom]
            .map (val, id) ->  moveRoom io.sockets.connected[id]
            .value()

            callback 'YOLO'

            io.sockets.in newRoom
            .emit 'match found', { location: getMeetLocation() }

        else
            socket.join mainRoom

            io.sockets.in mainRoom
            .emit 'waiting for match', {}

            callback 'YOLO'

    socket.on 'new message', (data) ->
        io.sockets.in newRoom
        .emit 'send message',
            msg: data
            username: socket.username