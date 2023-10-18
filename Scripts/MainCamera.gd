extends Camera3D

@export var drone_node_path : NodePath
@onready var drone_node:Node3D = get_node(drone_node_path)

func _process(delta):
	look_at(drone_node.global_position)
	pass
