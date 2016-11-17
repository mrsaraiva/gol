-- Variables
local aliveA = 0
local aliveAText
local aliveB = 0
local aliveBText
local cell = {}
local clearButton
local debugButton
local gbOffsetX
local gbOffsetY
local grid = display.newImageRect("img/grid@4x.png", 300, 300)
local gridEmpty = false
local isRunning = false
local lastObject
local pauseButton
local runButton
local runSpeed = 16.67
local speedSlider
local stepButton
local totalBirth = 0
local totalBirthText
local totalDeath = 0
local totalDeathText
local wasPrimaryMouseButtonDown = false
local wasMiddleMouseButtonDown = false
local wasSecondaryMouseButtonDown = false
local widget = require( "widget" )

-- Grid Variables
local GRID_WIDTH = 20
local GRID_HEIGHT = 20
local CELL_WIDTH = 15
local CELL_HEIGHT = 15

-- Functions forward declaration
local clearGrid
local clearPiece
local gol
local initCounters
local initGrid
local pauseGOL
local printGrid
local printTable
local runGOL
local setSpeed
local stepGOL
local spawnPiece
local updateCounters

-- Functions implementation
clearGrid = function()
	for i = 1, GRID_HEIGHT do
		for j = 1, GRID_WIDTH do
			clearPiece(cell[i][j])
		end
	end
	initCounters()
	initGrid()
end

clearPiece = function(piece, mode)
	if (piece) then
		local xPos = piece.xPos
		local yPos = piece.yPos

		if (mode == "auto" or mode == "manual") then
			if (piece.type == "red") then
				if (aliveA > 0) then
					aliveA = aliveA - 1
				end
			elseif (piece.type == "white") then
				if (aliveB > 0) then
					aliveB = aliveB - 1
				end
			end
			totalDeath = totalDeath + 1
			updateCounters()
		end

		piece:removeSelf()
		piece = nil
		cell[xPos][yPos] = piece 
	end	
end

getNeigh = function(xPos, yPos)
	local neigh = {}
	neigh.qtyNeighA = 0
	neigh.qtyNeighB = 0 
	--print("getNeigh xPos: " .. xPos)
	--print("getNeigh yPos: " .. yPos)
	for i = xPos - 1, xPos + 1 do
		for j = yPos - 1, yPos + 1 do
			if((i >= 1 and i <= GRID_WIDTH) and (j >= 1 and j <= GRID_HEIGHT)) then
				if(i ~= xPos or j ~= yPos) then
					--print(i .. "," .. j)
					local neighPiece = cell[i][j]
					if(neighPiece ~= nil) then
						if(neighPiece.type == "red") then
							neigh.qtyNeighA = neigh.qtyNeighA + 1 
						else
							neigh.qtyNeighB = neigh.qtyNeighB + 1
						end
					end
				end
		 	end
		end
	end

	return neigh
end

initCounters = function()
	aliveA = 0
	aliveB = 0
	totalBirth = 0
	totalDeath = 0
	updateCounters()
end

initGrid = function()
	for i = 1, GRID_HEIGHT do
		cell[i] = {}
		for j = 1, GRID_WIDTH do
			cell[i][j] = nil
		end
	end
end

