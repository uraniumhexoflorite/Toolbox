local widget = require "widget"
local ads = require "ads" 
local inMobi = require "plugin.inMobi" 
--local inMobi = require( "plugin.inMobi" )
local placementID = "75664f59cc9841d9ab92cc1d4bfacfb0"
local function adListener( event )
 
    if ( event.phase == "init" ) then  -- Successful initialization
        -- Load a banner ad
        inMobi.load( "banner", placementID )
 
    elseif ( event.phase == "loaded" ) then  -- The ad was successfully loaded
        -- Show the ad
        inMobi.show( event.type, event.placementId, { yAlign="top" } )
 
    elseif ( event.phase == "failed" ) then  -- The ad failed to load
        print( event.type )
        print( event.placementId )
        print( event.isError )
        print( event.response )
    end
end
 
-- Initialize the InMobi plugin
inMobi.init( adListener, { accountId="d97973718b78436a846785837cf90c2f", logLevel="debug" } )

local isAdLoaded = inMobi.isLoaded( placementID )
print( isAdLoaded )


local function savedata( datatosave )
	print("savedata")
	local saveData = datatosave
	local path = system.pathForFile( "savedequations.txt", system.DocumentsDirectory )
	local file, errorString = io.open( path, "w" )

	if not file then
    	-- Error occurred; output the cause
    	print( "File error: " .. errorString )
	else
    	-- Write data to file
    	file:write( datatosave )
    	-- Close the file handle
    	io.close( file )
	end

	file = nil
end

local function doesFileExist( fname, path )

    local results = false

    -- Path for the file
    local filePath = system.pathForFile( fname, path )

    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )

        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
            savedata( "|ohms law,v=i*r,v,i,r,|force,f=m*a,f,m,a,|area of rectangle,a=b*w,a,b,w,|" )

        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end

    return results
end

