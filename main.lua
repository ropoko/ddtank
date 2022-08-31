local PLAYER = {
	x = 500,
	y = 500,
	width = 25,
	height = 25
}

local ENEMY = {
	count = 100,
	alive = 0,
	size = 15
}

local function move_player()
	if love.keyboard.isDown('w') then
		PLAYER.y = PLAYER.y - 1

		if love.keyboard.isDown('space') then
			PLAYER.y = PLAYER.y - 3
		end
	end

	if love.keyboard.isDown('s') then
		PLAYER.y = PLAYER.y + 1

		if love.keyboard.isDown('space') then
			PLAYER.y = PLAYER.y + 3
		end
	end

	if love.keyboard.isDown('a') then
		PLAYER.x = PLAYER.x - 1

		if love.keyboard.isDown('space') then
			PLAYER.x = PLAYER.x - 3
		end
	end

	if love.keyboard.isDown('d') then
		PLAYER.x = PLAYER.x + 1

		if love.keyboard.isDown('space') then
			PLAYER.x = PLAYER.x + 3
		end
	end
end

function love.update()
	if love.keyboard.isDown('w', 'a', 's', 'd') then
		move_player()
	end
end

function love.draw()
	love.graphics.rectangle('fill', PLAYER.x, PLAYER.y, PLAYER.width, PLAYER.height)
end
