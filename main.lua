player = {
	pos = { x = 400, y = 300 },
	dir = { x = 20, y = 20 },
}

function love.load()
end

function love.update(dt)
	print(player.pos)
end

function love.draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.setLineWidth(0.5)
	love.graphics.line(player.pos.x, player.pos.y, player.pos.x + player.dir.x, player.pos.y + player.dir.y)
	love.graphics.setColor(0,1,0,1)
	love.graphics.points(player.pos.x, player.pos.y, player.pos.x + player.dir.x, player.pos.y + player.dir.y)
end
