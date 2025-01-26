class_name npcRoot
extends Area3D

@export var ThreeDee : bool

var playerInArea = false
var canActivateDialog = true
@export var NAMEHERE = "badName"
@export_file var DIALOGFILE = "res://assets/text/TEST_dracula_dialog.txt"
@export_file var CHOICEFILE = "res://assets/text/TEST_choices.txt"
@export var IMAGE : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$CutsceneManager.universal_dialog_file = DIALOGFILE
	$CutsceneManager.option_text_file = CHOICEFILE
	$CutsceneManager.dialog_options = PackedStringArray()
	$CutsceneManager._ready()
	
	$npcInteractText.mesh = $npcInteractText.mesh.duplicate()
	$npcInteractText.mesh.text += NAMEHERE
	
	if ThreeDee:
		$IMAGE_HERE.visible = false
	else:
		$MODEL_HERE.visible = false
		$IMAGE_HERE.mesh = $IMAGE_HERE.mesh.duplicate()
		$IMAGE_HERE.mesh.material = $IMAGE_HERE.mesh.material.duplicate()
		$IMAGE_HERE.mesh.material.albedo_texture = IMAGE
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event: InputEvent):
	if event.is_action_pressed("Interact") and playerInArea and canActivateDialog: 
		print("START DIALOG HERE")
		canActivateDialog = false
		$CutsceneManager.activate_dialog()
		

func _on_body_entered(body):
	if body.is_in_group("player"):
		playerInArea = true
		$npcInteractText.visible = true
	

func _on_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
		$npcInteractText.visible = false

#func customsignal():
	#$CutsceneManager.one_file_box.dialog_box_advanced.connect(methodNAme)
	
	
	
	
