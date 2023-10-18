extends RigidBody3D

@export var motorFL_speed = 0.0
@export var motorFR_speed = 0.0
@export var motorBL_speed = 0.0
@export var motorBR_speed = 0.0

const motor_offset = 0.12
const motorFL_offset = Vector3(+1, 0, +1) * motor_offset
const motorFR_offset = Vector3(-1, 0, +1) * motor_offset
const motorBL_offset = Vector3(+1, 0, -1) * motor_offset
const motorBR_offset = Vector3(-1, 0, -1) * motor_offset

const motor_force = Vector3(0,1,0) * 10.0

func _physics_process(delta):
	var impulse = motor_force * delta
	apply_impulse(impulse * motorFL_speed, motorFL_offset)
	apply_impulse(impulse * motorFR_speed, motorFR_offset)
	apply_impulse(impulse * motorBL_speed, motorBL_offset)
	apply_impulse(impulse * motorBR_speed, motorBR_offset)
