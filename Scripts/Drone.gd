extends RigidBody3D

@export var motorFL_speed = 0.0
@export var motorFR_speed = 0.0
@export var motorBL_speed = 0.0
@export var motorBR_speed = 0.0

const motor_offset = Vector3(1, 0, 1) * 0.12
const motorFL_offset = Vector3(1, 0, 1) * motor_offset
const motorFR_offset = Vector3(-1, 0, 1) * motor_offset
const motorBL_offset = Vector3(1, 0, -1) * motor_offset
const motorBR_offset = Vector3(-1, 0, -1) * motor_offset

const motor_force = Vector3(0, 1, 0) * 5.0

var box_position = Vector3.ZERO
var box2_position = Vector3.ZERO
var box3_position = Vector3.ZERO

var targetPositions = [
	box_position,
	box2_position,
	box3_position
]

var currentTargetIndex = 0
var isReturning = false  # Flag to indicate if the drone is returning to the starting point

func _ready():
	if has_node("box"):
		box_position = get_node("box").global_transform.origin
	if has_node("box2"):
		box2_position = get_node("box2").global_transform.origin
	if has_node("box3"):
		box3_position = get_node("box3").global_transform.origin

	targetPositions = [
		box_position,
		box2_position,
		box3_position
	]

func _physics_process(delta):
	var distanceThreshold = 0.1
	var heightAboveObject = 5.0  # Desired height above the object

	var currentTarget = targetPositions[currentTargetIndex] + Vector3(0, heightAboveObject, 0)  # Add height offset to the target position

	if position.distance_to(currentTarget) < distanceThreshold:
		if currentTargetIndex == targetPositions.size() - 1:
			isReturning = true  # Set the flag to indicate the drone is returning to the starting point
			currentTargetIndex = 0  # Reset the target index to the starting point
		else:
			currentTargetIndex += 1

	if isReturning:
		currentTarget = Vector3.ZERO  # Set the target position to the starting point

	var direction = (currentTarget - position).normalized()

	var impulse = motor_force * delta
	apply_impulse(impulse * motorFL_speed, motorFL_offset)
	apply_impulse(impulse * motorFR_speed, motorFR_offset)
	apply_impulse(impulse * motorBL_speed, motorBL_offset)
	apply_impulse(impulse * motorBR_speed, motorBR_offset)

	var velocityChange = (direction * 5.0) - linear_velocity
	apply_impulse(velocityChange * mass, Vector3.ZERO)
