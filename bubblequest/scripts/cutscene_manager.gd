extends Node

signal choosing_option
signal option_chosen
signal change_speaker(new_speaker: Actor)
signal bubbled

@export_category("Record of my Shame")
## Nothing here is used if this is toggled off.
@export var load_dialog_by_actor: bool = false
## The path to the dialog file that will be used by the child SubtitleBox
@export_file("*.txt") var universal_dialog_file: String
## Enable or disable this text box printing by character.
@export var toggle_type_by_char: bool = false
## Control how fast the dialog box scrolls when type by character is toggled on.
@export_range(1, 10, 1.0) var type_speed = 1
## The color of the text in the subtitle box.
@export var text_color: Color = Color.WHITE
@export_category("")

## A file containing the text for the dialog boxes.
@export_file("*.txt") var option_text_file: String

@onready var _temp_actors: Array[Node] = get_tree().get_nodes_in_group("Actor")
## The list of Actors in this cutscene.
var actors: Array[Actor]

## This displays all text here if load_actor_by_dialog is off. It's disabled otherwise.
@onready var one_file_box: SubtitleBox = $SubtitleBox

## The dialog path options that will be displayed in the text boxes. 
## Might be deleted later.
var dialog_options: PackedStringArray

## The dialog path that has been chosen. Potentially unnecessary?
var chosen_path: int = -1

## Is the game waiting for the player to select their dialog path?
var is_awaiting_selection: bool = false

## The actor that is currently speaking. This is probably only going to be used internally.
var speaking_actor: Actor = null

## Does what it says.
var block_keyboard_input: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if load_dialog_by_actor:
		_ready_by_actor()
		return

	#get_tree().call_group("Actor", "lose_subtitle_focus")
	# Initialize the master text box.
	one_file_box.sourceTextPath = universal_dialog_file
	one_file_box.toggle_type_by_char = toggle_type_by_char
	one_file_box.type_speed = type_speed
	one_file_box.set_text_color(text_color)
	
	one_file_box._ready()
	
	option_chosen.connect(one_file_box.choose_path)
	
	one_file_box.hit_branch.connect(display_options)
	one_file_box.out_of_dialog.connect(end_cutscene)
	
	var file = FileAccess.open(option_text_file, FileAccess.READ)
	var temp_dialog_options = file.get_as_text().split("~")
	for o in temp_dialog_options:
		dialog_options.append(o.strip_edges())
	
	# Set the option text for later use.
	var optionLabels = $MarginContainer/MarginContainer/HBoxContainer.get_children()
	for i in range(dialog_options.size()):
		optionLabels[i].visible = true
		optionLabels[i].text = dialog_options[i]
	

## I did a very foolish thing and wasted a lot of time making something that worked really well.
func _ready_by_actor():
		# Access the dialog option file and save for later use.
	var file = FileAccess.open(option_text_file, FileAccess.READ)
	var temp_dialog_options = file.get_as_text().split("~")
	for o in temp_dialog_options:
		dialog_options.append(o.strip_edges())
	#print(dialog_options)
	
	# Set the option text for later use.
	var optionLabels = $MarginContainer/HBoxContainer.get_children()
	for i in range(dialog_options.size()):
		optionLabels[i].visible = 1
		optionLabels[i].text = dialog_options[i]
	
	# Grab all the Actors in this cutscene.
	for a in _temp_actors:
		actors.append(a)
		
	# Connect signals.
	for a in actors:
		change_speaker.connect(a._on_change_speaker)
		choosing_option.connect(a._on_choosing_option)
		option_chosen.connect(a._on_option_chosen)
		
	actors[0].subtitles.set_text_color(Color.GREEN)
	actors[1].subtitles.set_text_color(Color.RED)
	get_tree().call_group("Actor", "lose_subtitle_focus")
	actors[1].gain_subtitle_focus()
	
	#for a in actors:
		#print(a.name)
		#print(a.subtitles.dialogList)
		#print(a.subtitles.dialogOptions)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## The majority of this is just for testing purposes.
func _unhandled_key_input(event: InputEvent):
	if block_keyboard_input:
		return
		
	if not is_awaiting_selection and event.is_pressed():
		match event.keycode:
			KEY_Q:
				if load_dialog_by_actor:
					get_tree().call_group("Actor", "advance_textbox")
				else:
					one_file_box.advance_text()
			KEY_MINUS:
				change_speaker.emit(actors[0])
			KEY_EQUAL:
				change_speaker.emit(actors[1])
	
	if is_awaiting_selection and event.is_action_pressed("Select_Number"):
		var selected_option: int
		match event.keycode:
			KEY_1:
				selected_option = 0
			KEY_2:
				# Not in any way intended to be permanent. 
				bubbled.emit()
				selected_option = 1
			KEY_3:
				selected_option = 2
		if (selected_option >= 0 and selected_option < dialog_options.size() ):
			option_chosen.emit(selected_option) 
			$MarginContainer.visible = false
			is_awaiting_selection = false
			if not load_dialog_by_actor:
				one_file_box.visible = true

## Allow the dialog to proceed.
func activate_dialog():
	if not load_dialog_by_actor:
		one_file_box.visible = true
		one_file_box.activate()
	block_keyboard_input = false
	
## Toggle between the two label holders to display the options that the player can select.
##
## This will dynamically scale the size of the text boxes based on how many options are presented.
##
func display_options():
	$MarginContainer.visible = true
	is_awaiting_selection = true
	if not load_dialog_by_actor:
		one_file_box.visible = false
		
## Whatever happens when a cutscene ends, put it here.
func end_cutscene():
	get_tree().call_group("Actor", "lose_dialog_focus")
	one_file_box.visible = false
	$MarginContainer.visible = false
