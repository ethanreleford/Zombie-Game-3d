extends CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")


var SPEED = 3.0


func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	update_target_location(player.global_transform.origin)
	move_and_slide()




func update_target_location(target_location):
	navigation_agent.target_position = target_location
