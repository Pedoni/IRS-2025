MAXSPEED = 80
PROXRANGE = 0.2
MAXRANGE = 30
W = 0.1
S = 0.01
PSmax = 0.99
PWmin = 0.005
ALPHA = 0.1
BETA = 0.05
Ds = 0.5
Dw = 0.5

PROXIMITY_THRESHOLD = 0.05

local states = {RANDWALK = 0, STOP = 1}

local obstacleStates = {
	NO_OBSTACLES = 0,
	OBSTACLE_LEFT = 1,
	OBSTACLE_RIGHT = 2,
	OBSTACLE_BEHIND = 3
}

local currentState
local nextState

function CountRAB()
	local number_robot_sensed = 0
	for i = 1, #robot.range_and_bearing do
		if robot.range_and_bearing[i].range < MAXRANGE and robot.range_and_bearing[i].data[1] == 1 then
			number_robot_sensed = number_robot_sensed + 1
		end
	end
	return number_robot_sensed
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
			return obstacleStates.OBSTACLE_LEFT
		elseif proximitySensor >= 19 then
			return obstacleStates.OBSTACLE_RIGHT
		else
			return obstacleStates.OBSTACLE_BEHIND
		end
	end
end

local function avoidObstacles(obstacleState)
	if obstacleState == obstacleStates.OBSTACLE_LEFT then
        left_v = MAXSPEED / 2
        right_v = - MAXSPEED / 2
    elseif obstacleState == obstacleStates.OBSTACLE_RIGHT then
        left_v = - MAXSPEED / 2
        right_v = MAXSPEED / 2
    else
        left_v = MAXSPEED
        right_v = MAXSPEED
    end
    robot.wheels.set_velocity(left_v, right_v)
end

local function checkSpot()
	for i=1,4 do
		if robot.motor_ground[i].value == 0 then
            return Ds, Dw
		end
	end
	return 0, 0
end

function init()
	currentState = states.RANDWALK
	nextState = states.RANDWALK
end

local function Randwalk(s)
	Ps = math.min(PSmax, S + ALPHA * N + s)
	local obstacleState = checkObstacles()
	if obstacleState == states.NO_OBSTACLES then
		robot.wheels.set_velocity(math.random(0, MAXSPEED), math.random(0, MAXSPEED))
	else
		avoidObstacles(obstacleState)
	end
		robot.leds.set_all_colors("yellow")
	
	if robot.random.uniform() <= Ps then
		nextState = states.STOP
	end
end

local function Stop(w)
	Pw = math.max(PWmin, W - BETA * N - w)
	robot.wheels.set_velocity(0, 0)
	robot.leds.set_all_colors("red")
	if robot.random.uniform() <= Pw then
		nextState = states.RANDWALK
	end
end

function step()
	currentState = nextState

    robot.range_and_bearing.set_data(1,currentState)

	N = CountRAB()

	local s, w = checkSpot()

	if currentState == states.RANDWALK then Randwalk(s) end
    if currentState == states.STOP then Stop(w) end
end

function reset()
	currentState = states.RANDWALK
    nextState = states.RANDWALK
end

function destroy()
end