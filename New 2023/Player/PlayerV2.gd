extends CharacterBody3D
var cursor = preload("res://Icons/16x16Cursor.png")
var mouse_lock: bool = false
var horizontal_velocity = Vector2.ZERO

#for t-game
#@onready var left_spawn: Marker3D = $"../LeftSpawn"
#@onready var right_spawn: Marker3D = $"../RightSpawn"




var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var horiz_direction: Vector2

@export var moving: float
@export var _mouse_sensitivity: float = 0.05
@export var jump_strength: float = 5
@export var speed: float = 4.0
@export var sprint_speed: float = 2.5
@export var turn_speed: float = 8
@export var air_control: float = 5.0
@export var idle: bool

@onready var armature: Node3D = $Armature
@onready var spring_arm: SpringArm3D = $Head/HeadPivot/SpringArm3D
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/HeadPivot/SpringArm3D/Camera3D
@onready var head_pivot: Node3D = $Head/HeadPivot
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var character_body_3d: CharacterBody3D = $"."


func _ready():
	Input.set_custom_mouse_cursor(cursor)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion && mouse_lock == false:
		#mouse movement
		head_pivot.rotate_y(deg_to_rad(-1 * event.relative.x) * _mouse_sensitivity)
		spring_arm.rotate_x(deg_to_rad(-1 * event.relative.y) * _mouse_sensitivity)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x , deg_to_rad(-45), deg_to_rad(45))
		
		
func _process(delta: float) -> void:
	pass
		
func _physics_process(delta: float) -> void:
	
	
	
	var direction = Vector3.ZERO
	idle = false
	#use this below to control animation sliders
	if Input.is_action_pressed("alternate"):
		mouse_lock = !mouse_lock
	if mouse_lock == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if mouse_lock == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		animation_tree.walking = false
		animation_tree.sprinting = false
		animation_tree.falling = true
		idle = false
		
		
		if Input.is_action_pressed("move_forward"):
			direction -= camera.global_transform.basis.z
		if Input.is_action_pressed("move_backward"):
			direction += camera.global_transform.basis.z
		if Input.is_action_pressed("move_left"):
			direction -= camera.global_transform.basis.x
		if Input.is_action_pressed("move_right"):
			direction += camera.global_transform.basis.x
		direction = direction.normalized()
		velocity.x += (direction.x /4) * delta * air_control
		velocity.z += (direction.z /4) * delta * air_control
		
		
	if Input.is_action_just_pressed("jump"): #and is_on_floor():
		velocity.y += jump_strength
		
	if is_on_floor():
		animation_tree.falling = false
		animation_tree.walking = false
		animation_tree.sprinting = false
		if Input.is_action_pressed("move_forward"):
			direction -= camera.global_transform.basis.z
			animation_tree.walking = true
		if Input.is_action_pressed("move_backward"):
			direction += camera.global_transform.basis.z
			animation_tree.walking = true
		if Input.is_action_pressed("move_left"):
			direction -= camera.global_transform.basis.x
			animation_tree.walking = true
		if Input.is_action_pressed("move_right"):
			direction += camera.global_transform.basis.x
			animation_tree.walking = true
		direction = direction.normalized()
		
		
		
		if Input.is_action_pressed("sprint"):
			direction *= sprint_speed
			animation_tree.sprinting = true
			
			
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed
		
	#smooths player turning, and sets idle for feet Y position
	if velocity.x != 0 || velocity.z != 0:
		idle = false
		armature.rotation.y  = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), delta * turn_speed)
	else:
		idle = true
	if animation_tree.falling == true:
		idle = false
		
	move_and_slide()
	



