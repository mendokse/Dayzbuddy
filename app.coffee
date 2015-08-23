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

io.on 'connection', (socket) ->
    socket.on 'new user', (data, callback) ->
        rooms = io.sockets.adapter.rooms
        socket.username = data
        if 'lobby' of rooms #and io.sockets.clients('lobby') and io.sockets.clients('lobby').length == 1
            socket.room = (Math.random() + 1).toString(36).substring(2)
            socket.join socket.room
            # console.log socket.username + ' joined room ', socket.room

            _(io.sockets.in('lobby').connected)
            .each (s) ->
                debugger
                s.leave 'lobby'
                s.join socket.room
                console.log "#{s.username} moved to #{socket.room}"
            .value()

            io.sockets.in socket.room
            .emit 'match found', { location: GetMeetLocation() }

        else
            socket.join 'lobby'
            io.sockets.in('lobby').emit 'waiting for match', {}
        callback 'YOLO'
        return
    socket.on 'move player', (data) ->
        socket.leave 'lobby'
        socket.join data.room
        console.log 'moved ' + socket.username + ' to room -> ', data.room
        io.sockets.in(data.room).emit 'match found', room: room
        return
    socket.on 'match found', (data) ->
        io.sockets.in(data.room).emit 'broadcast', location: GetMeetLocation()
        return
    socket.on 'new message', (data) ->
        io.sockets.in(socket.room).emit 'send message',
            msg: data
            username: socket.username
        return
    return