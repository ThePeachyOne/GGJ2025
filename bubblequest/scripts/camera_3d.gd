extends Camera3D

var rot_x = 0
var ROTATE_ADJUST 
# Called when the node enters the scene tree for the first time.
func _ready():
	ROTATE_ADJUST = self.get_parent().get_rotate_adjust()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_input(event):
	match event.get_class():
		"InputEventMouseMotion":
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				
				#Move the mouse forwards and backwards to rotate on the local x axis.
				rot_x += event.relative.y * (ROTATE_ADJUST/2)
				rot_x = clamp(rot_x, -PI/2, PI/2)
				transform.basis = Basis() # reset rotation
				#rotate_object_local(Vector3(0,1,0),-rot_y) #Always gonna be the global y axis.
				rotate_object_local(Vector3(1, 0, 0), -rot_x)
