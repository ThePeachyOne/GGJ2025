extends Area3D

@export var ambience : AudioStream
@export var player_group = "Player"

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(player_group):
		get_tree().get_first_node_in_group("SpatializedCamera3DsSpecialAwesomeSuperGroup").change_ambience(ambience)
