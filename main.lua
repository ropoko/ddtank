local all_objs = {}

function love.load()
	love.physics.setMeter(64)
	-- gravity in x, gravity in y, allows bodies to 'sleep'
	WORLD = love.physics.newWorld(0, 9.81*64, true)

	-- create the ground
	all_objs.ground = {}
	-- static because we won't interact with it
	all_objs.ground.body = love.physics.newBody(WORLD, 650/2, 650-50/2, "static")
	-- define sizes
	all_objs.ground.shape = love.physics.newRectangleShape(650, 50)
	-- attach shape to body
	all_objs.ground.fixture = love.physics.newFixture(all_objs.ground.body, all_objs.ground.shape)

	love.window.setMode(650, 650)
end

function love.update(dt)
	WORLD:update(dt)
end

function love.draw()
	-- set color for ground
	love.graphics.setColor(0.28, 0.63, 0.05)
  -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", all_objs.ground.body:getWorldPoints(all_objs.ground.shape:getPoints()))
end
