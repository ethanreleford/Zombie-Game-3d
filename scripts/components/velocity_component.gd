extends Node3D

@export var SPEED: float = 5.0
@export var enemyObj: CharacterBody3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not enemyObj.is_on_floor():
		gravity(delta)
	else:
		current_location()

func current_location():
	var current_location = enemyObj.global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	enemyObj.velocity = new_velocity
	update_target_location(player.global_transform.origin)

func gravity(delta: float):
	# Add gravity if the object is not on the floor
	enemyObj.velocity += enemyObj.get_gravity() * delta

func update_target_location(target_location):
	navigation_agent.target_position = target_location
