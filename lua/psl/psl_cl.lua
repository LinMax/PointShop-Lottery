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

psl = {}
psl.TimeLeft = 0
psl.PointsName = "Points"
psl.CCommand = "psl"

surface.CreateFont("MenuLarge", {
	font = "Verdana",
	size = 15,
	weight = 600,
	antialias = true,
})

surface.CreateFont( "WinLarge", {
	font = "Trebuchet MS",
	size = 32,
	weight = 900,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
} )

surface.CreateFont( "WinSmall", {
	font = "Trebuchet MS",
	size = 20,
	weight = 900,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
} )

function psl:LMenu(Jackpot)
	local LPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
	LPanel:SetSize( 300, 220 ) -- Size of the frame
	LPanel:SetTitle( "PS Lottery" ) -- Title of the frame
	LPanel:SetVisible( true )
	LPanel:SetDraggable( true ) -- Draggable by mouse?
	LPanel:ShowCloseButton( true ) -- Show the close button?
	LPanel:MakePopup() -- Show the frame
	LPanel:Center()
	LPanel:MakePopup()
	LPanel.Paint = function()
		draw.RoundedBox( 8, 0, 0, LPanel:GetWide(), LPanel:GetTall(), Color( 50, 50, 50, 240 ) )
	end
	
	local ThreeLabel = vgui.Create( "DLabel", LPanel )
	ThreeLabel:SetPos( 4, 24 )
	ThreeLabel:SetFont("WinSmall")
	ThreeLabel:SetText( "Number of Tickets you can buy: "..(psl.MaxTickets - LocalPlayer():GetNWInt("TicketsBought")))
	ThreeLabel:SizeToContents()
	
	local ThreeLabel1 = vgui.Create( "DLabel", LPanel )
	ThreeLabel1:SetPos( 4, 38 )
	ThreeLabel1:SetFont("WinSmall")
	ThreeLabel1:SetText( "Enter A Ticket Number")
	ThreeLabel1:SizeToContents()
	
	local ThreeLabel2 = vgui.Create( "DLabel", LPanel )
	ThreeLabel2:SetPos( 4, 120 )
	ThreeLabel2:SetFont("WinSmall")
	ThreeLabel2:SetText( "The next drawing is in "..string.ToMinutesSeconds(psl.TimeLeft))
	ThreeLabel2:SizeToContents()
	
	local ThreeLabel3 = vgui.Create( "DLabel", LPanel )
	ThreeLabel3:SetPos( 4, 140 )
	ThreeLabel3:SetFont("WinSmall")
	ThreeLabel3:SetText( "The current jackpot is "..Jackpot.." "..self.PointsName.."!")
	ThreeLabel3:SizeToContents()
	
	local StreamEntry = vgui.Create( "DTextEntry", LPanel )
	StreamEntry:SetPos( 4, 60 )
	StreamEntry:SetTall( 20 )
	StreamEntry:SetWide( 292 )
	StreamEntry:SetEnterAllowed( false )
	
	local SubmitButton = vgui.Create( "DButton", LPanel )
	SubmitButton:SetText( "Buy Ticket" )
	SubmitButton:SetPos( 4, 80 )
	SubmitButton:SetSize( 75, 30 )
	SubmitButton.DoClick = function ()
		local number = tonumber(StreamEntry:GetValue())
		if (!number) then number = -1 end
		net.Start( "LotteryMenu" )
			net.WriteEntity(LocalPlayer())
			net.WriteInt(number, 16)
		net.SendToServer( )
		LPanel:Close()
	end
	
	local ThreeLabel5 = vgui.Create( "DLabel", LPanel )
	ThreeLabel5:SetPos( 4, 160 )
	ThreeLabel5:SetText( " '!"..psl.CCommand.."' to pull up this menu\n '!"..psl.CCommand.." help' for help\n '!"..psl.CCommand.." buy 'ticket number' ' to buy a ticket\n '!"..psl.CCommand.." time' to see how much time is left")
	ThreeLabel5:SizeToContents()
	
	function LPanel:Think()
		ThreeLabel2:SetText( "The next drawing is in "..string.ToMinutesSeconds(psl.TimeLeft))
	end
	
end

net.Receive( "LotteryMenu", function( len )
	psl.MaxTickets = net.ReadInt(16)
	psl.TimeLeft = net.ReadInt(16)
	local Jackpot = net.ReadInt(32)
	psl.PointsName = net.ReadString()
	psl.CCommand = net.ReadString()
	psl:LMenu(Jackpot)
end )

timer.Create("CountDown", 1, 0, function() 
	if (psl.TimeLeft >= 1) then
		psl.TimeLeft = psl.TimeLeft -1
	end
 end)