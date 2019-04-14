local worldMap = {
	{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },
	{ 1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1 },
	{ 1,0,1,0,1,1,1,0,1,0,1,1,1,1,0,0,0,1,1,1,1,0,0,1 },
	{ 1,0,1,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1 },
	{ 1,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,0,1,0,1,0,1,0,1 },
	{ 1,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,0,1,0,0,0,1,0,1 },
	{ 1,0,1,1,1,0,1,0,1,0,1,0,0,1,1,0,1,1,1,1,1,1,1,1 },
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

local mapWidth = #worldMap[1]
local mapHeight = #worldMap

local wW = love.graphics.getWidth()
local wH = love.graphics.getHeight()

local player = {
	pos = {
		x = 10.5,
		y = 10.5,
	},
	dir = { x = 0, y = 0 },
	plane = { x = 0, y = 0 },
	theta = math.pi / 2,
}

local camera = {}

function love.load()
end

function love.update(dt)
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

	player.dir.x = math.cos(player.theta)
	player.dir.y = math.sin(player.theta)

	player.plane.x = math.sin(player.theta)
	player.plane.y = -math.cos(player.theta)

	--print(worldMap[math.floor(player.pos.x)][math.floor(player.pos.y)])
end

function love.draw()
	---[[
	for x = 0,wW do
		local ray = {}

		camera.x = 2 * x / wW - 1
		ray.x = player.dir.x + player.plane.x * camera.x
		ray.y = player.dir.y + player.plane.y * camera.x

		local map = {
			x = math.floor(player.pos.x),
			y = math.floor(player.pos.y),
		}

		-- Distance travelled by ray for one X or one Y unit
		-- Result is not an X or Y distance
		local deltaDistX = math.abs(1 / ray.x)
		local deltaDistY = math.abs(1 / ray.y)

		if ray.x < 0 then
			stepX = -1
			sideDistX = (player.pos.x - map.x) * deltaDistX
		else
			stepX = 1
			sideDistX = (map.x + 1 - player.pos.x) * deltaDistX
		end

		if ray.y < 0 then
			stepY = -1
			sideDistY = (player.pos.y - map.y) * deltaDistY
		else
			stepY = 1
			sideDistY = (map.y + 1 - player.pos.y) * deltaDistY
		end

		local hit = false
		while not hit do
			if sideDistX < sideDistY then
				sideDistX = sideDistX + deltaDistX
				map.x = map.x + stepX
				side = false
			else
				sideDistY = sideDistY + deltaDistY
				map.y = map.y + stepY
				side = true
			end

			if worldMap[map.x][map.y] > 0 then
				hit = true
			end
		end

		if not side then
			perpWallDist = (map.x - player.pos.x + (1 - stepX) / 2) / ray.x
		else
			perpWallDist = (map.y - player.pos.y + (1 - stepY) / 2) / ray.y
		end

		local lineHeight = wH / perpWallDist

		local drawStart = -lineHeight / 2 + wH / 2
		if drawStart < 0 then drawStart = 0 end
		local drawEnd = lineHeight / 2 + wH / 2
		if drawEnd >= wH then drawEnd = wH - 1 end

		local color = {0,1,0,1}

		if side then
			color[4] = color[4] / 2
		end

		love.graphics.setColor(color)
		love.graphics.setLineStyle('rough')
		love.graphics.line(x, drawStart, x, drawEnd)
	end
	--]]

	---[[
	local factor = 10
	local pos = {
		y = player.pos.x * factor,
		x = player.pos.y * factor,
	}
	local dir = {
		y = player.dir.x * factor,
		x = player.dir.y * factor,
	}
	local plane = {
		y = player.plane.x * factor,
		x = player.plane.y * factor,
	}

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

	for i = 1,#worldMap do
		for j = 1,#worldMap[i] do
			if worldMap[i][j] > 0 then
				love.graphics.setColor(0,0,1,1)
				love.graphics.polygon('line', j*factor, i*factor, (j+1)*factor, i*factor, (j+1)*factor, (i+1)*factor, j*factor, (i+1)*factor)
			end
		end
	end
	--]]
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
