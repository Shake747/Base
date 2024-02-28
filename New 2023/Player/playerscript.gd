extends CharacterBody3D

@onready var look_pivot = $Head
@onready var animationtree : AnimationTree = $AnimationTree
@onready var ray_cast_3d_slope: ShapeCast3D = $RayCast3DSlope
@onready var spring_arm_3d: SpringArm3D = $Head/SpringArm3D
@onready var armature: Node3D = $Armature
@onready var camera_3d: Camera3D = $Head/SpringArm3D/Camera3D



@export var _mouse_sensitivity: float = 0.05
@export var jump_velocity = 5
@export var air_movement_control = .4
@export var movement_transition_value : float = 1
@export var default_speed = 5
@export var sprintspeed = 2
@export var animtree : NodePath

var last_global_position: Vector3

var speed = 0.0
var velocity_y = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
var previous_horizontal_velocity = Vector2()
var previous_y = Vector2()
var current_y = Vector2.ZERO
var horizontal_velocity = Vector2.ZERO
var direction = Vector2.ZERO
var last_direction = Vector2.ZERO
var mouse_lock : bool = false
var cursor = preload("res://16x16Cursor.png")
var walk_blend = Vector2.ZERO


#useful functions, may need in future:+++++++++++++++++++++++++++++++++++++
#func vec2_from_vec3(vec3, axis):
#	var array = [vec3.x, vec3.y, vec3.z]
#	array.remove(axis)
#	return Vector2(array[0], array[1])

#func vec3_from_vec2(vec2, axis, value):
#	var array = [vec2.x, vec2.y]
#	array.insert(axis, value)
#	return Vector3(array[0], array[1], array[2])
#useful^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animationtree.active = true
	
	
	
	#----------REMOVED AFTER PORT------------
#func movement_tween(vec2_delta,vec2_current,vec2_previous, NodePath):
#
#	var tween = get_tree().create_tween()
#	tween.tween_property(self, NodePath, vec2_current, .8)
#	vec2_delta = vec2_current - vec2_previous
#	Tween.interpolate_value(vec2_current, vec2_delta, 1.0, 1.0 ,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)




func _input(event):
	if event is InputEventMouseMotion && mouse_lock == false:
		#mouse movement
		look_pivot.rotate_y(deg_to_rad(-1 * event.relative.x) * _mouse_sensitivity)
		spring_arm_3d.rotate_x(deg_to_rad(-1 * event.relative.y) * _mouse_sensitivity)
		spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x , deg_to_rad(-45), deg_to_rad(45))

	
	#OLD CODE FOR OVER SHOULDER
	#if event is InputEventMouseMotion && mouse_lock == false:
		##mouse movement
		#rotate_y(deg_to_rad(-1 * event.relative.x) * _mouse_sensitivity)
		#look_pivot.rotate_x(deg_to_rad(-1 * event.relative.y) * _mouse_sensitivity)
		#look_pivot.rotation.x = clamp(look_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	elif mouse_lock == true:
		rotate_y(0)
		rotate_x(0)
		
		
func _physics_process(delta):
	
	if Input.is_action_just_pressed("move_forward"):
		direction = camera_3d.get_global_transform().basis.z
	#MOVEMENT INPUT AND ASSIGNMENT:
	#basic movement
	horizontal_velocity = Vector2 (
	(Input.get_action_strength("move_right")) - (Input.get_action_strength("move_left")),
	(Input.get_action_strength("move_forward")) - (Input.get_action_strength("move_backward"))).normalized() * speed
	#remember past frames (delta)
	var current_horizontal_velocity = horizontal_velocity
	var delta_horizontal_velocity = current_horizontal_velocity - previous_horizontal_velocity
	direction =  snapped((current_horizontal_velocity * .25 - delta_horizontal_velocity * .25), Vector2(0.01,0.01))
	current_y = Vector2(direction.x, (velocity_y * delta))
	var delta_y = current_y - previous_y
	
	
	#Groud check for smoother slope movement
	if ray_cast_3d_slope.is_colliding() && is_on_floor():
		position.y = ray_cast_3d_slope.get_collision_point(0).y 
		print("COLLISSSIONNNN")
	elif !is_on_floor():
		position.y = position.y

		
		#CHANGES CURSOR WITH ALT KEY
	if Input.is_action_just_pressed("alternate"):
		mouse_lock = !mouse_lock
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	if Input.is_action_pressed("alternate") && !mouse_lock:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		
		
	#jump
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity_y = jump_velocity
	#slow diagonal running speed
		
	#walk backwards slower
	if horizontal_velocity.y < 0:
		horizontal_velocity.y = horizontal_velocity.y * 0.5
		
	print("HV: ",horizontal_velocity)
	
	
