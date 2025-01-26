class_name Actor 
extends Node

@export_group("Files for Children")
## The path to the dialog file that will be used by the child SubtitleBox
@export_file("*.txt") var sourceTextPath: String

## The color of the text in the subtitle box.
@export var text_color: Color = Color.WHITE

@onready var subtitles: SubtitleBox = $SubtitleBox

## Check for if this character is currently speaking.
var is_talking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	subtitles.sourceTextPath = sourceTextPath
	subtitles.set_text_color(text_color)
	subtitles._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Called by CutsceneManager when it's this Actor's turn to speak.
func gain_subtitle_focus():
	is_talking = true
	subtitles.visible = true

# Called by CutsceneManager when it's another Actor's turn to speak.
func lose_subtitle_focus():
	is_talking = false
	subtitles.visible = false
	
## Advance this Actor's subtitles to the next phase.
func advance_textbox():
	if is_talking:
		subtitles.advance_text()
	
## Transfer to the next audio sample for this Actor.
##
## Since I don't know how to handle this, I'll pass it off to someone else eventually.
func advance_audio():
	pass
	
## Transfer to the next animation for this Actor.
##
## Since I don't know how to handle this, I'll pass it off to someone else eventually.
func advance_animation():
	pass

## Trigger change of speaking globally without worrying about handling it individually every time.
func _on_change_speaker(new_speaker: Actor):
	#print(new_speaker == self)
	if new_speaker == self:
		gain_subtitle_focus()
	else:
		lose_subtitle_focus()
	
## Trigger all special conditions that happen while the player is selecting an option.
func _on_choosing_option():
	subtitles.is_selecting_path = true
	
## Proceed with normal functionality.
func _on_option_chosen(option: int):
	subtitles.is_selecting_path = false
	subtitles.choose_path(option)
