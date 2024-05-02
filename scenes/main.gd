extends Node


@export var mob_scene: PackedScene


func _ready() -> void:
	$UserInterface/Retry.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()


func _on_mob_timer_timeout() -> void:
	var player := $Player
	if player == null:
		return

	if not mob_scene:
		push_warning("mob_scene is null")
		return

	# Create a new instance of the Mob scene.
	var mob := mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location := $SpawnPath/SpawnLocation

	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	mob.initialize(mob_spawn_location.position, player.position)

	var score := $UserInterface/ScoreLabel
	mob.squashed.connect(score._on_mob_squashed.bind())

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
