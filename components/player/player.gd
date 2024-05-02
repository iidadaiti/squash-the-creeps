extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var _target_velocity = Vector3.ZERO


func _get_input_move_vector() -> Vector3:
	var input_vector := Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_back"):
		input_vector.z += 1
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1

	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized()

	return input_vector


func _physics_process(delta):
	var move_vector = _get_input_move_vector()

	if move_vector != Vector3.ZERO:
		$Pivot.look_at(position + move_vector, Vector3.UP)

	# Ground Velocity
	_target_velocity.x = move_vector.x * speed
	_target_velocity.z = move_vector.z * speed

	# Vertical Velocity
	if not is_on_floor():
		_target_velocity.y -= fall_acceleration * delta

	# Moving the Character
	velocity = _target_velocity
	move_and_slide()
