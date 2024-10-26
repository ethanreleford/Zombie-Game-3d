extends Node3D

# Assuming you have two AnimationPlayer nodes for gun and arms
@onready var gun_anim = $armshoot/Arms_Rig/Skeleton3D/BoneAttachment3D/gunshoot/AnimationPlayer
@onready var arms_anim = $armshoot/AnimationPlayer

func play_animations(animation_name: String):
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
