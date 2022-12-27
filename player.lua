local Player = {
	x = 150,
	y = 150,
	width = 50,
	height = 50
}

local center_user = {}

local angle = 0

function Player:load()
	self.body = love.physics.newBody(WORLD, self.x, self.y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Player:update(dt)
	if love.keyboard.isDown('w') then
		angle = angle + math.pi * dt * 0.2
	end

	if love.keyboard.isDown('s') then
		angle = angle - math.pi * dt * 0.2
	end

	center_user = {
		x = Player.x + Player.width / 2,
		y = Player.y + Player.height / 2
	}
end


function Player:draw()
	self.x, self.y,_,_ = self.body:getWorldPoints(self.shape:getPoints())

	love.graphics.setColor(1,0,0)
	-- love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))

	self:draw_aim()
end

local function stencilFunction()
	love.graphics.circle('fill', center_user.x, center_user.y, 50)
end

function Player:draw_aim()
	love.graphics.print(tostring(angle), 10, 10)

	love.graphics.stencil(stencilFunction, 'replace', 1)
	love.graphics.setStencilTest('equal', 0)
	love.graphics.setColor(228/255,228/255,228/255, 0.5)
	love.graphics.circle('fill', center_user.x, center_user.y, 100)
	love.graphics.setStencilTest()

	love.graphics.push()

	love.graphics.translate(center_user.x, center_user.y)
	love.graphics.rotate(angle)
	love.graphics.translate(-center_user.x, -center_user.y)

	love.graphics.setColor(1,0,0)
	love.graphics.line(center_user.x,center_user.y, center_user.x,center_user.y - 20)
	love.graphics.setColor(1,1,1)

	love.graphics.pop()
end

return Player