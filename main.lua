local Player = require('player')

local ground = {}

function love.load()
	love.physics.setMeter(64)
	-- gravity in x, gravity in y, allows bodies to 'sleep'
	WORLD = love.physics.newWorld(0, 9.81*64, true)

	-- create the ground
	ground = {}
	-- static because we won't interact with it
	ground.body = love.physics.newBody(WORLD, 600/2, 600-50/2, "static")
	-- define sizes
	ground.shape = love.physics.newRectangleShape(600, 50)
	-- attach shape to body
	ground.fixture = love.physics.newFixture(ground.body, ground.shape)

	local fixture = love.physics.newFixture(ground.body, ground.shape)
	fixture:setFriction(1)

	Player:load()

	love.window.setMode(600, 600)
end

function love.update(dt)
	Player:update(dt)
	WORLD:update(dt)
end

function love.draw()
	-- set color for ground
	love.graphics.setColor(0.28, 0.63, 0.05)
  -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

	Player:draw()
end
