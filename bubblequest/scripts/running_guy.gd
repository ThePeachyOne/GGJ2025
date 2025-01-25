extends CharacterBody3D

var SPEED = 7.0

func distance( a,  b):
	var x = (a.x - b.x) ** 2
	var y = (a.y - b.y) ** 2
	var z = (a.z - b.z) ** 2
	return sqrt(x + y + z)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationAgent3D.target_position = Vector3(20, 0, 20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = $NavigationAgent3D.get_next_path_position() - self.position
	direction = (transform.basis * Vector3(direction.x, 0, direction.z)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
	move_and_slide()
	print(distance(self.position, $NavigationAgent3D.target_position))
	print($NavigationAgent3D.target_position)
	print("How far? " + str(distance(self.position, $NavigationAgent3D.target_position)))
	if distance(self.position, $NavigationAgent3D.target_position) < 2:
		print("funky")
		$NavigationAgent3D.target_position = Vector3(randi_range(-20,20), 0, randi_range(-20,20))
		
		
	
