extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20

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

	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_target_velocity.y = jump_impulse

	# Vertical Velocity
	if not is_on_floor():
		_target_velocity.y -= fall_acceleration * delta

	# Moving the Character
	velocity = _target_velocity
	move_and_slide()
