@tool
extends Node3D

var eye1: MeshInstance3D
var eye2: MeshInstance3D

var player: Node3D = null
var rand_look: Vector3 = rand_vec3()

# Called when the node enters the scene tree for the first time.
func _ready():
	eye1 = get_child(0)
	eye2 = get_child(1)
	if get_tree().has_group("player"):
		player = get_tree().get_first_node_in_group("player")
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randi_range(0, 30) == 25:
		rand_look = rand_vec3()
		
	if player != null:
		eye1.basis = eye1.basis.looking_at(player.position, Vector3(0, 1, 0), true)
	else:
		eye1.basis = lerp(eye1.basis, eye1.basis.looking_at(rand_look), 0.05)
	
	#print(eye1)
	eye2.basis = lerp(eye2.basis, eye2.basis.looking_at(rand_look), 0.05)
	
	
func rand_vec3() -> Vector3:
	var temp = Vector3()
	temp.x = randf_range(-0.8, 0.8)
	temp.y = randf_range(-0.8, 0.8)
	temp.z = -1
	return temp
