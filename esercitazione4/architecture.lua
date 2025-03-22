local ms = require("motorschema")
local vector = require("vector")

MAX_VEL = 15

local schemas = {}

function init()
	robot.wheels.set_velocity(0,0)
	schemas = {
		ms.randomWalk,
		ms.phototaxisLayer,
		ms.obstacleAvoidanceLayer,
		ms.haltLayer,
	}
	L = robot.wheels.axis_length
end

function step()
	local pv = vector.get_polar_vector(0, 0)

	for _, schema in ipairs(schemas) do
		local v = schema(robot)
		pv = vector.vec2_polar_sum(pv, v)
	end

	pv = vector.get_polar_vector(pv.length == 0 and pv.length or MAX_VEL, pv.angle)

	local vel = vector.polar_to_vel(pv, L)

	robot.wheels.set_velocity(vel.vl, vel.vr)
end

function reset()
	robot.wheels.set_velocity(0,0)
end

function destroy()
   local x = robot.positioning.position.x
   local y = robot.positioning.position.y
   local d = math.sqrt((x-1.5)^2 + y^2)
   print('f_distance ' .. d)
end