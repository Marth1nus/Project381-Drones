extends Camera3D

@export var tracking_target : Node3D

func _process(_delta):
	look_at(tracking_target.global_position)
