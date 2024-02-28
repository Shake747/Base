extends Area3D
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"
@onready var left_spawn: Marker3D = $"../LeftSpawn"
@onready var right_spawn: Marker3D = $"../RightSpawn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_overlapping_areas()


