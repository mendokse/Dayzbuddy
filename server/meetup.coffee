# Meetuplocations
meetLocations = [
    {
        name: 'Kamyshovo'
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
        name: 'Cap Golova'
        coords: 'http://dayzdb.com/map/chernarusplus#7.083.129'
    }
    {
        name: 'Farm above Three valleys'
        coords: 'http://dayzdb.com/map/chernarusplus#6.123.100'
    }
]

exports.getMeetLocation = ->
    meetLocations[Math.round(Math.random() * (meetLocations.length - 1))]