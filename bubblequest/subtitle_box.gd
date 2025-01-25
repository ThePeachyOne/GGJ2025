extends Control
#Programmed and FULLY DOCUMENTED by Foxlord.

## A list of Strings separated by what text box they will appear in.
@onready var dialogList: PackedStringArray = load_file()

## The path to the dialog file that will be used by this text box.
@export_file("*.txt") var sourceTextPath: String

## Enable or disable this text box printing by character.
@export var toggle_type_by_char: bool = false

## Control how fast the dialog box scrolls when type by character is toggled on.
@export_range(1, 10, 1.0) var type_speed = 1

## The Label corresponding to this SubtitleBox
@onready var textBox: Label = $MarginContainer/Label

## Text for the potential routes that can be taken when a dialog path is chosen.
##
## These are stored in their full packed form to improve initial loading times. Upon an option being
## selected, the relevant option will be split into its respective text boxes, but doing that 
## prematurely would be a waste of processing power. The tradeoff is slightly more RAM usage, but
## honestly, it's not like this game will ever be big enough for this to matter anyways.
##
var dialogOptions: PackedStringArray

## What position are we at in the dialog chain.
var dialog_tick: int = 0

## What position are we at in the current dialog box?
##
## This variable is only used when typing by character is toggled on.
var char_tick: int = 0

## Toggle for if we're ready to choose our path.
var is_selecting_path: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if toggle_type_by_char:
		textBox.text = ""
		$Timer.timeout.connect(advance_char)
		advance_char()
	else:
		textBox.text = dialogList[0]
	#print(dialogList)

## Everything here should be moved to a higher-level handler later.
func _unhandled_key_input(event: InputEvent):
	if not is_selecting_path and event.is_pressed():
		match event.keycode:
			KEY_Q:
				advance_text()
	
	# This should be moved to a higher-level handler to be distributed to all relevant classes eventually.
	if is_selecting_path and event.is_action_pressed("Select_Number"):
		var selected_option: int
		match event.keycode:
			KEY_1:
				selected_option = 0
			KEY_2:
				selected_option = 1
			KEY_3:
				selected_option = 2
			_:
				selected_option = -1
		if selected_option >= 0: 
			choose_path(selected_option)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

## Change the text box to the next String in dialogList.
func advance_text():
	dialog_tick += 1
	if not $Timer.is_stopped():
		$Timer.stop()
	# This method of switching paths is subject to change with a global handler.
	if (dialog_tick >= dialogList.size()):
		is_selecting_path = true
		return
	
	if toggle_type_by_char:
		textBox.text = ""
		char_tick = 0
		advance_char()
		return
		
	textBox.text = dialogList[dialog_tick]

func advance_char():
	if toggle_type_by_char and char_tick < dialogList[dialog_tick].length():
		textBox.text += dialogList[dialog_tick][char_tick]
		$Timer.start( type_speed/50.0 )
		char_tick += 1
	else:
		$Timer.stop()
	
## Set the dialog onto a chosen path.
func choose_path(option: int):
	var temp = dialogOptions[option].strip_edges()
	temp = temp.split("\n")
	#print("Options: ")
	#print(temp)
	dialogList = temp
	is_selecting_path = false
	dialog_tick = -1
	advance_text()
	
## Look at the .txt file given and split on newline.
##
## Subject to adding further functionality.
func load_file():
	var file = FileAccess.open(sourceTextPath, FileAccess.READ)
	var content = file.get_as_text()
	var dialog = content.get_slice("<SPLIT>", 0)
	dialog = dialog.strip_edges()
	dialog = dialog.split("\n")
	print(dialog.size())
	
	
	# Find the choices and split them up accordingly.
	var temp_options = content.get_slice( "</SPLIT>", 0)
	temp_options = temp_options.get_slice( "<SPLIT>", 1)
	temp_options = temp_options.split("<CHOICE>")
	#var split_options: Array[PackedStringArray]
	dialogOptions = temp_options
	## Turn the choice paths into their own separate dialog boxes.
	#var tempy: String
	#for i in range(0, temp_options.size()):
		#tempy = temp_options[i].strip_edges()
		#split_options.append( tempy.split("\n") )
		#
	#print("Options: ")
	#print(split_options)
	return dialog
