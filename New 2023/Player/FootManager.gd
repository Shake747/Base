extends Node3D

@export var min_max_interpolation := Vector2(0, 0.9)
@export var foot_height_offset := 0.05

@onready var skeleton_ik_left_foot: SkeletonIK3D = $"../Armature/Skeleton3D/SkeletonIK_LeftFoot"
@onready var skeleton_ik_right_foot: SkeletonIK3D = $"../Armature/Skeleton3D/SkeletonIK_RightFoot"

@onready var target_right: Marker3D = $"../Armature/TargetRight"
@onready var target_right_no_cast: Marker3D = $"../Armature/TargetRight_NoCast"
@onready var interpolation_right_foot: Marker3D = $"../Armature/InterpolationRightFoot"
@onready var ray_cast_right_foot: RayCast3D = $"../Armature/RayCastRightFoot"
@onready var character: CharacterBody3D = $".."


@onready var target_left: Marker3D = $"../Armature/TargetLeft"
@onready var target_left_no_cast: Marker3D = $"../Armature/TargetLeft_NoCast"
@onready var interpolation_left_foot: Marker3D = $"../Armature/InterpolationLeftFoot"
@onready var ray_cast_left_foot: RayCast3D = $"../Armature/RayCastLeftFoot"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skeleton_ik_left_foot.start()
	skeleton_ik_right_foot.start()


func update_ik_target_pos(target, raycast , target_nocast, foot_height_off) -> void:
	if raycast.is_colliding():
		var hit_position = raycast.get_collision_point().y + foot_height_offset
		target.global_position.y = hit_position

	else:
		target.global_position.y = target_nocast.global_position.y


func _physics_process(delta: float) -> void:
	update_ik_target_pos(target_left, ray_cast_left_foot,target_left_no_cast, foot_height_offset)
	update_ik_target_pos(target_right, ray_cast_right_foot,target_right_no_cast, foot_height_offset)
	
	if character.idle == true:
		skeleton_ik_left_foot.interpolation = 1
		skeleton_ik_right_foot.interpolation = 1
	else:
		skeleton_ik_left_foot.interpolation = clamp(interpolation_left_foot.transform.origin.y, min_max_interpolation.x , min_max_interpolation.y)
		skeleton_ik_right_foot.interpolation = clamp(interpolation_right_foot.transform.origin.y, min_max_interpolation.x , min_max_interpolation.y)