#	if horizontal_velocity != Vector2.ZERO:
#		var tween = get_tree().create_tween()
#		tween.tween_property($AnimationTree,"parameters/StateMachine/Walk/blend_position",0.5,1.5)
		#Tween.interpolate_value(horizontal_velocity, delta_horizontal_velocity, 1.0, 2.0 ,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
		#print("HV VALUE IN TWEEN     :", horizontal_velocity)
		
	
	#----------REMOVED AFTER PORT------------
	#ANIMATION CALLS and KEY INPUT
	
	#crouching
	if Input.is_action_pressed("crouch") && is_on_floor():
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Standing", 0)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Crouching", 1)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/Crouching/blend_position", direction)
		speed = default_speed * 0.5
	else:
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Crouching", 0)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Standing", 1)
		speed = default_speed
#
#	#sprinting animations and control tweaks
	var sprinting: bool
	var walking: bool
	var idle: bool = true
	if Input.is_action_pressed("sprint") && is_on_floor() && horizontal_velocity != Vector2.ZERO:#animationtree.get("parameters/WalkIdleMachine/conditions/StandingStill") != 1:
		speed = default_speed * sprintspeed
		animationtree.set("parameters/WalkIdleMachine/conditions/Sprinting", 1)
		animationtree.set("parameters/WalkIdleMachine/Sprinting/blend_position", direction)
		animationtree.set("parameters/WalkIdleMachine/conditions/NotSprinting", 0)
		walk_blend = lerp(walk_blend, horizontal_velocity.normalized(), 0.25)
		sprinting = true
		walking = false
		idle = false
#		animationtree.set("parameters/StateMachine/conditions/NotSprinting", 0)
	else:
		speed = default_speed
		animationtree.set("parameters/WalkIdleMachine/conditions/Sprinting", 0)
		animationtree.set("parameters/WalkIdleMachine/conditions/NotSprinting", 1)
		sprinting = false
#	#standing and moving animations
	
	
	if horizontal_velocity != Vector2.ZERO && is_on_floor() && sprinting == false:
		animationtree.set("parameters/WalkIdleMachine/conditions/StandingStill", 0)
		animationtree.set("parameters/WalkIdleMachine/conditions/Walking", 1)
		walk_blend = lerp(walk_blend, horizontal_velocity.normalized(), 0.25) 
		animationtree.set("parameters/WalkIdleMachine/Walk/blend_position", walk_blend)
		walking = true
		idle = false
		sprinting = false
		print("walk_blend            :",walk_blend)
	else:
		animationtree.set("parameters/WalkIdleMachine/conditions/StandingStill", 1)
		animationtree.set("parameters/WalkIdleMachine/conditions/Walking", 0)
		walking = false
#	#jumping and falling animations and control tweaks
	if is_on_floor(): 
		armature.look_at(global_position - velocity, Vector3.UP, true)
		gravity = 0
		velocity = (horizontal_velocity.x * transform.basis.x)  + (horizontal_velocity.y * transform.basis.z) * -1
		#look_at(Vector3(direction.x,0 ,direction.y), Vector3.UP, true)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/Basic_Movements/blend_position", direction)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Onground", 1)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Jump_or_Fall", 0)
		
	else:
		horizontal_velocity *= previous_horizontal_velocity.length() * delta
		gravity = 9.8
		
		velocity += (((horizontal_velocity.x * transform.basis.x) + (horizontal_velocity.y * transform.basis.z) * -1))  * air_movement_control * .5
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Onground", 0)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/Jump_or_Fall", 1)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/Jump_Machine/blend_position", current_y )
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/StandingStill", 0)
#		$xbotpacked_extended/AnimationTree.set("parameters/StateMachine/conditions/MovingForward", 0)
		velocity_y -= gravity * delta
		
	#print("WALKING::::",walking,"SPRINTING::",sprinting, "IDLE",idle)
		
	if horizontal_velocity.length_squared() > speed:
		velocity = velocity.normalized() * speed
		
	#save for next frame
	previous_horizontal_velocity = current_horizontal_velocity * delta
	last_global_position = global_position
	previous_y = current_y
	last_direction = direction
	
	
	#pass off to move_slide
	velocity.y = velocity_y
	move_and_slide()
