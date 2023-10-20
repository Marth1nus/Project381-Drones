extends RigidBody3D

@export_range(0.0, 1.0, 0.01) var lift_speed = 0.0

const motor_position = 0.11
const motorFL_position = Vector3(+1, 0, +1) * motor_position
const motorFR_position = Vector3(-1, 0, +1) * motor_position
const motorBL_position = Vector3(+1, 0, -1) * motor_position
const motorBR_position = Vector3(-1, 0, -1) * motor_position

const gravity_acceleration = 9.8
const motor_acceleration = Vector3(0, 1, 0) * gravity_acceleration * 2 * 16.9 # 50% speed should basely excede gravity

func _physics_process(delta):
	
	# apply lift from all 4 motors
	lift_speed = clamp(lift_speed, 0, 1)
	var lift = to_global(motor_acceleration * delta * lift_speed)
	apply_force(lift, motorFL_position)
	apply_force(lift, motorFR_position)
	apply_force(lift, motorBL_position)
	apply_force(lift, motorBR_position)
	
