extends Node3D

# Current Round Number starts at 1 
@onready var currentRound : int = 0

# Preload Zombie Scene
@onready var zombie_scene = preload("res://scenes/enemies/enemy.tscn")

# Random Number variable to genreate number when called
@onready var rand = RandomNumberGenerator.new()

# Zombie Left to kill Count till next round starts
@onready var zombies_left_count = 0

# How Many Zombies should spawn count depending on the round
@onready var zombie_spawn_count 

# An instantiation of the Zombie Scene
@onready var zombie_instance 

# Coun of how many locations Zombies can spawn from
@onready var spawn_points_count

# Store the random number
@onready var rand_num : int

# The spawn location of the next zombie
@onready var spawn_position : Vector3

# Reference to ZombieSpawnTimer node
@onready var zombie_spawn_timer: Timer = $ZombieSpawnTimer

# Random offset of initial spawn location (Might not need to do this, but just in case)
@onready var random_offset = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1) * 0.5

func _ready():
	refreshSpawnLocations()
	startNextRound()

# Main Function
func _process(delta: float) -> void:
	pass

# Function to decrement Zombies when killing one
func zombiesLeftDecrement():
	zombies_left_count -= 1

# Function to call when a player unlocks an area on the map
# so we need to add the new spawn points based on where he is
func refreshSpawnLocations():
	print("Refresh locations")
	# Initialize spawn_points_count to 0
	spawn_points_count = 0
	# Get the amount of child spawn points in the node
	for child in get_children():
		if child is Node3D:
			spawn_points_count += 1
	print("Refresh End")

# Function to handle variables before round starts
func startNextRound():
	# Timer to start 
	zombie_spawn_timer.start()
	# Increment current round by 1
	currentRound += 1
	# Set the current delay between each zombie spawning at the start of the round
	zombie_spawn_timer.set_wait_time(max(2 * pow(0.95, currentRound - 1), 0.1))

# Get a random spawn location for the Zombie
func getSpawnLocation() -> Vector3:
	# Get a random number between all spawn points
	rand_num = rand.randi_range(1, spawn_points_count)
	# Get the position of the spawn point index in the array
	spawn_position = get_child(rand_num).position
	return spawn_position

# Function to spawn Zombie in specified location with global offset
func spawnZombieAtLocation(spawnLocation : Vector3):
	# Instantiate a new zombie
	zombie_instance = zombie_scene.instantiate()
	# Add random Vector3 offset to zombie spawn position
	spawn_position += random_offset
	# Make Zombie spawn position equal the offset spawn position
	zombie_instance.position = spawnLocation
	# Spawn in Zombie in /root/world/"here"
	get_tree().root.get_child(0).add_child(zombie_instance)

# Signal Function to spawn a Zombie everytime the ZombieSpawnTimer finshes
func _on_zombie_spawn_timer_timeout() -> void:
	# Call Functions to get spawn location and spawn the Zombie there
	spawnZombieAtLocation(getSpawnLocation())
	# Increment zombies left count by 1
	zombies_left_count += 1
	print("Spawned Zombie")
	# Reset Timer
	zombie_spawn_timer.start()
