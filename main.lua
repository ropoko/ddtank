local PLAYER = {
	x = 500,
	y = 500,
	width = 25,
	height = 25,
	dash_interval = 2, -- seconds
	last_dash = 0
}

local ENEMY = {
	count = 20,
	alive = 0,
	size = 10,
	all = {}
}

local function dash(direction, signal)
	if love.keyboard.isDown('space') then
		if (os.time() - PLAYER.last_dash) > PLAYER.dash_interval then
			PLAYER.last_dash = os.time()
			if signal == '-' then
				PLAYER[direction] = PLAYER[direction] - 5
			else
				PLAYER[direction] = PLAYER[direction] + 5
			end
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
	-- generate enemies
	if ENEMY.alive <= ENEMY.count then
		for i=1, ENEMY.count - ENEMY.alive do
			ENEMY.alive = ENEMY.alive + 1

			local x = love.math.random(0, 800)
			local y = love.math.random(0, 600)

			-- local color = Utils.random_color()

			table.insert(ENEMY.all, { x = x, y = y })
		end
	end

	if love.keyboard.isDown('w', 'a', 's', 'd') then
		move_player()
	end
end

function love.draw()
	for k,v in pairs(ENEMY.all) do
		love.graphics.ellipse('fill', v.x, v.y, ENEMY.size, ENEMY.size)
	end

	love.graphics.rectangle('fill', PLAYER.x, PLAYER.y, PLAYER.width, PLAYER.height)
end
