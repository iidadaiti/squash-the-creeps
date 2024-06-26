extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var min_speed := 10.0
# Maximum speed of the mob in meters per second.
@export var max_speed := 18.0

signal squashed()


func _physics_process(_delta: float) -> void:
	move_and_slide()


# This function will be called from the Main scene.
func initialize(start_position: Vector3, player_position: Vector3) -> void:
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))

	# reset height
	position.y = maxf(position.y, 0)

	# We calculate a random speed (integer)
	var random_speed = randf_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	# Animation speed
	$AnimationPlayer.speed_scale = random_speed / min_speed


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func squash():
	squashed.emit()
	queue_free()
