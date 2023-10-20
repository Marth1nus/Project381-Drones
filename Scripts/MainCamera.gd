extends Camera3D

@export var tracking_target : Node3D

func _process(delta):
	look_at(tracking_target.global_position)
