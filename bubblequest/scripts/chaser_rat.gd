extends CharacterBody3D

var SPEED = 6.8
var chase_object

# Called when the node enters the scene tree for the first time.
func _ready():
	chase_object = get_node("/root/rat_test_world/running_guy_root")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if chase_object != null:
		$NavigationAgent3D.target_position = chase_object.get_chase_point()
		#print(chase_object.position)
	
	var target = $NavigationAgent3D.get_next_path_position() - self.position
	var direction = (transform.basis * Vector3(target.x, 0, target.z)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	if self.position == $NavigationAgent3D.target_position:
		$MeshInstance3D.look_at(Vector3($NavigationAgent3D.target_position.x,
				self.position.y,
				$NavigationAgent3D.target_position.z),
				Vector3(0,1,0), false)
