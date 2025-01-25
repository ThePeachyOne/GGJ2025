extends Label

@export var text_array : PackedStringArray
@export var audio_array : Array



@export_category("Sound")
@export var use_audio = false
@export var audio_bus:String
@export var SpatialAudioSource : Node3D
var audio_player

@export_category("Speed")
@export var display_delay = 0.0
var display_timer = display_delay
@export var auto_advance = false
@export var advance_wait = 3.0
var advance_timer = advance_wait

var current_line = -1
var writing = false
var active_line = ""


func _ready() -> void:
	#initialize audioplayer
	if SpatialAudioSource:
		audio_player = SpatializedAudioStreamPlayer3D.new()
		audio_player.bus = audio_bus
		SpatialAudioSource.add_child(audio_player)
		audio_player.global_transform = SpatialAudioSource.global_transform
	else:
		audio_player = AudioStreamPlayer.new()
		audio_player.bus = audio_bus
		add_child(audio_player)



func _process(delta: float) -> void:
	if writing:
		display_timer -= delta
		if not active_line.is_empty() and display_timer<=0:
			text += active_line[0]
			active_line = active_line.trim_prefix(active_line[0])
			display_timer = display_delay
		elif active_line.is_empty():
			writing = false
	elif auto_advance:
		if use_audio:
			if not audio_player.playing:
				advance_text()
		elif advance_timer <= 0:
			advance_text()
			advance_timer = advance_wait
		else:
			advance_timer -= delta



func advance_text():
	if current_line<text_array.size()-1:
		current_line += 1
		text = ""
		active_line = text_array[current_line]
		writing = true
		if use_audio:
			audio_player.stream = audio_array[current_line]
			audio_player.play()
	else:
		text = ""


func display_text(dialogue_index:int):
	if dialogue_index>=0 and dialogue_index<text_array.size():
		current_line = dialogue_index
		text = ""
		active_line = text_array[current_line]
		writing = true
		if use_audio:
			audio_player.stream = audio_array[current_line]
			audio_player.play()


func display_new_text(dialogue:String, audio:AudioStream=null):
		current_line = -1
		text = ""
		active_line = dialogue
		writing = true
		if use_audio and audio!=null:
			audio_player.stream = audio
			audio_player.play()
