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

//---
//DO NOT EDIT ANY OF THIS FILE, TO CHANGE SETTING OPEN "psl_config.lua" AND EDIT THAT!
//---

//set-up meta table
psl = {}

//include config
include("psl_config.lua")

//for networking
util.AddNetworkString("LotteryMenu")
util.AddNetworkString("TicketBuy")

//All the data vars
psl.AllData = {
	TimeLeft = psl.DefaultTime,
	Jackpot = psl.StartingJackpot,
	Number = math.random(0, psl.MaxValue),
	Tickets = {},
	TicketNumber = 0,
	Winrars = {},
	WinrarsNumber = 0
}

//fix issues with data file
if !file.Exists( "psl_data.txt", "DATA" ) then
	local JSON = util.TableToJSON(psl.AllData)
	file.Write( "psl_data.txt", JSON )
end
//fix issues with data file
local JSON = file.Read("psl_data.txt", "DATA")
if ((JSON == nil) or (JSON == "") or (util.JSONToTable( JSON ) == nil)) then
	local JSON = util.TableToJSON(psl.AllData)
	file.Write( "psl_data.txt", JSON )
end

//Set up variables
//the time left before drawing
psl.TimeLeft = psl.DefaultTime
//the jackpot
psl.Jackpot = psl.StartingJackpot
//the winning number
psl.Number = 0
//table with all the tickets and their owners
psl.Tickets = {}
//number of tickets, used for the above table as a sort of "unique id" for each ticket
psl.TicketNumber = 0
//boolean for when players are allowed to buy tickets
psl.CanBuy = false
//table containing all the winners | or "Winrars" because le XD funny maymay...
psl.Winrars = {}
//the number of winners
psl.WinrarsNumber = 0
//the name of the points used
psl.PointsName = PS.Config.PointsName --* this uses whatever you set in Point Shop's config, no need to change it here too!

if (psl.PointsName == "" or psl.PointsName == nil) then
	psl.PointsName = "Points"
end

//starts things up
function psl:StartUp()

	self:GenerateNumeber()
	for k,v in pairs(player.GetAll()) do
		v:SetNWInt("TicketsBought",0)
	end
	local JSON = file.Read("psl_data.txt", "DATA")
	self.AllData = util.JSONToTable(JSON)
	self.TimeLeft = self.AllData.TimeLeft
	self.Jackpot = self.AllData.Jackpot
	self.Number = self.AllData.Number
	self.Tickets = self.AllData.Tickets
	self.TicketNumber = self.AllData.TicketNumber
	self.Winrars = self.AllData.Winrars
	self.WinrarsNumber = self.AllData.WinrarsNumber
		
	//check to see if the map changed at a bad time.
	if (self.TimeLeft != 0) then
		//add 1 second to be safe
		self.TimeLeft = self.TimeLeft + 1
	elseif (self.TimeLeft == 0) then
		//it should not have happened
		psl.TimeLeft = psl.DefaultTime
	end
	for k,v in pairs(player.GetAll()) do
		psl:SetBoughtTickets(v)
	end
	self.CanBuy = true
	timer.Create( "LotteryMessage", self.MessageDelay, 0, function() psl:Message() end )
	
end

function psl:Defaults()
	psl.TimeLeft = psl.DefaultTime
	psl.Jackpot = psl.StartingJackpot
	psl.Number = 0
	psl.Tickets = {}
	psl.TicketNumber = 0
	psl.Winrars = {}
	psl.WinrarsNumber = 0
	self:GenerateNumeber()
	SaveData()
end

//Run each Second
function psl:LotteryTick()
	if (psl.TimeLeft >= 1) then
		self.TimeLeft = self.TimeLeft - 1
		//cleanup players tickets who left
		if (self.TimeLeft == 5) then
			self:RemoveGonePlayers()
		//announce winrar
		elseif (self.TimeLeft == 0) then
			self.CanBuy = false
			self:Drawing()
		end
	end
end

//Generate the winning number
function psl:GenerateNumeber()
	self.Number = math.random(0, self.MaxValue)
end

