local subs = require("subsumptions")

local subsumptions = {}

function init()
	robot.wheels.set_velocity(0,0)
	subsumptions = {
		subs.randomWalk,
		subs.phototaxisLayer,
		subs.obstacleAvoidanceLayer,
		subs.haltLayer,
	}
end

function step()
	local lwheel = robot.wheels.velocity_left
	local rwheel = robot.wheels.velocity_right
	for _, sub in ipairs(subsumptions) do
		local l, r = sub(robot)
		if l then lwheel = l end
		if r then rwheel = r end
	end
	robot.wheels.set_velocity(lwheel, rwheel)
end

function reset()
	robot.wheels.set_velocity(0,0)
end


function destroy()
   x = robot.positioning.position.x
   y = robot.positioning.position.y
   d = math.sqrt((x-1.5)^2 + y^2)
   print('f_distance ' .. d)
end