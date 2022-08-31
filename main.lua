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

local function dash(direction, signal)
	if love.keyboard.isDown('space') then
		if signal == '-' then
			PLAYER[direction] = PLAYER[direction] - 3
		else
			PLAYER[direction] = PLAYER[direction] + 3
		end
	end
end

local function move_player()
	local last_movement = {}

	if love.keyboard.isDown('w') then
		PLAYER.y = PLAYER.y - 1

		last_movement.direction = 'y'
		last_movement.signal = '-'
	end

	if love.keyboard.isDown('s') then
		PLAYER.y = PLAYER.y + 1

		last_movement.direction = 'y'
		last_movement.signal = '+'
	end

	if love.keyboard.isDown('a') then
		PLAYER.x = PLAYER.x - 1

		last_movement.direction = 'x'
		last_movement.signal = '-'
	end

	if love.keyboard.isDown('d') then
		PLAYER.x = PLAYER.x + 1

		last_movement.direction = 'x'
		last_movement.signal = '+'
	end

	dash(last_movement.direction, last_movement.signal)
end

function love.update()
	if love.keyboard.isDown('w', 'a', 's', 'd') then
		move_player()
	end
end

function love.draw()
	love.graphics.rectangle('fill', PLAYER.x, PLAYER.y, PLAYER.width, PLAYER.height)
end
