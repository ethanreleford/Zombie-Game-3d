class_name Interactable
extends Area3D

@export var gun : StaticBody3D
var withinRange = false
var gun_text_id : String

func _ready():
	gun_text_id = owner.get_meta("name")

func _process(delta: float) -> void:
	pass
	#if withinRange and Input.is_action_just_pressed("interact"):
		#print("true")


# Enable Interacting with Weapon
func _on_body_exited(body):
	if body.is_in_group("player"):
		withinRange = true

# Disable Interacting with Weapon
func _on_body_entered(body):
	if body.is_in_group("player"):
		withinRange = false
