local PLAYER = {
	x = 500,
	y = 500,
	width = 25,
	height = 25,
	dash_interval = 2, -- seconds
	last_dash = 0
}

local ENEMY = {
	count = 2,
	alive = 0,
	size = 10,
	all = {}
}

local function has_collision(x1, y1, w1, h1, x2, y2, w2, h2)
	return (
		x2 < x1 + w1 and
		x1 < x2 + w2 and
		y1 < y2 + h2 and
		y2 < y1 + h1
	)
end

local function dash(direction, signal)
	local execute = {
		['-'] = function (x,y) return x - y end,
		['+'] = function (x,y) return x + y end,
	}

	if love.keyboard.isDown('space') then
		if (os.time() - PLAYER.last_dash) > PLAYER.dash_interval then
			PLAYER.last_dash = os.time()

			PLAYER[direction] = execute[signal](PLAYER[direction], 5)
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

local function get_short_distance(enemy_x, player_x, enemy_y, player_y)
	local minor_x = math.min(
		enemy_x - player_x,
		(enemy_x - (player_x + PLAYER.width)),
		(enemy_x - (player_x - PLAYER.width))
	)

	local minor_y = math.min(
		enemy_y - player_y,
		(enemy_y - (player_y + PLAYER.height)),
		(enemy_y - (player_y - PLAYER.height))
	)

	return minor_x, minor_y
end

function love.update(dt)
	-- generate enemies
	if ENEMY.alive <= ENEMY.count then
		for i=1, ENEMY.count - ENEMY.alive do
			ENEMY.alive = ENEMY.alive + 1

			local x = love.math.random(0, 800)
			local y = love.math.random(0, 600)

			table.insert(ENEMY.all, { x = x, y = y })
		end
	end

	local speed = 0.4

	for i = 1, #ENEMY.all do
		local x_distance, y_distance = get_short_distance(ENEMY.all[i].x, PLAYER.x, ENEMY.all[i].y, PLAYER.y)

		local distance = math.sqrt(x_distance^2 + y_distance^2)

		ENEMY.all[i].x = ENEMY.all[i].x - x_distance / distance * speed
		ENEMY.all[i].y = ENEMY.all[i].y - y_distance / distance * speed

		for j=i+1, #ENEMY.all do
			if has_collision(ENEMY.all[i].x, ENEMY.all[i].y, ENEMY.size, ENEMY.size,
				ENEMY.all[j].x, ENEMY.all[j].y, ENEMY.size, ENEMY.size) then
				if ENEMY.all[i].x <= ENEMY.all[j].x then
					ENEMY.all[j].x = ENEMY.all[j].x + ENEMY.size
				end

				if ENEMY.all[i].x >= ENEMY.all[j].x then
					ENEMY.all[j].x = ENEMY.all[j].x - ENEMY.size
				end

				if ENEMY.all[i].y <= ENEMY.all[j].y then
					ENEMY.all[j].y = ENEMY.all[j].y - ENEMY.size
				end

				if ENEMY.all[i].y >= ENEMY.all[j].y then
					ENEMY.all[j].y = ENEMY.all[j].y + ENEMY.size
				end
			end
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
