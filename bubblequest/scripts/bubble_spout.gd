extends GPUParticles3D

var timer = randf_range(1, 12)

func _ready() -> void:
	$AnimatedSprite3D.play("fizz")

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		emit_particle(global_transform, Vector3.ZERO, Color(1, 1, 1, 0.7), Color(1, 1, 1), 8 )
		$SpatializedAudioStreamPlayer3D2.play()
		timer = randf_range(1, 12)
