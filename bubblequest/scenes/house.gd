@tool
extends StaticBody3D

@export var size : Vector3
@export var bevel_size=0.5
@export var material : StandardMaterial3D
@export var color : Color

func _ready() -> void:
	material = material.duplicate()
	material.albedo_color = color
	$CollisionShape3D.shape = BoxShape3D.new()
	$CollisionShape3D.shape.size = size
	$CollisionShape3D.transform.origin = Vector3(0, size.y/2, 0)
	
	var count = 0
	for i:MeshInstance3D in $pillars.get_children():
		i.mesh = CapsuleMesh.new()
		i.mesh.radius = bevel_size
		i.mesh.height = size.y
		i.mesh.surface_set_material(0, material)
		match count:
			0:
				i.transform.origin = Vector3(size.x/2-i.mesh.radius, size.y/2, size.z/2-i.mesh.radius)
			1:
				i.transform.origin = Vector3(-size.x/2+i.mesh.radius, size.y/2, size.z/2-i.mesh.radius)
			2:
				i.transform.origin = Vector3(size.x/2-i.mesh.radius, size.y/2, -size.z/2+i.mesh.radius)
			3:
				i.transform.origin = Vector3(-size.x/2+i.mesh.radius, size.y/2, -size.z/2+i.mesh.radius)
		count+=1
	count = 0
	for i:MeshInstance3D in $lbars.get_children():
		i.mesh = CapsuleMesh.new()
		i.mesh.radius = bevel_size
		i.mesh.height = size.x
		i.mesh.surface_set_material(0, material)
		match count:
			0:
				i.transform.origin = Vector3(0, size.y-i.mesh.radius, size.z/2-i.mesh.radius)
			1:
				i.transform.origin = Vector3(0, size.y-i.mesh.radius, -size.z/2+i.mesh.radius)
			2:
				i.transform.origin = Vector3(0, i.mesh.radius, size.z/2-i.mesh.radius)
			3:
				i.transform.origin = Vector3(0, i.mesh.radius, -size.z/2+i.mesh.radius)
		count+=1
	count = 0
	for i:MeshInstance3D in $hbars.get_children():
		i.mesh = CapsuleMesh.new()
		i.mesh.radius = bevel_size
		i.mesh.height = size.z
		i.mesh.surface_set_material(0, material)
		match count:
			0:
				i.transform.origin = Vector3(size.x/2-i.mesh.radius, size.y-i.mesh.radius, 0)
			1:
				i.transform.origin = Vector3(-size.x/2+i.mesh.radius, size.y-i.mesh.radius, 0)
			2:
				i.transform.origin = Vector3(size.x/2-i.mesh.radius, i.mesh.radius, 0)
			3:
				i.transform.origin = Vector3(-size.x/2+i.mesh.radius, i.mesh.radius, 0)
		count+=1
	count = 0
	$lwalls/MeshInstance3D13.mesh = QuadMesh.new()
	$lwalls/MeshInstance3D13.mesh.size = Vector2(size.x-$lbars/MeshInstance3D5.mesh.radius*2, size.y-$lbars/MeshInstance3D5.mesh.radius*2)
	$lwalls/MeshInstance3D13.mesh.surface_set_material(0, material)
	$lwalls/MeshInstance3D13.transform.origin = Vector3(0, size.y/2, size.z/2)
	$lwalls/MeshInstance3D14.mesh = QuadMesh.new()
	$lwalls/MeshInstance3D14.mesh.size = Vector2(size.x-$lbars/MeshInstance3D5.mesh.radius*2, size.y-$lbars/MeshInstance3D5.mesh.radius*2)
	$lwalls/MeshInstance3D14.mesh.surface_set_material(0, material)
	$lwalls/MeshInstance3D14.transform.origin= Vector3(0, size.y/2, -size.z/2)
	$hwalls/MeshInstance3D15.mesh = QuadMesh.new()
	$hwalls/MeshInstance3D15.mesh.size = Vector2(size.z-$lbars/MeshInstance3D5.mesh.radius*2, size.y-$lbars/MeshInstance3D5.mesh.radius*2)
	$hwalls/MeshInstance3D15.mesh.surface_set_material(0, material)
	$hwalls/MeshInstance3D15.transform.origin = Vector3(size.x/2, size.y/2, 0)
	$hwalls/MeshInstance3D16.mesh = QuadMesh.new()
	$hwalls/MeshInstance3D16.mesh.size = Vector2(size.z-$lbars/MeshInstance3D5.mesh.radius*2, size.y-$lbars/MeshInstance3D5.mesh.radius*2)
	$hwalls/MeshInstance3D16.mesh.surface_set_material(0, material)
	$hwalls/MeshInstance3D16.transform.origin= Vector3(-size.x/2, size.y/2, 0)
	$caps/MeshInstance3D17.mesh = QuadMesh.new()
	$caps/MeshInstance3D17.mesh.orientation = 1
	$caps/MeshInstance3D17.mesh.size = Vector2(size.x-$lbars/MeshInstance3D5.mesh.radius*2, size.z-$lbars/MeshInstance3D5.mesh.radius*2)
	$caps/MeshInstance3D17.mesh.surface_set_material(0, material)
	$caps/MeshInstance3D17.transform.origin = Vector3(0, size.y, 0)
	$caps/MeshInstance3D18.mesh = QuadMesh.new()
	$caps/MeshInstance3D18.mesh.orientation = 1
	$caps/MeshInstance3D18.mesh.size = Vector2(size.x-$lbars/MeshInstance3D5.mesh.radius*2, size.z-$lbars/MeshInstance3D5.mesh.radius*2)
	$caps/MeshInstance3D18.mesh.surface_set_material(0, material)
	$caps/MeshInstance3D18.transform.origin= Vector3(0, 0, 0)
