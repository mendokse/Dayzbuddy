var express = require('express'),
	app = express(),
	server = require('http').createServer(app),
	io = require('socket.io').listen(server);
	
server.listen(process.env.PORT || 9000);

app.configure(function () {
    app.set('port', process.env.PORT || 9000);
    app.use(express.static(__dirname + '/public'));
});

// server.listen(9000);

// app.configure(function () {
//     app.set('port', 9000);
//     app.use(express.static(__dirname + '/public'));
// });

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
		name: "Farm above Three valleys", 
		coords: "http://dayzdb.com/map/chernarusplus#6.123.100"
	}
];

function GetMeetLocation(){

	return MeetLocation[Math.round(Math.random()*(MeetLocation.length-1))];

}

// Randomized codeword for teams

var Codeword = [
	"kod1",
	"kod2",
	"kod3",
	"kod4",
	"kod5",
	"kod6",
	"kod7",
	"kod8"
	];

function GetCodeWord(){
	return Codeword[Math.round(Math.random()*(Codeword.length-1))];
}

io.sockets.on('connection', function(socket){
	socket.on('new user', function(data, callback){
		var rooms = io.sockets.manager.rooms,
			room;

		socket.username = data;

		if (rooms) {
			for (roomName in rooms) {
				roomName = roomName.substring(1);

				if (io.sockets.clients(roomName) && io.sockets.clients(roomName).length === 1) {
					room = roomName;

					socket.room = room;
					socket.join(room);
					console.log('hest');
					io.sockets.in(socket.room).emit('match found',{location: GetMeetLocation(), codeword: GetCodeWord()});
					callback("YOLO");

					

					return;
				}
			}
		}

		if(!room) {
			room = (Math.random() + 1).toString(36).substring(2);
		}

		socket.room = room;
		socket.join(room);
		callback("YOLO");
		return;
	});

	socket.on('new message', function(data){
		
		io.sockets.in(socket.room).emit('send message', {msg: data, username: socket.username});

	});
	
});



	
