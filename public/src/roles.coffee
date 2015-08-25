_ = require 'lodash'

buildCharacter = (character, description) ->
    "<h5>Character: #{character}</h5> <p>#{description}</p>"

buildMission = (mission, description) ->
    "<h5>Mission: #{mission}</h5> <p>#{description}</p>"

exports.characters = _([
    {
        name: 'Drunk Russian'
        description: 'You have consumed enough alcohol to kill an ordinary man\
        . But you are russian, yes. Behave irrationally and have moodswings'
    }
    {
        name: 'Goldfish'
        description: 'You have extremely short memory. You have extremly short\
         memory. you hav.. oh a cookie'
    }
    {
        name: 'Redneck'
        description: 'You are a below average intelligent person with question\
        able morals and a you are proud about it. You are from murica and you \
        fucking hate commies.'
    }
    {
        name: 'Psychopath'
        description: 'You are a fucking crazy, insane and a heavy breathing ma\
        niac who scare the living shit out of people.'
    }
    {
        name: 'Religous'
        description: 'Every word of God is pure; He is a shield to those who p\
        ut their trust in Him. Prov. 30:5, Live your life as a true christian.'
    }
    {
        name: 'Child'
        description: 'Scared,lonely and your parents are long gone.'
    }
    {
        name: 'Cowboy'
        description: 'You are a leathal gentleman who charm everyone with your\
         southern accent.'
    }
    {
        name: 'Military'
        description: 'Everything you do is done with extreme attention to deta\
        ils. And with your particular set of skills you execute missions witho\
        ut fail.'
    }
    {
        name: 'Royal'
        description: 'Your royal blood goes back for generations. The other su\
        rvivors are of lesser importance, pessants if u will. Use them to get \
        what you want. '
    }
    {
        name: 'Flamboyant'
        description: 'You are the most dashing survivor in chernarus and with \
        your excellent sence for fashion you fight for equal rights for everyo\
        ne.'
    }
])
.map (c) -> buildCharacter c.name, c.description
.value()

exports.missions = _([
    {
        name: 'Bookseller'
        description: 'Collect books and setup up shop in a town or become a tr\
        aveling salesmen.'
    }
    {
        name: 'Storyteller'
        description: 'Find a gaslamp and gather a group of random people on a \
        nighttime server. Proceed to setup camp somewhere cozy and tell stories'
    }
    {
        name: 'Robber'
        description: 'Rob people for anything of value, but honor your profess\
        ion and only use violence when necessary.'
    }
    {
        name: 'Party starter'
        description: 'Become the partystarter. Play music in direct and do the\
         wiggle dance, gather as many people you can.'
    }
    {
        name: 'Fortuneteller'
        description: 'Make your way thru chernarus as a fortuneteller offering\
         your service for some beans'
    }
    {
        name: 'Salesmen'
        description: 'Hoard up with the mountain backpack and setup shop in a \
        big city'
    }
    {
        name: 'Superhero'
        description: 'Keep the scum out of a city of your choice: Berezino, El\
        ektro, or Cherno. Protect the weak, destroy the wicked.'
    }
    {
        name: 'Boxer'
        description: 'Challenge anyone and everyone to boxing. No weapons allo\
        wed.'
    }
    {
        name: 'Shepard'
        description: 'Roam the coast and gather all the bambies/freshspawns on\
         the way. Try to get as big of a group you can.'
    }
    {
        name: 'Medic'
        description: 'Collect medical gear and go about helping players with f\
        ood, bandages, blood etc.'
    }
    {
        name: 'Buddist'
        description: 'Material things have no value for you. Gather stuff and \
        give it to people who cross your path.'
    }
])
.map (m) -> buildCharacter m.name, m.description
.value()

exports.randomize = (which) -> Math.round(Math.random() * (which.length - 1))
