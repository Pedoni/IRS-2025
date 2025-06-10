local vector = require "vector"

PROXIMITY_THRESHOLD = 0.2
LIGHT_THRESHOLD = 0.02

local schemas = {}

local function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function schemas.randomWalk(robot)
    local lv = schemas.phototaxis(robot)
	local pv = schemas.obstacleAvoidance(robot)
	if lv.length == 0 and lv.angle == 0 and pv.length == 0 and pv.angle == 0 then
		return vector.get_polar_vector(MAX_VEL, randomFloat(-math.pi/4,math.pi/4))
	else 
		return vector.get_polar_vector(0, 0)
	end
end

function schemas.phototaxis(robot)
	local pv = vector.get_polar_vector(0, 0)
    for i=1,#robot.light do
		local sensorVector = vector.get_polar_vector(0, 0)
		if robot.light[i].value > LIGHT_THRESHOLD then
			sensorVector = vector.get_polar_vector(robot.light[i].value, robot.light[i].angle)
		end
        pv = vector.vec2_polar_sum(pv, sensorVector)
    end


    return pv
end

function schemas.obstacleAvoidance(robot)
	local pv = vector.get_polar_vector(0, 0)
    for i=1,#robot.proximity do
		local proxVector = vector.get_polar_vector(0, 0)
		if robot.proximity[i].value > PROXIMITY_THRESHOLD then
			--usiamo il modulo per restare nel range [-pi, +pi]
			proxVector = vector.get_polar_vector(robot.proximity[i].value, (robot.proximity[i].angle + math.pi) % (2 * math.pi))
		end
        pv = vector.vec2_polar_sum(pv, proxVector)
    end
    return pv
end

function schemas.halt(robot)
	local ground = robot.motor_ground
	local spot = false
	for i=1,4 do
		if ground[i].value == 0 then
			spot = true
			break
		end
	end
	if spot then
		local vect = schemas.phototaxis(robot)
		vect = vector.vec2_polar_sum(vect, schemas.obstacleAvoidance(robot))
		vect = vector.vec2_polar_sum(vect, schemas.randomWalk(robot))
		vect = vector.get_polar_vector(-vect.length, vect.angle)
		return vect
	else 
		return vector.get_polar_vector(0, 0)
	end
end

return schemas