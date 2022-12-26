local Player = {
	x = 150,
	y = 150,
	width = 50,
	height = 50
}

local center_user = {}

local selected_angle = 0

function love.keypressed(key)
	if key == 'w' then
		selected_angle = selected_angle + 1
	end

	if key == 's' then
		selected_angle = selected_angle - 1
	end
end

function Player:load()
	self.body = love.physics.newBody(WORLD, self.x, self.y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Player:update(dt)
	center_user = {
		x = Player.x + Player.width / 2,
		y = Player.y + Player.height / 2
	}
end


function Player:draw()
	self.x, self.y,_,_ = self.body:getWorldPoints(self.shape:getPoints())

	love.graphics.setColor(1,0,0)
	love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))

	self:draw_aim()
end

local function stencilFunction()
	love.graphics.circle('fill', center_user.x, center_user.y, 50)
end

function Player:draw_aim()
	love.graphics.print(tostring(selected_angle), 10, 10)

	local aim_x = center_user.x + math.cos(selected_angle)*100
	local aim_y = center_user.y + math.sin(selected_angle)*100

	-- love.graphics.circle('fill', aim_x, aim_y, 5,5)

	love.graphics.setColor(1,0,0)
	love.graphics.setLineWidth(2)
	love.graphics.line(aim_x, aim_y, aim_x - 25, aim_y - 25)
	love.graphics.setLineWidth(1)

	love.graphics.stencil(stencilFunction, 'replace', 1)
	love.graphics.setStencilTest('equal', 0)
	love.graphics.setColor(228/255,228/255,228/255, 0.5)
	love.graphics.circle('fill', center_user.x, center_user.y, 100)
	love.graphics.setStencilTest()
end

return Player
