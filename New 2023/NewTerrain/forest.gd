extends Node3D

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	
func _process(delta: float) -> void:
	print("FPS   ",Engine.get_frames_per_second())
	pass
	
