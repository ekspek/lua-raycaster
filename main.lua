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

local mapWidth = #worldMap[1]
local mapHeight = #worldMap

local rays = love.graphics.getWidth()

local player = {
	pos = {
		x = 10,
		y = 10,
	},
	dir = { x = -1, y = 0 },
	plane = { x = 0, y = 0.66 },
	theta = 0,
}

local camera = {}

function love.load()
end

function love.update(dt)
	if love.keyboard.isDown('left') then
		player.theta = player.theta - (5 * math.pi / 180)
	elseif love.keyboard.isDown('right') then
		player.theta = player.theta + (5 * math.pi / 180)
	end

	if love.keyboard.isDown('up') then
		player.pos.x = player.pos.x + 10 * dt * math.cos(player.theta)
		player.pos.y = player.pos.y + 10 * dt * math.sin(player.theta)
	elseif love.keyboard.isDown('down') then
		player.pos.x = player.pos.x - 10 * dt * math.cos(player.theta)
		player.pos.y = player.pos.y - 10 * dt * math.sin(player.theta)
	end

	for x = 0,rays do
		local ray = {}

		camera.x = 2 * x / rays - 1
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
	end


	player.dir.x = math.cos(player.theta)
	player.dir.y = math.sin(player.theta)

	player.plane.x = math.sin(player.theta)
	player.plane.y = -math.cos(player.theta)

	--print(worldMap[math.floor(player.pos.x)][math.floor(player.pos.y)])
end

function love.draw()
	local factor = 10
	local pos = {
		x = player.pos.x * factor,
		y = player.pos.y * factor,
	}
	local dir = {
		x = player.dir.x * factor,
		y = player.dir.y * factor,
	}
	local plane = {
		x = player.plane.x * factor,
		y = player.plane.y * factor,
	}

	love.graphics.setColor(1,1,1,1)
	love.graphics.setLineWidth(0.5)
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
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
