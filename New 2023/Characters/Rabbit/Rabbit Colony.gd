extends Node3D
@export var rabbit: PackedScene
@export var number_of_rabbits: int = 50


func _ready() -> void:
	rabbit_spawner()


func rabbit_spawner() -> void:
	for i in number_of_rabbits:
		var spawn_rabbit = rabbit.instantiate()
		add_child(spawn_rabbit)
		spawn_rabbit.position = Vector3(randi() % 15, get_parent_node_3d().global_position.y, randi() % 15)
	
	
