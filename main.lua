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

local rays = {}

local wW = love.graphics.getWidth()
local wH = love.graphics.getHeight()

local player = {}
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

local camera = {}
camera.fov = 90
camera.skew = 0
camera.stretch = 0

local var = 1
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

	-- Preparing for main raycasting loop
	local pos = {} -- Player position
	local dir = {} -- Player direction vector
	local plane = {} -- Camera plane vector from direction vector
	pos.x = player.pos.x
	pos.y = player.pos.y
	dir.x = player.dir.x
	dir.y = player.dir.y
	plane.x = player.plane.x
	plane.y = player.plane.y

	rays = {}

	-- Main raycasting loop
	-- Runs loop once per vertical pixel line
	for x = 0,wW do
		local camera_x -- X row position in map
		local hit = false -- Loop bool while it doesn't hit
		local side -- Bool if it ray hits side of tile

		-- Table containing main distances used through the loop
		local dist = {}
		dist.ray = {}
		dist.delta = {}
		dist.side = {}
		dist.step = {}

		camera_x = 2 * x / wW - 1
		dist.ray.x = dir.x + plane.x * camera_x
		dist.ray.y = dir.y + plane.y * camera_x

		local map = {}
		map.x = math.floor(pos.x)
		map.y = math.floor(pos.y)

		-- Distance travelled by ray for one X or one Y unit
		dist.delta.x = math.abs(1 / dist.ray.x)
		dist.delta.y = math.abs(1 / dist.ray.y)

		if dist.ray.x < 0 then
			dist.step.x = -1
			dist.side.x = (pos.x - map.x) * dist.delta.x
		else
			dist.step.x = 1
			dist.side.x = (map.x + 1 - pos.x) * dist.delta.x
		end

		if dist.ray.y < 0 then
			dist.step.y = -1
			dist.side.y = (pos.y - map.y) * dist.delta.y
		else
			dist.step.y = 1
			dist.side.y = (map.y + 1 - pos.y) * dist.delta.y
		end

		-- Increase the ray distance if it hasn't hit a full tile yet
		while not hit do
			if dist.side.x < dist.side.y then
				dist.side.x = dist.side.x + dist.delta.x
				map.x = map.x + dist.step.x
				side = false
			else
				dist.side.y = dist.side.y + dist.delta.y
				map.y = map.y + dist.step.y
				side = true
			end

			if worldMap[map.x][map.y] > 0 then
				hit = true
			end
		end

		-- Set the ray distance based on which side of the tile it hit
		if not side then
			dist.perpWall = (map.x - pos.x + (1 - dist.step.x) / 2) / dist.ray.x
		else
			dist.perpWall = (map.y - pos.y + (1 - dist.step.y) / 2) / dist.ray.y
		end

		-- Set on-screen line start and end positions based on ray distance
		local lineHeight = wH * var / dist.perpWall
		local drawStart = -lineHeight / 2 + wH / 2
		local drawEnd = lineHeight / 2 + wH / 2

		if drawStart < 0 then drawStart = 0 end
		if drawEnd >= wH then drawEnd = wH - 1 end

		-- Set color based on tile number
		local tile = worldMap[map.x][map.y] 
		local colorPalette = {
			{0,1,0,1},
			{0,0,1,1},
			{1,0,0,1},
			{1,1,0,1},
		}

		local tileColor = colorPalette[tile]

		-- Add some shading depending on the side the ray hit
		if side then
			tileColor[4] = tileColor[4] / 2
		end

		--[[
		if dist.perpWall < 20 then
			tileColor[4] = tileColor[4] * ((10 / (dist.perpWall - 20)) + 1)
		else
			tileColor[4] = 0
		end
		--]]

		-- Send back this vertical line's properties to be drawn in love.draw
		local ray = {
			x, drawStart, x, drawEnd,
			tileColor = tileColor,
		}

		table.insert(rays, ray)
	end
end

function love.draw()
	-- Main "3D" drawing loop
	love.graphics.setLineStyle('rough')
	for _, ray in ipairs(rays) do
		love.graphics.setColor(ray.tileColor)
		love.graphics.line(ray)
	end

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
