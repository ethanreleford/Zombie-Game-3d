class_name Interactable
extends StaticBody3D

var withinRange = false

func _process(delta: float) -> void:
	if withinRange and Input.is_action_just_pressed("interact"):
		print("true")

# Enable Interacting with Weapon
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		withinRange = true

# Disable Interacting with Weapon
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		withinRange = false
