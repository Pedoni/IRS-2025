MOVE_STEPS = 15
MAX_VELOCITY = 15
LIGHT_THRESHOLD = 1.5
PROXIMITY_THRESHOLD = 0.05

local states = {
	NO_OBSTACLES = 0, 
	OBSTACLE_LEFT = 1, 
	OBSTACLE_RIGHT = 2, 
	OBSTACLE_BEHIND = 3
}

function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

local function checkObstacles()
	local value = 0
	local proximitySensor = 0
	for i=1,#robot.proximity do
		if value < robot.proximity[i].value then
			proximitySensor = i
			value = robot.proximity[i].value
		end
	end
	if value < PROXIMITY_THRESHOLD then
		return 0
	else
		if proximitySensor <= 6 then
			return states.OBSTACLE_LEFT
		elseif proximitySensor >= 19 then
			return states.OBSTACLE_RIGHT
		else
			return states.OBSTACLE_BEHIND
		end
	end
end

local function moveTowardsLight()
	local lightSensor = 0
	for i=1,#robot.light do
		if robot.light[i].value > robot.light[lightSensor + 1].value then
			lightSensor =  i - 1
		end
	end
	if lightSensor == 0 then
		left_v = robot.random.uniform(0,MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
		return
	end
	lightSensor = lightSensor + 1
	if lightSensor == 24 or lightSensor == 1 then
		left_v = MAX_VELOCITY
		right_v = MAX_VELOCITY
	elseif lightSensor >= 2 and lightSensor <=12 then
		left_v = - MAX_VELOCITY / 2
		right_v = MAX_VELOCITY / 2
	elseif lightSensor >= 13 and lightSensor <= 23 then
		left_v = MAX_VELOCITY / 2
		right_v = - MAX_VELOCITY / 2
	else
		
	end
end

local function avoidObstacle(state)
	if state == states.OBSTACLE_LEFT then
			left_v = MAX_VELOCITY / 2
			right_v = - MAX_VELOCITY / 2
		elseif state == states.OBSTACLE_RIGHT then
			left_v = - MAX_VELOCITY / 2
			right_v = MAX_VELOCITY / 2
		else
			left_v = MAX_VELOCITY
			right_v = MAX_VELOCITY
		end
end

function step()
	local state = checkObstacles()
	if state == states.NO_OBSTACLES then
		moveTowardsLight()
	else
		avoidObstacle(state)
	end
	robot.wheels.set_velocity(left_v,right_v)
end

function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

function destroy()
end
