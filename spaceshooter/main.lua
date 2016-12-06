
-- general stuff
display.setStatusBar(display.HiddenStatusBar)
local cWidth = display.contentCenterX
local cHeight = display.contentCenterY

-- physics
local physics = require("physics")
physics.start()
physics.setGravity( 0,0)

-- groups
local enemies = display.newGroup()

-- global variables
-- global variables
local numberofticks = 0
local gameActive = true
local waveProgress = 1
local numHit = 0
local shipMoveX = 0
local shipMoveY = 0
local ship 
local speed = 10
local shootbtn
local numEnemy = 0
local enemyArray = {}
local totalBull = 0
local bullArray = {}
local state = "easy"
local curveMod = 1
local maxShots = 5
local curveOk = false
local ammoOk = false
local scoreMod = 1
local maxSpawn = 2
local timeKeepSec = 0
local timeKeepMin = 0
local did
local cheese
local bestScore = 0
local bdis
--add enemy arrays for other types of enemies
local onCollision
local score = 0
local gameovertxt
local numBullets = 15
local ammo
local AmmoActive = true

-- global functions
local removeEnemies
local createGame
--enemy
local createEnemy
local createSmallEnemy
local createMediumEnemy
local createLargeEnemy
local createCurvingEnemy
local createSmallCurvingEnemy
local createMediumCurvingEnemy
local createLargeCurvingEnemy

local shoot
local createShip
local newGame
local gameOver
local nextWave
local checkforProgress
local createAmmo
local setAmmoOn
local backgroundMusic
local timeKeep

--- audio
local shot = audio.loadSound ("laserbeam.mp3")
local wavesnd = audio.loadSound ("wave.mp3")
local ammosnd = audio.loadSound ("ammo.mp3")
local backgroundsnd = audio.loadStream ( "musicbackground.mp3")


	-- background
	local background = display.newImage("spacebackground.png")
	background.x = cWidth
	background.y = cHeight
	
	-- score 
	textScore = display.newText("Score: "..score, 10, 10, nil, 12)
	textWave = display.newText ("Wave: "..waveProgress, 10, 30, nil, 12)
	textBullets = display.newText ("Bullets: "..numBullets, 10, 50, nil, 12)

	-- set gamepad of the game
	local leftArrow = display.newImage("left.png")
	leftArrow.x = 30
	leftArrow.y = display.contentHeight - 30
	local rightArrow = display.newImage("right.png")
	rightArrow.x = 80
	rightArrow.y =display.contentHeight -30
	
	-- create shootbutton
	shootbtn = display.newImage("shootbutton.png")
	shootbtn.x = display.contentWidth -33
	shootbtn.y = display.contentHeight -33
	
	
	-- create gamepad
	local function stopShip(event)
		if event.phase == "ended" then
			shipMoveX = 0 
		end
	end
	

	local function moveShip(event)
		ship.x = ship.x + shipMoveX
		
	end
	

	function leftArrowtouch()
		shipMoveX = - speed
	end
	

	function rightArrowtouch()
		shipMoveX = speed
	end
	
	
	local function createWalls(event)	
		if ship.x < 0 then
			ship.x = 0
		end
		if ship.x > display.contentWidth then
			ship.x = display.contentWidth
		end
	end
	
	-- this will be the PC controls
	-- Called when a key event has been received
	local function onKeyEvent( event )
		if(event.phase == "up" and event.keyName ~= "space") then
			shipMoveX = 0
			shipMoveY = 0
		end

		-- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
		if ( event.keyName == "left" )and(event.phase == "down") then
			    
					shipMoveX =  - speed
				
		
		elseif(event.keyName == "right") and(event.phase == "down") then
			
			 shipMoveX = speed
			
		end

		if(event.keyName == "up" and ship.y > display.contentHeight - 200 and(event.phase == "down") ) then
			ship.y = ship.y  - speed*3
		elseif (event.keyName == "down" and ship.y < display.contentHeight and(event.phase == "down")  ) then
			ship.y = ship.y + speed*3
		end

		
		if(event.keyName == "space") and(totalBull <maxShots) and(event.phase == "down") then
			--numBullets = numBullets - 1
			if(state == "hard" and numBullets ~= 0) then
				numBullets = numBullets - 1
				local bullet = display.newImage("bullet.png")
				physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
				totalBull = totalBull +1
				
				bullet.x = ship.x 
				bullet.y = ship.y 
				bullet.myName = "bullet"
				textBullets.text = "Bullets "..numBullets
				transition.to ( bullet, { time = 1000, x = ship.x, y =-100} )



				table.insert(bullArray,bullet)

				audio.play(shot)
			else 
				local bullet = display.newImage("bullet.png")
				physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
				totalBull = totalBull +1
				
				bullet.x = ship.x 
				bullet.y = ship.y 
				bullet.myName = "bullet"
				textBullets.text = "Bullets "..numBullets
				transition.to ( bullet, { time = 1000, x = ship.x, y =-100} )



				table.insert(bullArray,bullet)

				audio.play(shot)
			end
		end


		--end 



		-- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
		-- This lets the operating system execute its default handling of the key
		return false
	end
	 

	-- Add the key event listener
	
		