onMouseEvent = function(event)
	-- Print the mouse cursor's current position to the log.
	--local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
	--print( message )
	--for k, v in pairs( event ) do
	--	print(k, v)
	--end
	local rxPos = event.x
	local ryPos = event.y
	-- printTable(event)

	if ((rxPos >= 90 and rxPos <= 388) and (ryPos >= 10 and ryPos <= 308)) then
		if (wasPrimaryMouseButtonDown and event.type == "up") then
			-- The right mouse button has just been released.
			print("Left mouse button click")
			-- xPos = math.floor(((CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX)))
			xPos = math.floor(((rxPos + CELL_WIDTH - 0.5 * CELL_WIDTH + gbOffsetX) / CELL_WIDTH) - 11.5)
			yPos = math.floor(((ryPos + CELL_HEIGHT - 0.5 * CELL_HEIGHT + gbOffsetX) / CELL_HEIGHT) - 6.15)
			pieceType = "red"
			print("Cursor X" .. rxPos)
			print("Cursor Y" .. ryPos) 
			print("Board Piece X " .. xPos)
			print("Board Piece Y " .. yPos)
			clearPiece(cell[xPos][yPos], "manual")
			cell[xPos][yPos] = spawnPiece(xPos, yPos, pieceType, "manual")
			lastObject = cell[xPos][yPos]

			-- If you return true, then the mouse event will not be dispatched to
			-- display objects below the mouse cursor.
			wasHandled = true
		end

		if (wasSecondaryMouseButtonDown and event.type == "up") then
			-- The right mouse button has just been released.
			print("Right mouse button click")
			-- xPos = math.floor(((CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX)))
			xPos = math.floor(((rxPos + CELL_WIDTH - 0.5 * CELL_WIDTH + gbOffsetX) / CELL_WIDTH) - 11.5)
			yPos = math.floor(((ryPos + CELL_HEIGHT - 0.5 * CELL_HEIGHT + gbOffsetX) / CELL_HEIGHT) - 6.15)
			pieceType = "white"
			print("Cursor X" .. rxPos)
			print("Cursor Y" .. ryPos) 
			print("Board Piece X " .. xPos)
			print("Board Piece Y " .. yPos)
			clearPiece(cell[xPos][yPos], "manual")
			cell[xPos][yPos] = spawnPiece(xPos, yPos, pieceType, "manual")
			lastObject = cell[xPos][yPos]
			-- If you return true, then the mouse event will not be dispatched to
			-- display objects below the mouse cursor.
			wasHandled = true
		end
		
		if (wasMiddleMouseButtonDown and event.type == "up") then
			-- The right mouse button has just been released.
			print("Middle mouse button click")
			-- xPos = math.floor(((CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX)))
			xPos = math.floor(((rxPos + CELL_WIDTH - 0.5 * CELL_WIDTH + gbOffsetX) / CELL_WIDTH) - 11.5)
			yPos = math.floor(((ryPos + CELL_HEIGHT - 0.5 * CELL_HEIGHT + gbOffsetX) / CELL_HEIGHT) - 6.15)
			pieceType = "white"
			clearPiece(cell[xPos][yPos], "manual")
			-- If you return true, then the mouse event will not be dispatched to
			-- display objects below the mouse cursor.
			wasHandled = true
		end
	
	end


	-- Store the current left button state for the next mouse event call.
	wasPrimaryMouseButtonDown = event.isPrimaryButtonDown

	-- Store the current middle button state for the next mouse event call.
	wasMiddleMouseButtonDown = event.isMiddleButtonDown

	-- Store the current right button state for the next mouse event call.
	wasSecondaryMouseButtonDown = event.isSecondaryButtonDown   
end

pauseGOL = function()
	if (isRunning) then
		timer.cancel(golTimer)
		isRunning = false
	end
end

printTable = function(tbl)
	for k, v in pairs( tbl ) do
		print(k, v)
	end
end

printGrid = function()
	for i = 1, GRID_WIDTH do
		for j = 1, GRID_HEIGHT do
			if (cell[i][j]) then
				print("Position[" .. i .. "][" .. j .. "]")
				printTable(cell[i][j])
			end
		end
	end
end

runGOL = function()
	if (not isRunning) then
		golTimer = timer.performWithDelay(runSpeed, gol, -1)
		isRunning = true
	end
end

setSpeed = function( event )
	local value = 1000 - (event.value * 10)
	if (value <= 10) then
		value = 16.67
	end
	runSpeed = value
	if (isRunning) then
		printTable(golTimer)
		golTimer._delay = runSpeed
		printTable(golTimer)
	end
end

spawnPiece = function( xPos, yPos, pieceType, mode )
	print("spawning " .. pieceType .. " piece")

	if xPos < 1 or xPos > GRID_WIDTH or yPos < 1 or yPos > GRID_HEIGHT then
		print( "Position out of range:", xPos, yPos )
		return nil
	end

	local piece = display.newImageRect( "img/token_" .. pieceType .. "@4x.png", CELL_WIDTH, CELL_HEIGHT )
	--
	-- record the pieces logical position on the board
	--
	piece.xPos = xPos
	piece.yPos = yPos
	piece.type = pieceType
	piece.alive = "yes"
	--
	-- Position the piece
	--
	piece.x = (xPos - 1) * CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX
	piece.y = (yPos - 1) * CELL_HEIGHT + (CELL_HEIGHT * 0.5) + gbOffsetY

	if (mode == "auto" or mode == "manual") then
		if (pieceType == "red") then
			aliveA = aliveA + 1
		else
			aliveB = aliveB + 1
		end
		totalBirth = totalBirth + 1
		updateCounters()
	end

	return piece
end

stepGOL = function()
	gol()
end

updateCounters = function()
	aliveAText.text = "Alive A: " .. aliveA
	aliveBText.text = "Alive B: " .. aliveB
	totalBirthText.text = "# Births: " .. totalBirth
	totalDeathText.text = "# Deaths: " .. totalDeath
end

-- Main game function

