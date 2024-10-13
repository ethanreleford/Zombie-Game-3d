extends RayCast3D

@onready var interactable_text: Label = $"Interactable Text"

func _physics_process(delta: float) -> void:
	interactable_text.text = ""
	if is_colliding():
		var detected = get_collider()
		if detected is Interactable:
			interactable_text.text = detected.name
