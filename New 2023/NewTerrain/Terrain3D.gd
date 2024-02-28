extends Node
#@export var shader := preload("res://hterrain/Shader/TerrainShader.tres")
const _material := preload("res://NewTerrain/new_terrain_3d_material.tres")
const texture_list := preload("res://NewTerrain/texture_list.res")
const new_storage := preload("res://NewTerrain/new_storage.res")
@onready var noise_generator: Node = $NoiseGenerator
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"
@onready var timer: Timer = $Timer
@onready var terrain_2: Terrain3D = $Terrain2

@export var map_size_x : int = 2048
@export var map_size_y : int = 2048
@export var final_map: Image
@export var map_height_scale: int = 600

#change these scales to alter map position and vertex density
@export var x_scale_pos: int = -1024
@export var z_scale_pos: int = -1024
@export var terrain : Terrain3D

@onready var noise1 = noise_generator.noise1
@onready var noise2 = noise_generator.noise2
@onready var noise3 = noise_generator.noise3

@export var img: Image

@export var material = Terrain3DMaterial


func _ready() -> void:

	terrain_2 = Terrain3D.new()
	#terrain.set_collision_enabled(false)
	#terrain.set_mesh_vertex_spacing(2.0)
	#terrain.storage = new_storage
	#terrain.texture_list = texture_list
	#terrain.material.world_background = Terrain3DMaterial.NOISE
	#terrain.material = _material
	#terrain.name = "Terrain3D"
	terrain_2.material.auto_shader = true
	#add_child(terrain, true)
	terrain.storage.add_region(Vector3(2048,0,2048))
	terrain.material.height_blending = false
	# Generate 32-bit noise and import it with scale
	var noise_1 = noise1.noise
	var noise_2 = noise2.noise
	var noise_3 = noise3.noise
	var img: Image = Image.create(map_size_x, map_size_y, true, Image.FORMAT_RF)
	for x in map_size_x:
		for y in map_size_y:
			img.set_pixel(x, y, Color(
				clamp(noise_1.get_noise_2d(x, y) * .3 + noise_1.get_noise_2d(x, y) * .001 ,0,.5 )+ noise_3.get_noise_2d(x, y) * .005,
				1.0 , 1.0 , 0))
			#img.set_pixel(x, y, Color((noise_1.get_noise_2d(x, y) * noise_2.get_noise_2d(x, y) * noise_1.get_noise_2d(x, y)) * 0.3, 0.0, 0.0, 1.0))
	terrain.storage.import_images([img, null, null], Vector3(x_scale_pos, 0, z_scale_pos), 0.0, map_height_scale)
	final_map = img
	
	# Enable collision. Enable the first if you wish to see it with Debug/Visible Collision Shapes
	#terrain.set_show_debug_collision(true)
	terrain.set_collision_enabled(true)
	var camera = character_body_3d.get_tree().get_first_node_in_group("camera")
	terrain.set_camera(camera)
	# Enable runtime navigation baking using the terrain
	#$RuntimeNavigationBaker.terrain = terrain
	#$RuntimeNavigationBaker.enabled = true
	
	# Retreive 512x512 region blur map showing where the regions are
	#var rbmap_rid: RID = terrain.material.get_region_blend_map()
	#img = RenderingServer.texture_2d_get(rbmap_rid)
	#$UI/TextureRect.texture = ImageTexture.create_from_image(img)
	
func _update_terrain():
	# Generate 32-bit noise and import it with scale
	terrain.global_position = character_body_3d.global_position
	print("terrain.global_transform    " , terrain.global_transform)
	
	
func _on_timer_timeout() -> void:
	_update_terrain()
