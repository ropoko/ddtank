local Player = {
	x = 150,
	y = 150,
	width = 50,
	height = 50,
	speed_aim = 0.2,
	angle = 0, -- radians
	angle_show = 0, -- converted to degrees
	mass = 50,
	side = 'left' -- left | right
}

local center_user = {}

function Player:load()
	self.body = love.physics.newBody(WORLD, self.x, self.y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)

	self.body:setMass(self.mass)
end

function Player:update(dt)
	if love.keyboard.isDown('w') then
		self.angle = self.angle + math.pi * dt * self.speed_aim
	end

	if love.keyboard.isDown('s') then
		self.angle = self.angle - math.pi * dt * self.speed_aim
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

	self.angle_show = self.angle
end


function Player:draw()
	love.graphics.setColor(1,0,0)
	love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))

	self:draw_aim()
end

local function stencilFunction()
	love.graphics.circle('fill', center_user.x, center_user.y, 50)
end

function Player:draw_aim()
	love.graphics.stencil(stencilFunction, 'replace', 1)
	love.graphics.setStencilTest('equal', 0)
	love.graphics.setColor(228/255,228/255,228/255, 0.5)
	love.graphics.circle('fill', center_user.x, center_user.y, 100)
	love.graphics.setStencilTest()

	love.graphics.push()

	love.graphics.translate(center_user.x, center_user.y)
	love.graphics.rotate(self.angle)
	love.graphics.translate(-center_user.x, -center_user.y)

	love.graphics.setColor(1,0,0)
	love.graphics.line(center_user.x,center_user.y, center_user.x,center_user.y - 100)
	love.graphics.setColor(1,1,1)

	love.graphics.pop()

	if self.side == 'right' then
		love.graphics.print('Angle: '.. math.deg(self.angle_show)..'°', 10, 10)
	else
		love.graphics.print('Angle: '.. math.deg(self.angle_show * -1)..'°', 10, 10)
	end

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

return Player
