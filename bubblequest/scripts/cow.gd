extends AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tmp = randi_range(0,2)
	match tmp:
		0:
			self.play("cow_idle")
		1:
			self.play("cow_walk")
		2:
			self.play("cow_eat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
