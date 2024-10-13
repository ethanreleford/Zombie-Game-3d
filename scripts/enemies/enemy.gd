extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var health_component: Node3D = $HealthComponent

func _physics_process(delta: float) -> void:
	move_and_slide()
