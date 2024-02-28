extends Terrain3D

@onready var noise_generator: Node = $NoiseGenerator
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"


@export var map_size_x : int = 2048  #size of the noise image captured
@export var map_size_y : int = 2048
@export var final_map: Image
@export var map_height_scale: int = 1

@export var x_scale_pos: int = -1024
@export var z_scale_pos: int = -1024

@onready var noise1 = noise_generator.noise1
@onready var noise2 = noise_generator.noise2
@onready var noise3 = noise_generator.noise3

@export var img: Image


func _ready() -> void:
	
	#create image from noise layers
	var noise_1 = noise1.noise
	var noise_2 = noise2.noise
	var noise_3 = noise3.noise
	var img: Image = Image.create(map_size_x, map_size_y, true, Image.FORMAT_RF)
	for x in map_size_x:
		for y in map_size_y:
			img.set_pixel(x, y, Color(
				clamp(noise_1.get_noise_2d(x, y) * .3 + noise_1.get_noise_2d(x, y) * .001 ,0,.5 )+ noise_3.get_noise_2d(x, y) * .005,
				1.0 , 1.0 , 0))
				
	storage.import_images([img, null, null], Vector3(x_scale_pos, 0.0, z_scale_pos), 0.0, map_height_scale)
	final_map = img
	
	#mesh_size *= 8
	
