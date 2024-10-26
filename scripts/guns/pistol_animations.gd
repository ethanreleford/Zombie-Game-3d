extends Node3D

# Assuming you have two AnimationPlayer nodes for gun and arms
@onready var gun_anim = $armshoot/Arms_Rig/Skeleton3D/BoneAttachment3D/gunshoot/AnimationPlayer
@onready var arms_anim = $armshoot/AnimationPlayer
@onready var audio_stream_player = preload("res://sounds/pistol-shot-233473.mp3") # preload the audio file

func play_animations(animation_name: String):
	# Create a new AudioStreamPlayer instance for each shot
	var new_audio_player = AudioStreamPlayer.new()
	new_audio_player.stream = audio_stream_player
	add_child(new_audio_player)  # Add it as a child to play sound
	new_audio_player.play()
	
	# Free the audio player after the sound finishes playing
	new_audio_player.connect("finished", Callable(new_audio_player.queue_free))
	
	# Restart the animations
	gun_anim.stop()
	arms_anim.stop()
	gun_anim.play(animation_name)
	arms_anim.play(animation_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
