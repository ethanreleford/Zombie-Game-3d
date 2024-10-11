extends CharacterBody3D


const BASE_SPEED : float = 5.0
const SPRINT_SPEED : float = 2.0
var SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5

@onready var camera = $Camera3D  # Reference to Camera Path

func _physics_process(delta: float) -> void:
	# Jump Function
	jump()
	# Gravity Function
	gravity(delta)
	# Sprint Function
	sprint()
	# Input Controller Function
	movementController()
	# Physics Function
	move_and_slide()

func movementController():
	# Store input direction as a vector
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Align the direction with the camera's rotation (yaw)
	var camera_yaw = camera.rotation.y
	var direction := (Quaternion(Vector3(0, 1, 0), camera_yaw) * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Set player velocity to direction * SPEED
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

#Function to handle gravity
func gravity(delta):
	#Add gravity if player is not on floor
	if not is_on_floor():
		velocity += get_gravity() * delta

# Function to handle jumping 
func jump():
	# If player presses jump keybind and is_on_floor, then jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

# Function to handle sprinting
func sprint():
	if Input.is_action_pressed("sprint"):
		SPEED = BASE_SPEED * SPRINT_SPEED
	else:
		SPEED = BASE_SPEED

func quit():
	if Input.is_action_just_pressed("quit"):
		$"../".exit_game(name.to_int())
		get_tree().quit()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
