local PLAYER = {
	x = 500,
	y = 500,
	width = 25,
	height = 25,
	dash_interval = 2, -- seconds
	last_dash = 0,
	shoots = {}
}

local ENEMY = {
	count = 1,
	alive = 0,
	size = 10,
	all = {}
}

local AIM = {
	x = 0,
	y = 0,
	size = 5 -- will depend on the image size
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

local function shoot()
	if love.mouse.isDown(1) then -- left
		local shot = {
			x = PLAYER.x,
			y = PLAYER.y,
			aim_x = AIM.x,
			aim_y = AIM.y,
			size = 6
		}

		table.insert(PLAYER.shoots, shot)
	end
end

local function mov_shot()
	for i = #PLAYER.shoots, 1, -1 do
		local aim_x = PLAYER.shoots[i].aim_x
		local aim_y = PLAYER.shoots[i].aim_y

		if (PLAYER.shoots[i].x <= aim_x and PLAYER.shoots[i].y <= aim_y) then
			table.remove(PLAYER.shoots, i)
		else
			local distance = math.sqrt((PLAYER.shoots[i].x - aim_x)^2 + (PLAYER.shoots[i].y - aim_y)^2)

			PLAYER.shoots[i].x = PLAYER.shoots[i].x - (PLAYER.shoots[i].x - aim_x) / distance
			PLAYER.shoots[i].y = PLAYER.shoots[i].y - (PLAYER.shoots[i].y - aim_y) / distance
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

-- fix: enemy should be able to follow one of the four boundaries
-- up-right, up-left; down-right, down-left
local function get_short_distance(enemy_x, player_x, enemy_y, player_y)
	local minor_x = math.min(
		enemy_x - player_x,
		(enemy_x - (player_x + PLAYER.width))
	)

	local minor_y = math.min(
		enemy_y - player_y,
		(enemy_y - (player_y - PLAYER.height))
	)

	return minor_x, minor_y
end

function love.update(dt)
	-- updated aim
	AIM.x, AIM.y = love.mouse.getPosition()

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

	shoot()
	mov_shot()
end

function love.draw()
	for k,v in pairs(ENEMY.all) do
		love.graphics.ellipse('fill', v.x, v.y, ENEMY.size, ENEMY.size)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', PLAYER.x, PLAYER.y, PLAYER.width, PLAYER.height)

	love.graphics.ellipse('line', AIM.x, AIM.y, AIM.size, AIM.size)

	-- only for testing enemy follow movement
	-- see line 75
	love.graphics.setColor(255, 0, 0)
	-- canto direito
	love.graphics.ellipse('fill', PLAYER.x, PLAYER.y, 2, 2)

	-- canto esquerdo
	love.graphics.ellipse('fill', PLAYER.x + PLAYER.width, PLAYER.y, 2, 2)

	-- canto baixo direito
	love.graphics.ellipse('fill', PLAYER.x, PLAYER.y + PLAYER.height, 2, 2)

	-- canto baixo esquerdo
	love.graphics.ellipse('fill', PLAYER.x + PLAYER.width, PLAYER.y + PLAYER.height, 2, 2)


	love.graphics.setColor(255, 255, 255)
	-- shoots
	for k,s in pairs(PLAYER.shoots) do
		love.graphics.ellipse('fill', s.x, s.y, 6, 6)
	end
end