gol = function()
	print("\nGame of Life Iteration Start")
	for i = 1, GRID_HEIGHT do
		for j = 1, GRID_WIDTH do
			piece = cell[i][j]
			if (piece == nil) then
				local neigh = getNeigh(i, j)
				print("Blank piece[" .. i .. "][" .. j .. "] " .. "qtyNeighA: ".. neigh.qtyNeighA)
				print("Blank piece[" .. i .. "][" .. j .. "] " .. "qtyNeighB: ".. neigh.qtyNeighB)
				if (neigh.qtyNeighA == 3) then
					cell[i][j] = spawnPiece(i, j, "red", "auto")
				elseif (neigh.qtyNeighB == 4) then
					cell[i][j] = spawnPiece(i, j, "white", "auto")
				end
			else
				local neigh = getNeigh(i, j)
				if (piece.type == "red") then
					local numNeigh = neigh.qtyNeighA
					print("Red piece[" .. i .. "][" .. j .. "] " .. "qtyNeighA: ".. neigh.qtyNeighA)
					if (piece.alive == "yes") then
						local deathReason = nil

						if (numNeigh == 2) then
							print("This fella has the right number of neighbors, he shall survive")							
						else
							if (numNeigh < 2) then
								deathReason = "Loneliness"
							end

							if (numNeigh > 3) then
								deathReason = "Overpopulation"
							end
						end

						if (deathReason) then
							piece.alive = "no"
							print("Marked as dead. Reason: " .. deathReason)
						end
					else
						clearPiece(piece, "auto")
						print("Piece cleared")
					end
				else
					local numNeigh = neigh.qtyNeighB
					print("White piece[" .. i .. "][" .. j .. "] " .. "qtyNeighB: ".. neigh.qtyNeighB)
					if (piece.alive == "yes") then
						local deathReason = nil

						if (numNeigh == 2 or numNeigh == 3) then
							print("This fella has the right number of neighbors, he shall survive")							
						else
							if (numNeigh < 4) then
								deathReason = "Loneliness"
							end

							if (numNeigh > 6) then
								deathReason = "Overpopulation"
							end
						end

						print(deathReason)
						if (deathReason) then
							piece.alive = "no"
							print("Marked as dead. Reason: " .. deathReason)
						end
					else
						clearPiece(piece, "auto")
						print("Piece cleared")
					end
				end
			end
		end
	end
	print("Game of Life Iteration End")
end

-- Position Background
grid.x = display.contentCenterX
grid.y = display.contentCenterY

-- 
-- Position Buttons
runButton = widget.newButton(
    {
        label = "Run",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 55,
        height = 20,
        cornerRadius = 6,
        fillColor = { default={ 0, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
        strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } },
        strokeWidth = 0,
		x = 28,
		y = 20
    }
)

pauseButton = widget.newButton(
    {
        label = "Pause",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 55,
        height = 20,
        cornerRadius = 6,
        fillColor = { default={ 0, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
        strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } },
        strokeWidth = 0,
		x = 28,
		y = 45
    }
)

stepButton = widget.newButton(
    {
        label = "Step",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 55,
        height = 20,
        cornerRadius = 6,
        fillColor = { default={ 0, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
        strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } },
        strokeWidth = 0,
		x = 28,
		y = 70
    }
)

clearButton = widget.newButton(
    {
        label = "Clear",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 55,
        height = 20,
        cornerRadius = 6,
        fillColor = { default={ 0, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
        strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } },
        strokeWidth = 0,
		x = 28,
		y = 95
    }
)

debugButton = widget.newButton(
    {
        label = "Debug",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 55,
        height = 20,
        cornerRadius = 6,
        fillColor = { default={ 0, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
        strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } },
        strokeWidth = 0,
		x = 28,
		y = 120
    }
)

speedSlider = widget.newSlider(
    {
		orientation = "vertical",
        top = 150,
        left = 8,
        height = 100,
        value = 100,
        listener = setSpeed
    }
)

speedSliderLabel = display.newText("Iteration Speed", 25, 285)

-- Position Counters
aliveAText = display.newText("Alive A: " .. aliveA, 430, 20, native.systemFont, 12)
aliveBText = display.newText("Alive B: " .. aliveB, 430, 40, native.systemFont, 12)
totalBirthText = display.newText("# Births: " .. totalBirth, 432, 60, native.systemFont, 12)
totalDeathText = display.newText("# Deaths: " .. totalDeath, 435, 80, native.systemFont, 12)

-- Button event listeners
clearButton:addEventListener("tap", clearGrid)
debugButton:addEventListener("tap", printGrid)
pauseButton:addEventListener("tap", pauseGOL)
runButton:addEventListener("tap", runGOL)
stepButton:addEventListener("tap", stepGOL)

-- Runtime event listeners
Runtime:addEventListener( "mouse", onMouseEvent )

--
-- Calculate some values
--
gbOffsetX = grid.x - ( grid.width * grid.anchorX ) 
gbOffsetY = grid.y - ( grid.height * grid.anchorY )

-- Program Start
initCounters()
initGrid()