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

local player = {
	pos = {
		x = 10.5,
		y = 10.5,
	},
	dir = { x = 0, y = 0 },
	plane = { x = 0, y = 0 },
	theta = math.pi / 2,
}

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


	local pos = {
		x = player.pos.x,
		y = player.pos.y,
	}
	local dir = {
		x = player.dir.x,
		y = player.dir.y,
	}
	local plane = {
		x = player.plane.x,
		y = player.plane.y,
	}

	rays = {}

	for x = 0,wW do
		local camera_x
		local hit = false
		local side

		local dist = {
			ray = {},
			delta = {},
			side = {},
			step = {},
		}

		camera_x = 2 * x / wW - 1
		dist.ray.x = dir.x + plane.x * camera_x
		dist.ray.y = dir.y + plane.y * camera_x

		local map = {
			x = math.floor(pos.x),
			y = math.floor(pos.y),
		}

		-- Distance travelled by ray for one X or one Y unit
		-- Result is not an X or Y distance
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

		if not side then
			dist.perpWall = (map.x - pos.x + (1 - dist.step.x) / 2) / dist.ray.x
		else
			dist.perpWall = (map.y - pos.y + (1 - dist.step.y) / 2) / dist.ray.y
		end

		local lineHeight = wH / dist.perpWall
		local drawStart = -lineHeight / 2 + wH / 2
		local drawEnd = lineHeight / 2 + wH / 2

		if drawStart < 0 then drawStart = 0 end
		if drawEnd >= wH then drawEnd = wH - 1 end

		local tile = worldMap[map.x][map.y] 
		local colorPalette = {
			{0,1,0,1},
			{0,0,1,1},
			{1,0,0,1},
			{1,1,0,1},
		}

		local tileColor = colorPalette[tile]

		if side then
			tileColor[4] = tileColor[4] / 2
		end

		local ray = {
			x, drawStart, x, drawEnd,
			tileColor = tileColor,
		}

		table.insert(rays, ray)
	end
end

function love.draw()
	love.graphics.setLineStyle('rough')
	for _, ray in ipairs(rays) do
		love.graphics.setColor(ray.tileColor)
		love.graphics.line(ray)
	end

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
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
