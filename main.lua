local Raycaster = require 'raycasting'

local worldMap = {
	{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },
	{ 1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,1,0,1,1,1,0,1,0,1,1,1,1,0,0,0,1,1,1,1,0,0,1 },
	{ 1,0,1,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1 },
	{ 1,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,0,1,0,1,0,1,0,1 },
	{ 1,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,0,1,0,0,0,1,0,1 },
	{ 1,0,2,1,1,0,1,0,1,0,1,0,0,1,1,0,1,1,1,1,1,1,1,1 },
	{ 1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 },
	{ 1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,1 },
	{ 1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,1,1,1,0,1,1,1 },
	{ 1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1 },
	{ 1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1 },
	{ 1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1 },
	{ 1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1 },
	{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },
}

local raycaster = Raycaster()

local wW = love.graphics.getWidth()
local wH = love.graphics.getHeight()

player = {}
player.pos = {}
player.dir = {}
player.plane = {}
player.pos.x = 10.5
player.pos.y = 10.5
player.dir.x = 0
player.dir.y = 0
player.plane.x = 0
player.plane.y = 0
player.plane.angle = 0
player.theta = math.pi / 2

camera = {}
camera.fov = 90
camera.skew = 0
camera.stretch = 0

var = 1
local gamma = 0

function love.load()
end

function love.update(dt)
	if love.keyboard.isDown('kp+') then
		var = var + 0.01
	elseif love.keyboard.isDown('kp-') then
		var = var - 0.01
	end

	--gamma = gamma + 0.001
	--var = 1 + 0.7 * math.sin(gamma)

	if love.keyboard.isDown('left') then
		player.theta = player.theta + (90 * math.pi / 180) * dt
	elseif love.keyboard.isDown('right') then
		player.theta = player.theta - (90 * math.pi / 180) * dt
	end

	if love.keyboard.isDown('up', 'down') then
		local newpos = {}
		if love.keyboard.isDown('up') then
			newpos.x = player.pos.x + 3 * math.cos(player.theta) * dt 
			newpos.y = player.pos.y + 3 * math.sin(player.theta) * dt 
		elseif love.keyboard.isDown('down') then
			newpos.x = player.pos.x - 3 * math.cos(player.theta) * dt 
			newpos.y = player.pos.y - 3 * math.sin(player.theta) * dt 
		end
		if worldMap[math.floor(newpos.x)][math.floor(newpos.y)] == 0 then
			player.pos.x = newpos.x
			player.pos.y = newpos.y
		elseif worldMap[math.floor(player.pos.x)][math.floor(newpos.y)] == 0 then
			player.pos.y = newpos.y
		elseif worldMap[math.floor(newpos.x)][math.floor(player.pos.y)] == 0 then
			player.pos.x = newpos.x
		end
	end

	if love.keyboard.isDown('q') then
		camera.skew = camera.skew + dt;
	elseif love.keyboard.isDown('w') then
		camera.skew = camera.skew - dt;
	end

	player.dir.x = math.cos(player.theta)
	player.dir.y = math.sin(player.theta)
	player.plane.x = var * math.sin(player.theta + camera.skew)
	player.plane.y = var * -math.cos(player.theta + camera.skew)

	raycaster:update(dt, worldMap)
end

function love.draw()
	raycaster:draw()

	-- Minimap scale factor and variable importing
	local factor = 10
	local pos = {}
	local dir = {}
	local plane = {}
	pos.x = player.pos.y * factor
	pos.y = player.pos.x * factor
	dir.x = player.dir.y * factor
	dir.y = player.dir.x * factor
	plane.x = player.plane.y * factor
	plane.y = player.plane.x * factor

	-- Player location on the minimap
	love.graphics.setColor(1,1,1,1)
	love.graphics.line(pos.x, pos.y, pos.x + dir.x, pos.y + dir.y)
	love.graphics.line(pos.x + dir.x, pos.y + dir.y, pos.x + dir.x + plane.x, pos.y + dir.y + plane.y)
	love.graphics.line(pos.x + dir.x, pos.y + dir.y, pos.x + dir.x - plane.x, pos.y + dir.y - plane.y)
	love.graphics.setColor(1,0,0,1)
	love.graphics.points(pos.x, pos.y)
	love.graphics.setColor(0,1,0,1)
	love.graphics.points(pos.x + dir.x, pos.y + dir.y)
	love.graphics.setColor(0,0,1,1)
	love.graphics.points(pos.x + dir.x, pos.y + dir.y, pos.x + dir.x + plane.x, pos.y + dir.y + plane.y)
	love.graphics.points(pos.x + dir.x, pos.y + dir.y, pos.x + dir.x - plane.x, pos.y + dir.y - plane.y)

	-- Minimap tiles
	for i = 1,#worldMap do
		for j = 1,#worldMap[i] do
			if worldMap[i][j] > 0 then
				love.graphics.setColor(0,0,1,1)
				love.graphics.polygon('line', j*factor, i*factor, (j+1)*factor, i*factor, (j+1)*factor, (i+1)*factor, j*factor, (i+1)*factor)
			end
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
