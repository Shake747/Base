extends Area3D
@onready var left_spawn: Marker3D = $"../../LeftSpawn"
@onready var right_spawn: Marker3D = $"../../RightSpawn"
@onready var character_body_3d: CharacterBody3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().global_position.y < -10:
		get_tree().reload_current_scene()


func _on_left_area_area_entered(area: Area3D) -> void:
	get_parent().global_position = right_spawn.global_position
	get_parent().rotation.y = -get_parent().rotation.y
	

func _on_right_area_area_entered(area: Area3D) -> void:
	get_parent().global_position = left_spawn.global_position
	get_parent().rotation.y = -get_parent().rotation.y
	
