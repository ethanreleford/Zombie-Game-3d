extends RayCast3D

@onready var interactable_text: Label = $"Interactable Text"
@onready var gun_component = $"../GunComponent"


func _physics_process(delta: float) -> void:
	interactable_text.text = "."
	if is_colliding():
		var detected = get_collider()
		if "interactable_component" in detected and detected.interactable_component is Interactable:
			interactable_text.text = detected.interactable_component.gun_text_id
			if Input.is_action_just_pressed("interact"):
				gun_component.findWeaponID(interactable_text.text)
