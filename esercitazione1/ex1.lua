MOVE_STEPS = 15
MAX_VELOCITY = 15
LIGHT_THRESHOLD = 1.5

function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

function step()	
	sensor = 1
	for i=1,#robot.light do
		if robot.light[i].value > robot.light[sensor].value then
			sensor =  i
		end
	end

	if sensor == 24 or sensor ==1 then
		robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	elseif sensor >= 2 and sensor <=12 then
		robot.wheels.set_velocity(-MAX_VELOCITY / 2, MAX_VELOCITY / 2)
	elseif sensor >= 13 and sensor <= 23 then
		robot.wheels.set_velocity(MAX_VELOCITY / 2, - MAX_VELOCITY / 2)
	end

end

function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

function destroy()
end
