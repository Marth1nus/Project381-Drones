extends RigidBody3D

################################################################################

const direction_up = Vector3(0, 1, 0)
const direction_front = Vector3(0, 0, 1)
const direction_right = Vector3(1, 0, 0)

const direction_down = -direction_up
const direction_back = -direction_front
const direction_left = -direction_right

const motor_position = 0.11
const motorFL_position = (direction_front + direction_left) * motor_position
const motorFR_position = (direction_front + direction_right) * motor_position
const motorBL_position = (direction_back + direction_left) * motor_position
const motorBR_position = (direction_back + direction_right) * motor_position

const gravity_acceleration = 9.8
const motor_acceleration = direction_up * gravity_acceleration * 2 * 16.9 # 50% speed should barely excede gravity

################################################################################

var motor_speed = 0.0
var motorFL_speed = 0.0
var motorFR_speed = 0.0
var motorBL_speed = 0.0
var motorBR_speed = 0.0

var motor_move_target = Vector3(0, 0, 0)
var global_position_old : Vector3

################################################################################

func _physics_process(delta):
	var motor_move_diff = global_position - global_position_old
	
	global_position_old = global_position
	motor_move_target -= motor_move_diff

	var motor_move_direction = motor_move_target.normalized()
	var lift_direction = to_global(direction_up).normalized()
	var lift_direction_error = motor_move_target.normalized() - lift_direction
	var facing_direction = to_global(direction_front).normalized()

	# Drone moves faster if it is tilted in the direct/oposite direction for the target
	var motor_move_speed = lift_direction.dot(motor_move_direction) * 0.5 + 0.5

	# TODO: modify individual motor speeds to tild drone in movement direction
	
	# TODO: find and follow QR targets. rotation.y reserved for modification here.

	var common_force = motor_acceleration * delta * motor_speed * motor_move_speed
	apply_force(to_global(common_force * motorFL_speed), motorFL_position)
	apply_force(to_global(common_force * motorFR_speed), motorFR_position)
	apply_force(to_global(common_force * motorBL_speed), motorBL_position)
	apply_force(to_global(common_force * motorBR_speed), motorBR_position)

func motor_move(move:Vector3):
	motor_move_target = move
	
func _ready():
	global_position_old = global_position
	
################################################################################
