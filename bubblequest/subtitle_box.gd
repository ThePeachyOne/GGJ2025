class_name SubtitleBox
extends Control
#Programmed and FULLY DOCUMENTED by Foxlord.

signal out_of_dialog

signal hit_branch

signal dialog_box_advanced

## The path to the dialog file that will be used by this text box.
@export_file("*.txt") var sourceTextPath: String

## Enable or disable this text box printing by character.
@export var toggle_type_by_char: bool = false

## Control how fast the dialog box scrolls when type by character is toggled on.
@export_range(1, 10, 1.0) var type_speed = 1

## The Label corresponding to this SubtitleBox
@onready var textBox: Label = $MarginContainer/Label

## This is a String representation of the file.
## It's here so I can parse out line indicators.
var file_text: String

## A list of Strings separated by what text box they will appear in.
var dialogList: PackedStringArray

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
	file_text = load_file_text()
	dialogList = load_base_dialog()
	dialogOptions = load_branch_dialog()
	
	$MarginContainer/Label.label_settings = LabelSettings.new()
	$MarginContainer/Label.label_settings.resource_local_to_scene = true
	if toggle_type_by_char:
		textBox.text = ""
		$Timer.timeout.connect(advance_char)
		advance_char()
	else:
		textBox.text = dialogList[0]
	#print(dialogList)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
## Change the text box to the next String in dialogList.
func advance_text():
	dialog_tick += 1
	
	# Another piece that exists exclusively to prevent flying past array bounds if skipping fast.
	if not $Timer.is_stopped():
		$Timer.stop()
	# This method of switching paths is subject to change with a global handler.
	if (dialog_tick >= dialogList.size()):
		is_selecting_path = true
		#display_options()
		return
	
	if toggle_type_by_char:
		textBox.text = ""
		char_tick = 0
		advance_char()
		return
		
	textBox.text = dialogList[dialog_tick]

## Advance the text box by individual characters. This is never called if toggled off.
##
## Control of the speed of typing is done via an abstracted slider. I could just make it an input 
## box if that would be preferable.
##
func advance_char():
	if toggle_type_by_char and char_tick < dialogList[dialog_tick].length():
		textBox.text += dialogList[dialog_tick][char_tick]
		$Timer.start( type_speed/50.0 )
		char_tick += 1
	else:
		# If you don't do this, you can go past the array bounds for number of text boxes
		# if you skip too fast.
		$Timer.stop()

## Toggle between the two label holders to display the options that the player can select.
##
## This will dynamically scale the size of the text boxes based on how many options are presented.
##
func display_options():
	$MarginContainer/Label.visible = false
	$MarginContainer/HBoxContainer.visible = true
	
	var optionLabels = $MarginContainer/HBoxContainer.get_children()
	for i in range(dialogOptions.size()):
		optionLabels[i].visible = 1
		
		
	
## Set the dialog onto a chosen path.
func choose_path(option: int):
	if option < 0: return
	
	$MarginContainer/Label.visible = true
	$MarginContainer/HBoxContainer.visible = false
	
	var optionLabels = $MarginContainer/HBoxContainer.get_children()
	for l in optionLabels:
		l.visible = false
		
	var temp = dialogOptions[option].strip_edges()
	temp = temp.split("\n")
	#print("Options: ")
	#print(temp)
	dialogList = temp
	is_selecting_path = false
	dialog_tick = -1
	advance_text()
	
## Load the sourceTextFile as a String and remove any lines starting with hashtags.
func load_file_text() -> String:
	var file = FileAccess.open(sourceTextPath, FileAccess.READ)
	if file == null:
		return "NULL"
		
	var content = file.get_as_text()
	var hashtag_parser = RegEx.new()
	hashtag_parser.compile("(?:#\\d?).*\n?")
	content = hashtag_parser.sub(content, "", true)
	
	file.close()
	
	return content

## Load the dialog before branching.	
func load_base_dialog() -> PackedStringArray:
	if file_text == "NULL":
		var temp_error_arr = PackedStringArray()
		temp_error_arr.append("[FILE WAS NULL]")
		return temp_error_arr
		
	var dialog = file_text.get_slice("<SPLIT>", 0)
	dialog = dialog.strip_edges()
	dialog = dialog.split("\n")

	return dialog

## Load the potential branching dialog.
func load_branch_dialog() -> PackedStringArray:
	if file_text == "NULL":
		var temp_error_arr = PackedStringArray()
		temp_error_arr.append("[FILE WAS NULL]")
		return temp_error_arr
	var content = file_text
	
	if not content.contains("<SPLIT>"):
		var temp_error_arr = PackedStringArray()
		temp_error_arr.append("[FILE CONTAINED NO BRANCHING DIALOG]")
		return temp_error_arr
	# Find the choices and split them up accordingly.
	var temp_options = content.get_slice( "</SPLIT>", 0)
	temp_options = temp_options.get_slice( "<SPLIT>", 1)
	temp_options = temp_options.split("<CHOICE>")
	
	return temp_options

	
## Look at the .txt file given and split on newline.
##
## Subject to adding further functionality.
func load_file():
	var file = FileAccess.open(sourceTextPath, FileAccess.READ)
	if file == null:
		dialogOptions.append("[FAILED TO LOAD FILE]")
		return dialogOptions
	var content = file.get_as_text()
	
	var label_parser: RegEx = RegEx.new()
	label_parser.compile("[^{]+(?=})")
	var labels = label_parser.search_all(content)
	for i in range(labels.size()):
		$MarginContainer/HBoxContainer.get_child(i).text = labels[i].get_string()
		#print(l.get_string())
		
	var dialog = content.get_slice("<SPLIT>", 0)
	dialog = dialog.strip_edges()
	dialog = dialog.split("\n")
	#print(dialog.size())
	
	
	# Find the choices and split them up accordingly.
	label_parser.compile("({.*})")
	var temp_options = label_parser.sub(content, "", true)
	temp_options = temp_options.get_slice( "</SPLIT>", 0)
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
	
## A helper function to change the color of the text in the textbox.
func set_text_color(color: Color):
	$MarginContainer/Label.label_settings.font_color = color
