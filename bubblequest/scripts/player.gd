extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var ROTATE_ADJUST = 0.007
var rot_x: float
var rot_y: float
var can_move = true

#viewbob constants
var bob_frequency = 0.5
var bob_amplitude
var step_timer = bob_frequency

func get_rotate_adjust():
	return ROTATE_ADJUST


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if can_move:
		match event.get_class():
			"InputEventMouseMotion":
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					#Move the mouse side to side to rotate around the GLOBAL y axis.
					rot_y += event.relative.x * ROTATE_ADJUST
					#Move the mouse forwards and backwards to rotate on the local x axis.
					rot_x += event.relative.y * (ROTATE_ADJUST/2)
					rot_x = clamp(rot_x, -PI/2, PI/2)
					transform.basis = Basis() # reset rotation
					rotate_object_local(Vector3(0,1,0),-rot_y) #Always gonna be the global y axis.
					#rotate_object_local(Vector3(1, 0, 0), -rot_x)
					
			#"InputEventKey":
				#if Input.is_action_just_pressed("Escape"):
				#	get_tree().quit()
		
	


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Walk_Left", "Walk_Right", "Walk_Forward", "Walk_Backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if not $AudioStreamPlayer.playing and can_move:
			if step_timer <= 0:
				$AudioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
				$AudioStreamPlayer.play()
				step_timer = bob_frequency
			else:
				step_timer -=delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		

	if can_move:
		move_and_slide()
