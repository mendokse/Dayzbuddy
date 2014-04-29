var express = require('express'),
	app = express(),
	server = require('http').createServer(app),
	io = require('socket.io').listen(server);
	
// server.listen(process.env.PORT || 9000);

// app.configure(function () {
//     app.set('port', process.env.PORT || 9000);
//     app.use(express.static(__dirname + '/public'));
// });

server.listen(9000);

app.configure(function () {
    app.set('port', 9000);
    app.use(express.static(__dirname + '/public'));
});

app.get('/', function(req, res){
	res.sendfile(__dirname + '/index.html');
});

// Meetuplocations

var MeetLocation = [
	{
		name: "kamyshovo", 
		coords: "http://dayzdb.com/map/chernarusplus#7.120.119"
	},
	{
		name: "Docks in Solnichniy", 
		coords: "http://dayzdb.com/map/chernarusplus#7.132.092"
	},
	{
		name: "Farm above factory", 
		coords: "http://dayzdb.com/map/chernarusplus#7.129.083"
	},
	{
		name: "Cap golova", 
		coords: "http://dayzdb.com/map/chernarusplus#7.083.129"
	},
	{
		name: "Farm above Three valleys", 
		coords: "http://dayzdb.com/map/chernarusplus#6.123.100"
	}
];

function GetMeetLocation(){

	return MeetLocation[Math.round(Math.random()*(MeetLocation.length-1))];

}

// Randomized codeword for teams

io.sockets.on('connection', function(socket){
	socket.on('new user', function(data, callback){
		var rooms = io.sockets.manager.rooms;

		socket.username = data;

		if ('/lobby' in rooms && io.sockets.clients('lobby') && io.sockets.clients('lobby').length === 1) {
			socket.room = (Math.random() + 1).toString(36).substring(2);

			socket.join(socket.room);
			console.log(socket.username + ' joined room ', socket.room);

			io.sockets.in('lobby').emit('move player', {room: socket.room});
		} else {
			socket.join('lobby');

			io.sockets.in('lobby').emit('waiting for match', {});
		}
		
		callback("YOLO");
		return;
	});

	socket.on('move player', function(data){
		socket.leave('lobby');
		socket.join(data.room);

		console.log('moved ' + socket.username + ' to room -> ', data.room);

		io.sockets.in(data.room).emit('match found', {room: room});
	});

	socket.on('match found', function(data){
		io.sockets.in(data.room).emit('broadcast', {location: GetMeetLocation()});
	});

	socket.on('new message', function(data){
		io.sockets.in(socket.room).emit('send message', {msg: data, username: socket.username});
	});
	
});



	
