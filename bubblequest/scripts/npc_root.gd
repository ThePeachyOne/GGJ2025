class_name npcRoot
extends Area3D

@export var ThreeDee : bool
@export var potato : bool
@export var fishicca : bool
@export var rock : bool
@export var jorb : bool

var playerInArea = false
var canActivateDialog = true
@export var NAMEHERE = "badName"
@export_file var DIALOGFILE = "res://assets/text/TEST_dracula_dialog.txt"
@export_file var CHOICEFILE = "res://assets/text/TEST_choices.txt"
@export var IMAGE = [] 
var imageCount = 0
var speakCount = 0 

var speaking = false	#To be used when the character is speaking, used for speaking/extra animations

@export var MAX_lines = 50
@export var split_line = 48
#^this is the line of dialogue at which a question is posed
#we can use the difference between this and MAX_lines to tell where to skip to in the audioList when we make a desicion

@export var audioList = []
@export var volume_db = 0
var audioCount = 0

var chosen_value = -1		#returned value from the player's choice. 0 is nonbubbled choice, 1 is bubbled choice
var playerChose = false
var bubbled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$npcSpeak.volume_db = volume_db
	
	$CutsceneManager.universal_dialog_file = DIALOGFILE
	$CutsceneManager.option_text_file = CHOICEFILE
	$CutsceneManager.dialog_options = PackedStringArray()
	$CutsceneManager._ready()
	
	$npcInteractText.mesh = $npcInteractText.mesh.duplicate()
	$npcInteractText.mesh.text += NAMEHERE
	
	$CutsceneManager.one_file_box.dialog_box_advanced.connect(dialogAdvanced)
	
	$npcSpeak.stream = audioList[audioCount]
	
	if ThreeDee:
		$IMAGE_HERE.visible = false
		if potato:
			$potato.visible = true
		if fishicca:
			$fishicca.visible = true
		if rock:
			$potato.visible = true
		if jorb:
			$jorb.visible = true
		
	else:
		$IMAGE_HERE.mesh = $IMAGE_HERE.mesh.duplicate()
		$IMAGE_HERE.mesh.material = $IMAGE_HERE.mesh.material.duplicate()
		$IMAGE_HERE.mesh.material.albedo_texture = IMAGE[0]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_key_input(event: InputEvent):
	if event.is_action_pressed("Interact") and playerInArea and canActivateDialog: 
		print("START DIALOG HERE")
		canActivateDialog = false
		$npcInteractText.visible = false
		
		$CutsceneManager.activate_dialog()
		$npcSpeak.play()
		$speakTimer.start()
		
		

func _on_body_entered(body):
	if body.is_in_group("player"):
		playerInArea = true
		if canActivateDialog:
			$npcInteractText.visible = true
	

func _on_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
		$npcInteractText.visible = false

func dialogAdvanced():
	print("received")
	$speakTimer.start()
	
	audioCount+=1
	
	if playerChose:
		if chosen_value == 0:
			playerChose = false	#do nothing here
		if chosen_value == 1:
			audioCount = split_line + 1
			playerChose = false			#add the option here for when the player makes a choice and choose the new audio
			
	
	if audioCount == split_line:
		audioCount = MAX_lines
	if audioCount > MAX_lines:
		audioCount = MAX_lines
	
	$npcSpeak.stream = audioList[audioCount]
	$npcSpeak.play()		
	
func bubbleNPC():
	print("bubbled!")
	bubbled = true
	$theBubble.visible = true
	
func _on_speak_timer_timeout():
	if imageCount == 0:
		$IMAGE_HERE.mesh.material.albedo_texture = IMAGE[1]
		imageCount = 1
	else:
		$IMAGE_HERE.mesh.material.albedo_texture = IMAGE[0]
		imageCount = 0
	if speakCount >= 10:
		speakCount = 0
	else:
		speakCount+=1
		$speakTimer.start()
		
		


func _on_cutscene_manager_bubbled():
	bubbleNPC()


func _on_cutscene_manager_option_chosen(chosen_int):
	chosen_value = chosen_int
	playerChose = true
