express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http
port = process.env.PORT or 9000
_ = require 'lodash'

GetMeetLocation = ->
    MeetLocation[Math.round(Math.random() * (MeetLocation.length - 1))]

app.use express.static(process.cwd() + '/public')

app.get '/', (req, res) ->
    res.sendfile process.cwd() + '/index.html'
    return

http.listen port, ->
    console.log "listening on port #{port}"
    return

# Meetuplocations
MeetLocation = [
    {
        name: 'kamyshovo'
        coords: 'http://dayzdb.com/map/chernarusplus#7.120.119'
    }
    {
        name: 'Docks in Solnichniy'
        coords: 'http://dayzdb.com/map/chernarusplus#7.132.092'
    }
    {
        name: 'Farm above factory'
        coords: 'http://dayzdb.com/map/chernarusplus#7.129.083'
    }
    {
        name: 'Cap golova'
        coords: 'http://dayzdb.com/map/chernarusplus#7.083.129'
    }
    {
        name: 'Farm above Three valleys'
        coords: 'http://dayzdb.com/map/chernarusplus#6.123.100'
    }
]

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
            .map (val, id) -> io.sockets.connected[id]
            .each (s) -> moveRoom s
            .value()

            callback 'YOLO'

            io.sockets.in newRoom
            .emit 'match found', { location: GetMeetLocation() }

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