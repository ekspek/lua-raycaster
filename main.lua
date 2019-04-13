player = {
	pos = { x = 400, y = 300 },
	dir = { x = 20, y = 20 },
	theta = 0,
}

function love.load()
end

function love.update(dt)
	if love.keyboard.isDown('left') then
		player.theta = player.theta - (5 * math.pi / 180)
	elseif love.keyboard.isDown('right') then
		player.theta = player.theta + (5 * math.pi / 180)
	end

	if love.keyboard.isDown('up') then
		player.pos.x = player.pos.x + 2 * math.cos(player.theta)
		player.pos.y = player.pos.y + 2 * math.sin(player.theta)
	elseif love.keyboard.isDown('down') then
		player.pos.x = player.pos.x - 2 * math.cos(player.theta)
		player.pos.y = player.pos.y - 2 * math.sin(player.theta)
	end

	player.dir.x = 40 * math.cos(player.theta)
	player.dir.y = 40 * math.sin(player.theta)
end

function love.draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.setLineWidth(0.5)
	love.graphics.line(player.pos.x, player.pos.y, player.pos.x + player.dir.x, player.pos.y + player.dir.y)
	love.graphics.setColor(1,0,0,1)
	love.graphics.points(player.pos.x, player.pos.y)
	love.graphics.setColor(0,1,0,1)
	love.graphics.points(player.pos.x + player.dir.x, player.pos.y + player.dir.y)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
