@tool
extends Node3D

## How many spawners, simple as that.
@export var num_spawners: int = 1

var bubbleSpawner = preload("res://scenes/bubble_spout.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var pos = position
	var x_range: float = self.mesh.size.x/2
	var z_range: float = self.mesh.size.z/2
	for i in range(num_spawners):
		var instance = bubbleSpawner.instantiate()
		pos.x = randf_range(position.x - x_range, position.x + x_range)
		pos.z = randf_range(position.z - z_range, position.z + z_range)
		instance.position = pos
		instance.get_child(0).visible = false
		instance.preprocess = randf_range(0, 10)
		add_child(instance)
		#print(pos)
	self.mesh.material.albedo_color.a = 0
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