--if system.pathForFile() == nil then
--	savedata( "|ohms law,v=i*r,v,i,r,|force,f=m*a,f,m,a,|area of rectangle,a=b*w,a,b,w,|" )
--end
local function dataretrieve( parentlist )
	--inMobi.init( adListener, { accountId="d97973718b78436a846785837cf90c2f", logLevel="debug" } )
	local path = system.pathForFile( "savedequations.txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
    	-- Error occurred; output the cause
    	print( "File error: " .. errorString )
	else
    	-- Read data from file
    	local contents = file:read( "*a" )
    	parentlist = contents
    	print(contents)
    	print(parentlist)
    	print("contents")
    	-- Output the file contents
    	print( "Contents of " .. path .. "\n" .. contents )
    	-- Close the file handle
	    io.close( file )
	end

	file = nil
	return parentlist
end

--savedata was here
local function separator( parentlist )
	if vardefvar == 0 then
	listvar = string.sub(parentlist,string.find(parentlist,"|"..textBoxa.text..",")+1,string.find(parentlist,"|",string.find(parentlist,"|"..textBoxa.text..",")+1))
	end
	--
	--print("parentlist")
	print(listvar)
	if vardefvar == 1 and _G[string.sub(equation,2)] ~= nil then
		textc = _G[string.sub(equation,2)]
	end
	if vardefvar == 0 then
		selectvar = 1
		selectvar = string.find(listvar,",")
		name = string.sub(listvar, 1, selectvar-1)
		equation = string.sub(listvar, selectvar+1, string.find(listvar,",", selectvar+1)-1)
		selectvar = string.find(listvar,",",selectvar+1)
		answervar = string.sub(listvar, selectvar+1, string.find(listvar,",", selectvar+1)-1)
		selectvar = string.find(listvar,",",selectvar+1)
		while string.find(listvar, ",", selectvar+2) ~= 0 and string.find(listvar, ",", selectvar+1) ~= nil do
			print(string.find(listvar, ",", selectvar+1))
			var = string.sub(listvar, selectvar+1, string.find(listvar,",", selectvar+1)-1)
			print(var)
			_G[var] = 0
			print(_G[var])
			--print(string.format(_G[string.sub(listvar, selectvar+1, string.find(listvar,",", selectvar+1)-1)]))
			selectvar = string.find(listvar,",",selectvar+1)
		end
		--var = string.sub(listvar, selectvar+1, string.find(listvar,",", selectvar+1)-1)
		--print(var)
		--_G[var] = 0
		--print(_G[var])
		print(name, equation, answervar)
		vardefvar = 1
	end
end



local function exec( name )
	return _G[name]
end
local function eval( str )
	return loadstring('return '..str)()
end
local function handleButtonEvent( event )
	if ( "ended" == event.phase ) then
		if separator == nil then
			parentlist = dataretrieve(parentlist)
		end
		if textBoxa.text == "edit" then
			textbinfo = "Input a new equation in this format: equation name,equation,answer variable (eg. f for f=ma),and the remaining variables separated by comas (no spaces though)"
			savedata(parentlist..textBoxb.text..",|")
		end
		if textBoxa.text ~= "edit" and textBoxa.text ~= "" and parentlist ~= nil then
			separator( parentlist )
        end
        print( "Button was pressed and released" )
        --selectvar = tonumber(textBoxb.text)
        _G[textBoxa.text] = tonumber(textBoxb.text)
        print(_G[textBoxa.text])
        print(textBoxa.text)
        print(string.sub(equation,3))
        print(eval(string.sub(equation,3)))
        textc.text = eval(string.sub(equation,3))
        textainfo.text = ""
    	textbinfo.text = ""
    	textdinfo.text = "Input variables and press input"
    	textcinfo.text = "Input what each variable is equal to"
		--tonumber(selectvar) = tonumber(textBoxb.text)
		--print(_G["i*r"])
		--if _G[textBoxa.text] == 3 then
		--	print("test")
		--	print(r)
		--end
		--if not i == nil and not r == nil then
		--	textc.text = i
		--end
    end
	--print("test")
	
end
--throws error without this
view = 0
---------
local button = widget.newButton(
	{
		left = 0,
		top = 300,
		defaultFile="inputbuttontoolbox.png",
		overFile="inputbuttontoolbox.png",
		id = "button",
		label = "",
		onEvent = handleButtonEvent
	}
)

local function handleButtonEvent2( event )
	vardefvar = 0
	textbinfo.text = ""
	textainfo.text = "Input formula ->"
	textcinfo.text = ""
	textdinfo.text = ""
end

local button2 = widget.newButton(
	{
		left = 175,
		top = 300,
		defaultFile="resetbuttontoolbox.png",
		overFile="resetbuttontoolbox.png",
		id = "button2",
		label = "",
		onEvent = handleButtonEvent2
	}
)

local function isempty(s)
	return s == nil or s == '' or s == '-'
end
vardefvar = 0
selectvar = ""
var = ""
equation = ""
name = ""
step = 1
answervar = ""
parentlist = dataretrieve( parentlist )
print(parentlist)
--parentlist = "|ohms law,v=i*r,v,i,r,|force,f=m*a,f,m,a,|area of rectangle,a=b*w,a,b,w,|"
listvar = "|ohms law,v=i*r,v,i,r,|"
textboxspace = 0
texta = display.newText( "textBoxa", 9000, 25, native.systemFont, 16 )
textb = display.newText( "textBoxb", 9000, 150, native.systemFont, 16 )
textc = display.newText( "", 150, 275, native.systemFont, 16 )
textainfo = display.newText( "Input formula ->", 90, 100, native.systemFont, 16 )
textbinfo = display.newText( "", 90, 200, native.systemFont, 16 )
textcinfo = display.newText( "", 150, 150, native.systemFont, 16 )
textdinfo = display.newText( "", 150, 50, native.systemFont, 16 )
local function textListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( event.target.text )

    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
        texta.text = ( textBoxa.text )
        textb.text = tonumber(textBoxb.text)
        textc.text = _G["3*5"]
        --textc.text = textBoxc.text
        if not isempty(textc.text) then
        	--selectvar=loadstring(textBoxa.text)
        	--textBoxb.text=tonumber(textBoxa.text)
        	--print((loadstring(textBoxb.text)))
        	--textBoxb.text=(loadstring(textBoxa.text))
        	--print(textBoxa.text)
        	--if not isempty(vard) and vard == 1 then
        		--print("vard")
        		--print(tonumber(textBoxa.text))
        		--print("vard")
    		--end
    		textc.text = _G[string.sub(equation,2)]
    		if not r == nil and not i == nil then
    			textc.text = string.format(i*r)
			end
    	end
	end
end
textBoxa = native.newTextField( 230, 100, 150, 50, vara )
textBoxa.inputType = "default"
textBoxa:addEventListener( "userInput", textListener )
textBoxb = native.newTextField( 230, 200, 150, 50, vara )
textBoxb.inputType = "default"
textBoxb:addEventListener( "userInput", textListener )
--print "test"
--widget_button:setEnabled(true)

local results = doesFileExist( "savedequations.txt", system.DocumentsDirectory )
if isAdLoaded == true then
	textbinfo.text = "true"
else
	textbinfo.text = "false"
end
--Made by Brendan Smith