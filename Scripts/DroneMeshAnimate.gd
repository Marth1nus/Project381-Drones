extends Node3D

@export var propeller_speed = 100.0
@export var propellers: Array[Node3D]
	
func _process(delta):
	for propeller in propellers:
		propeller.rotate_y(delta * propeller_speed)
