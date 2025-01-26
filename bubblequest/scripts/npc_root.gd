extends Area3D

@export var ThreeDee : bool

var playerInArea = false
var canActivateDialog = true
var NAMEHERE = ""
@export_file var DIALOGFILE = "res://assets/text/TEST_dracula_dialog.txt"
@export_file var CHOICEFILE = "res://assets/text/TEST_choices.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$CutsceneManager.universal_dialog_file = DIALOGFILE
	$CutsceneManager.option_text_file = CHOICEFILE
	$CutsceneManager.dialog_options = PackedStringArray()
	$CutsceneManager._ready()
	
	$npcInteractText.mesh.text += NAMEHERE
	
	if ThreeDee:
		$IMAGE_HERE.visible = false
	else:
		$MODEL_HERE.visible = false
	


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
