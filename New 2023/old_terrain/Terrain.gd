extends StaticBody3D

@export var mesh_generate: bool
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@export var texture: NoiseTexture2D
@export var texture2: NoiseTexture2D
#@export var texture3: NoiseTexture2D
@export var mesh_size: Vector2




func _process(delta: float) -> void:
	generate_mesh()
	



func generate_mesh():
	if mesh_generate == true:
		#await texture.changed
		print("generating mesh...")
		var plane_mesh = PlaneMesh.new()
		plane_mesh.size = mesh_size
		plane_mesh.subdivide_depth = (512) - 1
		plane_mesh.subdivide_width = (512)- 1
		
		var surface_tool = SurfaceTool.new()
		surface_tool.create_from(plane_mesh, 0)
		var data = surface_tool.commit_to_arrays()
		var verticies = data[ArrayMesh.ARRAY_VERTEX]
		
		for i in verticies.size():
			var vertex = verticies[i]
			verticies[i].y = (texture.noise.get_noise_2d(vertex.x, vertex.z) * texture2.noise.get_noise_2d(vertex.x, vertex.z)) * 32
		
		data [ArrayMesh.ARRAY_VERTEX] = verticies
		
		var array_mesh = ArrayMesh.new()
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
		
		surface_tool.create_from(array_mesh, 0)
		surface_tool.generate_normals()
		
		mesh_instance_3d.mesh = surface_tool.commit()
		collision_shape_3d.shape = array_mesh.create_trimesh_shape()
		set_process(false)
	
