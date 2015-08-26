express     = require 'express'
app         = express()
http        = require('http').Server app
io          = require('socket.io') http
_           = require 'lodash'
session     = require 'express-session'
MongoStore  = require('connect-mongo') session


SocketRoomManager   = require('./SocketRoomManager') io
{ getMeetLocation } = require './meetup'

port = process.env.PORT ? 9000

sessionMiddleware = session
    secret: 'keyboard cat'
    store: new MongoStore
        url: 'mongodb://localhost/dayzbuddy'

app.use sessionMiddleware

app.use express.static process.cwd() + '/public'

app.get '/', (req, res) ->
    res.sendFile process.cwd() + '/public/html/index.html'
    return

http.listen port, ->
    console.log "listening on port #{port}"
    return

mainRoom    = 'lobby'
newRoom     = null

io.use (socket, next) ->
    sessionMiddleware socket.request, socket.request.res, next

io.on 'connection', (socket) ->
    socketRoomManager = new SocketRoomManager socket, mainRoom

    socket.on 'new user', (data, callback) ->
        socket.request.session.username = data

        if socketRoomManager.mainRoomOk()
            socketRoomManager.joinMainRoom()
            newRoom = socketRoomManager.makeNewRandomRoom()
            socketRoomManager.moveAllSocketsToNewRoomFromMainRoom newRoom
            callback 'YOLO'
            io.sockets.in newRoom
            .emit 'match found', { location: getMeetLocation() }

        else
            socketRoomManager.joinMainRoom()
            io.sockets.in socketRoomManager.mainRoom
            .emit 'waiting for match', {}
            callback 'YOLO'

    socket.on 'new message', (data) ->
        io.sockets.in newRoom
        .emit 'send message',
            msg: data
            username: socket.request.session.username