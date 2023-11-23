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
var box4_position = Vector3.ZERO  
var box5_position = Vector3.ZERO  

var targetPositions = [   #Drone Route
	box_position,
	box2_position,
	box3_position,
	box4_position, 
	box5_position  
]

var currentTargetIndex = 0
var isReturning = false  #Indicate if the drone is returning to the starting point

var start_position = Vector3.ZERO  #Store the starting point

func _ready():
	if has_node("box"):
		box_position = get_node("box").global_transform.origin
	if has_node("box2"):
		box2_position = get_node("box2").global_transform.origin
	if has_node("box3"):
		box3_position = get_node("box3").global_transform.origin
	if has_node("box4"):
		box4_position = get_node("box4").global_transform.origin  
	if has_node("box5"):
		box5_position = get_node("box5").global_transform.origin  

	targetPositions = [
		box_position,
		box2_position,
		box3_position,
		box4_position, 
		box5_position  
	]

	# Store the starting position of the drone
	start_position = global_transform.origin

func _physics_process(delta):
	var distanceThreshold = 0.5
	var heightAboveObject = 3.0  

	var currentTarget = targetPositions[currentTargetIndex] + Vector3(0, heightAboveObject, 0)  

	if position.distance_to(currentTarget) < distanceThreshold:
		if currentTargetIndex == targetPositions.size() - 1:
			isReturning = true  
			currentTargetIndex = 0 
		else:
			currentTargetIndex += 1

	if isReturning:
		currentTarget = start_position  # Set the target as the starting position
	
	var direction = (currentTarget - position).normalized()

	# Check if the drone has returned to its starting position
	if isReturning and position.distance_to(start_position) < distanceThreshold:
		# Stop the drone's movement
		motorFL_speed = 0.0
		motorFR_speed = 0.0
		motorBL_speed = 0.0
		motorBR_speed = 0.0

	else:
		# Continue normal movement
		var impulse = motor_force * delta
		apply_impulse(impulse * motorFL_speed, motorFL_offset)
		apply_impulse(impulse * motorFR_speed, motorFR_offset)
		apply_impulse(impulse * motorBL_speed, motorBL_offset)
		apply_impulse(impulse * motorBR_speed, motorBR_offset)

		var velocityChange = (direction * 2.2) - linear_velocity
		apply_impulse(velocityChange * mass, Vector3.ZERO)
