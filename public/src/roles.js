// Role

var Quotation = [
        "<h5>Character: Drunk russian</h5> <p>You have consumed enough alcohol to kill an ordinary man. But you are russian, yes. Behave irrationally and have moodswings</p>",

        "<h5>Character: Goldfish</h5> <p>You have extremely short memory. You have extremly short memory. you hav.. oh a cookie</p>",

        "<h5>Character: Redneck</h5> <p>You are a below average intelligent person with questionable morals and a you are proud about it. You are from murica and you fucking hate commies.</p>",

        "<h5>Character: Psychopath</h5> <p>You are a fucking crazy, insane and a heavy breathing maniac who scare the living shit out of people.</p>",

        "<h5>Character: Religous</h5> <p>Every word of God is pure; He is a shield to those who put their trust in Him. Prov. 30:5, Live your life as a true christian.</p>",

        "<h5>Character: Child</h5> <p>Scared,lonely and your parents are long gone.</p>",

        "<h5>Character: Cowboy</h5> <p>You are a leathal gentleman who charm everyone with your southern accent.</p>",

        "<h5>Character: Military</h5> <p>Everything you do is done with extreme attention to details. And with your particular set of skills you execute missions without fail.</p>",

        "<h5>Character: Royal</h5> <p>Your royal blood goes back for generations. The other survivors are of lesser importance, pessants if u will. Use them to get what you want. </p>",

        "<h5>Character: Flamboyant</h5> <p>You are the most dashing survivor in chernarus and with your excellent sence for fashion you fight for equal rights for everyone.</p>"
    ],
    Q = Quotation.length;

// Misson
    var Quotation2 = [
        "<h5>Misson: Bookseller</h5> <p>Collect books and setup up shop in a town or become a traveling salesmen.</p>",

        "<h5>Misson: Storyteller</h5> <p>Find a gaslamp and gather a group of random people on a nighttime server. Proceed to setup camp somewhere cozy and tell stories</p>",

        "<h5>Misson: Robber</h5> <p>Rob people for anything of value, but honor your profession and only use violence when necessary.</p>",

        "<h5>Misson: Party starter</h5> <p>Become the partystarter. Play music in direct and do the wiggle dance, gather as many people you can.</p>",

        "<h5>Misson: Fortuneteller</h5> <p>Make your way thru chernarus as a fortuneteller offering your service for some beans</p>",

        "<h5>Misson: Salesmen</h5> <p>Hoard up with the mountain backpack and setup shop in a big city</p>",

        "<h5>Misson: Superhero</h5> <p>Keep the scum out of a city of your choice: Berezino, Elektro, or Cherno. Protect the weak, destroy the wicked.</p>",

        "<h5>Misson: Boxer</h5> <p>Challenge anyone and everyone to boxing. No weapons allowed.</p>",

        "<h5>Misson: Shepard</h5> <p>Roam the coast and gather all the bambies/freshspawns on the way. Try to get as big of a group you can.</p>",

       "<h5>Misson: Medic</h5> <p>Collect medical gear and go about helping players with food, bandages, blood etc.</p>",

        "<h5>Misson: Buddist</h5> <p>Material things have no value for you. Gather stuff and give it to people who cross your path.</p>"
    ],
    Q2 = Quotation.length;

function showQuotation(){
    var whichQuotation = Math.round(Math.random()*(Q-1));
    var whichQuotation2 = Math.round(Math.random()*(Q2-1));

    document.getElementById("quotation").innerHTML = Quotation[whichQuotation];

    document.getElementById("quotation2").innerHTML = Quotation2[whichQuotation2];
}

$('#randomize').click(function() {
    showQuotation();
    return false;
})

showQuotation();