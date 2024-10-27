extends Camera3D

# Adjustable sensitivity and smoothing factors
@export var sensitivity: Vector2 = Vector2(0.1, 0.1)
@export var smoothness: float = 1

# Limits for the up/down rotation of the camera
@export var vertical_limit: float = 90.0

var rotation_degrees_x: float = 0.0  # Horizontal rotation (yaw)
var rotation_degrees_y: float = 0.0  # Vertical rotation (pitch)

# For smoother rotation
var target_rotation: Vector3
var current_rotation: Vector3

func _ready():
	# Capture the mouse so it hides the cursor and locks it
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Initialize the rotation variables
	target_rotation = rotation_degrees
	current_rotation = rotation_degrees

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		print("moving")
		# Adjust the yaw and pitch based on mouse movement
		rotation_degrees_x -= event.relative.x * sensitivity.x
		rotation_degrees_y -= event.relative.y * sensitivity.y
		
		# Clamp the pitch (vertical rotation) to avoid flipping the camera
		rotation_degrees_y = clamp(rotation_degrees_y, -vertical_limit, vertical_limit)

		# Set the target rotation for smooth interpolation
		target_rotation.x = rotation_degrees_y
		target_rotation.y = rotation_degrees_x

func _process(delta):
	# Smoothly interpolate towards the target rotation
	current_rotation.x = lerp(current_rotation.x, target_rotation.x, smoothness)
	current_rotation.y = lerp(current_rotation.y, target_rotation.y, smoothness)

	# Apply the rotation to the camera
	rotation_degrees.x = current_rotation.x
	rotation_degrees.y = current_rotation.y
