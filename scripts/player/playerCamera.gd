extends Camera3D

#Sensitivity of Camera
var sensitivity = Vector2(0.2, 0.2)

#Prevent the camera from flipping on itself
var min_vertical_angle = -80.0
var max_vertical_angle = 80.0

var rotation_x = 0.0  # Pitch (up/down)
var rotation_y = 0.0  # Yaw (left/right)

func _ready():
	# Hide and capture the mouse
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	pass


func _input(event):
	if event is InputEventMouseMotion:
		# Yaw (left/right movement)
		rotation_y -= event.relative.x * sensitivity.x
		# Pitch (up/down movement)
		rotation_x -= event.relative.y * sensitivity.y
		rotation_x = clamp(rotation_x, deg_to_rad(min_vertical_angle), deg_to_rad(max_vertical_angle))
		update_camera_rotation()

func update_camera_rotation():
	# Apply yaw (rotation around Y axis) and pitch (rotation around X axis)
	rotation = Vector3(rotation_x, rotation_y, 0.0)
