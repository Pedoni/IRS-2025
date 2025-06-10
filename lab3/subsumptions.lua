MAX_VELOCITY = 15
PROXIMITY_THRESHOLD = 0.20
LIGHT_THRESHOLD = 0.05

local subs = {}

local states = {
	NO_OBSTACLES = 0, 
	OBSTACLE_LEFT = 1, 
	OBSTACLE_RIGHT = 2, 
	OBSTACLE_BEHIND = 3
}

function subs.randomWalk(robot)
    return robot.random.uniform(0,MAX_VELOCITY), robot.random.uniform(0,MAX_VELOCITY)
end

function subs.phototaxisLayer(robot)
	local lightSensor = 0
	for i=1,#robot.light do
		if robot.light[i].value > robot.light[lightSensor + 1].value then
			if (robot.light[i].value > LIGHT_THRESHOLD) then
				lightSensor =  i - 1
			end
		end
	end
	if lightSensor ~= 0 then
		lightSensor = lightSensor + 1
		if lightSensor == 24 or lightSensor == 1 then
			left_v = MAX_VELOCITY
			right_v = MAX_VELOCITY
		elseif lightSensor >= 2 and lightSensor <=12 then
			left_v = - MAX_VELOCITY / 2
			right_v = MAX_VELOCITY / 2
		else
			left_v = MAX_VELOCITY / 2
			right_v = - MAX_VELOCITY / 2
		end
		return left_v, right_v
	else
		return nil, nil
	end
end

local function checkObstacles(robot)
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

function subs.obstacleAvoidanceLayer(robot)
	local state = checkObstacles(robot)
	if state ~= states.NO_OBSTACLES then
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
		return left_v, right_v
	else
		return nil, nil
	end
end

function subs.haltLayer(robot)
	local ground = robot.motor_ground
	local spot = false
	for i=1,4 do
		if ground[i].value == 0 then
			spot = true
			break
		end
	end
	if spot then
		return 0, 0
	else
		return nil, nil
	end
end

return subs