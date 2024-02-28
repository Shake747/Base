extends AnimationTree

@onready var camera: Camera3D = $"../Head/HeadPivot/SpringArm3D/Camera3D"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../CollisionShape3D"
@onready var character_body_3d: CharacterBody3D = $".."

#@export var zooming_in: bool = false
@export var zoom_in_out_amount: float = 1
@export var camera_y_pos_zoom_amount: float = .1
@onready var spring_arm: SpringArm3D = $"../Head/HeadPivot/SpringArm3D"

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	
	var current_springarm_len = spring_arm.spring_length
	var spring_arm_pos_y: float = spring_arm.position.y
	if Input.is_action_just_pressed("zoom_in"):
		current_springarm_len = clamp(current_springarm_len - zoom_in_out_amount, 1, 5)
		spring_arm_pos_y = clamp(spring_arm_pos_y - camera_y_pos_zoom_amount, 0, .5)
	
	if Input.is_action_just_pressed("zoom_out"):
		current_springarm_len = clamp(current_springarm_len + zoom_in_out_amount, 1, 5)
		spring_arm_pos_y = clamp(spring_arm_pos_y + camera_y_pos_zoom_amount, 0, .5)
		
	if current_springarm_len != spring_arm.spring_length:
		var tween = create_tween()
		tween.tween_property(spring_arm,"spring_length",current_springarm_len,.2)

	if spring_arm_pos_y != spring_arm.position.y:
		var tween = create_tween()
		tween.tween_property(spring_arm,"position:y",spring_arm_pos_y,.2)

var walking: bool:
	set(walking_state):
		walking = walking_state
		walk_handle(walking)

func walk_handle(walk_val: bool) -> void:
	if walk_val == true:
		set("parameters/WalkIdleMachine/conditions/walking" ,1)
		set("parameters/WalkIdleMachine/conditions/not_walking", 0)
	if walk_val == false:
		set("parameters/WalkIdleMachine/conditions/walking" ,0)
		set("parameters/WalkIdleMachine/conditions/not_walking", 1)
	
var sprinting: bool:
	set(sprinting_state):
		sprinting = sprinting_state
		sprint_handle(sprinting)
	
func sprint_handle(sprint_val: bool) -> void:
	if sprinting == true:
		set("parameters/WalkIdleMachine/conditions/sprinting" , 1)
		set("parameters/WalkIdleMachine/conditions/not_sprinting" ,0)
	if sprinting == false:
		set("parameters/WalkIdleMachine/conditions/not_sprinting" , 1)
		set("parameters/WalkIdleMachine/conditions/sprinting" ,0)
	
var falling: bool:
	set(falling_state):
		falling = falling_state
		falling_handle(falling)
	
func falling_handle(sprint_val: bool) -> void:
	if falling == true:
		set("parameters/WalkIdleMachine/conditions/falling" , 1)
		set("parameters/WalkIdleMachine/conditions/not_falling" ,0)
		#collision_shape_3d.shape.height = 1.353
		#collision_shape_3d.position.y = 1.021
		
	if falling == false:
		set("parameters/WalkIdleMachine/conditions/not_falling" , 1)
		set("parameters/WalkIdleMachine/conditions/falling" ,0)
		#collision_shape_3d.shape.height = 1.7
		#collision_shape_3d.position.y = .877
