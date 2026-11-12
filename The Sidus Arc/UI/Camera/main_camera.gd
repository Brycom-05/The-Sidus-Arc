extends Camera2D

const CAMERA_VELOCITY: float = 1000
const ZOOM_VELOCITY: float = 1.8

const ZOOM_BOUNDS := Vector2(0.25, 1.3)

var last_mouse_pos: Vector2

func _process(delta: float) -> void:
	
	var camera_vector: Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("camera_up"):
		camera_vector.y = -1
	elif Input.is_action_pressed("camera_down"):
		camera_vector.y = 1
	
	if Input.is_action_pressed("camera_right"):
		camera_vector.x = 1
	elif Input.is_action_pressed("camera_left"):
		camera_vector.x = -1
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom += Vector2(ZOOM_VELOCITY, ZOOM_VELOCITY) * delta
		clamp_zoom()
	elif Input.is_action_just_pressed("zoom_out"):
		zoom -= Vector2(ZOOM_VELOCITY, ZOOM_VELOCITY) * delta
		clamp_zoom()
	
	if Input.is_action_pressed("camera_drag") and last_mouse_pos:
		var instant_mouse_movement: Vector2 = last_mouse_pos - get_viewport().get_mouse_position()
		position.x += 1 / zoom.x * instant_mouse_movement.x
		position.y += 1 / zoom.y * instant_mouse_movement.y
	
	last_mouse_pos = get_viewport().get_mouse_position()
	position += camera_vector.normalized() * CAMERA_VELOCITY * delta


func clamp_zoom() -> void:
	zoom.x = clamp(zoom.x, ZOOM_BOUNDS.x, ZOOM_BOUNDS.y)
	zoom.y = clamp(zoom.y, ZOOM_BOUNDS.x, ZOOM_BOUNDS.y)
