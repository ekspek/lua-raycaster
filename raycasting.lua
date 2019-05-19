local Class = require 'libs.hump.class'

Raycaster = Class{}

function Raycaster:init()
	self.rays = {}
end

function Raycaster:update(dt, worldMap)
	-- Preparing for main raycasting loop
	local wW = love.graphics.getWidth()
	local wH = love.graphics.getHeight()
	local pos = {} -- Player position
	local dir = {} -- Player direction vector
	local plane = {} -- Camera plane vector from direction vector
	pos.x = player.pos.x
	pos.y = player.pos.y
	dir.x = player.dir.x
	dir.y = player.dir.y
	plane.x = player.plane.x
	plane.y = player.plane.y

	self.rays = {}
	self.buffer = {}

	local texWidth = texture1.width

	-- Main raycasting loop
	-- Runs loop once per vertical pixel line
	for x = 0,wW do
		local camera_x -- X row position in map
		local hit = false -- Loop bool while it doesn't hit
		local side -- Bool if it ray hits side of tile

		-- Table containing main distances used through the loop
		local dist = {}
		dist.ray = {} -- Direction vector for cast ray
		dist.delta = {} -- Vector of distance the ray covers each tile
		dist.side = {} -- Vector to check which side of a tile the ray hits
		dist.step = {} -- Vector of which 4-way direction to step in

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
			wallX = pos.y + dist.perpWall * dir.y
		else
			wallX = pos.y + dist.perpWall * dir.x
		end
		wallX = wallX - math.floor(wallX)

		texX = math.floor(wallX * texWidth)
		if not side and dir.x > 0 then
			texX = texWidth - texX - 1
		end
		if side and dir.y < 0 then
			texX = texWidth - texX - 1
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

		table.insert(self.rays, ray)
	end
end

function Raycaster:draw()
	-- Main "3D" drawing loop
	love.graphics.setLineStyle('rough')
	for _, ray in ipairs(self.rays) do
		love.graphics.setColor(ray.tileColor)
		love.graphics.line(ray)
	end

	love.graphics.setPointSize(2)
	for x = 1,#texture1 do
		for y = 1,#texture1[x] do
			love.graphics.setColor(texture1[x][y].r, texture1[x][y].g, texture1[x][y].b)
			love.graphics.points(x*2, y*2)
		end
	end
end

return Raycaster
