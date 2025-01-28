@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("SpatializedAudioStreamPlayer3D", "AudioStreamPlayer3D", preload("SpatializedAudioStreamPlayer3D.gd"), preload("AudioStreamPlayer3D.svg"))
	add_custom_type("SpatializedCamera3D", "Camera3D", preload("SpatializedCamera3D.gd"), preload("Camera3D.svg"))
	add_custom_type("SceneChangeButton", "Button", preload("SceneChangeButton.gd"), preload("Button.svg"))
	add_custom_type("BaseMenuSystem", "Control", preload("BaseMenu.gd"), preload("Window.svg"))
	add_custom_type("FollowerArm3D", "SpringArm3D", preload("FollowerArm3D.gd"), preload("SpringArm3D.svg"))
	add_custom_type("VirtualEye3D", "Node3D", preload("VirtualEye.gd"), preload("Eye.svg"))
	add_custom_type("VirtualMouth3D", "Node3D", preload("VirtualMouth.gd"), preload("Mouth.svg"))
	add_custom_type("MoCapBone", "Node3D", preload("MoCapBone.gd"), preload("MoCap_Marker.svg"))
	add_custom_type("DialogueManager", "Label", preload("dialogueManager.gd"), preload("Dialogue.svg"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("SpatializedAudioStreamPlayer3D")
	remove_custom_type("SpatializedCamera3D")
	remove_custom_type("SceneChangeButton")
	remove_custom_type("BaseMenuSystem")
	remove_custom_type("FollowerArm3D")
	remove_custom_type("VirtualEye3D")
	remove_custom_type("VirtualMouth3D")
	remove_custom_type("MoCapBone")
	remove_custom_type("DialogueManager")
