MAX_VELOCITY = 15

function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

function step()
	value = 0
	proximitySensor = 0
	for i=1,#robot.proximity do
		if value < robot.proximity[i].value then
			proximitySensor = i
			value = robot.proximity[i].value
		end
	end
	if value == 0 then
		left_v = robot.random.uniform(0,MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
	else
		--ostacolo a sinistra
		if sensor <= 6 then
			left_v = MAX_VELOCITY / 2
			right_v = - MAX_VELOCITY / 2
		--ostacolo a destra
		elseif sensor >= 19 then
			left_v = - MAX_VELOCITY / 2
			right_v = MAX_VELOCITY / 2
		--ostacolo alle spalle, vai dritto
		else
			left_v = MAX_VELOCITY
			right_v = MAX_VELOCITY
		end
	end
	robot.wheels.set_velocity(left_v,right_v)
end

function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
end

function destroy()
end
