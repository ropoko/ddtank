local Player = {
	x = 150,
	y = 150,
	width = 50,
	height = 50,
	mass = 50,
	side = 'left', -- left | right

	aim = {
		radius = 100,
		speed = 0.2,
		angle = 0, -- radians
		angle_show = 0, -- converted to degrees
	},

	shoot = {}
}

local is_shoot_created = false

local center_user = {}

function Player:load()
	self.body = love.physics.newBody(WORLD, self.x, self.y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)

	self.body:setMass(self.mass)
end

function Player:update(dt)
	local round_angle = tonumber(string.format("%.0f", math.deg(self.aim.angle_show)))
	if round_angle == 360 or round_angle == -360 then
		self.aim.angle = 0
	end


	if love.keyboard.isDown('w') then
		self.aim.angle = self.aim.angle + math.pi * dt * self.aim.speed
	end

	if love.keyboard.isDown('s') then
		self.aim.angle = self.aim.angle - math.pi * dt * self.aim.speed
	end

	center_user = {
		x = Player.x + Player.width / 2,
		y = Player.y + Player.height / 2
	}

	-- ------------------------------------

	self.x, self.y,_,_ = self.body:getWorldPoints(self.shape:getPoints())

	local force = self.body:getInertia() + self.body:getMass()

	if love.keyboard.isDown('a') then
		self.body:applyLinearImpulse(-force, 0)
		self:change_side('left')
	end

	if love.keyboard.isDown('d') then
		self.body:applyLinearImpulse(force, 0)
		self:change_side('right')
	end

	self.aim.angle_show = self.aim.angle

	if is_shoot_created and not self.shoot.body:isAwake() then
		self.shoot.body:destroy()
		is_shoot_created = false
	end
end


function Player:draw()
	love.graphics.setColor(1,0,0)
	love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))

	self:draw_aim()

	if is_shoot_created then
		love.graphics.setColor(0,1,0)
		love.graphics.polygon('fill', self.shoot.body:getWorldPoints(self.shoot.shape:getPoints()))
	end
end

local function stencilFunction()
	love.graphics.circle('fill', center_user.x, center_user.y, Player.aim.radius/2)
end

function Player:draw_aim()
	love.graphics.stencil(stencilFunction, 'replace', 1)
	love.graphics.setStencilTest('equal', 0)
	love.graphics.setColor(228/255,228/255,228/255, 0.5)
	love.graphics.circle('fill', center_user.x, center_user.y, self.aim.radius)
	love.graphics.setStencilTest()

	local x_angle = center_user.x + math.cos(self.aim.angle) * self.aim.radius
	local y_angle = center_user.y + math.sin(self.aim.angle) * self.aim.radius

	love.graphics.setColor(1,0,0)
	love.graphics.line(center_user.x,center_user.y, x_angle, y_angle)
	love.graphics.setColor(1,1,1)

	if love.keyboard.isDown('space') and not is_shoot_created then
		self:to_shoot(x_angle,y_angle)
	end

	if self.side == 'right' then
		love.graphics.print('Angle: '.. math.deg(self.aim.angle_show)..'°', 10, 10)
	else
		love.graphics.print('Angle: '.. math.deg(self.aim.angle_show * -1)..'°', 10, 10)
	end

	love.graphics.setColor(0,1,0)
end

function Player:set_degree_aim(deg)
	self.angle = math.rad(deg)
end

function Player:change_side(side)
	if side ~= 'left' and side ~= 'right' then
		error('side not valid')
	end

	if self.side ~= side then
		self.side = side
	end
end

function Player:to_shoot(x,y)
	self:create_shoot(x,y)

	local force = 1000

	-- TODO: I don't think it's right
	if center_user.x > x then
		force = force * -1
	end

	self.shoot.body:applyLinearImpulse(force,-10000,x,y)
end

function Player:create_shoot(x,y)
	self.shoot = {}

	self.shoot.body = love.physics.newBody(WORLD, x, y, 'dynamic')
	self.shoot.shape = love.physics.newRectangleShape(20, 20)
	self.shoot.fixture = love.physics.newFixture(self.shoot.body, self.shoot.shape)

	self.shoot.body:setMass(20)

	is_shoot_created = true
end

return Player
