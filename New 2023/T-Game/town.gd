extends Node3D
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#character_body_3d.global_rotate(Vector3.UP, 180)
	pass


func _physics_process(delta: float) -> void:
	pass
