express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http
port = process.env.PORT or 9000

GetMeetLocation = ->
    MeetLocation[Math.round(Math.random() * (MeetLocation.length - 1))]

app.configure ->
    app.set 'port', process.env.PORT or 9000

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
# Randomized codeword for teams
io.on 'connection', (socket) ->
    console.log 'connection made.'