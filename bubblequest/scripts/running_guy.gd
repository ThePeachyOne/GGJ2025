extends CharacterBody3D

var SPEED = 7.0
@export var lower_bound: Vector2 = Vector2(0,0)
@export var upper_bound: Vector2 = Vector2(0,0)

func distance( a,  b):
	var x = (a.x - b.x) ** 2
	var y = (a.y - b.y) ** 2
	var z = (a.z - b.z) ** 2
	return sqrt(x + y + z)


# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationAgent3D.target_position = Vector3(randf_range(lower_bound.x,upper_bound.x),
													 0,
													 randf_range(lower_bound.y,upper_bound.y))
	$MeshInstance3D.look_at(Vector3($NavigationAgent3D.target_position.x,
			self.position.y,
			$NavigationAgent3D.target_position.z),
			Vector3(0,1,0), false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = $NavigationAgent3D.get_next_path_position() - self.position
	
	direction = (transform.basis * Vector3(direction.x, self.position.y, direction.z)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
	move_and_slide()
	
	#print(distance(self.position, $NavigationAgent3D.target_position))
	#print($NavigationAgent3D.target_position)
	#print("How far? " + str(distance(self.position, $NavigationAgent3D.target_position)))
	if distance(self.position, $NavigationAgent3D.target_position) < 2:
		#print("funky")
		$NavigationAgent3D.target_position = Vector3(randf_range(lower_bound.x,upper_bound.x),
													 0,
													 randf_range(lower_bound.y,upper_bound.y))

		$MeshInstance3D.look_at(Vector3($NavigationAgent3D.target_position.x,
			self.position.y,
			$NavigationAgent3D.target_position.z),
			Vector3(0,1,0), false)
			
			
	if $MeshInstance3D/RayCast3D.is_colliding():
		var obj = $MeshInstance3D/RayCast3D.get_collider()
		print(obj.get_class())
		if obj.get_class() == "CharacterBody3D":
			print("hooray")
			$NavigationAgent3D.target_position = Vector3(randf_range(lower_bound.x,upper_bound.x),
													 0,
													 randf_range(lower_bound.y,upper_bound.y))
			$MeshInstance3D.look_at(Vector3($NavigationAgent3D.target_position.x,
				self.position.y,
				$NavigationAgent3D.target_position.z),
				Vector3(0,1,0), false)
			
			
func get_chase_point():
	return $MeshInstance3D/follow_point.global_position
