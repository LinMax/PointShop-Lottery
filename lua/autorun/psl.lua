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

AddCSLuaFile()
if SERVER then
	include("psl/psl_init.lua")
	AddCSLuaFile("psl/psl_cl.lua")
else
	include("psl/psl_cl.lua")
end