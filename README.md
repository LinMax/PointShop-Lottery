PointShop Lottery

PointShop Lottery is a lottery addon for _Undefined's pointshop. It adds a lottery for players to have a chance to win more points. Players simply choose a lottery number, then wait for the drawing to see if they won. The jackpot goes up with every ticket sold, and if no one wins it just keeps getting bigger and bigger! It is completely configurable and makes a nice fun addition to any server running _Undefined's pointshop.

Features:

-Small and compact.

-Simple easy to use GUI.

-Completely configurable.

-Persistent Data, if the server restarts or changes levels everything is saved

-Can handle multiple winners, If two or more players have the same winning lotto ticket number, they all get an equal share.

-Players can buy multiple tickets, you can configure the maximum they can buy.

How it works:

Just install, configure, and start your server. As long as you are running _Undefined's pointshop then thats it.

Once in game type '!psl' to open the GUI, '!psl buy "lotto number"' to buy a ticket, '!psl help' for help, and type '!psl time' to see when the next drawing is, and what the current jackpot is. you can change the command in the config.

Requirements: _Undefined's pointshop

If you run into any issues please contact me on steam. -Max




To install just place "pointshoplottery" in "/garrysmod/addons" then configure and start gmod...

To Configure go into "psl_config.lua" and edit the following.

//psl.CCommand Sets the command to use in chat. ie !psl or /psl
//*NOTE* both / and ! will work || do not add the "/" or "!" to this value! example if you wanted your command to be "/lottery" or "!lottery" then just put "lottery"
//Default "psl"

//psl.DefaultTime sets the amount of time between drawing in seconds. 
//Default 1800 (30 minutes)

//psl.MaxValue Sets the range of possible numbers, this sets the "difficulty" in guessing the right number
//*NOTE* This is the available lottery guesses IE the lotto number will be random number 0-500 and players will enter 0-500 as there guess to win the lotto
//Default 500, meaning 1 in 500 chance of guessing the current lotto number

//psl.TicketPrice sets the price of the tickets and how much the jackpot goes up with each ticket sale.
//Default 5

//psl.StartingJackpot sets the default jackpot when the server first starts, and when someone wins
//Default 100

//psl.MessageDelay Sets the delay in, seconds, that the server advertises the current time left before the drawing and the current jackpot
//Default 180 (3 minutes) make less than default time...


//psl.MaxTickets sets how many tickets each player can buy per drawing.
//Default 1

//psl.RemoveOnLeave remove players tickets when they disconnect, if false players will be able to rejoin and there tickets will remain for the next drawing. 
//*NOTE* players have to actually be in game when the drawing happens to win...
//default false

//psl.DropTickets remove players' tickets after each drawing, even if no one won, this lets people buy more tickets to guess the lottery number each round, while keeping the number the same. 
//default true

//psl.KeepWinningNumber Keeps the same winning number every round until someone guesses it. makes it less random, but easier to guess
//default true