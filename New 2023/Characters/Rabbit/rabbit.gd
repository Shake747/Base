extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var rabbit: Node3D = $Rabbit
@onready var rabbit_bunny: CharacterBody3D = $"."
var is_hopping: bool
var playing_idle: bool
var body_entered: bool
@export var speed = 10
@export var run_anim_speed: float = 1.8

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var running: bool = false
var char_pos: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if !is_on_floor(): velocity.y -= gravity * delta
	if is_on_floor() && timer.time_left > 0:
		var run_away_from = global_position.direction_to(char_pos)
		run_val = true
		direction = -run_away_from

	direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	
	
	if velocity.x != 0 || velocity.y != 0:
		rabbit.rotation.y = lerp_angle(rabbit.rotation.y, atan2(direction.x, direction.z), .3)
	
	#if is_hopping == true:
		#direction.x += 2
		#direction.z += 2
		#var hop_timer = get_tree().create_timer(1)
		#await hop_timer.timeout
		#is_hopping == false
		#print("IS HOPPING")
	
	if velocity.x == 0 && velocity.z == 0:
		var anim = animation_player.get_animation("RabbitAnimationLib2/Run")
		anim.loop_mode = false
		idle_val = true
		#if is_hopping == true:
			#velocity.z += 2
	else:
		run_val = true
		var anim = animation_player.get_animation("RabbitAnimationLib2/Run")
		anim.loop_mode = true
		animation_player.play("RabbitAnimationLib2/Run", 0.1, run_anim_speed)
	
	
	move_and_slide()

var idle_val: bool = false:
	set(idle_state):
		idle_val = idle_state
		idle_handle(idle_val)
	
func idle_handle(idle_val: bool) -> void: 
	if idle_val == true && playing_idle == false && run_val == false:
		var rand = randi_range(0, 3)
		if rand == 0:
			animation_player.play("RabbitAnimationLib2/Idle")
			playing_idle = true
		if rand == 1:
			animation_player.play("RabbitAnimationLib2/Idle2")
			playing_idle = true
		if rand == 2:
			animation_player.play("RabbitAnimationLib2/single-hop")
			playing_idle = true
			is_hopping = true
			


var run_val: bool = false:
	set(run_state):
		run_val = run_state
		idle_handle(run_val)
	
func run_handle(run_val: bool) -> void: 
	if run_val == true:
		idle_val = false
		animation_player.play("RabbitAnimationLib2/Run", .1,run_anim_speed)
		var anim = animation_player.get_animation("RabbitAnimationLib2/Run")
		anim.loop_mode = true
		
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animation_player.play("RabbitAnimationLib2/Run", .1, run_anim_speed)
		var anim = animation_player.get_animation("RabbitAnimationLib2/Run")
		anim.loop_mode = true
		timer.start()
		char_pos = body.global_position
		body_entered = true
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	body_entered = false

func _on_timer_timeout() -> void:
	run_val = false
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "RabbitAnimationLib2/single-hop" || "RabbitAnimationLib2/Idle" || "RabbitAnimationLib2/Idle2":
		playing_idle = false
