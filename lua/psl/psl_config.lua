--[[
  _____      _       _    _____ _                   _           _   _                  
 |  __ \    (_)     | |  / ____| |                 | |         | | | |                 
 | |__) |__  _ _ __ | |_| (___ | |__   ___  _ __   | |     ___ | |_| |_ ___ _ __ _   _ 
 |  ___/ _ \| | '_ \| __|\___ \| '_ \ / _ \| '_ \  | |    / _ \| __| __/ _ \ '__| | | |
 | |  | (_) | | | | | |_ ____) | | | | (_) | |_) | | |___| (_) | |_| ||  __/ |  | |_| |
 |_|   \___/|_|_| |_|\__|_____/|_| |_|\___/| .__/  |______\___/ \__|\__\___|_|   \__, |
                                           | |                                    __/ |
                                           |_|                                   |___/  --By Max
										   
 Copyright (C) 2013-2015  Max (github.com/LinMax)
	This file is part of PointShop Lottery

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

//edit these to fit your needs

--------------------------------------------------------------------------------------------------------------------------------------------------
--EDIT VALUES BELOW THIS---------------------------------------------------------------------------------------------------------------

psl.Pointshop = "pointshop" // Change to pointshop2 to use it for pointshop 2 and pointshop for _Undefined

//psl.CCommand Sets the command to use in chat. ie !psl or /psl
//*NOTE* both / and ! will work || do not add the "/" or "!" to this value! example if you wanted your command to be "/lottery" or "!lottery" then just put "lottery"
//Default "psl"
psl.CCommand = "psl"

//psl.DefaultTime sets the amount of time between drawing in seconds. 
//Default 1800 (30 minutes)
psl.DefaultTime = 1800

//psl.MaxValue Sets the range of possible numbers, this sets the "difficulty" in guessing the right number
//*NOTE* This is the available lottery guesses IE the lotto number will be random number 0-500 and players will enter 0-500 as there guess to win the lotto
//Default 500, meaning 1 in 500 chance of guessing the current lotto number
psl.MaxValue = 500

//psl.TicketPrice sets the price of the tickets and how much the jackpot goes up with each ticket sale.
//Default 5
psl.TicketPrice = 5

//psl.StartingJackpot sets the default jackpot when the server first starts, and when someone wins
//Default 100
psl.StartingJackpot = 100

//psl.MessageDelay Sets the delay in, seconds, that the server advertises the current time left before the drawing and the current jackpot
//Default 180 (3 minutes) make less than default time...
psl.MessageDelay = 180


//psl.MaxTickets sets how many tickets each player can buy per drawing.
//Default 1
psl.MaxTickets = 1

//psl.RemoveOnLeave remove players tickets when they disconnect, if false players will be able to rejoin and there tickets will remain for the next drawing. 
//*NOTE* players have to actually be in game when the drawing happens to win...
//default false
psl.RemoveOnLeave = false

//psl.DropTickets remove players' tickets after each drawing, even if no one won, this lets people buy more tickets to guess the lottery number each round, while keeping the number the same. 
//default true
psl.DropTickets = true

//psl.KeepWinningNumber Keeps the same winning number every round until someone guesses it. makes it less random, but easier to guess
//default true
psl.KeepWinningNumber = true

--EDIT VALUES ABOVE THIS-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------