//handle the winning system
function psl:Drawing()
	//clean up again
	self.RemoveGonePlayers()
	timer.Destroy( "LotteryMessage")
	
	if psl.KeepWinningNumber == false then
		for k,v in pairs(player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: Drawing! The winning number is "..self.Number)
		end
	end
	
	for k,v in pairs(self.Tickets) do
		if (v.NumberChosen == self.Number) then
			self.WinrarsNumber = self.WinrarsNumber + 1
			self.Winrars[self.WinrarsNumber] = GetPlyFromSteam(v.PlayerSID)
		end
	end
	if (self.WinrarsNumber > 0) then
		self:Winrar()
	else
		for k,v in pairs(player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: Nobody won! The Jackpot stays at "..self.Jackpot.." "..self.PointsName.."!")
			v:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: Next Drawing in "..string.ToMinutesSeconds(self.DefaultTime))
		end
		self:EndofRound(false)
	end
end

//Handles the winnings
function psl:Winrar()
	local PlayerPayout = self.Jackpot / self.WinrarsNumber
	
	//reset the jackpot
	self.Jackpot = self.StartingJackpot
	for k,v in pairs(self.Winrars) do
		if psl.Pointshop == "pointshop" then
		v:PS_GivePoints(PlayerPayout)
		for i,p in pairs(player.GetAll()) do
			p:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: Player '"..v:Name().."' Won the Lottery, and got "..PlayerPayout.." "..self.PointsName.."!")
		end
		elseif psl.Pointshop == "pointshop2" then
			v:PS2_GiveStandardPoints(PlayerPayout, "You won the Lottery")
		for i,p in pairs(player.GetAll()) do
			p:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: Player '"..v:Name().."' Won the Lottery, and got "..PlayerPayout.." points!")
		end
		end
		end 
	end
	self:EndofRound(true)
end

function psl:EndofRound(winrar)
	if (winrar) then
		self:Defaults()
		SaveData()
	else
		self.TimeLeft = self.DefaultTime
		if (self.DropTickets) then
			self.Tickets = {}
		end
		if (psl.KeepWinningNumber == false) then
			self:GenerateNumeber()
		end
		SaveData()
	end
	timer.Simple(1, function()
		self:StartUp()
	end)
end

//deals with tickets
function psl:AddTicket(ply, number)
	self.TicketNumber = self.TicketNumber + 1
	
	self.Tickets[self.TicketNumber] = {}
	self.Tickets[self.TicketNumber].PlayerSID = ply:SteamID()
	self.Tickets[self.TicketNumber].NumberChosen = number
	
	self.Jackpot = self.Jackpot + self.TicketPrice
	ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: You Bought a ticket with the number "..number)
	ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: The Jackpot is currently "..self.Jackpot.." "..self.PointsName.."!")
	SaveData()
end

//How users will buy tickets
function CCommand( ply, text, public )
	local len = (string.len(psl.CCommand) + 1)
    if ((string.lower(string.sub(text, 1, len)) == "!"..psl.CCommand) || ((string.lower(string.sub(text, 1, len))) == "/"..psl.CCommand)) then
        if (string.lower(string.sub(text, (len + 2), (len + 4)))== "buy") then
			local number = tonumber(string.sub(text, (len + 6)))
			psl:CheckNumber(ply, number)
		elseif (string.lower(string.sub(text, (len + 2), (len + 5)))== "time") then
			ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: The next drawing is in "..string.ToMinutesSeconds((psl.TimeLeft)))
			ply:PrintMessage( HUD_PRINTTALK , "The Jackpot is currently at "..psl.Jackpot.." "..psl.PointsName.."")
		elseif (string.lower(string.sub(text, (len + 2), (len + 5)))== "help") then
			ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery Usage: !"..psl.CCommand.." buy 'ticket number 0-"..psl.MaxValue.."'")
			ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery Usage: '!"..psl.CCommand.." time' to see how much time is left, and the current Jackpot.")
		else
			net.Start( "LotteryMenu" )
				net.WriteInt(psl.MaxTickets, 16)
				net.WriteInt(psl.TimeLeft, 16)
				net.WriteInt(psl.Jackpot, 32)
				net.WriteString(psl.PointsName)
				net.WriteString(psl.CCommand)
			net.Send( ply )
		end
		
        return(false)
    end
end
hook.Add( "PlayerSay", "pslChatCommand", CCommand)

function psl:CheckNumber(ply, number)
	if (number != nil && (number >= 0 && number <= psl.MaxValue)) then
		if (ply:PS_HasPoints(psl.TicketPrice)) then
			local IsGood = true
			for k,v in pairs(psl.Tickets) do
				if (GetPlyFromSteam(v.PlayerSID) == ply && v.NumberChosen == number) then
					IsGood = false
					break;
				end
			end
			if (IsGood) then
				if (psl.CanBuy) then
					if (ply:GetNWInt("TicketsBought") < psl.MaxTickets) then
						ply:PS_TakePoints(psl.TicketPrice)
						psl:AddTicket(ply, number)
						ply:SetNWInt("TicketsBought", (ply:GetNWInt("TicketsBought") +1))
					else
						ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: You bought the maximum amount of tickets, please wait for next drawing.")
					end
				else
					ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: You can not buy tickets right now, please wait "..psl.TimeLeft.." seconds")
				end
			else
				ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: You can't buy two tickets with the same number!")
			end
		else
			ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: You don't have enough points to buy a ticket!")
		end
	else
		ply:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: enter a ticket number between 0-"..psl.MaxValue)
	end
end

function psl:Message()
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTTALK , "PointShop Lottery: The next drawing is in "..string.ToMinutesSeconds((psl.TimeLeft)))
		v:PrintMessage( HUD_PRINTTALK , "The Jackpot is currently at "..psl.Jackpot.." "..self.PointsName.."")
	end
end

//if a player leaves the server their tickets get "removed" by making out of the lotto's scope of numbers
function PlayerLeavesServer( ply )
	if (psl.RemoveOnLeave) then
		for k,v in pairs(psl.Tickets) do
			if (GetPlyFromSteam(v.PlayerSID) == ply) then
				v.NumberChosen = -1
			end
		end
	end
end
hook.Add( "PlayerDisconnected", "PSLplayerleavesserver", PlayerLeavesServer )

//receive number from the vgui
net.Receive( "LotteryMenu", function( len )
	local ply = net.ReadEntity()
	local number = net.ReadInt(16)
	psl:CheckNumber(ply, number)
end )

//save the data to a json string in a txt file
function SaveData()

	if file.Exists( "psl_data.txt", "DATA" ) then
		psl.AllData.TimeLeft = psl.TimeLeft
		psl.AllData.Jackpot = psl.Jackpot
		psl.AllData.Number = psl.Number
		psl.AllData.Tickets = psl.Tickets
		psl.AllData.TicketNumber = psl.TicketNumber
		psl.AllData.Winrars = psl.Winrars
		psl.AllData.WinrarsNumber = psl.WinrarsNumber
		
		local JSON = util.TableToJSON(psl.AllData)
		file.Write( "psl_data.txt", JSON )
	else
		print("|PSL|: ERROR Saving data! save file does not exist!")
	end

end

//check to make sure that the players are still here, if not remove tickets.
function psl:RemoveGonePlayers()
	for k,v in pairs(psl.Tickets) do
		local ply = GetPlyFromSteam(v.PlayerSID)
		if (!ply or ply == nil) then
			v.NumberChosen = -1
		end
	end
end

//get player entity from steam id
function GetPlyFromSteam(SID)
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == SID then
			return v
		end
	end
	return nil
end

function psl:SetBoughtTickets(ply)
	ply:SetNWInt("TicketsBought",0)
	for k,v in pairs(psl.Tickets) do
		if (GetPlyFromSteam(v.PlayerSID) == ply) then
			ply:SetNWInt("TicketsBought", ply:GetNWInt("TicketsBought") + 1)
		end
	end
end

local function PlayerFirstSpawn(ply)
	psl:SetBoughtTickets(ply)
end
hook.Add( "PlayerInitialSpawn", "WhenThePlayerFirstSpawns", PlayerFirstSpawn )

//create default timers
//need a slight delay... so that is why i put in a simple timer
timer.Simple( 3, function()
	//run every second to check time
	timer.Create( "LotteryTick", 1, 0, function() psl:LotteryTick() end)
	//run every 10 seconds to save data
	timer.Create("PSL_SaveData", 10, 0, function() SaveData() end)
end )

print("|PSL|: PointShop Lottery Initialized!")

psl:StartUp()