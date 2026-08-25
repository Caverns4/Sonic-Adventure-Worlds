extends "res://entitites/generic_objects/collectible.gd"

func _physics_process(delta: float) -> void:
	$Ring.rotate_y(8*delta)

func collect(player: CharacterBody3D):
	super(player)
	player.ring_count += 1
	$Ring.hide()

func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