function createShip()
	ship = display.newImage ("ship.png")
	physics.addBody(ship, "static", {density = 1, friction = 0, bounce = 0});
	ship.x = cWidth
	ship.y = display.contentHeight - 80
	ship.myName = "ship"
end
function createCurvingEnemy( )
	numEnemy = numEnemy +1 
	print("new curving enemy respawned :"..numEnemy)
		  	enemies	:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_large.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "curvingEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-500, -100)
			enemyArray[numEnemy] .y = startlocationY
		
			transition.to ( enemyArray[numEnemy] , { time = math.random (2000, 8000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end
function createSmallCurvingEnemy( )
	numEnemy = numEnemy +1 
	print("new curving enemy respawned :"..numEnemy)
		  	enemies	:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_small.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "curvingEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-500, -100)
			enemyArray[numEnemy] .y = startlocationY
		
			transition.to ( enemyArray[numEnemy] , { time = math.random (2000, 8000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end
function createMediumCurvingEnemy( )
	numEnemy = numEnemy +1 
	print("new curving enemy respawned :"..numEnemy)
		  	enemies	:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_medium.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "curvingEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-500, -100)
			enemyArray[numEnemy] .y = startlocationY
		
			transition.to ( enemyArray[numEnemy] , { time = math.random (2000, 8000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end
function createLargeCurvingEnemy( )
	numEnemy = numEnemy +1 
	print("new curving enemy respawned :"..numEnemy)
		  	enemies	:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_large.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "curvingEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-500, -100)
			enemyArray[numEnemy] .y = startlocationY
		
			transition.to ( enemyArray[numEnemy] , { time = math.random (2000, 8000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end

function createEnemy()
	numEnemy = numEnemy +1 

	print("new enemy respawned :"..numEnemy)
			enemies:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_medium.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "enemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-100, -25)
			enemyArray[numEnemy] .y = startlocationY
			
			
			transition.to ( enemyArray[numEnemy] , { time = math.random (8000, 15000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end

function createLargeEnemy()
	numEnemy = numEnemy +1 

	print("new enemy respawned :"..numEnemy)
			enemies:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_large.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "largeEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-100, -25)
			enemyArray[numEnemy] .y = startlocationY
			
			transition.to ( enemyArray[numEnemy] , { time = math.random (8000, 15000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end

function createMediumEnemy()
	numEnemy = numEnemy +1 

	print("new enemy respawned :"..numEnemy)
			enemies:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_medium.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "mediumEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-100, -25)
			enemyArray[numEnemy] .y = startlocationY
			
			transition.to ( enemyArray[numEnemy] , { time = math.random (8000, 15000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end

function createSmallEnemy()
	numEnemy = numEnemy +1 

	print("new enemy respawned :"..numEnemy)
			enemies:toFront()
			enemyArray[numEnemy]  = display.newImage("asteroid_small.png")
			physics.addBody ( enemyArray[numEnemy] , {density=0.5, friction=0, bounce=1})
			enemyArray[numEnemy] .myName = "smallEnemy" 
			startlocationX = math.random (0, display.contentWidth)
			enemyArray[numEnemy] .x = startlocationX
			startlocationY = math.random (-100, -25)
			enemyArray[numEnemy] .y = startlocationY
			
			transition.to ( enemyArray[numEnemy] , { time = math.random (8000, 15000), x= math.random (0, display.contentWidth ), y=ship.y+500 } )
			enemies:insert(enemyArray[numEnemy] )
end

function createAmmo()
	
		ammo = display.newImage("ammo.png")
		physics.addBody ( ammo,  {density=0.5, friction=0, bounce=0 })
		ammo.myName = "ammo" 
		startlocationX = math.random (0, display.contentWidth)
		ammo .x = startlocationX
		startlocationY = math.random (-500, -100)
		ammo .y = startlocationY
		ammo.rotation = 0
		transition.to ( ammo, {time = math.random (5000, 10000 ), x= math.random (0, display.contentWidth ), y=ship.y+500 } ) 
	
		local function rotationAmmo ()
			if ammo.rotation ~=nil then
				ammo.rotation = ammo.rotation + 45
			end
		end
		if(ammo.rotation ~= nil) then
			rotationTimer = timer.performWithDelay(200, rotationAmmo, -1)
		end
		
end

	function shoot(event)
		
		if (numBullets ~= 0) then
			numBullets = numBullets - 1
			local bullet = display.newImage("bullet.png")
			physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
			bullet.x = ship.x 
			bullet.y = ship.y 
			bullet.myName = "bullet"
			textBullets.text = "Bullets "..numBullets
			transition.to ( bullet, { time = 1000, x = ship.x, y =-100} )
			audio.play(shot)
		end 
		
	end
 

function onCollision(event)
	if(event.object1.myName =="ship" and (event.object2.myName=="enemy" or string.find(event.object2.myName, "Enemy") )) then	
			
			
			--local function setgameOver()
			--gameovertxt = display.newText(  "Game Over", cWidth-110, cHeight-100, "Arcade", 50 )
			--gameovertxt:addEventListener("tap",  newGame)
			if(score > 1500 and state == "hard") then
				score =math.floor( score * .75)
			elseif (score > 1000 and state == "medium") then
				score = math.floor(score * .9)
			else 
				score = score - 100
			end
			event.object2:removeSelf()
			event.object2.myName=nil
			-- use setgameover after transition complete to avoid that user clicks gameover before the transition is completed
			--transition.to( ship, { time=1500, xScale = 0.4, yScale = 0.4, alpha=0, onComplete=setgameOver  } )
			--gameActive = false
			--removeEnemies()
			--audio.fadeOut(backgroundsnd)
			--audio.rewind (backgroundsnd)
			
	end	
	
	if(event.object1.myName =="ship" and event.object2.myName =="ammo") then
		local function sizeBack()
		ship.xScale = 1.0
		ship.yScale = 1.0 
		
		end
		transition.to( ship, { time=500, xScale = 1.2, yScale = 1.2, onComplete = sizeBack  } )
		numBullets = numBullets + 3 
		textBullets.text = "Bullets "..numBullets
		event.object2:removeSelf()
		event.object2.myName=nil
		timer.cancel(rotationTimer)
		audio.play(ammosnd)
		
	end

	if((event.object1.myName=="enemy" or string.find(event.object1.myName, "Enemy")) and event.object2.myName=="bullet")  then
			event.object1:removeSelf()
			event.object1.myName=nil
			--event.object2:removeSelf()
			--event.object2.myName=nil
			score = score + (10*scoreMod)
			textScore.text = "Score: "..score
			numHit = numHit + 1
			--totalBull = totalBull -1
			print ("numhit "..numHit)
	end
	
		if(event.object1.myName=="bullet" and (event.object2.myName=="enemy" or string.find(event.object2.myName, "Enemy") )) then
			--event.object1:removeSelf()
			--event.object1.myName=nil
			event.object2:removeSelf()
			event.object2.myName=nil
			score = score + 10
			textScore.text = "Score: "..score
			numHit = numHit + 1
			--totalBull = totalBull -1
			print ("numhit "..numHit)
		end
	
	
end

function removeEnemies()
	for i =1, #enemyArray do
		if (enemyArray[i].myName ~= nil) then
		enemyArray[i]:removeSelf()
		enemyArray[i].myName = nil
		end
	end
end


function newGame(event)	
		display.remove(event.target)	
		textScore.text = "Score: 0"
		numEnemy = 0
		ship.alpha = 1
		ship.xScale = 1.0
		ship.yScale = 1.0
		score = 0
		gameActive = true
		waveProgress = 1	
		backgroundMusic()
		numBullets = 3
		textBullets.text = "Bullets "..numBullets
		AmmoActive = true
end

function nextWave (event)
	display.remove(event.target)
	numHit = 0
	gameActive = true 
end

function setAmmoOn()
		AmmoActive = true
end
-- controls spawning of ammo and enemies. bullets only apply when on hard mode
function ammoStatus()
	
	if gameActive then
		for i =1, maxSpawn do
			rand=math.random(0,3)
			if rand==0 then
				createSmallEnemy()
			elseif rand ==1 then
				createMediumEnemy()
			else
				createLargeEnemy()
			end
		end
		if(curveOk) then
			for i=1, maxSpawn-2 do
				rand=math.random(0,3)
				if rand==0 then
					createSmallCurvingEnemy()
				elseif rand ==1 then
					createMediumCurvingEnemy()
				else
					createLargeCurvingEnemy()
				end
			end
		end
		if AmmoActive and ammoOk then
			if (numBullets == 0) then
		 	createAmmo()
		 	AmmoActive = false 	
			end
			if (numBullets == 1) then
		 	createAmmo()
		 	AmmoActive = false 	
			end
			if (numBullets == 2) then
		 	createAmmo()
		 	AmmoActive = false 	
			end
			if (numBullets == 4) then
		 	createAmmo()
		 	AmmoActive = false 	
			end
		end
	end

	
end

local function aplyCurve( )
	numberofticks=numberofticks+1
	--print("numberofticks: "..numberofticks)
	for i =1, #enemyArray do
		if (enemyArray[i].myName ~= nil) and (enemyArray[i].myName=="curvingEnemy")then
			--print("giving the curve")
			enemyArray[i].x = enemyArray[i].x + math.sin(numberofticks /100 * math.pi) * 200
			--print('curve given is ' .. math.sin(numberofticks /180 * math.pi) * 30)
		end
	end
end

local function checkforProgress()
		if numHit == (math.floor(math.exp(waveProgress*2+1)-waveProgress*2+3)) then
			gameActive = false
			audio.play(wavesnd)
			removeEnemies()
			waveTxt = display.newText(  "Wave "..waveProgress.. " Completed", cWidth-80, cHeight-100, nil, 20 )
			waveProgress = waveProgress + 1
			textWave.text = "Wave: "..waveProgress
			print("wavenumber "..waveProgress)
			waveTxt:addEventListener("tap",  nextWave)
		end
	
	-- remove enemies which are not shot
	
	for i =1, #enemyArray do
		if (enemyArray[i].myName ~= nil) then
			if(enemyArray[i].y > display.contentHeight) then
			    enemyArray[i]:removeSelf()
			    enemyArray[i].myName = nil
				score = score - (20*scoreMod) 
				textScore.text = "Score: "..score
				warningTxt = display.newText(  "Watch out!", cWidth-42, ship.y-50, nil, 12 )
					local function showWarning()
					display.remove(warningTxt)
					end
				timer.performWithDelay(1000, showWarning)
				print("cleared")
		end
		end
	end
end

-- play background music
function backgroundMusic()
	audio.play (backgroundsnd, { loops = -1})
	audio.setVolume(0.5, {backgroundsnd} ) 	
end
-- outline code for state machine conditions
function gameLoop()
    bestScore = math.max(bestScore,score)
	if(#bullArray ~= 0) then
		for i = 1, #bullArray do
			if(bullArray[i].y < 0) then
				table.remove(bullArray,i)
				totalBull = totalBull -1
				break
			end
		end
	end
	
	if(score > 500 and score < 1500) then
		state = "medium"
	elseif(score >=1500 ) then
		state = "hard"
	else 
		state = "easy"
	end 
	
	
	if (state == "easy")then
		curveOk = false
		ammoOk = false
		scoreMod = 1
		maxShots = 5
		if(score <100) then
			maxSpawn = 1
		else 
			maxSpawn = 2
		end
	elseif(state == "medium") then
		ammoOk = false
		curveOk = true
		curveMod = 1
		scoreMod = 2
		maxShots = 3
		maxSpawn = 3
	elseif (state == "hard")then 
		ammoOk = true
		curveOk = true
		curveMod = math.floor(math.random(1,5))
		scoreMod = 3
		maxShots = 1
		maxSpawn = 5
	end 
	moveShip()
	 
end
--time keeper
function timeKeep()
	display.remove(did)
	did = display.newText(  "Difficulty: "..state, 50, 100, nil, 12 )
	
	score = score + 5
	timeKeepSec = timeKeepSec + 1
	if(timeKeepSec%60 == 0 and timeKeepSec ~= 0) then
		timeKeepMin = timeKeepMin + 1
	end
	display.remove(cheese)
	cheese = display.newText(  "Time: "..timeKeepMin..": "..(timeKeepSec%60), 50, 125, nil, 20 )
	display.remove(bdis)
	bdis = display.newText(  "Best Score: "..bestScore, 80, 150, nil, 20 )
	
end
-- heart of the game
function startGame()
createShip()
--backgroundMusic()

createCurvingEnemy()
did = display.newText(  "Difficulty: "..state, 50, 100, nil, 12 )
cheese = display.newText(  "Time: "..timeKeepMin..": "..(timeKeepSec%60), 50, 125, nil, 20 )
bdis = display.newText(  "Best Score: "..bestScore, 80, 150, nil, 20 )


--createCurvingEnemy()
createSmallEnemy()
createMediumEnemy()
createLargeEnemy()
createSmallCurvingEnemy()
createMediumCurvingEnemy()
createLargeCurvingEnemy()


shootbtn:addEventListener ( "tap", shoot )
rightArrow:addEventListener ("touch", rightArrowtouch)
leftArrow:addEventListener("touch", leftArrowtouch)
Runtime:addEventListener("enterFrame", createWalls)
Runtime:addEventListener("enterFrame", moveShip)
Runtime:addEventListener("touch", stopShip)
Runtime:addEventListener("collision" , onCollision)
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener("enterFrame", gameLoop)

timer.performWithDelay(2000, ammoStatus,0)
timer.performWithDelay ( 5000, setAmmoOn, 0 )
timer.performWithDelay(300, checkforProgress,0)
timer.performWithDelay(10*curveMod, aplyCurve,0)
timer.performWithDelay(1000, timeKeep, 0)



end

startGame()
